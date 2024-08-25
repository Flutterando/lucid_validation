import 'package:lucid_validation/lucid_validation.dart';

extension CustomValidPasswordValidator on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> customValidPassword() {
    return notEmpty() //
        .minLength(5)
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumbers()
        .mustHaveSpecialCharacter();
  }
}

extension CustomValidPhoneValidator on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> customValidPhone(String message) {
    return matchesPattern(
      r'^\(?(\d{2})\)?\s?9?\d{4}-?\d{4}$',
      message: message,
      code: 'invalid_phone',
    );
  }
}
