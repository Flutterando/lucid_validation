part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a maximum length validation.
///
/// This extension adds a `maxLength` method that can be used to ensure that the length of a string
/// does not exceed a specified maximum number of characters.
extension MaxLengthValidation on SimpleValidationBuilder<String> {
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
  /// ...
  /// ruleFor((user) => user.username, key: 'username')
  ///   .maxLength(10);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{MaxLength}**: The value to compare against.
  /// - **{TotalLength}**: total characters entered.
  ///
  SimpleValidationBuilder<String> maxLength(int num, {String? message, String? code}) {
    return use(
      (value, entity) {
        if (value.length <= num) return null;

        final currentCode = code ?? Language.code.maxLength;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': key,
            'MaxLength': '$num',
            'TotalLength': '${value.length}',
          },
          defaultMessage: message,
        );

        return ValidationException(message: currentMessage, code: currentCode);
      },
    );
  }
}
