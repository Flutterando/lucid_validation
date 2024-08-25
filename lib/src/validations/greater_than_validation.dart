part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a greater than validation.
///
/// This extension adds a `greaterThan` method that can be used to ensure that a number
/// is greater than a specified value.
extension GreaterThanValidation on SimpleValidationBuilder<num> {
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
  /// ...
  /// ruleFor((user) => user.age, key: 'age')
  ///   .greaterThan(18);
  /// ```
  SimpleValidationBuilder<num> greaterThan(num minValue, {String message = r'Must be greater than $minValue', String code = 'greater_than'}) {
    return must(
      (value) => value > minValue,
      message.replaceAll('$minValue', minValue.toString()),
      code,
    );
  }
}
