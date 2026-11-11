import '../models/garment.dart';

bool garmentMatchesQuery(Garment garment, String query) {
  final needle = query.trim().toLowerCase();
  if (needle.isEmpty) return true;

  bool contains(String? value) =>
      value != null && value.toLowerCase().contains(needle);

  return contains(garment.name) ||
      contains(garment.brand) ||
      contains(garment.color) ||
      contains(garment.category) ||
      contains(garment.occasion);
}
