/// Observability port. The Firebase adapter is one implementation.
abstract interface class CrashReporter {
  Future<void> start();

  Future<void> setUser(String? userId);

  Future<void> record(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  });
}
