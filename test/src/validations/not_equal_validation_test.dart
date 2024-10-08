import 'package:lucid_validation/src/validations/validations.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('not equal validation...', () {
    final validator = TestLucidValidator<UserModel>();
    validator
        .ruleFor((user) => user.confirmPassword, key: 'confirmPassword') //
        .notEqualTo((user) => user.password);

    final user = UserModel() //
      ..password = 'teste123'
      ..confirmPassword = 'teste123';

    final result = validator.validate(user);

    expect(result.isValid, false);
    expect(result.exceptions.length, 1);
    expect(result.exceptions.first.message,
        "'confirmPassword' must not be equal to 'teste123'.");
  });
}
