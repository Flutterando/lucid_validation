part of 'validations.dart';

final _uuidRegExp = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  caseSensitive: false,
);

extension ValidUuidValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid UUID (v1–v8).
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((item) => item.id, key: 'id')
  ///   .validUuid();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> validUuid({String? message, String? code}) {
    return useValidation(
      (value, entity) => _uuidRegExp.hasMatch(value),
      code: code ?? Language.code.validUuid,
      message: message,
    );
  }
}

extension ValidUuidNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid UUID.
  ///
  /// Fails if the value is null or is not a valid UUID.
  SimpleValidationBuilder<String?> validUuid({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && _uuidRegExp.hasMatch(value),
      code: code ?? Language.code.validUuid,
      message: message,
    );
  }
}

extension ValidUuidOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid UUID or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and is not a valid UUID.
  SimpleValidationBuilder<String?> validUuidOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || _uuidRegExp.hasMatch(value),
      code: code ?? Language.code.validUuid,
      message: message,
    );
  }
}
