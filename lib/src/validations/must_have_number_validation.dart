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
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> mustHaveNumber(
      {String? message, String? code}) {
    return use(
      (value, entity) {
        final isValid = RegExp(r'[0-9]').hasMatch(value);
        if (isValid) return null;

        final currentCode = code ?? Language.code.mustHaveNumber;
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
      },
    );
  }
}

extension MustHaveNumbersNullableValidation
    on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] contains at least one numeric digit.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must contain at least one numeric digit".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password') // user.password is nullable
  ///   .mustHaveNumbers();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String?> mustHaveNumber(
      {String? message, String? code}) {
    return use(
      (value, entity) {
        if (value != null) {
          final isValid = RegExp(r'[0-9]').hasMatch(value);
          if (isValid) return null;
        }

        final currentCode = code ?? Language.code.mustHaveNumber;
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
      },
    );
  }
}

extension MustHaveNumbersOrNullableValidation
    on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] contains at least one numeric digit or [null].
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
  ///   .mustHaveNumberOrNull();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String?> mustHaveNumberOrNull(
      {String? message, String? code}) {
    return use(
      (value, entity) {
        if (value == null) return null;
        final isValid = RegExp(r'[0-9]').hasMatch(value);
        if (isValid) return null;

        final currentCode = code ?? Language.code.mustHaveNumber;
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
      },
    );
  }
}
