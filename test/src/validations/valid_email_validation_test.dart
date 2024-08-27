import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('valid email validation ...', () {
    final validator = TestLucidValidator<UserModel>();

    validator
        .ruleFor((e) => e.email, key: 'email') //
        .validEmail();

    final user = UserModel()..email = 'testtest.com';

    final result = validator.validate(user);

    expect(result.isValid, false);

    expect(result.errors.length, 1);

    final error = result.errors.first;

    expect(error.message, "'email' is not a valid email address.");
  });
}
