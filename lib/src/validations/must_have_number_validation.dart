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
    return useValidation(
      (value, entity) => RegExp(r'[0-9]').hasMatch(value),
      code: code ?? Language.code.mustHaveNumber,
      message: message,
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
    return useValidation(
      (value, entity) => value != null && RegExp(r'[0-9]').hasMatch(value),
      code: code ?? Language.code.mustHaveNumber,
      message: message,
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
    return useValidation(
      (value, entity) => value == null || RegExp(r'[0-9]').hasMatch(value),
      code: code ?? Language.code.mustHaveNumber,
      message: message,
    );
  }
}
