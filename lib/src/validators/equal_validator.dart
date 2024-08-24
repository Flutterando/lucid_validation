part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [T] properties to add an equality validation.
///
/// This extension adds an `equalTo` method that can be used to ensure that a value
/// is equal to a specific value.
extension EqualValidator<T> on LucidValidationBuilder<T> {
  /// Adds a validation rule that checks if the value is equal to [comparison].
  ///
  /// [comparison] is the value that the field must match.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be equal to $comparison".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String>(key: 'confirmPassword');
  /// builder.equalTo('password123');
  /// ```
  LucidValidationBuilder<T> equalTo(T comparison, {String message = r'Must be equal to $comparison', String code = 'equal_to_error'}) {
    return registerRule(
      (value) => value == comparison,
      message.replaceAll(r'$comparison', comparison.toString()),
      code,
    );
  }
}
