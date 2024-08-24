part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a maximum length validation.
///
/// This extension adds a `maxLength` method that can be used to ensure that the length of a string
/// does not exceed a specified maximum number of characters.
extension MaxLengthValidator on LucidValidationBuilder<String, dynamic> {
  /// Adds a validation rule that checks if the length of a [String] is less than or equal to [num].
  ///
  /// [num] is the maximum allowed length for the string.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be at most $num characters long".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String>(key: 'username');
  /// builder.maxLength(10);
  /// ```
  LucidValidationBuilder<String, dynamic> maxLength(int num, {String message = r'Must be at most $num characters long', String code = 'max_length'}) {
    return must(
      (value) => value.length <= num,
      message.replaceAll(r'$num', num.toString()),
      code,
    );
  }
}
