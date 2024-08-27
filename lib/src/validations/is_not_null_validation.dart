part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [T?] properties to add a not null validation.
///
/// This extension adds an `isNotNull` method that can be used to ensure that a value
/// is not null.
extension IsNotNullValidation<T> on SimpleValidationBuilder<T?> {
  /// Adds a validation rule that checks if the value is not null.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.name, key: 'name') // required field
  ///   .isNotNull();
  /// ```
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<T?> isNotNull({String? message, String? code}) {
    return use(
      (value, entity) {
        if (value != null) return null;

        final currentCode = code ?? Language.code.isNotNull;
        final currentMessage = message ??
            LucidValidation.global.languageManager.translate(currentCode, {
              'PropertyName': key,
            });

        return ValidationError(message: currentMessage, code: currentCode);
      },
    );
  }
}
