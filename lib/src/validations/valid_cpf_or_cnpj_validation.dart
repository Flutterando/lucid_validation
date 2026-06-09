part of 'validations.dart';

extension ValidCpfOrCnpjValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the [String] is a valid CPF or CNPJ number.
  ///
  /// The CPF is the national identifier for Brazilian individuals and the CNPJ is the national identifier for Brazilian companies.
  /// This method verifies the format and the validity of the CPF or CNPJ, ensuring it follows the correct algorithm for digit verification.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid CPF or CNPJ".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ...
  /// ruleFor((user) => user.cpfOrCnpj, key: 'cpfOrCnpj')
  ///   .validCpfOrCnpj();
  ///
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String> validCPFOrCNPJ(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => _validateCPF(value) || _validateCNPJ(value),
      code: code ?? Language.code.validCpfOrCnpj,
      message: message,
    );
  }
}

extension ValidCpfOrCnpjNullableValidation on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String] is a valid CPF or CNPJ number.
  ///
  /// The CPF is the national identifier for Brazilian individuals and the CNPJ is the national identifier for Brazilian companies.
  /// This method verifies the format and the validity of the CPF or CNPJ, ensuring it follows the correct algorithm for digit verification.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid CPF or CNPJ".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ...
  /// ruleFor((user) => user.cpfOrCnpj, key: 'cpfOrCnpj')  // user.cpfOrCnpj is nullable
  ///   .validCpfOrCnpj();
  ///
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String?> validCPFOrCNPJ(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) =>
          value != null && (_validateCPF(value) || _validateCNPJ(value)),
      code: code ?? Language.code.validCpfOrCnpj,
      message: message,
    );
  }
}

extension ValidCpfOrCnpjOrNullableValidation
    on SimpleValidationBuilder<String?> {
  /// Adds a validation rule that checks if the [String?] is a valid CEP (Brazilian postal code) or [null].
  ///
  /// This method verifies that the CEP is in the correct format (#####-###) and consists
  /// of only numbers.
  ///
  /// [message] is the error message returned if the validation fails. Defaults to "Invalid CEP".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.cep, key: 'cep')
  ///  .validCEPOrNull();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<String?> validCPFOrCNPJOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) =>
          value == null || _validateCPF(value) || _validateCNPJ(value),
      code: code ?? Language.code.validCpfOrCnpj,
      message: message,
    );
  }
}
