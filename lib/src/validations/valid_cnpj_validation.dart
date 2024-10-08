part of 'validations.dart';

extension ValidCnpjValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid CNPJ number.
  ///
  /// The CNPJ is the national identifier for Brazilian companies. This method
  /// verifies the format and the validity of the CNPJ, ensuring it follows the correct
  /// algorithm for digit verification.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid CNPJ".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.cnpj, key: 'cnpj')
  ///  .validCNPJ();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> validCNPJ({String? message, String? code}) {
    return use((value, entity) {
      if (_validateCNPJ(value)) return null;

      final currentCode = code ?? Language.code.validCNPJ;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
        },
        defaultMessage: message,
      );

      return ValidationException(message: currentMessage, code: currentCode);
    });
  }

  bool _validateCNPJ(String cnpj) {
    // Remove non-numeric characters
    cnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    if (cnpj.length != 14) return false;

    // Check if all digits are the same
    if (RegExp(r'^(\d)\1*$').hasMatch(cnpj)) return false;

    // Calculate the first check digit
    int sum = 0;
    List<int> weight1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    for (int i = 0; i < 12; i++) {
      sum += int.parse(cnpj[i]) * weight1[i];
    }
    int remainder = (sum % 11);
    int firstCheckDigit = remainder < 2 ? 0 : 11 - remainder;

    // Check the first check digit
    if (firstCheckDigit != int.parse(cnpj[12])) return false;

    // Calculate the second check digit
    sum = 0;
    List<int> weight2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    for (int i = 0; i < 13; i++) {
      sum += int.parse(cnpj[i]) * weight2[i];
    }
    remainder = (sum % 11);
    int secondCheckDigit = remainder < 2 ? 0 : 11 - remainder;

    // Check the second check digit
    return secondCheckDigit == int.parse(cnpj[13]);
  }
}
