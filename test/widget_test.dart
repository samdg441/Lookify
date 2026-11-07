import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_closet/domain/auth/credential_rules.dart';

void main() {
  test('credential rules stay independent of Firebase', () {
    expect(CredentialRules.email('not-an-email'), isNotNull);
    expect(CredentialRules.password('secret'), isNull);
  });
}
