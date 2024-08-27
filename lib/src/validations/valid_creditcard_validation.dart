part of 'validations.dart';

extension ValidCreditCardValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid credit card number.
  ///
  /// This method uses the Luhn algorithm to verify the validity of a credit card number.
  /// It checks the length of the number and ensures it passes the Luhn check.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid credit card number".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.

  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.creditCard, key: 'creditCard')
  ///  .validCreditCard();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> validCreditCard({String? message, String? code}) {
    return use((value, entity) {
      if (_validateCreditCard(value)) return null;

      final currentCode = code ?? Language.code.validCreditCard;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': key,
        },
        defaultMessage: message,
      );

      return ValidationException(message: currentMessage, code: currentCode);
    });
  }

  bool _validateCreditCard(String number) {
    // Remove non-numeric characters
    number = number.replaceAll(RegExp(r'[^0-9]'), '');
    if (number.isEmpty || number.length < 13 || number.length > 19) {
      return false;
    }

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
