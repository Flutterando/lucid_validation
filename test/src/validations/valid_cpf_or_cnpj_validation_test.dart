import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('valid cpf or cnpj validation ...', () {
    final validator = TestLucidValidator<UserModel>();

    validator
        .ruleFor((e) => e.cpfOrCnpj, key: 'cpfOrCnpj', label: 'document') //
        .validCPFOrCNPJ();

    final user = UserModel()..cpfOrCnpj = null;

    final result = validator.validate(user);

    expect(result.isValid, false);

    expect(result.exceptions.length, 1);

    final error = result.exceptions.first;

    expect(error.message, "'document' is not a valid CPF or CNPJ.");
  });

  test('valid cpf validation or null ...', () {
    final validator = TestLucidValidator<UserModel>();

    validator
        .ruleFor((e) => e.cpfOrCnpj, key: 'cpfOrCnpj', label: 'document') //
        .validCPFOrCNPJOrNull();

    final user = UserModel()..cpfOrCnpj = null;

    final result = validator.validate(user);

    expect(result.isValid, true);
  });
}
