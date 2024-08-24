import 'package:lucid_validation/lucid_validation.dart';

extension CustomValidPasswordValidator on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> customValidPassword() {
    return notEmpty('This field cannot be empty')
        .minLength(5, message: 'Must be at least 8 characters long')
        .mustHaveLowercase('Must contain lowercase')
        .mustHaveUppercase('Must contain uppercase')
        .mustHaveNumbers('Must contain number')
        .mustHaveSpecialCharacter('Must contain special character');
  }
}

extension CustomValidPhoneValidator on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> customValidPhone(String message) {
    return registerRule((value) => RegExp(r'^\(?(\d{2})\)?\s?9?\d{4}-?\d{4}$').hasMatch(value), message);
  }
}
