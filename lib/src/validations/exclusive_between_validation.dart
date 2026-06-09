part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add an exclusive between validation.
///
/// This extension adds an `exclusiveBetween` method that ensures a number is within
/// the open range `(min, max)` (both bounds excluded).
extension ExclusiveBetweenValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] is between [min] and [max] (exclusive).
  ///
  /// [min] is the lower bound (exclusive).
  /// [max] is the upper bound (exclusive).
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((sensor) => sensor.ratio, key: 'ratio')
  ///   .exclusiveBetween(0, 1);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{From}**: The lower bound.
  /// - **{To}**: The upper bound.
  /// - **{PropertyValue}**: The value of the property.
  SimpleValidationBuilder<num> exclusiveBetween(
    num min,
    num max, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value > min && value < max,
      code: code ?? Language.code.exclusiveBetween,
      message: message,
      parameters: (value, entity) => {
        'From': '$min',
        'To': '$max',
        'PropertyValue': '$value',
      },
    );
  }
}

extension ExclusiveBetweenOrNullableValidation
    on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] is between [min] and [max]
  /// (exclusive) or is `null`.
  ///
  /// [min] is the lower bound (exclusive).
  /// [max] is the upper bound (exclusive).
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{From}**: The lower bound.
  /// - **{To}**: The upper bound.
  /// - **{PropertyValue}**: The value of the property.
  SimpleValidationBuilder<num?> exclusiveBetweenOrNull(
    num min,
    num max, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value == null || (value > min && value < max),
      code: code ?? Language.code.exclusiveBetween,
      message: message,
      parameters: (value, entity) => {
        'From': '$min',
        'To': '$max',
        'PropertyValue': '$value',
      },
    );
  }
}
