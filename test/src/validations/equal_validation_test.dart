import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('equal validation', () {
    final validator = TestLucidValidator<UserModel>();
    validator
        .ruleFor((user) => user.confirmPassword, key: 'confirmPassword') //
        .equalTo((user) => user.password);

    final user = UserModel()
      ..password = 'password'
      ..confirmPassword = 'password2';
    final result = validator.validate(user);

    expect(result.isValid, false);
    expect(result.errors.length, 1);

    final error = result.errors.first;
    expect(error.message, r"'confirmPassword' must be equal to 'password'.");
  });

  test('equal validation with local message', () {
    final validator = TestLucidValidator<UserModel>();
    validator
        .ruleFor((user) => user.confirmPassword, key: 'confirmPassword') //
        .equalTo((user) => user.password, message: "Campo '{PropertyName}' deve ser igual ao campo '{ComparisonValue}'.");

    final user = UserModel()
      ..password = 'password'
      ..confirmPassword = 'password2';
    final result = validator.validate(user);

    expect(result.isValid, false);
    expect(result.errors.length, 1);

    final error = result.errors.first;
    expect(error.message, r"Campo 'confirmPassword' deve ser igual ao campo 'password'.");
  });
}
