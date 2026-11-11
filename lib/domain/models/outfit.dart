import 'garment.dart';

class Outfit {
  final String id;
  final String userId;
  final String name;
  final List<String> garmentIds;
  final List<Garment> garments;
  final String? occasion;
  final String? season;
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
    this.notes,
    this.wearCount = 0,
    this.lastWorn,
    required this.createdAt,
  });
}
