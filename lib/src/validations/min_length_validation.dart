part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a minimum length validation.
///
/// This extension adds a `minLength` method that can be used to ensure that the length of a string
/// meets a specified minimum number of characters.
extension MinLengthValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the length of a [String] is greater than or equal to [num].
  ///
  /// [num] is the minimum required length for the string.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be at least $num characters long".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .maxLength(8);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{MinLength}**: The value to compare against.
  /// - **{TotalLength}**: total characters entered.
  SimpleValidationBuilder<String> minLength(int num,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value.length >= num,
      code: code ?? Language.code.minLength,
      message: message,
      parameters: (value, entity) => {
        'MinLength': '$num',
        'TotalLength': '${value.length}',
      },
    );
  }
}

extension MinLengthNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the length of a [String?] is greater than or equal to [num].
  ///
  /// [num] is the minimum required length for the string.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be at least $num characters long".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password') // user.password is nullable
  ///   .maxLength(8);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{MinLength}**: The value to compare against.
  /// - **{TotalLength}**: total characters entered.
  SimpleValidationBuilder<String?> minLength(int num,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value.length >= num,
      code: code ?? Language.code.minLength,
      message: message,
      parameters: (value, entity) => {
        'MinLength': '$num',
        'TotalLength': '${value != null ? value.length : 0}',
      },
    );
  }
}

extension MinLengthOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the length of a [String?] is greater than or equal to [num] or [null].
  ///
  /// [num] is the minimum required length for the string.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be at least $num characters long".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .minLengthOrNull(8);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{MinLength}**: The value to compare against.
  /// - **{TotalLength}**: total characters entered.
  SimpleValidationBuilder<String?> minLengthOrNull(int num,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value.length >= num,
      code: code ?? Language.code.minLength,
      message: message,
      parameters: (value, entity) => {
        'MinLength': '$num',
        'TotalLength': '${value?.length ?? 0}',
      },
    );
  }
}
