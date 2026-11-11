import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// Active palette. Set by the theme controller before the app rebuilds.
  static bool isDark = true;

  /// Foreground for content placed on top of [primary].
  static Color get onPrimary =>
      isDark ? const Color(0xFF0A0A0A) : const Color(0xFFFFFFFF);

  // Brand
  static Color get primary => isDark ? const Color(0xFFC8A96E) : const Color(0xFFA88545);
  static Color get primaryDark => isDark ? const Color(0xFF9B7D47) : const Color(0xFF7E6330);
  static Color get primaryLight => isDark ? const Color(0xFFE8D5B7) : const Color(0xFFE8D5B7);

  // Background
  static Color get background => isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF7F5F0);
  static Color get surface => isDark ? const Color(0xFF141414) : const Color(0xFFFFFFFF);
  static Color get surfaceVariant => isDark ? const Color(0xFF1E1E1E) : const Color(0xFFEEEAE1);
  static Color get card => isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF);

  // Text
  static Color get textPrimary => isDark ? const Color(0xFFF5F5F0) : const Color(0xFF1A1A1A);
  static Color get textSecondary => isDark ? const Color(0xFF9E9E9E) : const Color(0xFF5F5F5F);
  static Color get textDisabled => isDark ? const Color(0xFF555555) : const Color(0xFF9A9A9A);

  // Semantic
  static Color get success => isDark ? const Color(0xFF4CAF6E) : const Color(0xFF3A9A58);
  static Color get error => isDark ? const Color(0xFFE05A5A) : const Color(0xFFD04545);
  static Color get warning => isDark ? const Color(0xFFF0A830) : const Color(0xFFD9920F);
  static Color get info => isDark ? const Color(0xFF5A9BF0) : const Color(0xFF3F86DE);

  // Borders
  static Color get border => isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0DCD2);
  static Color get borderLight => isDark ? const Color(0xFF3A3A3A) : const Color(0xFFD0CBC0);

  // Category colors
  static const Color categoryTops = Color(0xFF7B68EE);
  static const Color categoryBottoms = Color(0xFF5F9EA0);
  static const Color categoryShoes = Color(0xFFCD853F);
  static const Color categoryAccessories = Color(0xFFDB7093);
  static const Color categoryOuterwear = Color(0xFF708090);
  static const Color categoryDresses = Color(0xFFDA70D6);
  static const Color categoryBags = Color(0xFF8FBC8F);

  // Season colors
  static const Color seasonSpring = Color(0xFF98D8AA);
  static const Color seasonSummer = Color(0xFFF7C59F);
  static const Color seasonFall = Color(0xFFD4845A);
  static const Color seasonWinter = Color(0xFF9DCFED);
}
