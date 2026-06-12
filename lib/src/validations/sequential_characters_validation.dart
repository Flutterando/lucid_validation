part of 'validations.dart';

/// Extension on [SimpleValidationBuilder] for [String] properties to add validation against sequential characters.
///
/// This extension adds a `hasNoSequentialCharacters` method that ensures a string does not contain sequential ascending or descending characters like "123" or "cba".
extension SequentialCharactersValidator on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if a [String] does not contain [sequenceLength] or more sequential characters (ascending or descending).
  ///
  /// [sequenceLength] is the number of sequential characters to disallow.
  /// [message] is an optional custom message.
  /// [code] is an optional custom error code.
  ///
  /// Returns the [SimpleValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .hasNoSequentialCharacters(sequenceLength: 3);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{Length}**: Number of sequential characters not allowed.
  SimpleValidationBuilder<String> hasNoSequentialCharacters({
    int sequenceLength = 3,
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) {
        if (value.isEmpty || value.length < sequenceLength) return true;
        return !_hasSequential(value, sequenceLength);
      },
      code: code ?? Language.code.sequentialCharactersNotAllowed,
      message: message,
      parameters: (value, entity) => {'Length': '$sequenceLength'},
    );
  }
}

/// Extension on [SimpleValidationBuilder] for nullable [String?] properties to add validation against sequential characters.
///
/// This extension ensures that even nullable strings are validated for sequential characters.
extension SequentialCharactersNullableValidator
    on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if a nullable [String?] does not contain [sequenceLength] or more sequential characters (ascending or descending).
  ///
  /// [sequenceLength] is the number of sequential characters to disallow.
  /// [message] is an optional custom message.
  /// [code] is an optional custom error code.
  ///
  /// Returns the [SimpleValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .hasNoSequentialCharacters(sequenceLength: 3);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{Length}**: Number of sequential characters not allowed.
  SimpleValidationBuilder<String?> hasNoSequentialCharacters({
    int sequenceLength = 3,
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) {
        if (value == null || value.length < sequenceLength) return true;
        return !_hasSequential(value, sequenceLength);
      },
      code: code ?? Language.code.sequentialCharactersNotAllowed,
      message: message,
      parameters: (value, entity) => {'Length': '$sequenceLength'},
    );
  }
}

/// Extension on [SimpleValidationBuilder] for nullable [String?] properties
/// that allows either a valid string with no sequential characters or null.
///
/// Useful when the field is optional but must be validated when present.
extension SequentialCharactersOrNullValidator
    on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if a nullable [String?] either is null or does not contain [sequenceLength] or more sequential characters (ascending or descending).
  ///
  /// [sequenceLength] is the number of sequential characters to disallow.
  /// [message] is an optional custom message.
  /// [code] is an optional custom error code.
  ///
  /// Returns the [SimpleValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.nickname, key: 'nickname')
  ///   .hasNoSequentialCharactersOrNull(sequenceLength: 4);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{Length}**: Number of sequential characters not allowed.
  SimpleValidationBuilder<String?> hasNoSequentialCharactersOrNull({
    int sequenceLength = 3,
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) {
        if (value == null) return true;
        return !_hasSequential(value, sequenceLength);
      },
      code: code ?? Language.code.sequentialCharactersNotAllowed,
      message: message,
      parameters: (value, entity) => {'Length': '$sequenceLength'},
    );
  }
}

bool _hasSequential(String input, int length) {
  for (int i = 0; i <= input.length - length; i++) {
    final slice = input.substring(i, i + length);
    if (_isSequential(slice, ascending: true) ||
        _isSequential(slice, ascending: false)) {
      return true;
    }
  }
  return false;
}

bool _isSequential(String input, {required bool ascending}) {
  for (int i = 0; i < input.length - 1; i++) {
    final current = input.codeUnitAt(i);
    final next = input.codeUnitAt(i + 1);
    if (ascending) {
      if (next != current + 1) return false;
    } else {
      if (next != current - 1) return false;
    }
  }
  return true;
}
