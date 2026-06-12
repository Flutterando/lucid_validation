part of 'validations.dart';

extension IsFalseValidation on SimpleValidationBuilder<bool> {
  /// Adds a validation rule that checks if the [bool] value is `false`.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((account) => account.isBanned, key: 'isBanned')
  ///   .isFalse();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<bool> isFalse({String? message, String? code}) {
    return useValidation(
      (value, entity) => value == false,
      code: code ?? Language.code.isFalse,
      message: message,
    );
  }
}

extension IsFalseNullableValidation on SimpleValidationBuilder<bool?> {
  /// Adds a validation rule that checks if the [bool?] value is `false`.
  ///
  /// Fails if the value is null or true.
  SimpleValidationBuilder<bool?> isFalse({String? message, String? code}) {
    return useValidation(
      (value, entity) => value == false,
      code: code ?? Language.code.isFalse,
      message: message,
    );
  }
}

extension IsFalseOrNullableValidation on SimpleValidationBuilder<bool?> {
  /// Adds a validation rule that checks if the [bool?] value is `false` or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and true.
  SimpleValidationBuilder<bool?> isFalseOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value == false,
      code: code ?? Language.code.isFalse,
      message: message,
    );
  }
}
