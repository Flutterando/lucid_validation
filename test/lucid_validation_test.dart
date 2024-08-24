import 'package:test/test.dart';

import 'mocks/mocks.dart';

void main() {
  test('when validating [UserEntityMock] should return a list of error messages for the email field', () {
    final validator = UserValidation();
    final userEntity = UserModel(
      email: '',
      password: 'Teste@1234',
      age: 18,
      phone: '(11) 99999-9999',
    );

    final errors = validator.validate(userEntity);

    expect(errors.length, 2);
    expect(errors.first.key, 'email');
    expect(errors.first.message, 'This field cannot be empty');
    expect(errors[1].message, 'E-mail in invalid format');
  });

  test('when validating [UserModel] should return a list of error messages for the password field', () {
    final validator = UserValidation();
    final userEntity = UserModel(
      email: 'teste@gmail.com',
      password: '',
      age: 18,
      phone: '(11) 99999-9999',
    );

    final errors = validator.validate(userEntity);

    expect(errors.length, 6);
    expect(errors.first.key, 'password');
    expect(errors.first.message, 'This field cannot be empty');
    expect(errors[1].message, 'Must be at least 8 characters long');
    expect(errors[2].message, 'Must contain lowercase');
    expect(errors[3].message, 'Must contain uppercase');
    expect(errors[4].message, 'Must contain number');
    expect(errors[5].message, 'Must contain special character');
  });

  test('when validating [UserModel] should return a list of error messages for the age field', () {
    final validator = UserValidation();
    final userEntity = UserModel(
      email: 'teste@gmail.com',
      password: 'Teste@1234',
      age: 15,
      phone: '(11) 99999-9999',
    );

    final errors = validator.validate(userEntity);

    expect(errors.length, 1);
    expect(errors.first.key, 'age');
    expect(errors.first.message, 'Minimum age is 18 years');
  });

  test('when validating [UserModel] should return a list of error messages for the phone field', () {
    final validator = UserValidation();
    final userEntity = UserModel(
      email: 'teste@gmail.com',
      password: 'Teste@1234',
      age: 18,
      phone: '',
    );

    final errors = validator.validate(userEntity);

    expect(errors.length, 1);
    expect(errors.first.key, 'phone');
    expect(errors.first.message, 'Phone invalid format');
  });

  test('when validating [UserModel] should return a list of error messages for all fields', () {
    final validator = UserValidation();
    final userEntity = UserModel(
      email: '',
      password: '',
      age: 15,
      phone: '',
    );

    final errors = validator.validate(userEntity);

    expect(errors.length, 10);
    expect(
      errors.map((error) => error.key).toSet(),
      {'email', 'password', 'age', 'phone'},
    );
  });
}
