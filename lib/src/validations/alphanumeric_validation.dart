part of 'validations.dart';

extension AlphanumericValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] contains only letters and digits.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((user) => user.username, key: 'username')
  ///   .isAlphanumeric();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> isAlphanumeric(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value),
      code: code ?? Language.code.alphanumeric,
      message: message,
    );
  }
}

extension AlphanumericNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] contains only letters and digits.
  ///
  /// Fails if the value is null or contains non-alphanumeric characters.
  SimpleValidationBuilder<String?> isAlphanumeric(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) =>
          value != null && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value),
      code: code ?? Language.code.alphanumeric,
      message: message,
    );
  }
}

extension AlphanumericOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] contains only letters and digits or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and contains non-alphanumeric characters.
  SimpleValidationBuilder<String?> isAlphanumericOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) =>
          value == null || RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value),
      code: code ?? Language.code.alphanumeric,
      message: message,
    );
  }
}
