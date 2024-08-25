part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a numeric character validation.
///
/// This extension adds a `mustHaveNumbers` method that can be used to ensure that a string
/// contains at least one numeric digit.
extension MustHaveNumbersValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] contains at least one numeric digit.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must contain at least one numeric digit".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .mustHaveNumbers();
  /// ```
  SimpleValidationBuilder<String> mustHaveNumbers({String message = 'Must contain at least one numeric digit', String code = 'must_have_numbers'}) {
    return must(
      (value) => RegExp(r'[0-9]').hasMatch(value),
      message,
      code,
    );
  }
}
