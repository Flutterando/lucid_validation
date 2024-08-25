part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a range validation.
///
/// This extension adds a `range` method that can be used to ensure that a number
/// is within a specified range.
extension RangeValidation on LucidValidationBuilder<num, dynamic> {
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
  /// final builder = LucidValidationBuilder<num>(key: 'age');
  /// builder.range(18, 65);
  /// ```
  LucidValidationBuilder<num, dynamic> range(num min, num max, {String message = r'Must be between $min and $max', String code = 'range_error'}) {
    return must(
      (value) => value >= min && value <= max,
      message.replaceAll(r'$min', min.toString()).replaceAll('$max', max.toString()),
      code,
    );
  }
}
