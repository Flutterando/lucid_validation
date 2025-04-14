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
    return use((value, entity) {
      if (_validateCPF(value) || _validateCNPJ(value)) return null;

      if (value.length == 11) {
        final currentCode = code ?? Language.code.validCpfOrCnpj;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': label.isNotEmpty ? label : key,
          },
          defaultMessage: message,
        );

        return ValidationException(
          entity: extractClassName(entity.toString()),
          message: currentMessage,
          code: currentCode,
          key: key,
        );
      } else if (value.length == 14) {
        final currentCode = code ?? Language.code.validCpfOrCnpj;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': label.isNotEmpty ? label : key,
          },
          defaultMessage: message,
        );

        return ValidationException(
          entity: extractClassName(entity.toString()),
          message: currentMessage,
          code: currentCode,
          key: key,
        );
      }

      final currentCode = code ?? Language.code.validCpfOrCnpj;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
        },
        defaultMessage: message,
      );

      return ValidationException(
        entity: extractClassName(entity.toString()),
        message: currentMessage,
        code: currentCode,
        key: key,
      );
    });
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
    return use((value, entity) {
      if (value != null && (_validateCPF(value) || _validateCNPJ(value))) {
        return null;
      }

      if (value != null && value.length == 11) {
        final currentCode = code ?? Language.code.validCpfOrCnpj;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': label.isNotEmpty ? label : key,
          },
          defaultMessage: message,
        );

        return ValidationException(
          entity: extractClassName(entity.toString()),
          message: currentMessage,
          code: currentCode,
          key: key,
        );
      } else if (value != null && value.length == 14) {
        final currentCode = code ?? Language.code.validCpfOrCnpj;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': label.isNotEmpty ? label : key,
          },
          defaultMessage: message,
        );

        return ValidationException(
          entity: extractClassName(entity.toString()),
          message: currentMessage,
          code: currentCode,
          key: key,
        );
      }

      final currentCode = code ?? Language.code.validCpfOrCnpj;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
        },
        defaultMessage: message,
      );

      return ValidationException(
        entity: extractClassName(entity.toString()),
        message: currentMessage,
        code: currentCode,
        key: key,
      );
    });
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
    return use((value, entity) {
      if (value == null) return null;
      if (_validateCPF(value) || _validateCNPJ(value)) return null;

      if (value.length == 11) {
        final currentCode = code ?? Language.code.validCpfOrCnpj;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': label.isNotEmpty ? label : key,
          },
          defaultMessage: message,
        );

        return ValidationException(
          entity: extractClassName(entity.toString()),
          message: currentMessage,
          code: currentCode,
          key: key,
        );
      } else if (value.length == 14) {
        final currentCode = code ?? Language.code.validCpfOrCnpj;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': label.isNotEmpty ? label : key,
          },
          defaultMessage: message,
        );

        return ValidationException(
          entity: extractClassName(entity.toString()),
          message: currentMessage,
          code: currentCode,
          key: key,
        );
      }

      final currentCode = code ?? Language.code.validCpfOrCnpj;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
        },
        defaultMessage: message,
      );

      return ValidationException(
        entity: extractClassName(entity.toString()),
        message: currentMessage,
        code: currentCode,
        key: key,
      );
    });
  }
}
