part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a minimum value validation.
///
/// This extension adds a `min` method that can be used to ensure that a numerical value
/// meets or exceeds a specified minimum.
extension MinValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if a [num] value is greater than or equal to [num].
  ///
  /// [num] is the minimum allowed value.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be greater than or equal to $num".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.age, key: 'age')
  ///   .maxLength(18);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{MinValue}**: The minimum value.
  /// - **{PropertyValue}**: value entered.
  ///
  SimpleValidationBuilder<num> min(num num, {String? message, String? code}) {
    return useValidation(
      (value, entity) => value >= num,
      code: code ?? Language.code.min,
      message: message,
      parameters: (value, entity) => {
        'MinValue': '$num',
        'PropertyValue': '$value',
      },
    );
  }
}

extension MinNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if a [num?] value is greater than or equal to [num].
  ///
  /// [num] is the minimum allowed value.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be greater than or equal to $num".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.age, key: 'age')
  ///   .maxLength(18);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{MinValue}**: The minimum value.
  /// - **{PropertyValue}**: value entered.
  ///
  SimpleValidationBuilder<num?> min(num num, {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value >= num,
      code: code ?? Language.code.min,
      message: message,
      parameters: (value, entity) => {
        'MinValue': '$num',
        'PropertyValue': '$value',
      },
    );
  }
}

extension MinOrNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if a [num?] value is greater than or equal to [num] or [null].
  ///
  /// [num] is the minimum allowed value.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be greater than or equal to $num".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.age, key: 'age')
  ///   .minOrNull(18);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{MinValue}**: The minimum value.
  /// - **{PropertyValue}**: value entered.
  ///
  SimpleValidationBuilder<num?> minOrNull(num num,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value >= num,
      code: code ?? Language.code.min,
      message: message,
      parameters: (value, entity) => {
        'MinValue': '$num',
        'PropertyValue': '$value',
      },
    );
  }
}
