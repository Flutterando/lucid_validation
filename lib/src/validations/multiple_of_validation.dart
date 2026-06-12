part of 'validations.dart';

extension MultipleOfValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] value is a multiple of [divisor].
  ///
  /// [divisor] is the required divisor (must be non-zero).
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((order) => order.quantity, key: 'quantity')
  ///   .multipleOf(5);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{Divisor}**: The required divisor.
  ///
  SimpleValidationBuilder<num> multipleOf(num divisor,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value % divisor == 0,
      code: code ?? Language.code.multipleOf,
      message: message,
      parameters: (value, entity) => {'Divisor': '$divisor'},
    );
  }
}

extension MultipleOfNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is a multiple of [divisor].
  ///
  /// Fails if the value is null or not a multiple of [divisor].
  SimpleValidationBuilder<num?> multipleOf(num divisor,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value % divisor == 0,
      code: code ?? Language.code.multipleOf,
      message: message,
      parameters: (value, entity) => {'Divisor': '$divisor'},
    );
  }
}

extension MultipleOfOrNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is a multiple of [divisor] or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and not a multiple of [divisor].
  SimpleValidationBuilder<num?> multipleOfOrNull(num divisor,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value % divisor == 0,
      code: code ?? Language.code.multipleOf,
      message: message,
      parameters: (value, entity) => {'Divisor': '$divisor'},
    );
  }
}
