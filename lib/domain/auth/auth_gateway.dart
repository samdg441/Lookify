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

  Future<void> updateDisplayName(String fullName);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> signOut();

  Future<void> sendPasswordReset(String email);

  Future<void> updateProfile({required String fullName});

  /// Confirms [password] for the signed-in user before a destructive action.
  Future<void> reauthenticate({required String password});

  /// Deletes the auth user and the profile document. Closet data is removed
  /// by the caller first, because auth has no cascade.
  Future<void> deleteAccount();
}
