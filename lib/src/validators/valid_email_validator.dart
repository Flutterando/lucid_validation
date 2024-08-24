part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a valid email validation.
///
/// This extension adds a `validEmail` method that can be used to ensure that a string
/// is a valid email address.
extension ValidEmailValidator on LucidValidationBuilder<String, dynamic> {
  /// Adds a validation rule that checks if the [String] is a valid email address.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid email address".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String>(key: 'email');
  /// builder.validEmail();
  /// ```
  LucidValidationBuilder<String, dynamic> validEmail({String message = 'Invalid email address', String code = 'invalid_email'}) {
    return must(
      (value) => RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$').hasMatch(value),
      message,
      code,
    );
  }
}
