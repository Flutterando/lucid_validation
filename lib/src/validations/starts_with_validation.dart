part of 'validations.dart';

extension StartsWithValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] starts with [prefix].
  ///
  /// [prefix] is the required prefix.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((config) => config.apiPath, key: 'apiPath')
  ///   .startsWith('/api/');
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{Prefix}**: The required prefix.
  ///
  SimpleValidationBuilder<String> startsWith(String prefix,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value.startsWith(prefix),
      code: code ?? Language.code.startsWith,
      message: message,
      parameters: (value, entity) => {'Prefix': prefix},
    );
  }
}

extension StartsWithNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] starts with [prefix].
  ///
  /// Fails if the value is null or does not start with [prefix].
  SimpleValidationBuilder<String?> startsWith(String prefix,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value.startsWith(prefix),
      code: code ?? Language.code.startsWith,
      message: message,
      parameters: (value, entity) => {'Prefix': prefix},
    );
  }
}

extension StartsWithOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] starts with [prefix] or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and does not start with [prefix].
  SimpleValidationBuilder<String?> startsWithOrNull(String prefix,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value.startsWith(prefix),
      code: code ?? Language.code.startsWith,
      message: message,
      parameters: (value, entity) => {'Prefix': prefix},
    );
  }
}
