import 'calendar_store.dart';
import 'outfit_store.dart';
import 'wear_log.dart';

class ScheduleOutfit {
  const ScheduleOutfit({
    required this.calendar,
    required this.outfits,
  });

  final CalendarStore calendar;
  final OutfitStore outfits;

  Future<void> call({
    required DateTime date,
    required String outfitId,
    DateTime? now,
  }) async {
    final existing = await calendar.getEntryForDate(date);
    await calendar.setOutfitForDate(date: date, outfitId: outfitId);
    if (shouldLogWear(
      date: date,
      now: now ?? DateTime.now(),
      outfitId: outfitId,
      previousOutfitId: existing?.outfitId,
    )) {
      await outfits.incrementWearCount(outfitId);
    }
  }
}
