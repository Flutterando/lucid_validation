# Lucid Validation Example

Check this!


```dart
import 'package:lucid_validation/lucid_validation.dart';

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

class UserValidation extends LucidValidation<UserModel> {
  UserValidation() {
    ruleFor((user) => user.email, key: 'email')
        .notEmpty()
        .validEmail();

    ruleFor((user) => user.password, key: 'password')
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

void main() {
  final user = UserModel(email: 'test@example.com', password: 'Passw0rd!', age: 25);
  final validator = UserValidation();

  final errors = validator.validate(user);

  if (errors.isEmpty) {
    print('User is valid');
  } else {
    print('Validation errors: ${errors.map((e) => e.message).join(', ')}');
  }
}

```

## Flutter Integration

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