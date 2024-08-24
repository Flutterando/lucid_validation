part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a regex pattern match validation.
///
/// This extension adds a `matchesPattern` method that can be used to ensure that a string
/// matches a specific regex pattern.
extension MatchesPatternValidator on LucidValidationBuilder<String, dynamic> {
  /// Adds a validation rule that checks if the [String] matches the [pattern].
  ///
  /// [pattern] is the regex pattern that the string must match.
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid format".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String>(key: 'phoneNumber');
  /// builder.matchesPattern(r'^\d{3}-\d{3}-\d{4}$');
  /// ```
  LucidValidationBuilder<String, dynamic> matchesPattern(String pattern, {String message = 'Invalid format', String code = 'invalid_format'}) {
    return must(
      (value) => RegExp(pattern).hasMatch(value),
      message,
      code,
    );
  }
}
