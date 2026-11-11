import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../domain/closet/outfit_membership.dart';
import '../../domain/closet/outfit_store.dart';
import '../../domain/models/garment.dart';
import '../../domain/models/outfit.dart';
import 'firestore_mappers.dart';

class FirebaseOutfitStore implements OutfitStore {
  FirebaseOutfitStore({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  final _uuid = const Uuid();

  String get _userId => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _outfits =>
      _db.collection('users').doc(_userId).collection('outfits');

  CollectionReference<Map<String, dynamic>> get _garments =>
      _db.collection('users').doc(_userId).collection('garments');

  CollectionReference<Map<String, dynamic>> get _calendar =>
      _db.collection('users').doc(_userId).collection('calendar');

  @override
  Future<List<Outfit>> getOutfits({String? occasion}) async {
    final snap = await _outfits.orderBy('createdAt', descending: true).get();
    final wardrobe = await _wardrobeById();
    final outfits = snap.docs.map((doc) {
      final ids = List<String>.from(doc.data()['garmentIds'] ?? const []);
      return outfitFromDoc(
        doc,
        garments: [
          for (final id in ids)
            if (wardrobe.containsKey(id)) wardrobe[id]!,
        ],
      );
    }).toList();
    if (occasion == null || occasion == 'All') return outfits;
    return outfits.where((outfit) => outfit.occasion == occasion).toList();
  }

  @override
  Future<Outfit> getOutfit(String id) async {
    final doc = await _outfits.doc(id).get();
    if (!doc.exists) {
      throw StateError('Outfit $id was not found');
    }
    final wardrobe = await _wardrobeById();
    final ids = List<String>.from(doc.data()?['garmentIds'] ?? const []);
    return outfitFromDoc(
      doc,
      garments: [
        for (final garmentId in ids)
          if (wardrobe.containsKey(garmentId)) wardrobe[garmentId]!,
      ],
    );
  }

  @override
  Future<Outfit> createOutfit({
    required String name,
    required List<String> garmentIds,
    String? occasion,
    String? season,
    String? notes,
  }) async {
    final id = _uuid.v4();
    await _outfits.doc(id).set({
      'userId': _userId,
      'name': name,
      'garmentIds': garmentIds,
      'occasion': occasion,
      'season': season,
      'notes': notes,
      'wearCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return getOutfit(id);
  }

  @override
  Future<void> updateOutfit({
    required String id,
    required String name,
    String? occasion,
    String? season,
    String? notes,
  }) async {
    await _outfits.doc(id).update({
      'name': name,
      'occasion': occasion,
      'season': season,
      'notes': notes,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> detachGarment(String garmentId) async {
    final snap =
        await _outfits.where('garmentIds', arrayContains: garmentId).get();
    final plans = planGarmentRemoval(
      outfits: [
        for (final doc in snap.docs)
          (
            id: doc.id,
            garmentIds: List<String>.from(doc.data()['garmentIds'] ?? const []),
          ),
      ],
      garmentId: garmentId,
    );
    for (final plan in plans) {
      if (plan.change == OutfitMembershipChange.delete) {
        await deleteOutfit(plan.outfitId);
      } else {
        await _outfits.doc(plan.outfitId).update({
          'garmentIds': plan.garmentIds,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  @override
  Future<void> deleteOutfit(String id) async {
    final entries = await _calendar.where('outfitId', isEqualTo: id).get();
    final batch = _db.batch();
    for (final doc in entries.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_outfits.doc(id));
    await batch.commit();
  }

  @override
  Future<void> incrementWearCount(String id) async {
    final outfitRef = _outfits.doc(id);
    await _db.runTransaction((tx) async {
      final outfitSnap = await tx.get(outfitRef);
      final data = outfitSnap.data();
      if (data == null) return;
      final ids = List<String>.from(data['garmentIds'] ?? const []);
      final garmentSnaps = [
        for (final garmentId in ids) await tx.get(_garments.doc(garmentId)),
      ];
      tx.update(outfitRef, {
        'wearCount': FieldValue.increment(1),
        'lastWorn': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      for (final snap in garmentSnaps) {
        if (!snap.exists) continue;
        tx.update(snap.reference, {
          'wearCount': FieldValue.increment(1),
          'lastWorn': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Future<Map<String, Garment>> _wardrobeById() async {
    final snap = await _garments.get();
    final garments = await Future.wait(snap.docs.map(garmentFromDoc));
    return {for (final garment in garments) garment.id: garment};
  }
}
