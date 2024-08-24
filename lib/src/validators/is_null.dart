part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [T?] properties to add a null validation.
///
/// This extension adds an `isNull` method that can be used to ensure that a value
/// is null.
extension IsNullValidator<T> on LucidValidationBuilder<T?> {
  /// Adds a validation rule that checks if the value is null.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must be null".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String?>(key: 'optionalField');
  /// builder.isNull();
  /// ```
  LucidValidationBuilder<T?> isNull({String message = 'Must be null', String code = 'must_be_null'}) {
    return registerRule(
      (value) => value == null,
      message,
      code,
    );
  }
}
