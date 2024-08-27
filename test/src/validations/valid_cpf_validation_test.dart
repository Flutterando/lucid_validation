import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('valid cpf validation ...', () {
    final validator = TestLucidValidator<UserModel>();

    validator
        .ruleFor((e) => e.cpf, key: 'cpf') //
        .validCPF();

    final user = UserModel()..cpf = '1';

    final result = validator.validate(user);

    expect(result.isValid, false);

    expect(result.errors.length, 1);

    final error = result.errors.first;

    expect(error.message, "'cpf' is not a valid CPF.");
  });
}
