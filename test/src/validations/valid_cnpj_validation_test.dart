import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('valid cnpj validation ...', () {
    final validator = TestLucidValidator<Customer>();

    validator
        .ruleFor((e) => e.cnpj, key: 'cnpj') //
        .validCNPJ();

    var customer = Customer(
      name: 'John Doe',
      address: Address(
        country: 'Brazil',
        postcode: '12345-678',
      ),
      cnpj: '12345678901234',
    );

    final result = validator.validate(customer);

    expect(result.isValid, false);

    expect(result.errors.length, 1);

    final error = result.errors.first;

    expect(error.message, "'cnpj' is not a valid CNPJ.");
  });
}
