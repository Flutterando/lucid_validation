part of 'validations.dart';

extension IsTrueValidation on SimpleValidationBuilder<bool> {
  /// Adds a validation rule that checks if the [bool] value is `true`.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((user) => user.termsAccepted, key: 'termsAccepted')
  ///   .isTrue();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<bool> isTrue({String? message, String? code}) {
    return useValidation(
      (value, entity) => value == true,
      code: code ?? Language.code.isTrue,
      message: message,
    );
  }
}

extension IsTrueNullableValidation on SimpleValidationBuilder<bool?> {
  /// Adds a validation rule that checks if the [bool?] value is `true`.
  ///
  /// Fails if the value is null or false.
  SimpleValidationBuilder<bool?> isTrue({String? message, String? code}) {
    return useValidation(
      (value, entity) => value == true,
      code: code ?? Language.code.isTrue,
      message: message,
    );
  }
}

extension IsTrueOrNullableValidation on SimpleValidationBuilder<bool?> {
  /// Adds a validation rule that checks if the [bool?] value is `true` or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and false.
  SimpleValidationBuilder<bool?> isTrueOrNull({String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value == true,
      code: code ?? Language.code.isTrue,
      message: message,
    );
  }
}
