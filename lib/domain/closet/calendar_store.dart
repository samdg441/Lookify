import '../models/calendar_entry.dart';

abstract interface class CalendarStore {
  Future<List<CalendarEntry>> getEntriesForMonth(int year, int month);

  Future<CalendarEntry?> getEntryForDate(DateTime date);

  Future<CalendarEntry> setOutfitForDate({
    required DateTime date,
    required String outfitId,
    String? notes,
  });

  Future<void> removeEntryForDate(DateTime date);

  Future<int> countEntries();

  Future<void> deleteAll();
}
