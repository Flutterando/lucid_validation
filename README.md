
# LucidValidation

**LucidValidation** is a pure Dart package for building strongly typed validation rules, inspired by FluentValidation. Created by the Flutterando community, this package offers a fluent and extensible API for validations, both in frontend (with Flutter) and backend applications.

## Features

- Strongly typed validation rules.
- Fluent API for defining validations.
- Extensible with custom validators.
- Consistent usage across backend and frontend (Flutter).

## Installation

Execute a `pub.add` command:

```sh
dart pub add lucid_validation
```

## Basic Usage

First, make a model:

```dart
class UserModel {
  String email;
  String password;
  int age;

  UserModel({
    required this.email,
    required this.password,
    required this.age,
  });

}
```

After that, create a `Validation` class and extends to `LucidValidation`:

```dart
import 'package:lucid_validation/lucid_validation.dart';

class UserValidation extends LucidValidation<UserModel> {
  UserValidation() {
    ruleFor((user) => user.email, key: 'email')
        .notEmpty()
        .validEmail();

    ruleFor((user) => user.password, key: 'password') //
        .notEmpty()
        .minLength(8, message: 'Must be at least 8 characters long')
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumbers()
        .mustHaveSpecialCharacter();

    ruleFor((user) => user.age, key: 'age')
        .min(18, message: 'Minimum age is 18 years');
  }
}

```

Now, just validate!

```dart

void main() {
  final user = UserModel(email: 'test@example.com', password: 'Passw0rd!', age: 25);
  final validator = UserValidation();

  final errors = validator.validate(user);
  
  if (errors.isEmpty) {
    print('User is valid');
  } else {
    print('Validation errors: \${errors.map((e) => e.message).join(', ')}');
  }
}
```

Note, the validate method returns a list of errors with all validation exceptions.

### Available Validators

Here’s a complete list of available validators you can use:

- **equalTo**: checks if value is equal to another value.
- **greaterThan**: Checks if number is greater than minimum value.
- **lessThan**: Checks if the number is less than max value.
- **notEmpty**: Checks if a string is not empty.
- **matchesPattern**: Checks if the a string matches the pattern (Regex).
- **range**: Checks whether a number is within the range of a minimum and maximum value.
- **validEmail**: Checks if a string is a valid email address.
- **minLength**: Checks if a string has a minimum length.
- **maxLength**: Checks if a string does not exceed a maximum length.
- **mustHaveLowercase**: Checks if a string contains at least one lowercase letter.
- **mustHaveUppercase**: Checks if a string contains at least one uppercase letter.
- **mustHaveNumbers**: Checks if a string contains at least one number.
- **mustHaveSpecialCharacter**: Checks if a string contains at least one special character.
- **min**: Checks if a number is greater than or equal to a minimum value.
- **max**: Checks if a number is less than or equal to a maximum value.
- **isNull**: Checks if a value is null.
- **isNotNull**: Checks if a value is not null.
- **isEmpty**: Checks if a string is empty.
- **validCPF**: Checks if a string is a valid CPF (for use in Brazil).
- **validCNPJ**: Checks if a string is a valid CNPJ (for use in Brazil).
- **validCEP**: Checks if a string is a valid CEP (for use in Brazil).
- **validCredCard**: Checks if a string is a valid Credit Card.

## Usage with Flutter

If you’re using the `lucid_validation` package in a Flutter app, integrating with `TextFormField` is straightforward.

Use the `byField('key')` for this:

```dart
import 'package:flutter/material.dart';
import 'package:lucid_validation/lucid_validation.dart';

class LoginForm extends StatelessWidget {
  final validator = UserValidation();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(hintText: 'Email'),
            validator: validator.byField('email'),
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Password'),
            validator: validator.byField('password'),
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
```

## Creating Custom Rules

You can easily extend the functionality of `LucidValidation` by creating your own custom rules using `extensions`. Here’s an example of how to create a validation for phone numbers:

```dart
extension CustomValidPhoneValidator on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> customValidPhone({String message = 'Invalid phone number format'}) {
    return registerRule(
      (value) => RegExp(r'^\(?(\d{2})\)?\s?9?\d{4}-?\d{4}\$').hasMatch(value),
      message,
      'invalid_phone_format',
    );
  }
}

extension CustomValidPasswordValidator on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> customValidPassword() {
    return notEmpty()
        .minLength(8)
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumbers()
        .mustHaveSpecialCharacter();
  }
}
```

Use directly!

```dart

 ruleFor((user) => user.password, key: 'password')
        .customValidPassword();

```

## Contributing

Feel free to open issues or pull requests on the [GitHub repository](https://github.com/Flutterando/lucid_validation) if you find any issues or have suggestions for improvements.

## License

This package is available under the MIT License. See the `LICENSE` file for more details.
