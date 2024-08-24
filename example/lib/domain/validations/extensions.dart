import 'package:lucid_validation/lucid_validation.dart';

extension CustomValidPasswordValidator on LucidValidationBuilder<String, dynamic> {
  LucidValidationBuilder<String, dynamic> customValidPassword() {
    return notEmpty() //
        .minLength(5)
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumbers()
        .mustHaveSpecialCharacter();
  }
}

extension CustomValidPhoneValidator on LucidValidationBuilder<String, dynamic> {
  LucidValidationBuilder<String, dynamic> customValidPhone(String message) {
    return must((value) => RegExp(r'^\(?(\d{2})\)?\s?9?\d{4}-?\d{4}$').hasMatch(value), message, 'invalid_phone');
  }
}
