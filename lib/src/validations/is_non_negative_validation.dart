part of 'validations.dart';

extension IsNonNegativeValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] value is greater than or equal to zero.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((product) => product.quantity, key: 'quantity')
  ///   .isNonNegative();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<num> isNonNegative({String? message, String? code}) {
    return useValidation(
      (value, entity) => value >= 0,
      code: code ?? Language.code.isNonNegative,
      message: message,
    );
  }
}

extension IsNonNegativeNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is greater than or equal to zero.
  ///
  /// Fails if the value is null or negative.
  SimpleValidationBuilder<num?> isNonNegative(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value >= 0,
      code: code ?? Language.code.isNonNegative,
      message: message,
    );
  }
}

extension IsNonNegativeOrNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is >= 0 or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and negative.
  SimpleValidationBuilder<num?> isNonNegativeOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value >= 0,
      code: code ?? Language.code.isNonNegative,
      message: message,
    );
  }
}
