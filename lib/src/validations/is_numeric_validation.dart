part of 'validations.dart';

extension IsNumericValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] contains only digit characters (0-9).
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((user) => user.zipCode, key: 'zipCode')
  ///   .isNumeric();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> isNumeric({String? message, String? code}) {
    return useValidation(
      (value, entity) => RegExp(r'^\d+$').hasMatch(value),
      code: code ?? Language.code.isNumeric,
      message: message,
    );
  }
}

extension IsNumericNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] contains only digit characters.
  ///
  /// Fails if the value is null or contains non-digit characters.
  SimpleValidationBuilder<String?> isNumeric({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && RegExp(r'^\d+$').hasMatch(value),
      code: code ?? Language.code.isNumeric,
      message: message,
    );
  }
}

extension IsNumericOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] contains only digit characters or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and contains non-digit characters.
  SimpleValidationBuilder<String?> isNumericOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || RegExp(r'^\d+$').hasMatch(value),
      code: code ?? Language.code.isNumeric,
      message: message,
    );
  }
}
