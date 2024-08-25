part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a minimum value validation.
///
/// This extension adds a `min` method that can be used to ensure that a numerical value
/// meets or exceeds a specified minimum.
extension MinValidation on LucidValidationBuilder<num, dynamic> {
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
  /// final builder = LucidValidationBuilder<num>(key: 'age');
  /// builder.min(18);
  /// ```
  LucidValidationBuilder<num, dynamic> min(num num, {String message = r'Must be greater than or equal to $num', String code = 'min_value'}) {
    return must(
      (value) => value >= num,
      message.replaceAll(r'$num', num.toString()),
      code,
    );
  }
}
