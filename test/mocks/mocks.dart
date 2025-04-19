// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lucid_validation/lucid_validation.dart';

class Classroom {
  final String? className;
  final TeacherModel teacher;
  final List<StudentModel> students;

  Classroom({required this.students, required this.teacher, this.className});
}

class TeacherModel {
  String name = '';
}

class StudentModel {
  String email = '';
  String name = '';
}

class UserModel {
  String email = '';
  String password = '';
  String confirmPassword = '';
  String? description;
  int age = 0;
  String? phone = '';
  String? cpf = '';
  String? cpfOrCnpj = '';
}

class UserNullableModel {
  String? email = '';
  String? password = '';
  String? confirmPassword = '';
  String? description;
  int? age = 0;
  String phone = '';
  String? cpf = '';
}

class StudentValidator extends LucidValidator<StudentModel> {
  StudentValidator() {
    ruleFor((user) => user.email, key: 'email') //
        .validEmail();

    ruleFor((user) => user.name, key: 'name')
      .notEmpty();
  }
}

class TeacherModelValidator extends LucidValidator<TeacherModel> {
  TeacherModelValidator() {
    ruleFor((user) => user.name, key: 'name')
        .notEmpty();
  }
}

class UserValidator extends LucidValidator<UserModel> {
  UserValidator() {
    ruleFor((user) => user.email, key: 'email') //
        .notEmpty()
        .validEmail();

    ruleFor((user) => user.password, key: 'password') //
        .customValidPassword();

    ruleFor((user) => user.age, key: 'age') //
        .min(18, message: 'Minimum age is 18 years');

    ruleFor((user) => user.phone, key: 'phone') //
        .customValidPhone('Phone invalid format');

    ruleFor((user) => user.cpf, key: 'cpf') //
        .isNotNull()
        .notEmpty()
        .validCPF();
  }
}

extension CustomValidPhoneValidator on LucidValidationBuilder<String?, dynamic> {
  LucidValidationBuilder<String?, dynamic> customValidPhone(String message) {
    return must(
      (value) => value == null || RegExp(r'^\(?(\d{2})\)?\s?9?\d{4}-?\d{4}$').hasMatch(value),
      message,
      'invalid_phone_format',
    );
  }
}

extension CustomValidPasswordValidator
    on LucidValidationBuilder<String, dynamic> {
  LucidValidationBuilder<String, dynamic> customValidPassword() {
    return notEmpty() //
        .minLength(5, message: 'Must be at least 8 characters long')
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumber()
        .mustHaveSpecialCharacter();
  }
}

class CredentialsRegister {
  String email;
  String password;
  String confirmPassword;

  CredentialsRegister({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  CredentialsRegister copyWith({
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return CredentialsRegister(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}

class CredentialsRegisterValidator extends LucidValidator<CredentialsRegister> {
  CredentialsRegisterValidator() {
    ruleFor((credentials) => credentials.email, key: 'email') //
        .notEmpty()
        .validEmail();

    ruleFor((credentials) => credentials.password, key: 'password') //
        .customValidPassword()
        .equalTo((entity) => entity.confirmPassword,
            message: 'Must be equal to confirmPassword');

    ruleFor((credentials) => credentials.confirmPassword,
            key: 'confirmPassword') //
        .equalTo((entity) => entity.password,
            message: 'Must be equal to password');
  }
}

class Address {
  String country;
  String postcode;

  Address({
    required this.country,
    required this.postcode,
  });
}

class AddressNullable {
  String? country;
  String? postcode;
}

class AddressValidator extends LucidValidator<Address> {
  AddressValidator() {
    ruleFor((address) => address.country, key: 'country') //
        .notEmpty();

    ruleFor((address) => address.postcode, key: 'postcode') //
        .notEmpty();
  }
}

class Customer {
  String name;
  Address address;
  String cnpj;

  Customer({
    required this.name,
    required this.address,
    required this.cnpj,
  });
}

class CustomerNullable {
  String? name;
  Address? address;
  String? cnpj;
}

class CustomerValidator extends LucidValidator<Customer> {
  final addressValidator = AddressValidator();

  CustomerValidator() {
    ruleFor((customer) => customer.name, key: 'name') //
        .notEmpty();

    ruleFor((customer) => customer.address, key: 'address') //
        .setValidator(addressValidator);

    ruleFor((customer) => customer.cnpj, key: 'cnpj') //
        .notEmpty()
        .validCNPJ();
  }
}

class EventModel {
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  DateTime dateEvent = DateTime.now();
}

class EventNullableModel {
  DateTime? start = DateTime.now();
  DateTime? end = DateTime.now();
  DateTime? dateEvent = DateTime.now();
}

class CreditCardModel {
  String number = '';
}

class CreditCardNullableModel {
  String? number;
}

class CreditCardValidator extends LucidValidator<CreditCardModel> {
  CreditCardValidator() {
    ruleFor((card) => card.number, key: 'number') //
        .notEmpty()
        .validCreditCard();
  }
}

class TestLucidValidator<T> extends LucidValidator<T> {}
