part of 'validations.dart';

/// Extension on [SimpleValidationBuilder] for [String] properties to add validation against sequential repeated characters.
///
/// This extension adds a `hasNoSequentialRepeatedCharacters` method that ensures a string does not contain repeated characters in sequence.
extension RepeatedCharactersValidator on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if a [String] does not contain [sequenceLength] or more of the same character in sequence.
  ///
  /// [sequenceLength] is the number of repeated characters in sequence to disallow.
  /// [label] is the display name of the field used in the error message.
  ///
  /// Returns the [SimpleValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .hasNoSequentialRepeatedCharacters(sequenceLength: 3);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{SequenceLength}**: Number of repeated characters not allowed.
  SimpleValidationBuilder<String> hasNoSequentialRepeatedCharacters({
    int sequenceLength = 3,
    String? message,
    String? code,
  }) {
    return use((value, entity) {
      if (value.isEmpty) return null;

      final regex = RegExp(r'(.)\1{' + (sequenceLength - 1).toString() + r',}');
      if (!regex.hasMatch(value)) {
        return null;
      }

      final currentCode = code ?? Language.code.sequentialRepeatedCharacters;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
          'SequenceLength': '$sequenceLength',
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

/// Extension on [SimpleValidationBuilder] for nullable [String?] properties to add validation against sequential repeated characters.
///
/// This extension allows validation even when the input string is nullable.
extension RepeatedCharactersNullableValidator
    on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if a nullable [String?] does not contain [sequenceLength] or more of the same character in sequence.
  ///
  /// [sequenceLength] is the number of repeated characters in sequence to disallow.
  /// [label] is the display name of the field used in the error message.
  ///
  /// Returns the [SimpleValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .hasNoSequentialRepeatedCharacters(sequenceLength: 3);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{SequenceLength}**: Number of repeated characters not allowed.
  SimpleValidationBuilder<String?> hasNoSequentialRepeatedCharacters({
    int sequenceLength = 3,
    String? message,
    String? code,
  }) {
    return use((value, entity) {
      if (value == null || value.isEmpty) return null;

      final regex = RegExp(r'(.)\1{' + (sequenceLength - 1).toString() + r',}');
      if (!regex.hasMatch(value)) {
        return null;
      }

      final currentCode = code ?? Language.code.sequentialRepeatedCharacters;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
          'SequenceLength': '$sequenceLength',
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

/// Extension on [SimpleValidationBuilder] for nullable [String?] properties
/// that allows either a valid string with no repeated characters or null.
///
/// Useful when the field is optional but still must be validated when present.
extension RepeatedCharactersOrNullValidator
    on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if a nullable [String?] either is null or does not contain [sequenceLength] or more of the same character in sequence.
  ///
  /// [sequenceLength] is the number of repeated characters in sequence to disallow.
  /// [label] is the display name of the field used in the error message.
  ///
  /// Returns the [SimpleValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.nickname, key: 'nickname')
  ///   .hasNoSequentialRepeatedCharactersOrNull(sequenceLength: 4);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{SequenceLength}**: Number of repeated characters not allowed.
  SimpleValidationBuilder<String?> hasNoSequentialRepeatedCharactersOrNull({
    int sequenceLength = 3,
    String? message,
    String? code,
  }) {
    return use((value, entity) {
      if (value == null) return null;

      final regex = RegExp(r'(.)\1{' + (sequenceLength - 1).toString() + r',}');
      if (!regex.hasMatch(value)) {
        return null;
      }

      final currentCode = code ?? Language.code.sequentialRepeatedCharacters;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
          'SequenceLength': '$sequenceLength',
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
