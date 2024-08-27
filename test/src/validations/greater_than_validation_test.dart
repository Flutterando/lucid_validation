import 'package:lucid_validation/src/validations/validations.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('greater than validation ...', () {
    final validator = TestLucidValidator<UserModel>();
    validator
        .ruleFor((user) => user.age, key: 'age') //
        .greaterThan(17);

    final user = UserModel()..age = 15;

    final result = validator.validate(user);

    expect(result.isValid, false);
    expect(result.errors.length, 1);
    expect(result.errors.first.message, "'age' must be greater than '17'.");
  });
}
