part of 'validations.dart';

final _ipv6RegExp = RegExp(
  r'^('
  r'([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|'
  r'([0-9a-fA-F]{1,4}:){1,7}:|'
  r'([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|'
  r'([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|'
  r'([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|'
  r'([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|'
  r'([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|'
  r'[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|'
  r':((:[0-9a-fA-F]{1,4}){1,7}|:)|'
  r'::([fF]{4}(:0{1,4})?:)?'
  r'((25[0-5]|(2[0-4]|1?[0-9])?[0-9])\.){3}'
  r'(25[0-5]|(2[0-4]|1?[0-9])?[0-9])|'
  r'([0-9a-fA-F]{1,4}:){1,4}:'
  r'((25[0-5]|(2[0-4]|1?[0-9])?[0-9])\.){3}'
  r'(25[0-5]|(2[0-4]|1?[0-9])?[0-9])'
  r')$',
);

extension ValidIpv6Validation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid IPv6 address.
  ///
  /// Supports full, compressed (::), and IPv4-mapped (::ffff:) formats.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((server) => server.ipv6, key: 'ipv6')
  ///   .validIpv6();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> validIpv6({String? message, String? code}) {
    return useValidation(
      (value, entity) => _ipv6RegExp.hasMatch(value),
      code: code ?? Language.code.validIpv6,
      message: message,
    );
  }
}

extension ValidIpv6NullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid IPv6 address.
  ///
  /// Fails if the value is null or is not a valid IPv6 address.
  SimpleValidationBuilder<String?> validIpv6({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && _ipv6RegExp.hasMatch(value),
      code: code ?? Language.code.validIpv6,
      message: message,
    );
  }
}

extension ValidIpv6OrNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid IPv6 address or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and is not a valid IPv6 address.
  SimpleValidationBuilder<String?> validIpv6OrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || _ipv6RegExp.hasMatch(value),
      code: code ?? Language.code.validIpv6,
      message: message,
    );
  }
}
