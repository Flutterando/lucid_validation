part of 'validations.dart';

final _urlRegex = RegExp(
  r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(:\d+)?(\/[^\s]*)?$',
  caseSensitive: false,
);

/// Extension on [LucidValidationBuilder] for [String] properties to add a valid URL validation.
extension ValidUrlValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid URL.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((company) => company.website, key: 'website')
  ///   .validUrl();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  SimpleValidationBuilder<String> validUrl({String? message, String? code}) {
    return useValidation(
      (value, entity) => _urlRegex.hasMatch(value),
      code: code ?? Language.code.validUrl,
      message: message,
    );
  }
}

extension ValidUrlOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid URL or is `null`.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  SimpleValidationBuilder<String?> validUrlOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || _urlRegex.hasMatch(value),
      code: code ?? Language.code.validUrl,
      message: message,
    );
  }
}
