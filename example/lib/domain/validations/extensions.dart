import 'package:lucid_validation/lucid_validation.dart';

extension CustomValidPasswordValidator on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> customValidPassword() {
    return notEmpty() //
        .minLength(5)
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumber()
        .mustHaveSpecialCharacter();
  }
}

extension CustomValidUrlValidator on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> customValidPhone({
    String code = 'validPhone',
    required String message,
  }) {
    return use((value, entity) {
      final regex = RegExp(
        r'^\(?(\d{2})\)?\s?9?\d{4}-?\d{4}$',
        caseSensitive: false,
      );

      if (regex.hasMatch(value)) {
        return null;
      }

      return ValidationException(
        message: message,
        code: code,
        key: key,
        entity: extractClassName(entity),
      );
    });
  }
}
