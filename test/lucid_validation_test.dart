import 'package:test/test.dart';

import 'mocks/mocks.dart';

void main() {
  test(
      'when validating [UserEntityMock] should return a list of error messages for the email field',
      () {
    final validator = UserValidator();
    final userEntity = UserModel()
      ..age = 18
      ..email = ''
      ..phone = '(11) 99999-9999'
      ..password = 'Teste@1234';

    final result = validator.validate(userEntity);
    final exceptions = result.exceptions;

    expect(exceptions.length, 4);
  });

  test(
      'when validating [UserModel] should return a list of error messages for the password field',
      () {
    final validator = UserValidator();
    final userEntity = UserModel()
      ..age = 18
      ..email = 'teste@gmail.com'
      ..phone = '(11) 99999-9999'
      ..password = '';

    final result = validator.validate(userEntity);
    final exceptions = result.exceptions;

    expect(exceptions.length, 8);
  });

  test(
      'when validating [UserModel] should return a list of error messages for the age field',
      () {
    final validator = UserValidator();
    final userEntity = UserModel()
      ..age = 15
      ..email = 'teste@gmail.com'
      ..phone = '(11) 99999-9999'
      ..password = 'Teste@1234';

    final result = validator.validate(userEntity);
    final exceptions = result.exceptions;

    expect(exceptions.length, 3);
  });

  test(
      'when validating [UserModel] should return a list of error messages for the phone field',
      () {
    final validator = UserValidator();

    final userEntity = UserModel()
      ..age = 18
      ..email = 'teste@gmail.com'
      ..phone = ''
      ..password = 'Teste@1234';

    final result = validator.validate(userEntity);
    final exceptions = result.exceptions;

    expect(exceptions.length, 3);
  });

  test(
      'when validating [UserModel] should return a list of error messages for all fields',
      () {
    final validator = UserValidator();
    final userEntity = UserModel()..age = 15;

    final result = validator.validate(userEntity);
    final exceptions = result.exceptions;

    expect(exceptions.length, 12);
  });

  test('EqualTo', () {
    var credentials = CredentialsRegister(
      email: 'test@test.com',
      confirmPassword: '123asdASD@',
      password: '123asdASD@',
    );
    final validator = CredentialsRegisterValidator();

    var result = validator.validate(credentials);
    var exceptions = result.exceptions;

    expect(exceptions.length, 0);

    credentials = credentials.copyWith(confirmPassword: '123asdASDsdsdw');
    result = validator.validate(credentials);
    exceptions = result.exceptions;
    expect(exceptions.length, 2);
  });

  test('setValidator', () {
    var customer = Customer(
      name: 'John Doe',
      address: Address(
        country: 'Brazil',
        postcode: '12345-678',
      ),
      cnpj: '63.288.044/0001-89',
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
    expect(stringError, '\'postcode\' must not be empty.');
  });
}
