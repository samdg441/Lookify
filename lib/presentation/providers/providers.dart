import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/anthropic/anthropic_outfit_suggester.dart';
import '../../data/datasources/background_removal_service.dart';
import '../../data/datasources/model_install_service.dart';
import '../../data/diagnostics/crash_reporter_factory.dart';
import '../../data/firebase/firebase_auth_gateway.dart';
import '../../data/firebase/firebase_calendar_store.dart';
import '../../data/firebase/firebase_garment_store.dart';
import '../../data/firebase/firebase_outfit_store.dart';
import '../../domain/auth/auth_gateway.dart';
import '../../domain/auth/auth_session.dart';
import '../../domain/closet/calendar_store.dart';
import '../../domain/closet/garment_store.dart';
import '../../domain/closet/outfit_store.dart';
import '../../domain/closet/wardrobe_insights.dart';
import '../../domain/diagnostics/crash_reporter.dart';
import '../../domain/imaging/background_remover.dart';
import '../../domain/models/calendar_entry.dart';
import '../../domain/models/garment.dart';
import '../../domain/models/outfit.dart';
import '../../domain/styling/outfit_suggestion.dart';
import '../../domain/styling/outfit_suggester.dart';

export '../../domain/styling/outfit_suggestion.dart' show SuggestionRequest;

final crashReporterProvider = Provider<CrashReporter>(
  (ref) => createCrashReporter(),
);

final authGatewayProvider = Provider<AuthGateway>(
  (ref) => FirebaseAuthGateway(),
);

final authStateProvider = StreamProvider<AuthSession?>(
  (ref) => ref.watch(authGatewayProvider).watchSession(),
);

final currentUserProvider = Provider<AuthSession?>((ref) {
  final asyncUser = ref.watch(authStateProvider);
  return asyncUser.asData?.value ??
      ref.watch(authGatewayProvider).currentSession;
});

final aiServiceProvider = Provider<OutfitSuggester>(
  (_) => AnthropicOutfitSuggester(
    dotenv.env['AI_API_KEY'] ?? '',
    dotenv.env['AI_MODEL'] ?? '',
  ),
);

final backgroundRemovalServiceProvider = Provider<BackgroundRemover>(
  (ref) => BackgroundRemovalService(
    crashReporter: ref.watch(crashReporterProvider),
  ),
);

final modelInstallServiceProvider = Provider<ModelInstallService>(
  (_) => ModelInstallService(),
);

/// Subject Segmentation model download progress: null while unknown/not yet
/// requested, 0-99 while downloading, 100 once confirmed available. Set by
/// SplashScreen at startup and read by AddGarmentScreen to tell a genuine
/// "still downloading" state apart from a real segmentation failure.
final backgroundRemovalModelProgressProvider = StateProvider<int?>((_) => null);

final garmentRepositoryProvider = Provider<GarmentStore>(
  (ref) => FirebaseGarmentStore(),
);

final outfitRepositoryProvider = Provider<OutfitStore>(
  (ref) => FirebaseOutfitStore(),
);

final calendarRepositoryProvider = Provider<CalendarStore>(
  (ref) => FirebaseCalendarStore(),
);

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final garmentsProvider = FutureProvider.autoDispose<List<Garment>>((ref) {
  final repo = ref.watch(garmentRepositoryProvider);
  final category = ref.watch(selectedCategoryProvider);
  return repo.getGarments(category: category == 'All' ? null : category);
});

final garmentProvider =
    FutureProvider.autoDispose.family<Garment, String>((ref, id) {
  return ref.watch(garmentRepositoryProvider).getGarment(id);
});

final selectedOccasionProvider = StateProvider<String>((ref) => 'All');

final outfitsProvider = FutureProvider.autoDispose<List<Outfit>>((ref) {
  final repo = ref.watch(outfitRepositoryProvider);
  final occasion = ref.watch(selectedOccasionProvider);
  return repo.getOutfits(occasion: occasion == 'All' ? null : occasion);
});

final outfitProvider =
    FutureProvider.autoDispose.family<Outfit, String>((ref, id) {
  return ref.watch(outfitRepositoryProvider).getOutfit(id);
});

final selectedMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final calendarEntriesProvider =
    FutureProvider.autoDispose<List<CalendarEntry>>((ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  final month = ref.watch(selectedMonthProvider);
  return repo.getEntriesForMonth(month.year, month.month);
});

final calendarEntryForDateProvider =
    FutureProvider.autoDispose.family<CalendarEntry?, DateTime>((ref, date) {
  return ref.watch(calendarRepositoryProvider).getEntryForDate(date);
});

final aiSuggestionsProvider = FutureProvider.autoDispose
    .family<List<OutfitSuggestion>, SuggestionRequest>((ref, params) async {
  final garments = await ref.watch(garmentRepositoryProvider).getGarments();
  if (garments.isEmpty) return [];
  return ref.watch(aiServiceProvider).suggestOutfits(
        garments: garments,
        occasion: params.occasion,
        season: params.season,
        count: 3,
      );
});

final wardrobeInsightsProvider =
    FutureProvider.autoDispose<WardrobeInsights>((ref) {
  return ref.watch(garmentRepositoryProvider).insights();
});

final wardrobeSizeProvider = Provider<AsyncValue<int>>((ref) {
  return ref.watch(wardrobeInsightsProvider).whenData((insights) => insights.total);
});

final categoryStatsProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  return ref
      .watch(wardrobeInsightsProvider)
      .whenData((insights) => insights.categoryCounts);
});

final mostWornProvider = Provider<AsyncValue<List<Garment>>>((ref) {
  return ref
      .watch(wardrobeInsightsProvider)
      .whenData((insights) => insights.mostWorn);
});

final leastWornProvider = Provider<AsyncValue<List<Garment>>>((ref) {
  return ref
      .watch(wardrobeInsightsProvider)
      .whenData((insights) => insights.leastWorn);
});
