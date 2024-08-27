import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('is not null validation ...', () {
    final validator = TestLucidValidator<UserModel>();
    validator
        .ruleFor((e) => e.description, key: 'description') //
        .isNotNull();

    final user = UserModel();

    final result = validator.validate(user);

    expect(result.isValid, false);

    expect(result.errors.length, 1);

    final error = result.errors.first;

    expect(error.message, r"'description' must not be null.");
  });
}
