part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add an uppercase letter validation.
///
/// This extension adds a `mustHaveUppercase` method that can be used to ensure that a string
/// contains at least one uppercase letter.
extension MustHaveUppercaseValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] contains at least one uppercase letter.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must contain at least one uppercase letter".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .mustHaveUppercase();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> mustHaveUppercase({String? message, String? code}) {
    return use(
      (value, entity) {
        final isValid = RegExp(r'[A-Z]').hasMatch(value);
        if (isValid) return null;

        final currentCode = code ?? Language.code.mustHaveUppercase;
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
