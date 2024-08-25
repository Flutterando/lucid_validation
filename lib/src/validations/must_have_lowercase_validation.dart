part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a lowercase letter validation.
///
/// This extension adds a `mustHaveLowercase` method that can be used to ensure that a string
/// contains at least one lowercase letter.
extension MustHaveLowercaseValidation on LucidValidationBuilder<String, dynamic> {
  /// Adds a validation rule that checks if the [String] contains at least one lowercase letter.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must contain at least one lowercase letter".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String>(key: 'password');
  /// builder.mustHaveLowercase();
  /// ```
  LucidValidationBuilder<String, dynamic> mustHaveLowercase({String message = 'Must contain at least one lowercase letter', String code = 'must_have_lowercase'}) {
    return must(
      (value) => RegExp(r'[a-z]').hasMatch(value),
      message,
      code,
    );
  }
}
