part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a maximum value validation.
///
/// This extension adds a `max` method that can be used to ensure that a numerical value
/// does not exceed a specified maximum.
extension MaxValidation on LucidValidationBuilder<num, dynamic> {
  /// Adds a validation rule that checks if a [num] value is less than or equal to [num].
  ///
  /// [num] is the maximum allowed value.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be less than or equal to $num".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<num>(key: 'age');
  /// builder.max(18);
  /// ```
  LucidValidationBuilder<num, dynamic> max(num num, {String message = r'Must be less than or equal to $num', String code = 'max_value'}) {
    return must(
      (value) => value <= num,
      message.replaceAll(r'$num', num.toString()),
      code,
    );
  }
}
