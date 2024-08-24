part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a less than validation.
///
/// This extension adds a `lessThan` method that can be used to ensure that a number
/// is less than a specified value.
extension LessThanValidator on LucidValidationBuilder<num> {
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
  /// final builder = LucidValidationBuilder<num>(key: 'discount');
  /// builder.lessThan(100);
  /// ```
  LucidValidationBuilder<num> lessThan(num maxValue, {String message = r'Must be less than $maxValue', String code = 'less_than'}) {
    return registerRule(
      (value) => value < maxValue,
      message.replaceAll('$maxValue', maxValue.toString()),
      code,
    );
  }
}
