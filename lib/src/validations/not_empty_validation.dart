part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a not empty validation.
///
/// This extension adds a `notEmpty` method that can be used to ensure that a string
/// is not empty.
extension NotEmptyValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is not empty.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Cannot be empty".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.username, key: 'username')
  ///   .notEmpty();
  /// ```
  SimpleValidationBuilder<String> notEmpty({String message = 'Cannot be empty', String code = 'not_empty'}) {
    return must(
      (value) => value.isNotEmpty,
      message,
      code,
    );
  }
}
