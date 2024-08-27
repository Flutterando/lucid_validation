import 'package:lucid_validation/src/validations/validations.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('is empty validation ...', () {
    final validator = TestLucidValidator<UserModel>();
    validator
        .ruleFor((user) => user.email, key: 'email') //
        .isEmpty();

    final user = UserModel()..email = 'ss';

    final result = validator.validate(user);

    expect(result.isValid, false);

    expect(result.exceptions.length, 1);

    expect(result.exceptions.first.message, "'email' must be empty.");
  });
}
