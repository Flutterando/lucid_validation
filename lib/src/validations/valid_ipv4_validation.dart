part of 'validations.dart';

bool _isValidIpv4(String value) {
  final parts = value.split('.');
  if (parts.length != 4) return false;
  for (final part in parts) {
    if (part.isEmpty || part.length > 3) return false;
    final n = int.tryParse(part);
    if (n == null || n < 0 || n > 255) return false;
    if (part.length > 1 && part.startsWith('0')) return false;
  }
  return true;
}

extension ValidIpv4Validation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid IPv4 address.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((server) => server.ip, key: 'ip')
  ///   .validIpv4();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> validIpv4({String? message, String? code}) {
    return useValidation(
      (value, entity) => _isValidIpv4(value),
      code: code ?? Language.code.validIpv4,
      message: message,
    );
  }
}

extension ValidIpv4NullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid IPv4 address.
  ///
  /// Fails if the value is null or is not a valid IPv4 address.
  SimpleValidationBuilder<String?> validIpv4({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && _isValidIpv4(value),
      code: code ?? Language.code.validIpv4,
      message: message,
    );
  }
}

extension ValidIpv4OrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid IPv4 address or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and is not a valid IPv4 address.
  SimpleValidationBuilder<String?> validIpv4OrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || _isValidIpv4(value),
      code: code ?? Language.code.validIpv4,
      message: message,
    );
  }
}
