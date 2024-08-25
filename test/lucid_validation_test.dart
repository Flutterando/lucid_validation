import 'package:test/test.dart';

import 'mocks/mocks.dart';

void main() {
  test('when validating [UserEntityMock] should return a list of error messages for the email field', () {
    final validator = UserValidator();
    final userEntity = UserModel(
      email: '',
      password: 'Teste@1234',
      age: 18,
      phone: '(11) 99999-9999',
    );

    final result = validator.validate(userEntity);
    final errors = result.errors;

    expect(errors.length, 2);
    expect(errors.first.key, 'email');
    expect(errors.first.message, 'Cannot be empty');
    expect(errors[1].message, 'Invalid email address');
  });

  test('when validating [UserModel] should return a list of error messages for the password field', () {
    final validator = UserValidator();
    final userEntity = UserModel(
      email: 'teste@gmail.com',
      password: '',
      age: 18,
      phone: '(11) 99999-9999',
    );

    final result = validator.validate(userEntity);
    final errors = result.errors;

    expect(errors.length, 6);
    expect(errors.first.key, 'password');
    expect(errors.first.message, 'Cannot be empty');
    expect(errors[1].message, 'Must be at least 8 characters long');
    expect(errors[2].message, 'Must contain at least one lowercase letter');
    expect(errors[3].message, 'Must contain at least one uppercase letter');
    expect(errors[4].message, 'Must contain at least one numeric digit');
    expect(errors[5].message, 'Must contain at least one special character');
  });

  test('when validating [UserModel] should return a list of error messages for the age field', () {
    final validator = UserValidator();
    final userEntity = UserModel(
      email: 'teste@gmail.com',
      password: 'Teste@1234',
      age: 15,
      phone: '(11) 99999-9999',
    );

    final result = validator.validate(userEntity);
    final errors = result.errors;

    expect(errors.length, 1);
    expect(errors.first.key, 'age');
    expect(errors.first.message, 'Minimum age is 18 years');
  });

  test('when validating [UserModel] should return a list of error messages for the phone field', () {
    final validator = UserValidator();
    final userEntity = UserModel(
      email: 'teste@gmail.com',
      password: 'Teste@1234',
      age: 18,
      phone: '',
    );

    final result = validator.validate(userEntity);
    final errors = result.errors;

    expect(errors.length, 1);
    expect(errors.first.key, 'phone');
    expect(errors.first.message, 'Phone invalid format');
  });

  test('when validating [UserModel] should return a list of error messages for all fields', () {
    final validator = UserValidator();
    final userEntity = UserModel(
      email: '',
      password: '',
      age: 15,
      phone: '',
    );

    final result = validator.validate(userEntity);
    final errors = result.errors;

    expect(errors.length, 10);
    expect(
      errors.map((error) => error.key).toSet(),
      {'email', 'password', 'age', 'phone'},
    );
  });

  test('EqualTo', () {
    var credentials = CredentialsRegister(
      email: 'test@test.com',
      confirmPassword: '123asdASD@',
      password: '123asdASD@',
    );
    final validator = CredentialsRegisterValidator();

    var result = validator.validate(credentials);
    var errors = result.errors;

    expect(errors.length, 0);

    credentials = credentials.copyWith(confirmPassword: '123asdASDsdsdw');
    result = validator.validate(credentials);
    errors = result.errors;
    expect(errors.length, 2);

    final stringError = validator.byField(credentials, 'confirmPassword')();
    expect(stringError, 'Must be equal to password');
  });

  test('setValidator', () {
    var customer = Customer(
      name: 'John Doe',
      address: Address(
        country: 'Brazil',
        postcode: '12345-678',
      ),
    );

    final validator = CustomerValidator();

    var result = validator.validate(customer);
    expect(result.isValid, isTrue);

    customer.address = Address(
      country: 'Brazil',
      postcode: '',
    );

    result = validator.validate(customer);

    expect(result.isValid, isFalse);

    final stringError = validator.byField(customer, 'address')();
    expect(stringError, 'Cannot be empty');
  });
}
