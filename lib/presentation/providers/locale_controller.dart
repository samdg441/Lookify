import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const localePreferenceKey = 'app_locale';

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    _restore();
    return const Locale('es');
  }

  Future<void> _restore() async {
    final preferences = await SharedPreferences.getInstance();
    final code = preferences.getString(localePreferenceKey);
    if (code == 'es' || code == 'en') {
      state = Locale(code!);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(localePreferenceKey, locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);
