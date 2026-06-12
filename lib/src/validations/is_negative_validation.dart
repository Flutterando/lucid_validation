part of 'validations.dart';

extension IsNegativeValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] value is less than zero.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((account) => account.balance, key: 'balance')
  ///   .isNegative();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<num> isNegative({String? message, String? code}) {
    return useValidation(
      (value, entity) => value < 0,
      code: code ?? Language.code.isNegative,
      message: message,
    );
  }
}

extension IsNegativeNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is less than zero.
  ///
  /// Fails if the value is null or not negative.
  SimpleValidationBuilder<num?> isNegative({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value < 0,
      code: code ?? Language.code.isNegative,
      message: message,
    );
  }
}

extension IsNegativeOrNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is less than zero or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and not negative.
  SimpleValidationBuilder<num?> isNegativeOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value < 0,
      code: code ?? Language.code.isNegative,
      message: message,
    );
  }
}
