part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [T?] properties to add a not null validation.
///
/// This extension adds an `isNotNull` method that can be used to ensure that a value
/// is not null.
extension IsNotNullValidator<T> on LucidValidationBuilder<T?> {
  /// Adds a validation rule that checks if the value is not null.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Cannot be null".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String?>(key: 'requiredField');
  /// builder.isNotNull();
  /// ```
  LucidValidationBuilder<T?> isNotNull({String message = 'Cannot be null', String code = 'cannot_be_null'}) {
    return registerRule(
      (value) => value != null,
      message,
      code,
    );
  }
}
