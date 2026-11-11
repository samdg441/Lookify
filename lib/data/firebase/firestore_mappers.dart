import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/models/garment.dart';
import '../../domain/models/outfit.dart';

DateTime? firestoreDate(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

Future<Garment> garmentFromDoc(
  DocumentSnapshot<Map<String, dynamic>> doc, {
  FirebaseStorage? storage,
  bool resolveImages = true,
}) async {
  final data = doc.data() ?? {};
  final raw = (data['images'] as List<dynamic>? ?? const [])
      .map((e) => Map<String, dynamic>.from(e as Map))
      .toList()
    ..sort(
      (a, b) => ((a['position'] as num?) ?? 0)
          .compareTo((b['position'] as num?) ?? 0),
    );

  final urls = <String>[];
  if (resolveImages) {
    final bucket = storage ?? FirebaseStorage.instance;
    for (final image in raw) {
      final path = image['path'] as String?;
      if (path == null || path.isEmpty) continue;
      try {
        urls.add(await bucket.ref(path).getDownloadURL());
      } catch (_) {
        // A missing object should not hide the rest of the garment.
      }
    }
  }

  return Garment(
    id: doc.id,
    userId: data['userId'] as String? ??
        doc.reference.parent.parent?.id ??
        '',
    name: data['name'] as String? ?? '',
    category: data['category'] as String? ?? '',
    brand: data['brand'] as String?,
    color: data['color'] as String?,
    season: data['season'] as String?,
    occasion: data['occasion'] as String?,
    price: (data['price'] as num?)?.toDouble(),
    currency: data['currency'] as String? ?? Garment.defaultCurrency,
    imageUrls: urls,
    notes: data['notes'] as String?,
    wearCount: (data['wearCount'] as num?)?.toInt() ?? 0,
    lastWorn: firestoreDate(data['lastWorn']),
    createdAt: firestoreDate(data['createdAt']) ?? DateTime.now(),
  );
}

Outfit outfitFromDoc(
  DocumentSnapshot<Map<String, dynamic>> doc, {
  List<Garment> garments = const [],
}) {
  final data = doc.data() ?? {};
  return Outfit(
    id: doc.id,
    userId: data['userId'] as String? ?? doc.reference.parent.parent?.id ?? '',
    name: data['name'] as String? ?? '',
    garmentIds: List<String>.from(data['garmentIds'] ?? const []),
    garments: garments,
    occasion: data['occasion'] as String?,
    season: data['season'] as String?,
    notes: data['notes'] as String?,
    wearCount: (data['wearCount'] as num?)?.toInt() ?? 0,
    lastWorn: firestoreDate(data['lastWorn']),
    createdAt: firestoreDate(data['createdAt']) ?? DateTime.now(),
  );
}
