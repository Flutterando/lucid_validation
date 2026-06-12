part of 'validations.dart';

extension IsUppercaseValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] consists entirely of uppercase letters.
  ///
  /// Non-letter characters (digits, spaces, symbols) are ignored in the check.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((user) => user.countryCode, key: 'countryCode')
  ///   .isUppercase();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> isUppercase({String? message, String? code}) {
    return useValidation(
      (value, entity) => value == value.toUpperCase(),
      code: code ?? Language.code.isUppercase,
      message: message,
    );
  }
}

extension IsUppercaseNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is entirely uppercase.
  ///
  /// Fails if the value is null or contains lowercase letters.
  SimpleValidationBuilder<String?> isUppercase(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value == value.toUpperCase(),
      code: code ?? Language.code.isUppercase,
      message: message,
    );
  }
}

extension IsUppercaseOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is entirely uppercase or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and contains lowercase letters.
  SimpleValidationBuilder<String?> isUppercaseOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value == value.toUpperCase(),
      code: code ?? Language.code.isUppercase,
      message: message,
    );
  }
}
