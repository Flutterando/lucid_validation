part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a special character validation.
///
/// This extension adds a `mustHaveSpecialCharacter` method that can be used to ensure that a string
/// contains at least one special character.
extension MustHaveSpecialCharacter on LucidValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] contains at least one special character.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must contain at least one special character".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String>(key: 'password');
  /// builder.mustHaveSpecialCharacter();
  /// ```
  LucidValidationBuilder<String> mustHaveSpecialCharacter({String message = 'Must contain at least one special character', String code = 'must_have_special_character'}) {
    return registerRule(
      (value) => RegExp(r'[!@#\$%\^&\*(),.?":{}|<>]').hasMatch(value),
      message,
      code,
    );
  }
}
