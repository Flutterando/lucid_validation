import 'package:lucid_validation/src/validations/validations.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('min validation...', () {
    final validator = TestLucidValidator<UserModel>();
    validator
        .ruleFor((user) => user.age, key: 'age') //
        .min(18);

    final user = UserModel()..age = 17;

    final result = validator.validate(user);

    expect(result.isValid, false);
    expect(result.errors.length, 1);
    expect(result.errors.first.message, "'age' must be greater than or equal to 18. You entered 17.");
  });
}
