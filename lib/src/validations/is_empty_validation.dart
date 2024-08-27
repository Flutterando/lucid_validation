part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add an empty string validation.
///
/// This extension adds an `isEmpty` method that can be used to ensure that a string
/// is empty.
extension IsEmptyValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is empty.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.name, key: 'name')
  ///   .isEmpty();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> isEmpty({String? message, String? code}) {
    return use((value, entity) {
      if (value.isEmpty) return null;

      final currentCode = code ?? Language.code.isEmpty;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': key,
        },
        defaultMessage: message,
      );

      return ValidationError(message: currentMessage, code: currentCode);
    });
  }
}
