import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'domain/auth/auth_gateway.dart';
import 'domain/auth/auth_session.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/providers/locale_controller.dart';
import 'presentation/providers/providers.dart';
import 'presentation/screens/auth/splash_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/closet/closet_screen.dart';
import 'presentation/screens/closet/garment_detail_screen.dart';
import 'presentation/screens/closet/add_garment_screen.dart';
import 'presentation/screens/closet/closet_search_screen.dart';
import 'presentation/screens/outfits/outfit_detail_screen.dart';
import 'presentation/screens/outfits/outfits_screen.dart';
import 'presentation/screens/outfits/outfit_builder_screen.dart';
import 'presentation/screens/calendar/calendar_screen.dart';
import 'presentation/screens/analytics/analytics_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class _SessionRefresh extends ChangeNotifier {
  _SessionRefresh(this._gateway) {
    _subscription = _gateway.watchSession().listen((_) {
      notifyListeners();
    });
  }

  final AuthGateway _gateway;
  late final StreamSubscription<AuthSession?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authGatewayProvider);
  final notifier = _SessionRefresh(auth);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final isLoggedIn = auth.currentSession != null;
      final loc = state.matchedLocation;
      final isAuthRoute =
          loc == '/login' || loc == '/register' || loc == '/';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute && loc != '/') return '/closet';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),

      // Shell route for main navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) =>
            MainNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: '/closet',
            pageBuilder: (_, __) => const NoTransitionPage(
              child: ClosetScreen(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, __) => const AddGarmentScreen(),
              ),
              GoRoute(
                path: 'search',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, __) => const ClosetSearchScreen(),
              ),
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, state) =>
                    GarmentDetailScreen(id: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'edit',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, state) => AddGarmentScreen(
                      garmentId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/outfits',
            pageBuilder: (_, __) => const NoTransitionPage(
              child: OutfitsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'builder',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, __) => const OutfitBuilderScreen(),
              ),
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, state) =>
                    OutfitDetailScreen(id: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/calendar',
            pageBuilder: (_, __) => const NoTransitionPage(
              child: CalendarScreen(),
            ),
          ),
          GoRoute(
            path: '/analytics',
            pageBuilder: (_, __) => const NoTransitionPage(
              child: AnalyticsScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (_, __) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Redirect /home to /closet
      GoRoute(
        path: '/home',
        redirect: (_, __) => '/closet',
      ),
    ],
  );
});

class VirtualClosetApp extends ConsumerWidget {
  const VirtualClosetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    ref.listen(authStateProvider, (_, next) {
      ref.read(crashReporterProvider).setUser(next.asData?.value?.id);
    });

    return MaterialApp.router(
      title: 'Lookify',
      theme: AppTheme.dark,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
