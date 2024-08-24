import 'package:lucid_validation/lucid_validation.dart';

class UserModel {
  String email;
  String password;
  int age;
  String phone;

  UserModel({
    required this.email,
    required this.password,
    required this.age,
    required this.phone,
  });

  factory UserModel.empty() => UserModel(email: '', password: '', age: 18, phone: '');
}

class UserValidation extends LucidValidation<UserModel> {
  UserValidation() {
    ruleFor((user) => user.email, key: 'email') //
        .notEmpty('This field cannot be empty')
        .validEmail('E-mail in invalid format');

    ruleFor((user) => user.password, key: 'password') //
        .customValidPassword();

    ruleFor((user) => user.age, key: 'age') //
        .min(18, message: 'Minimum age is 18 years');

    ruleFor((user) => user.phone, key: 'phone') //
        .customValidPhone('Phone invalid format');
  }
}

extension CustomValidPhoneValidator on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> customValidPhone(String message) {
    return registerRule((value) => RegExp(r'^\(?(\d{2})\)?\s?9?\d{4}-?\d{4}$').hasMatch(value), message);
  }
}

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