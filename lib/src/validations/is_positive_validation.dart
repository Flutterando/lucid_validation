part of 'validations.dart';

extension IsPositiveValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] value is greater than zero.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((product) => product.price, key: 'price')
  ///   .isPositive();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<num> isPositive({String? message, String? code}) {
    return useValidation(
      (value, entity) => value > 0,
      code: code ?? Language.code.isPositive,
      message: message,
    );
  }
}

extension IsPositiveNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is greater than zero.
  ///
  /// Fails if the value is null or not positive.
  SimpleValidationBuilder<num?> isPositive({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value > 0,
      code: code ?? Language.code.isPositive,
      message: message,
    );
  }
}

extension IsPositiveOrNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is greater than zero or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and not positive.
  SimpleValidationBuilder<num?> isPositiveOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value > 0,
      code: code ?? Language.code.isPositive,
      message: message,
    );
  }
}
