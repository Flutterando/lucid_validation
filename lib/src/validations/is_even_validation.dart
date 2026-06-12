part of 'validations.dart';

extension IsEvenValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] value is an even number.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((config) => config.columns, key: 'columns')
  ///   .isEven();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<num> isEven({String? message, String? code}) {
    return useValidation(
      (value, entity) => value % 2 == 0,
      code: code ?? Language.code.isEven,
      message: message,
    );
  }
}

extension IsEvenNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is an even number.
  ///
  /// Fails if the value is null or odd.
  SimpleValidationBuilder<num?> isEven({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value % 2 == 0,
      code: code ?? Language.code.isEven,
      message: message,
    );
  }
}

extension IsEvenOrNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is even or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and odd.
  SimpleValidationBuilder<num?> isEvenOrNull({String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value % 2 == 0,
      code: code ?? Language.code.isEven,
      message: message,
    );
  }
}
