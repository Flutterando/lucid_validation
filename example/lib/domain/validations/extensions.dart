import 'package:lucid_validation/lucid_validation.dart';

extension CustomValidPasswordValidator on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> customValidPassword() {
    return notEmpty() //
        .minLength(5)
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumbers()
        .mustHaveSpecialCharacter();
  }
}

extension CustomValidPhoneValidator on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> customValidPhone(String message) {
    return registerRule((value) => RegExp(r'^\(?(\d{2})\)?\s?9?\d{4}-?\d{4}$').hasMatch(value), message, 'invalid_phone');
  }
}
