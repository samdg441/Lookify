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
import '../../domain/imaging/local_photo.dart';
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
    List<LocalPhoto> photos = const [],
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

    if (photos.isNotEmpty) {
      final uploaded = <String>[];
      try {
        final images = await mapWithConcurrency(
          photos,
          (photo) async {
            final path = await _uploadImage(File(photo.path));
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
        for (final photo in photos) {
          await deleteFileQuietly(File(photo.path));
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
  Future<void> updateGarment({
    required String id,
    required String name,
    required String category,
    String? brand,
    String? color,
    String? season,
    String? occasion,
    double? price,
    String currency = AppConstants.defaultCurrency,
    String? notes,
  }) async {
    await _garments.doc(id).update({
      'name': name,
      'category': category,
      'brand': brand,
      'color': color,
      'season': season,
      'occasion': occasion,
      'price': price,
      'currency': currency,
      'notes': notes,
      'updatedAt': FieldValue.serverTimestamp(),
    });
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
    final summary = summarizeWardrobe(garments, limit: limit);
    final highlighted = {
      for (final garment in [...summary.mostWorn, ...summary.leastWorn])
        garment.id,
    };

    final resolved = <String, Garment>{};
    await Future.wait(
      snap.docs.where((doc) => highlighted.contains(doc.id)).map((doc) async {
        resolved[doc.id] = await garmentFromDoc(doc, storage: _storage);
      }),
    );

    List<Garment> pick(List<Garment> source) {
      return [
        for (final garment in source) resolved[garment.id] ?? garment,
      ];
    }

    return WardrobeInsights(
      total: summary.total,
      categoryCounts: summary.categoryCounts,
      mostWorn: pick(summary.mostWorn),
      leastWorn: pick(summary.leastWorn),
      averageCostPerWear: summary.averageCostPerWear,
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
