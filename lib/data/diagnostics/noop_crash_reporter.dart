import 'package:flutter/foundation.dart';

import '../../domain/diagnostics/crash_reporter.dart';

class NoopCrashReporter implements CrashReporter {
  const NoopCrashReporter();

  @override
  Future<void> start() async {}

  @override
  Future<void> setUser(String? userId) async {}

  @override
  Future<void> record(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    debugPrint('[CrashReporter] $reason: $error');
  }
}

CrashReporter createCrashReporter() => const NoopCrashReporter();
