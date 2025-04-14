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
          'PropertyName': label.isNotEmpty ? label : key,
        },
        defaultMessage: message,
      );

      return ValidationException(
        entity: extractClassName(entity.toString()),
        message: currentMessage,
        code: currentCode,
        key: key,
      );
    });
  }
}

extension IsEmptyNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is empty.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.name, key: 'name') // user.name is nullable
  ///   .isEmpty();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String?> isEmpty({String? message, String? code}) {
    return use((value, entity) {
      if (value != null && value.isEmpty) return null;

      final currentCode = code ?? Language.code.isEmpty;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
        },
        defaultMessage: message,
      );

      return ValidationException(
        entity: extractClassName(entity.toString()),
        message: currentMessage,
        code: currentCode,
        key: key,
      );
    });
  }
}

extension IsEmptyOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is empty.
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
  ///   .isEmptyOrNull();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String?> isEmptyOrNull(
      {String? message, String? code}) {
    return use((value, entity) {
      if (value == null || value.isEmpty) return null;

      final currentCode = code ?? Language.code.isEmpty;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
        },
        defaultMessage: message,
      );

      return ValidationException(
        entity: extractClassName(entity.toString()),
        message: currentMessage,
        code: currentCode,
        key: key,
      );
    });
  }
}
