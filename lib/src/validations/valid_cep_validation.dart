part of 'validations.dart';

extension ValidCEPValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid CEP (Brazilian postal code).
  ///
  /// This method verifies that the CEP is in the correct format (#####-###) and consists
  /// of only numbers.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid CEP".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.cep, key: 'cep')
  ///  .validCEP();
  /// ```
  SimpleValidationBuilder<String> validCEP({String message = 'Invalid CEP', String code = 'invalid_cep'}) {
    return must(
      (value) => RegExp(r'^\d{5}-?\d{3}$').hasMatch(value),
      message,
      code,
    );
  }
}
