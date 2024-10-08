import 'package:lucid_validation/src/validations/validations.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('must have special character validation...', () {
    final validator = TestLucidValidator<UserModel>();
    validator
        .ruleFor((user) => user.password, key: 'password') //
        .mustHaveSpecialCharacter();

    final user = UserModel()..password = 'AAAAaaa124';

    final result = validator.validate(user);

    expect(result.isValid, false);
    expect(result.exceptions.length, 1);
    expect(result.exceptions.first.message,
        "'password' must have at least one non-alphanumeric character.");
  });
}
