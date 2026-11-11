import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key, required this.child});
  final Widget child;

  static const _tabs = [
    _NavItem(
      route: '/closet',
      icon: Icons.checkroom_outlined,
      activeIcon: Icons.checkroom,
    ),
    _NavItem(
      route: '/outfits',
      icon: Icons.style_outlined,
      activeIcon: Icons.style,
    ),
    _NavItem(
      route: '/calendar',
      icon: Icons.calendar_month_outlined,
      activeIcon: Icons.calendar_month,
    ),
    _NavItem(
      route: '/analytics',
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart,
    ),
    _NavItem(
      route: '/profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  int _indexFor(String location) {
    if (location.startsWith('/outfits')) return 1;
    if (location.startsWith('/calendar')) return 2;
    if (location.startsWith('/analytics')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexFor(GoRouterState.of(context).uri.path);
    final l10n = AppLocalizations.of(context);
    final labels = [
      l10n.closet,
      l10n.outfits,
      l10n.calendar,
      l10n.analytics,
      l10n.profile,
    ];
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => context.go(_tabs[index].route),
          items: [
            for (var i = 0; i < _tabs.length; i++)
              BottomNavigationBarItem(
                icon: Icon(_tabs[i].icon),
                activeIcon: Icon(_tabs[i].activeIcon),
                label: labels[i],
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
  });
  final String route;
  final IconData icon;
  final IconData activeIcon;
}
