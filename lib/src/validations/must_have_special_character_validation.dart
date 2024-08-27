part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a special character validation.
///
/// This extension adds a `mustHaveSpecialCharacter` method that can be used to ensure that a string
/// contains at least one special character.
extension MustHaveSpecialCharacterValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] contains at least one special character.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must contain at least one special character".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .mustHaveSpecialCharacter();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> mustHaveSpecialCharacter({String? message, String? code}) {
    return use(
      (value, entity) {
        final isValid = RegExp(r'[!@#\$%\^&\*(),.?":{}|<>]').hasMatch(value);
        if (isValid) return null;

        final currentCode = code ?? Language.code.mustHaveSpecialCharacter;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': key,
          },
          defaultMessage: message,
        );

        return ValidationException(message: currentMessage, code: currentCode);
      },
    );
  }
}
