part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a combined length validation.
extension LengthValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the length of a [String] is between
  /// [min] and [max] characters (inclusive).
  ///
  /// [min] is the minimum required length.
  /// [max] is the maximum allowed length.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.username, key: 'username')
  ///   .length(3, 20);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{MinLength}**: The minimum length.
  /// - **{MaxLength}**: The maximum length.
  /// - **{TotalLength}**: The number of characters entered.
  SimpleValidationBuilder<String> length(
    int min,
    int max, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value.length >= min && value.length <= max,
      code: code ?? Language.code.length,
      message: message,
      parameters: (value, entity) => {
        'MinLength': '$min',
        'MaxLength': '$max',
        'TotalLength': '${value.length}',
      },
    );
  }
}

extension LengthOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the length of a [String?] is between
  /// [min] and [max] characters (inclusive), or is `null`.
  ///
  /// [min] is the minimum required length.
  /// [max] is the maximum allowed length.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{MinLength}**: The minimum length.
  /// - **{MaxLength}**: The maximum length.
  /// - **{TotalLength}**: The number of characters entered.
  SimpleValidationBuilder<String?> lengthOrNull(
    int min,
    int max, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) =>
          value == null || (value.length >= min && value.length <= max),
      code: code ?? Language.code.length,
      message: message,
      parameters: (value, entity) => {
        'MinLength': '$min',
        'MaxLength': '$max',
        'TotalLength': '${value?.length ?? 0}',
      },
    );
  }
}
