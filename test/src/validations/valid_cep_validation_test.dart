import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('valid cep validation ...', () {
    final validator = TestLucidValidator<Address>();

    validator
        .ruleFor((e) => e.postcode, key: 'postcode') //
        .validCEP();

    var customer = Address(
      country: 'Brazil',
      postcode: '1234578',
    );

    final result = validator.validate(customer);

    expect(result.isValid, false);

    expect(result.errors.length, 1);

    final error = result.errors.first;

    expect(error.message, "'postcode' is not a valid CEP.");
  });
}
