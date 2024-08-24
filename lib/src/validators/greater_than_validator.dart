part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a greater than validation.
///
/// This extension adds a `greaterThan` method that can be used to ensure that a number
/// is greater than a specified value.
extension GreaterThanValidator on LucidValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] is greater than [minValue].
  ///
  /// [minValue] is the value that the number must be greater than.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be greater than $minValue".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<num>(key: 'age');
  /// builder.greaterThan(18);
  /// ```
  LucidValidationBuilder<num> greaterThan(num minValue, {String message = r'Must be greater than $minValue', String code = 'greater_than'}) {
    return registerRule(
      (value) => value > minValue,
      message.replaceAll('$minValue', minValue.toString()),
      code,
    );
  }
}
