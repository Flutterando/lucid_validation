part of 'validations.dart';

extension IsLowercaseValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] consists entirely of lowercase letters.
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
  /// ruleFor((user) => user.slug, key: 'slug')
  ///   .isLowercase();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> isLowercase({String? message, String? code}) {
    return useValidation(
      (value, entity) => value == value.toLowerCase(),
      code: code ?? Language.code.isLowercase,
      message: message,
    );
  }
}

extension IsLowercaseNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is entirely lowercase.
  ///
  /// Fails if the value is null or contains uppercase letters.
  SimpleValidationBuilder<String?> isLowercase(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value == value.toLowerCase(),
      code: code ?? Language.code.isLowercase,
      message: message,
    );
  }
}

extension IsLowercaseOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is entirely lowercase or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and contains uppercase letters.
  SimpleValidationBuilder<String?> isLowercaseOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value == value.toLowerCase(),
      code: code ?? Language.code.isLowercase,
      message: message,
    );
  }
}
