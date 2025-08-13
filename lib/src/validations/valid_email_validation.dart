part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a valid email validation.
///
/// This extension adds a `validEmail` method that can be used to ensure that a string
/// is a valid email address.
extension ValidEmailValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid email address.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid email address".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.email, key: 'email')
  ///  .validEmail();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> validEmail({String? message, String? code}) {
    return use((value, entity) {
      if (RegExp(r'^[\w\.-]+@([A-Za-z0-9][A-Za-z0-9\-]*\.)+[A-Za-z]{2,}$')
          .hasMatch(value)) {
        return null;
      }

      final currentCode = code ?? Language.code.validEmail;
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

extension ValidEmailNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid email address.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid email address".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.email, key: 'email') // user.email is nullable
  ///  .validEmail();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String?> validEmail({String? message, String? code}) {
    return use((value, entity) {
      if (value != null &&
          RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
        return null;
      }

      final currentCode = code ?? Language.code.validEmail;
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

extension ValidEmailOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid email address.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid email address".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.email, key: 'email')
  ///  .validEmailOrNull();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String?> validEmailOrNull(
      {String? message, String? code}) {
    return use((value, entity) {
      if (value == null) return null;
      if (RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
        return null;
      }

      final currentCode = code ?? Language.code.validEmail;
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
