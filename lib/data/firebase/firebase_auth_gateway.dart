import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/auth/auth_gateway.dart';
import '../../domain/auth/auth_session.dart';

class FirebaseAuthGateway implements AuthGateway {
  FirebaseAuthGateway({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  @override
  Stream<AuthSession?> watchSession() {
    return _auth.userChanges().map(_sessionOf);
  }

  @override
  AuthSession? get currentSession => _sessionOf(_auth.currentUser);

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_message(error));
    }
  }

  @override
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthFailure('Could not create the account');
      }
      final name = fullName.trim();
      await user.updateDisplayName(name);
      await _db.collection('users').doc(user.uid).set({
        'fullName': name,
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_message(error));
    }
  }

  @override
  Future<void> updateDisplayName(String fullName) async {
    final user = _auth.currentUser;
    if (user == null) throw const AuthFailure('You are not signed in');
    final name = fullName.trim();
    try {
      await user.updateDisplayName(name);
      await _db
          .collection('users')
          .doc(user.uid)
          .set({'fullName': name}, SetOptions(merge: true));
      await user.reload();
      // Re-emit so listeners of userChanges() pick up the new name.
      await _auth.currentUser?.getIdToken(true);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_message(error));
    } on FirebaseException {
      throw const AuthFailure('Could not save your name');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      throw const AuthFailure('You are not signed in');
    }
    try {
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: currentPassword),
      );
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'wrong-password' ||
          error.code == 'invalid-credential') {
        throw const AuthFailure('Current password is incorrect');
      }
      throw AuthFailure(_message(error));
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  AuthSession? _sessionOf(User? user) {
    if (user == null) return null;
    return AuthSession(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  String _message(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Enter a valid email';
      case 'email-already-in-use':
        return 'An account already exists for this email';
      case 'weak-password':
        return 'Password does not meet the requirements';
      case 'user-disabled':
        return 'This account is disabled';
      case 'operation-not-allowed':
        return 'Email and password sign-in is not enabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-credential':
        return 'Email or password is incorrect';
      case 'requires-recent-login':
        return 'Please sign in again and retry';
      case 'network-request-failed':
        return 'Check your internet connection';
      default:
        return 'Could not complete the request';
    }
  }
}
