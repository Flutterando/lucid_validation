part of 'validations.dart';

bool _isHttpUrl(String value) {
  try {
    final uri = Uri.parse(value);
    return (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  } catch (_) {
    return false;
  }
}

extension HttpUrlValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid HTTP or HTTPS URL.
  ///
  /// Unlike [validUrl], this method only accepts URLs with the `http` or `https` scheme.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((config) => config.webhookUrl, key: 'webhookUrl')
  ///   .httpUrl();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> httpUrl({String? message, String? code}) {
    return useValidation(
      (value, entity) => _isHttpUrl(value),
      code: code ?? Language.code.httpUrl,
      message: message,
    );
  }
}

extension HttpUrlNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid HTTP or HTTPS URL.
  ///
  /// Fails if the value is null or is not a valid HTTP/HTTPS URL.
  SimpleValidationBuilder<String?> httpUrl({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && _isHttpUrl(value),
      code: code ?? Language.code.httpUrl,
      message: message,
    );
  }
}

extension HttpUrlOrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid HTTP or HTTPS URL or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and is not a valid HTTP/HTTPS URL.
  SimpleValidationBuilder<String?> httpUrlOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || _isHttpUrl(value),
      code: code ?? Language.code.httpUrl,
      message: message,
    );
  }
}
