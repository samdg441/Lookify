import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/bounded_concurrency.dart';
import '../../core/utils/file_utils.dart';
import '../../domain/closet/garment_store.dart';
import '../../domain/closet/wardrobe_insights.dart';
import '../../domain/models/garment.dart';
import 'firestore_mappers.dart';

class FirebaseGarmentStore implements GarmentStore {
  FirebaseGarmentStore({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseStorage? storage,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final _uuid = const Uuid();

  static const _uploadConcurrency = 3;

  String get _userId => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _garments =>
      _db.collection('users').doc(_userId).collection('garments');

  @override
  Future<List<Garment>> getGarments({String? category}) async {
    Query<Map<String, dynamic>> query = _garments;
    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    final snap = await query.get();
    final garments = await Future.wait(
      snap.docs.map((doc) => garmentFromDoc(doc, storage: _storage)),
    );
    garments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return garments;
  }

  @override
  Future<Garment> getGarment(String id) async {
    final doc = await _garments.doc(id).get();
    if (!doc.exists) {
      throw StateError('Garment $id was not found');
    }
    return garmentFromDoc(doc, storage: _storage);
  }

  @override
  Future<Garment> createGarment({
    required String name,
    required String category,
    String? brand,
    String? color,
    String? season,
    String? occasion,
    double? price,
    String currency = AppConstants.defaultCurrency,
    String? notes,
    List<File> imageFiles = const [],
  }) async {
    final id = _uuid.v4();
    final doc = _garments.doc(id);
    await doc.set({
      'userId': _userId,
      'name': name,
      'category': category,
      'brand': brand,
      'color': color,
      'season': season,
      'occasion': occasion,
      'price': price,
      'currency': currency,
      'notes': notes,
      'wearCount': 0,
      'images': <Map<String, dynamic>>[],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (imageFiles.isNotEmpty) {
      final uploaded = <String>[];
      try {
        final images = await mapWithConcurrency(
          imageFiles,
          (file) async {
            final path = await _uploadImage(file);
            uploaded.add(path);
            return path;
          },
          maxConcurrent: _uploadConcurrency,
        );
        await doc.update({
          'images': [
            for (var i = 0; i < images.length; i++)
              {'path': images[i], 'position': i},
          ],
          'updatedAt': FieldValue.serverTimestamp(),
        });
        for (final file in imageFiles) {
          await deleteFileQuietly(file);
        }
      } catch (_) {
        await doc.delete();
        await _deleteStorage(uploaded);
        rethrow;
      }
    }

    return getGarment(id);
  }

  @override
  Future<void> deleteGarment(String id) async {
    final doc = await _garments.doc(id).get();
    final paths = _imagePaths(doc.data());
    await _garments.doc(id).delete();
    await _deleteStorage(paths);
  }

  @override
  Future<void> incrementWearCount(String id) async {
    await _garments.doc(id).update({
      'wearCount': FieldValue.increment(1),
      'lastWorn': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<WardrobeInsights> insights({int limit = 5}) async {
    final snap = await _garments.get();
    final garments = await Future.wait(
      snap.docs.map(
        (doc) => garmentFromDoc(doc, storage: _storage, resolveImages: false),
      ),
    );

    final counts = <String, int>{};
    for (final garment in garments) {
      counts[garment.category] = (counts[garment.category] ?? 0) + 1;
    }

    final byWear = [...garments]
      ..sort((a, b) => b.wearCount.compareTo(a.wearCount));
    final mostIds = byWear.take(limit).map((g) => g.id).toSet();
    final leastIds = byWear.reversed.take(limit).map((g) => g.id).toSet();
    final highlighted = mostIds.union(leastIds);

    final resolved = <String, Garment>{};
    await Future.wait(
      snap.docs.where((doc) => highlighted.contains(doc.id)).map((doc) async {
        resolved[doc.id] = await garmentFromDoc(doc, storage: _storage);
      }),
    );

    List<Garment> pick(Iterable<Garment> source) {
      return [
        for (final garment in source) resolved[garment.id] ?? garment,
      ];
    }

    return WardrobeInsights(
      total: garments.length,
      categoryCounts: counts,
      mostWorn: pick(byWear.take(limit)),
      leastWorn: pick(byWear.reversed.take(limit)),
    );
  }

  Future<String> _uploadImage(File file) async {
    final path = 'garments/$_userId/${_uuid.v4()}.jpg';
    await _storage.ref(path).putFile(
          file,
          SettableMetadata(contentType: 'image/jpeg'),
        );
    return path;
  }

  Future<void> _deleteStorage(List<String> paths) async {
    for (final path in paths) {
      try {
        await _storage.ref(path).delete();
      } catch (_) {}
    }
  }

  List<String> _imagePaths(Map<String, dynamic>? data) {
    final raw = data?['images'] as List<dynamic>? ?? const [];
    return [
      for (final image in raw)
        if (image is Map && image['path'] is String) image['path'] as String,
    ];
  }
}
