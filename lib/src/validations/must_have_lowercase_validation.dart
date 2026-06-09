part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a lowercase letter validation.
///
/// This extension adds a `mustHaveLowercase` method that can be used to ensure that a string
/// contains at least one lowercase letter.
extension MustHaveLowercaseValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] contains at least one lowercase letter.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must contain at least one lowercase letter".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .mustHaveLowercase();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  /// '{PropertyName}' must have at least one lowercase letter.
  SimpleValidationBuilder<String> mustHaveLowercase(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => RegExp(r'[a-z]').hasMatch(value),
      code: code ?? Language.code.mustHaveLowercase,
      message: message,
    );
  }
}

extension MustHaveLowercaseNullableValidation
    on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] contains at least one lowercase letter.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must contain at least one lowercase letter".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password') //  user.password is nullable
  ///   .mustHaveLowercase();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  /// '{PropertyName}' must have at least one lowercase letter.
  SimpleValidationBuilder<String?> mustHaveLowercase(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && RegExp(r'[a-z]').hasMatch(value),
      code: code ?? Language.code.mustHaveLowercase,
      message: message,
    );
  }
}

extension MustHaveLowercaseOrNullableValidation
    on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] contains at least one lowercase letter or [null].
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Must contain at least one lowercase letter".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .mustHaveLowercaseOrNull();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  /// '{PropertyName}' must have at least one lowercase letter.
  SimpleValidationBuilder<String?> mustHaveLowercaseOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || RegExp(r'[a-z]').hasMatch(value),
      code: code ?? Language.code.mustHaveLowercase,
      message: message,
    );
  }
}
