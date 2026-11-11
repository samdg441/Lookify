/// Wearing an outfit counts once for today. Planning another day, or
/// picking the outfit that is already on today, does not add another wear.
bool shouldLogWear({
  required DateTime date,
  required DateTime now,
  required String outfitId,
  String? previousOutfitId,
}) {
  if (outfitId.isEmpty) return false;
  final day = DateTime(date.year, date.month, date.day);
  final today = DateTime(now.year, now.month, now.day);
  if (day != today) return false;
  return previousOutfitId != outfitId;
}
