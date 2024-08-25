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
  SimpleValidationBuilder<num> min(num num, {String message = r'Must be greater than or equal to $num', String code = 'min_value'}) {
    return must(
      (value) => value >= num,
      message.replaceAll(r'$num', num.toString()),
      code,
    );
  }
}
