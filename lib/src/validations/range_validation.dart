part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a range validation.
///
/// This extension adds a `range` method that can be used to ensure that a number
/// is within a specified range.
extension RangeValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] is within the range of [min] and [max].
  ///
  /// [min] and [max] define the acceptable range for the number.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be between $min and $max".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.age, key: 'age')
  ///   .range(18, 65);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{From}**: The minimum value of the range.
  /// - **{To}**: The maximum value of the range.
  /// - **{PropertyValue}**: The value of the property.
  ///
  SimpleValidationBuilder<num> range(num min, num max,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value >= min && value <= max,
      code: code ?? Language.code.range,
      message: message,
      parameters: (value, entity) => {
        'From': '$min',
        'To': '$max',
        'PropertyValue': '$value',
      },
    );
  }
}

extension RangeNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] is within the range of [min] and [max].
  ///
  /// [min] and [max] define the acceptable range for the number.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be between $min and $max".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.age, key: 'age') // user.age is nullable
  ///   .range(18, 65);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{From}**: The minimum value of the range.
  /// - **{To}**: The maximum value of the range.
  /// - **{PropertyValue}**: The value of the property.
  ///
  SimpleValidationBuilder<num?> range(num min, num max,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value >= min && value <= max,
      code: code ?? Language.code.range,
      message: message,
      parameters: (value, entity) => {
        'From': '$min',
        'To': '$max',
        'PropertyValue': '$value',
      },
    );
  }
}

extension RangeOrNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] is within the range of [min] and [max].
  ///
  /// [min] and [max] define the acceptable range for the number.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be between $min and $max".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.age, key: 'age') // user.age is nullable
  ///   .range(18, 65);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{From}**: The minimum value of the range.
  /// - **{To}**: The maximum value of the range.
  /// - **{PropertyValue}**: The value of the property.
  ///
  SimpleValidationBuilder<num?> rangeOrNull(num min, num max,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || (value >= min && value <= max),
      code: code ?? Language.code.range,
      message: message,
      parameters: (value, entity) => {
        'From': '$min',
        'To': '$max',
        'PropertyValue': '$value',
      },
    );
  }
}
