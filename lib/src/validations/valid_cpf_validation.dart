part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a valid CPF validation.
///
/// This extension adds a `validCPF` method that can be used to ensure that a string
/// is a valid CPF number.
extension ValidCPFValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid CPF number.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid CPF".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.cpf, key: 'cpf')
  ///   .validCPF();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> validCPF({String? message, String? code}) {
    return use((value, entity) {
      if (_validateCPF(value)) return null;

      final currentCode = code ?? Language.code.validCPF;
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

  bool _validateCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length != 11) return false;

    for (int i = 0; i < 10; i++) {
      if (cpf == '$i' * 11) return false;
    }

    int add = 0;
    for (int i = 0; i < 9; i++) {
      add += int.parse(cpf[i]) * (10 - i);
    }
    int rev = 11 - (add % 11);
    if (rev == 10 || rev == 11) rev = 0;
    if (rev != int.parse(cpf[9])) return false;

    add = 0;
    for (int i = 0; i < 10; i++) {
      add += int.parse(cpf[i]) * (11 - i);
    }
    rev = 11 - (add % 11);
    if (rev == 10 || rev == 11) rev = 0;
    if (rev != int.parse(cpf[10])) return false;

    return true;
  }
}
