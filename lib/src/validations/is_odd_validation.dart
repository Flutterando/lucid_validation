part of 'validations.dart';

extension IsOddValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] value is an odd number.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((config) => config.columns, key: 'columns')
  ///   .isOdd();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<num> isOdd({String? message, String? code}) {
    return useValidation(
      (value, entity) => value % 2 != 0,
      code: code ?? Language.code.isOdd,
      message: message,
    );
  }
}

extension IsOddNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is an odd number.
  ///
  /// Fails if the value is null or even.
  SimpleValidationBuilder<num?> isOdd({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value % 2 != 0,
      code: code ?? Language.code.isOdd,
      message: message,
    );
  }
}

extension IsOddOrNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] value is odd or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and even.
  SimpleValidationBuilder<num?> isOddOrNull({String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value % 2 != 0,
      code: code ?? Language.code.isOdd,
      message: message,
    );
  }
}
