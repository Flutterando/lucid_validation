part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add an uppercase letter validation.
///
/// This extension adds a `mustHaveUppercase` method that can be used to ensure that a string
/// contains at least one uppercase letter.
extension MustHaveUppercase on LucidValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] contains at least one uppercase letter.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must contain at least one uppercase letter".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String>(key: 'password');
  /// builder.mustHaveUppercase();
  /// ```
  LucidValidationBuilder<String> mustHaveUppercase({String message = 'Must contain at least one uppercase letter', String code = 'must_have_uppercase'}) {
    return registerRule(
      (value) => RegExp(r'[A-Z]').hasMatch(value),
      message,
      code,
    );
  }
}
