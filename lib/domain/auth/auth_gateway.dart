import 'auth_session.dart';

/// Identity port. Screens depend on this, not on a vendor SDK.
abstract interface class AuthGateway {
  Stream<AuthSession?> watchSession();

  AuthSession? get currentSession;

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> signOut();
}
