part of 'validations.dart';

extension EndsWithValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] ends with [suffix].
  ///
  /// [suffix] is the required suffix.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((file) => file.name, key: 'name')
  ///   .endsWith('.dart');
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{Suffix}**: The required suffix.
  ///
  SimpleValidationBuilder<String> endsWith(String suffix,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value.endsWith(suffix),
      code: code ?? Language.code.endsWith,
      message: message,
      parameters: (value, entity) => {'Suffix': suffix},
    );
  }
}

extension EndsWithNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] ends with [suffix].
  ///
  /// Fails if the value is null or does not end with [suffix].
  SimpleValidationBuilder<String?> endsWith(String suffix,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value.endsWith(suffix),
      code: code ?? Language.code.endsWith,
      message: message,
      parameters: (value, entity) => {'Suffix': suffix},
    );
  }
}

extension EndsWithOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] ends with [suffix] or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and does not end with [suffix].
  SimpleValidationBuilder<String?> endsWithOrNull(String suffix,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value.endsWith(suffix),
      code: code ?? Language.code.endsWith,
      message: message,
      parameters: (value, entity) => {'Suffix': suffix},
    );
  }
}
