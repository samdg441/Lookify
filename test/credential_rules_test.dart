import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_closet/domain/auth/credential_rules.dart';

void main() {
  test('email requires an @', () {
    expect(CredentialRules.email(''), 'invalidEmail');
    expect(CredentialRules.email('ada@lookify.app'), isNull);
  });

  test('password requires 6 characters', () {
    expect(CredentialRules.password('12345'), 'passwordTooShort');
    expect(CredentialRules.password('123456'), isNull);
  });

  test('full name cannot be blank', () {
    expect(CredentialRules.fullName('   '), 'nameRequired');
    expect(CredentialRules.fullName('Ada'), isNull);
  });
}
