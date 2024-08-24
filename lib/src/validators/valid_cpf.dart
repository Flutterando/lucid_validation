part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a valid CPF validation.
///
/// This extension adds a `validCPF` method that can be used to ensure that a string
/// is a valid CPF number.
extension ValidCPFValidator on LucidValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid CPF number.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid CPF".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String>(key: 'cpf');
  /// builder.validCPF();
  /// ```
  LucidValidationBuilder<String> validCPF({String message = 'Invalid CPF', String code = 'invalid_cpf'}) {
    return registerRule(
      (value) => _validateCPF(value),
      message,
      code,
    );
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
