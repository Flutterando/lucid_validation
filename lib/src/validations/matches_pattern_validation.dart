part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a regex pattern match validation.
///
/// This extension adds a `matchesPattern` method that can be used to ensure that a string
/// matches a specific regex pattern.
extension MatchesPatternValidation on SimpleValidationBuilder<String> {
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
  /// ...
  /// ruleFor((user) => user.phoneNumber, key: 'phoneNumber')
  ///   .matchesPattern(r'^\d{3}-\d{3}-\d{4}$');
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> matchesPattern(String pattern, {String? message, String? code}) {
    return use(
      (value, entity) {
        final isValid = RegExp(pattern).hasMatch(value);

        if (isValid) return null;

        final currentCode = code ?? Language.code.matchesPattern;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': key,
          },
          defaultMessage: message,
        );

        return ValidationError(message: currentMessage, code: currentCode);
      },
    );
  }
}
