part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [T] properties to add a non-equality validation.
///
/// This extension adds a `notEqualTo` method that can be used to ensure that a value
/// is not equal to a specific value.
extension NotEqualValidator<T> on LucidValidationBuilder<T> {
  /// Adds a validation rule that checks if the value is not equal to [comparison].
  ///
  /// [comparison] is the value that the field must not match.
  /// [message] is the error message returned if the validation fails. Defaults to "Must not be equal to $comparison".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String>(key: 'newUsername');
  /// builder.notEqualTo('oldUsername');
  /// ```
  LucidValidationBuilder<T> notEqualTo(T comparison, {String message = r'Must not be equal to $comparison', String code = 'not_equal_to_error'}) {
    return registerRule(
      (value) => value != comparison,
      message.replaceAll(r'$comparison', comparison.toString()),
      code,
    );
  }
}
