part of 'validations.dart';

extension IsNonZeroValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] value is not zero.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((config) => config.divisor, key: 'divisor')
  ///   .isNonZero();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<num> isNonZero({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != 0,
      code: code ?? Language.code.isNonZero,
      message: message,
    );
  }
}

extension IsNonZeroNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is not zero.
  ///
  /// Fails if the value is null or zero.
  SimpleValidationBuilder<num?> isNonZero({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value != 0,
      code: code ?? Language.code.isNonZero,
      message: message,
    );
  }
}

extension IsNonZeroOrNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is not zero or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and equal to zero.
  SimpleValidationBuilder<num?> isNonZeroOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value != 0,
      code: code ?? Language.code.isNonZero,
      message: message,
    );
  }
}
