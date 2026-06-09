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
    return useValidation(
      (value, entity) => value.isEmpty,
      code: code ?? Language.code.isEmpty,
      message: message,
    );
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
    return useValidation(
      (value, entity) => value != null && value.isEmpty,
      code: code ?? Language.code.isEmpty,
      message: message,
    );
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
    return useValidation(
      (value, entity) => value == null || value.isEmpty,
      code: code ?? Language.code.isEmpty,
      message: message,
    );
  }
}
