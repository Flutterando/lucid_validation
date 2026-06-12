part of 'validations.dart';

extension ContainsValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] contains [substring].
  ///
  /// [substring] is the required substring.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((user) => user.bio, key: 'bio')
  ///   .contains('@');
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{RequiredSubstring}**: The required substring.
  ///
  SimpleValidationBuilder<String> contains(String substring,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value.contains(substring),
      code: code ?? Language.code.contains,
      message: message,
      parameters: (value, entity) => {'RequiredSubstring': substring},
    );
  }
}

extension ContainsNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] contains [substring].
  ///
  /// Fails if the value is null or does not contain [substring].
  SimpleValidationBuilder<String?> contains(String substring,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value.contains(substring),
      code: code ?? Language.code.contains,
      message: message,
      parameters: (value, entity) => {'RequiredSubstring': substring},
    );
  }
}

extension ContainsOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] contains [substring] or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and does not contain [substring].
  SimpleValidationBuilder<String?> containsOrNull(String substring,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value.contains(substring),
      code: code ?? Language.code.contains,
      message: message,
      parameters: (value, entity) => {'RequiredSubstring': substring},
    );
  }
}
