import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../domain/diagnostics/crash_reporter.dart';

class FirebaseCrashReporter implements CrashReporter {
  const FirebaseCrashReporter();

  @override
  Future<void> start() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  @override
  Future<void> setUser(String? userId) {
    return FirebaseCrashlytics.instance.setUserIdentifier(userId ?? '');
  }

  @override
  Future<void> record(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) {
    return FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }
}

CrashReporter createCrashReporter() => const FirebaseCrashReporter();
