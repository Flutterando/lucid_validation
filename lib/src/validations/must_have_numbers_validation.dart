part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a numeric character validation.
///
/// This extension adds a `mustHaveNumbers` method that can be used to ensure that a string
/// contains at least one numeric digit.
extension MustHaveNumbersValidation on LucidValidationBuilder<String, dynamic> {
  /// Adds a validation rule that checks if the [String] contains at least one numeric digit.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must contain at least one numeric digit".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String>(key: 'password');
  /// builder.mustHaveNumbers();
  /// ```
  LucidValidationBuilder<String, dynamic> mustHaveNumbers({String message = 'Must contain at least one numeric digit', String code = 'must_have_numbers'}) {
    return must(
      (value) => RegExp(r'[0-9]').hasMatch(value),
      message,
      code,
    );
  }
}
