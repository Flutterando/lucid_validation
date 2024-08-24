part of 'validators.dart';

extension ValidCreditCardValidator on LucidValidationBuilder<String, dynamic> {
  /// Adds a validation rule that checks if the [String] is a valid credit card number.
  ///
  /// This method uses the Luhn algorithm to verify the validity of a credit card number.
  /// It checks the length of the number and ensures it passes the Luhn check.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid credit card number".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  LucidValidationBuilder<String, dynamic> validCreditCard({String message = 'Invalid credit card number', String code = 'invalid_credit_card'}) {
    return must(
      (value) => _validateCreditCard(value),
      message,
      code,
    );
  }

  bool _validateCreditCard(String number) {
    // Remove non-numeric characters
    number = number.replaceAll(RegExp(r'[^0-9]'), '');
    if (number.isEmpty || number.length < 13 || number.length > 19) return false;

    int sum = 0;
    bool alternate = false;

    for (int i = number.length - 1; i >= 0; i--) {
      int n = int.parse(number[i]);

      if (alternate) {
        n *= 2;
        if (n > 9) {
          n -= 9;
        }
      }

      sum += n;
      alternate = !alternate;
    }

    return (sum % 10 == 0);
  }
}
