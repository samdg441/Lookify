/// Form rules kept out of the widgets so they can be tested without Firebase.
abstract final class CredentialRules {
  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty || !email.contains('@')) {
      return 'invalidEmail';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return 'passwordTooShort';
    }
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'nameRequired';
    }
    return null;
  }
}
