import 'outfit.dart';

class CalendarEntry {
  final String id;
  final String userId;
  final String outfitId;
  final Outfit? outfit;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;

  const CalendarEntry({
    required this.id,
    required this.userId,
    required this.outfitId,
    this.outfit,
    required this.date,
    this.notes,
    required this.createdAt,
  });
}
