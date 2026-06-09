part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a less than validation.
///
/// This extension adds a `lessThan` method that can be used to ensure that a number
/// is less than a specified value.
extension LessThanValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] is less than [maxValue].
  ///
  /// [maxValue] is the value that the number must be less than.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be less than $maxValue".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.discount, key: 'discount')
  ///   .lessThan(100);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<num> lessThan(num maxValue,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value < maxValue,
      code: code ?? Language.code.lessThan,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': '$maxValue'},
    );
  }
}

extension LessThanNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] is less than [maxValue].
  ///
  /// [maxValue] is the value that the number must be less than.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be less than $maxValue".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.discount, key: 'discount') // user.discount is nullable
  ///   .lessThan(100);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<num?> lessThan(num maxValue,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value < maxValue,
      code: code ?? Language.code.lessThan,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': '$maxValue'},
    );
  }
}

extension LessThanOrNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] is less than [maxValue] or [null].
  ///
  /// [maxValue] is the value that the number must be less than.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be less than $maxValue".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.discount, key: 'discount')
  ///   .lessThanOrNull(100);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<num?> lessThanOrNull(num maxValue,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value < maxValue,
      code: code ?? Language.code.lessThan,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': '$maxValue'},
    );
  }
}
