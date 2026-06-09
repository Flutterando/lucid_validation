part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add an inclusive between validation.
///
/// This extension adds an `inclusiveBetween` method that ensures a number is within
/// the closed range `[min, max]` (both bounds included).
extension InclusiveBetweenValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] is between [min] and [max] (inclusive).
  ///
  /// [min] is the lower bound (inclusive).
  /// [max] is the upper bound (inclusive).
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((product) => product.discount, key: 'discount')
  ///   .inclusiveBetween(0, 100);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{From}**: The lower bound.
  /// - **{To}**: The upper bound.
  /// - **{PropertyValue}**: The value of the property.
  SimpleValidationBuilder<num> inclusiveBetween(
    num min,
    num max, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value >= min && value <= max,
      code: code ?? Language.code.inclusiveBetween,
      message: message,
      parameters: (value, entity) => {
        'From': '$min',
        'To': '$max',
        'PropertyValue': '$value',
      },
    );
  }
}

extension InclusiveBetweenOrNullableValidation
    on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks if the [num?] is between [min] and [max]
  /// (inclusive) or is `null`.
  ///
  /// [min] is the lower bound (inclusive).
  /// [max] is the upper bound (inclusive).
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{From}**: The lower bound.
  /// - **{To}**: The upper bound.
  /// - **{PropertyValue}**: The value of the property.
  SimpleValidationBuilder<num?> inclusiveBetweenOrNull(
    num min,
    num max, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value == null || (value >= min && value <= max),
      code: code ?? Language.code.inclusiveBetween,
      message: message,
      parameters: (value, entity) => {
        'From': '$min',
        'To': '$max',
        'PropertyValue': '$value',
      },
    );
  }
}
