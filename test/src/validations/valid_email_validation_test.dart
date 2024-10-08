import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('valid email validation ...', () {
    final validator = TestLucidValidator<UserModel>();

    validator
        .ruleFor((e) => e.email, key: 'email', label: 'E-mail') //
        .validEmail();

    final user = UserModel()..email = 'testtest.com';

    final result = validator.validate(user);

    expect(result.isValid, false);

    expect(result.exceptions.length, 1);

    final error = result.exceptions.first;

    expect(error.message, "'E-mail' is not a valid email address.");
  });
}
