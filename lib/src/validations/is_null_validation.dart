part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [T?] properties to add a null validation.
///
/// This extension adds an `isNull` method that can be used to ensure that a value
/// is null.
extension IsNullValidation<T> on SimpleValidationBuilder<T?> {
  /// Adds a validation rule that checks if the value is null.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must be null".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.name, key: 'name') // optional field
  ///   .isNull();
  /// ```
  SimpleValidationBuilder<T?> isNull({String message = 'Must be null', String code = 'must_be_null'}) {
    return must(
      (value) => value == null,
      message,
      code,
    );
  }
}
