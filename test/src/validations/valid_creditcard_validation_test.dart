import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('valid creditcard validation ...', () {
    final validator = TestLucidValidator<CreditCardModel>();

    validator
        .ruleFor((e) => e.number, key: 'number') //
        .validCreditCard();

    final creditCard = CreditCardModel()..number = '1';

    final result = validator.validate(creditCard);

    expect(result.isValid, false);

    expect(result.errors.length, 1);

    final error = result.errors.first;

    expect(error.message, "'number' is not a valid credit card number.");
  });
}
