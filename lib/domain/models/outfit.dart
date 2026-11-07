import 'garment.dart';

class Outfit {
  final String id;
  final String userId;
  final String name;
  final List<String> garmentIds;
  final List<Garment> garments;
  final String? occasion;
  final String? season;
  final String? imageUrl;
  final String? notes;
  final int wearCount;
  final DateTime? lastWorn;
  final DateTime createdAt;

  const Outfit({
    required this.id,
    required this.userId,
    required this.name,
    required this.garmentIds,
    this.garments = const [],
    this.occasion,
    this.season,
    this.imageUrl,
    this.notes,
    this.wearCount = 0,
    this.lastWorn,
    required this.createdAt,
  });

  Outfit copyWith({
    String? name,
    List<String>? garmentIds,
    List<Garment>? garments,
    String? occasion,
    String? season,
    String? imageUrl,
    String? notes,
    int? wearCount,
    DateTime? lastWorn,
  }) =>
      Outfit(
        id: id,
        userId: userId,
        name: name ?? this.name,
        garmentIds: garmentIds ?? this.garmentIds,
        garments: garments ?? this.garments,
        occasion: occasion ?? this.occasion,
        season: season ?? this.season,
        imageUrl: imageUrl ?? this.imageUrl,
        notes: notes ?? this.notes,
        wearCount: wearCount ?? this.wearCount,
        lastWorn: lastWorn ?? this.lastWorn,
        createdAt: createdAt,
      );
}
