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
  DateTime dateOfBirth;

  UserModel({
    required this.email,
    required this.password,
    required this.age,
    required this.dateOfBirth,
  });

}
```

After that, create a `LucidValidator` class and extends to `LucidValidator`:

```dart
import 'package:lucid_validation/lucid_validation.dart';

class UserValidator extends LucidValidator<UserModel> {
  UserValidator() {
    final now = DateTime.now();

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

    ruleFor((user) => user.dateOfBirth, key: 'dateOfBirth')
        .lessThan(DateTime(now.year - 18, now.month, now.day));
  }
}

```

Now, just validate!

```dart

void main() {
  final user = UserModel(email: 'test@example.com', password: 'Passw0rd!', age: 25);
  final validator = UserValidator();

  final result = validator.validate(user);
  
  if (result.isValid) {
    print('User is valid');
  } else {
    print('Validation errors: \${result.exceptions.map((e) => e.message).join(', ')}');
  }
}
```

Note, the validate method returns a list of errors with all validation exceptions.

### Available Validations

Here’s a complete list of available validators you can use:

- **must**: custom validation.
- **mustWith**: custom validation with entity.
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
- **validCPFOrCNPJ**: Checks if a string is a valid CPF or CNPJ (for use in Brazil).
- **validCredCard**: Checks if a string is a valid Credit Card.
- **greaterThanOrEqualTo**: Checks if the datetime value is greater than or equal to a specified minimum datetime.
- **greaterThan**: Checks if the datetime value is greater than a specified minimum datetime.
- **lessThanOrEqualTo**: Checks if the datetime value is less than or equal to a specified maximum datetime.
- **lessThan**: Checks if the datetime value is less than a specified maximum datetime.
- **inclusiveBetween**: Checks if the datetime value is between two datetime values, including both bounds.
- **exclusiveBetween**: Checks if the datetime value is between two datetime values, excluding both bounds.
- **validPhoneBR:** Check if the strig is a valid brazilian phone number (xx9xxxxxxxx)
- **validPhoneWithCountryCodeBR:** Check if the strig is a valid brazilian phone number with DDI (55xx9xxxxxxxx)

**Observation: for almost all validators, there is an equivalent with the `OrNull` suffix. Example: `validEmailOrNull`**

## Usage with Flutter

If you’re using the `lucid_validation` package in a Flutter app, integrating with `TextFormField` is straightforward.

Use the `byField(entity, 'key')` for this:

```dart
import 'package:flutter/material.dart';
import 'package:lucid_validation/lucid_validation.dart';

class LoginForm extends StatelessWidget {
  final validator = CredentialsValidation();
  final credentials = CredentialsModel();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(hintText: 'Email'),
            validator: validator.byField(credentials, 'email'),
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Password'),
            validator: validator.byField(credentials, 'password'),
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
```

## Cascate Mode

CascadeMode in LucidValidation controls the behavior of rule execution when a validation failure occurs for a property. By default, the validation rules continue to execute even if a previous rule for the same property fails. However, you can change this behavior using the CascadeMode.

### Available Modes

`CascadeMode.continueExecution (Default)`: All validation rules for a property are executed, even if one fails. This mode is useful when you want to collect all validation errors at once.

`CascadeMode.stopOnFirstFailure`: Stops executing further validation rules for a property as soon as a failure is detected. This is useful when you want to prevent unnecessary validation checks after an error has been found.

You can apply CascadeMode to your validation chain using the cascaded method:

```dart
 return notEmpty() //
        .minLength(5, message: 'Must be at least 8 characters long')
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumbers()
        .mustHaveSpecialCharacter()
        .cascade(CascadeMode.stopOnFirstFailure); // change cascade mode
```

## When condition

Adds a conditional execution rule for the validation logic based on the given [condition].

The `when` method allows you to specify a condition that must be met for the validation rules
within this builder to be executed. If the condition is not met, the validation rules areskipped,
and the property is considered valid by default.

This is particularly useful for scenarios where certain validation rules should only apply
under specific circumstances, such as when a certain property is set to a particular value.

[condition] is a function that takes the entire entity and returns a boolean indicating whether
the validation rules should be applied.

Example:

```dart
ruleFor((user) => user.phoneNumber, key: 'phoneNumber')
    .when((user) => user.requiresPhoneNumber)
    .isEmpty()
    .must((value) => value.length == 10, 'Phone number must be 10 digits', 'phone_length');
```

In the example above, the phone number validation rules are only applied if the user's `requiresPhoneNumber`
property is true. If the condition is false, the phone number field will be considered valid,and the
associated rules will not be executed.

## Complex Validations

When working with complex models that contain nested objects, it’s often necessary to apply validation rules not only to the parent model but also to its nested properties. The `setValidator` method allows you to integrate a nested `LucidValidator` within another validator, enabling a modular and scalable approach to validation.

See this example:

```dart
// Models
class Customer {
  String name;
  Address address;

  Customer({
    required this.name,
    required this.address,
  });
}

class Address {
  String country;
  String postcode;

  Address({
    required this.country,
    required this.postcode,
  });
}

```

Now, we can create two validators, `CustomerValidator` and `AddressValidator`.
Use `setValidator` to integrate `AddressValidor` into `CustomerValidator`;

```dart
class AddressValidator extends LucidValidator<Address> {
  AddressValidator() {
    ruleFor((address) => address.country, key: 'country') //
        .notEmpty();

    ruleFor((address) => address.postcode, key: 'postcode') //
        .notEmpty();
  }
}

class CustomerValidator extends LucidValidator<Customer> {
  final addressValidator = AddressValidator();

  CustomerValidator() {
    ruleFor((customer) => customer.name, key: 'name') //
        .notEmpty();

    ruleFor((customer) => customer.address, key: 'address') //
        .setValidator(addressValidator);
  }
}
```

After that, execute a validation normaly:

```dart
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
```

You can use `byField` using nested params syntax:

```dart
final validator = CustomerValidator();

final postCodeValidator = validator.byField(customer, 'address.postcode')();
expect(postCodeValidator, null); // is valid

```

There are several ways to customize or internationalize the failure message in validation.

All validations have the `message` parameter for customization, with the possibility of receiving arguments to make the message more dynamic.

```dart
  ruleFor((entity) => entity.name, key: 'name')
      .isEmpty(message: "'{PropertyName}' can not be empty." )
```

Please note that the `{PropertyName}` is an exclusive parameter of the `isEmpty` validation that will be internally changed to the validation's `key`, which in this case is `name`.
Each validation can have different parameters such as `{PropertyValue}` or `{ComparisonValue}`, so please check the documentation of each one to know the available parameters.

### Default Messages

By default, validation messages are in English, but you can change the language in the global properties of `LucidValidation`.

```dart
LucidValidation.global.culture = Culture('pt', 'BR');
```

If you’d like to contribute a translation of `LucidValidation’s` default messages, please open a pull request that adds a language file to the project.

You can also customize the default messages by overriding the `LanguageManager`:

```dart
class CustomLanguageManager extends LanguageManager {
  CustomLanguageManager(){
    addTranslation(Culture('pt', 'PR'), Language.code.equalTo, 'Custom message here');
  }
}
...
// change manager
LucidValidation.global.languageManager = CustomLanguageManager();

```

## Flutter Configuration

You can create a `Delegate` to automate internationalization directly in Flutter.

To create a `Delegate` follow these steps:

```dart
class LucidLocalizationDelegate extends LocalizationsDelegate<Culture> {
  const LucidLocalizationDelegate();

  static final delegate = LucidLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return LucidValidation.global.languageManager.isSupported(
      locale.languageCode,
      locale.countryCode,
    );
  }

  @override
  Future<Culture> load(Locale locale) async {
    print(locale);
    final culture = Culture(locale.languageCode, locale.countryCode ?? '');
    LucidValidation.global.culture = culture;
    return culture;
  }

  @override
  bool shouldReload(LocalizationsDelegate<Culture> old) {
    return true;
  }
}
```

Now just add it to the `MaterialApp` or `CupertinoApp`:

```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: [
        LucidLocalizationDelegate.delegate,
        //
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      
      ],
      ...
    );
  }
```

## Creating Custom Rules

You can easily extend the functionality of `LucidValidator` by creating your own custom rules using `extensions`. Here’s an example of how to create a validation for phone numbers:

```dart
extension CustomValidPhoneValidator on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> customValidPhone({String message = 'Invalid phone number format'}) {
    return matchesPattern(
      r'^\(?(\d{2})\)?\s?9?\d{4}-?\d{4}\$',
      message,
      'invalid_phone_format',
    );
  }
}

extension CustomValidPasswordValidator on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> customValidPassword() {
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
