import 'package:lucid_validation/src/validations/validations.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('matches pattern validation...', () {
    final validator = TestLucidValidator<UserModel>();
    validator
        .ruleFor((user) => user.email, key: 'email') //
        .matchesPattern(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$');

    final user = UserModel()..email = 'teste.com';

    final result = validator.validate(user);

    expect(result.isValid, false);
    expect(result.errors.length, 1);
    expect(result.errors.first.message, "'email' is not in the correct format.");
  });
}
