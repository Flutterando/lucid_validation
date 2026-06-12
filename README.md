# LucidValidation

[![pub package](https://img.shields.io/pub/v/lucid_validation.svg?logo=dart&logoColor=00C2FF)](https://pub.dev/packages/lucid_validation)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Pub points](https://img.shields.io/pub/points/lucid_validation)](https://pub.dev/packages/lucid_validation)

**LucidValidation** is a pure Dart package for building strongly-typed validation rules, inspired by FluentValidation. Developed by the Flutterando community, this package offers a fluent, expressive, and highly extensible API for both frontend (Flutter) and backend applications.

---

## Key Features

- **Strongly Typed**: Errors are caught at compile-time, with full autocomplete support.
- **Fluent API**: Expressive chainable validators that read like natural language.
- **Highly Extensible**: Easily add custom validation rules via Dart extensions.
- **Polymorphic Validations**: Handle complex conditional flows out of the box using `switchOn` and `when`/`unless` branches.
- **Unified Validation System**: Write validation rules once and reuse them across frontend (Flutter) and backend applications.
- **Deep Nesting Support**: Effortlessly validate complex object graphs, lists of items, and simple collections with index tracking.
- **Built-in Localization**: Localized messages out of the box with custom translation capabilities.

---

## Installation

Add `lucid_validation` to your project using the Dart CLI:

```sh
dart pub add lucid_validation
```

Or for Flutter projects:

```sh
flutter pub add lucid_validation
```

---

## Basic Usage

### 1. Define Your Model

Create your domain or data model class:

```dart
class UserModel {
  final String email;
  final String password;
  final int age;
  final DateTime dateOfBirth;

  UserModel({
    required this.email,
    required this.password,
    required this.age,
    required this.dateOfBirth,
  });
}
```

### 2. Create the Validator

Extend `LucidValidator` and declare your validation rules in the constructor:

```dart
import 'package:lucid_validation/lucid_validation.dart';

class UserValidator extends LucidValidator<UserModel> {
  UserValidator() {
    final now = DateTime.now();

    ruleFor((user) => user.email, key: 'email')
        .notEmpty()
        .validEmail();

    ruleFor((user) => user.password, key: 'password')
        .notEmpty()
        .minLength(8, message: 'Must be at least 8 characters long')
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumber()
        .mustHaveSpecialCharacter();

    ruleFor((user) => user.age, key: 'age')
        .min(18, message: 'Minimum age is 18 years');

    ruleFor((user) => user.dateOfBirth, key: 'dateOfBirth')
        .lessThan(DateTime(now.year - 18, now.month, now.day));
  }
}
```

### 3. Run Validation

Instantiate your validator and validate your model instances:

```dart
void main() {
  final user = UserModel(
    email: 'test@example.com',
    password: 'Passw0rd!',
    age: 25,
    dateOfBirth: DateTime(2001, 1, 1),
  );
  
  final validator = UserValidator();
  final result = validator.validate(user);

  if (result.isValid) {
    print('User is valid!');
  } else {
    print('Validation errors: ${result.exceptions.map((e) => e.message).join(', ')}');
  }
}
```

---

## Inline Validation (`LucidValidator.inline`)

For simple, lightweight, or dynamically configured validation needs, you do not need to declare a dedicated class extending `LucidValidator`. You can construct a ready-to-use validator inline using the `LucidValidator.inline` factory constructor.

This is extremely useful for:
- Quick validation logic within a controller, API handler, controller action, or leaving your validations alongside your form (Flutter).
- Dynamic validation rules created on the fly.
- Nested or sub-property validations passed to `.setValidator()` or `.setEach()`.

> [!TIP]
> **Keep your codebase lean** by using inline validators for one-off tasks, and reserve class-based validators (e.g. `UserValidator extends LucidValidator<User>`) for reusable domain model validations.

### How to use

```dart
final validator = LucidValidator<UserModel>.inline((v) {
  v.ruleFor((user) => user.email, key: 'email')
      .notEmpty()
      .validEmail();

  v.ruleFor((user) => user.password, key: 'password')
      .notEmpty()
      .minLength(8);
});

// Run validation normally
final result = validator.validate(user);
```

---

## Working with `ValidationResult`

The returned `ValidationResult` provides helpers for extracting error details, which is especially useful for rendering forms or building API responses:

```dart
final result = validator.validate(user);

// Check overall status
bool isValid = result.isValid;

// Map containing errors grouped by field key — perfect for JSON API payloads
Map<String, List<String>> errors = result.errorsByKey;
// Output: { "email": ["'email' is not a valid email address."], "password": [...] }

// Retrieve only the first error message for a specific key
String? emailError = result.firstErrorFor('email');
```

If your application architecture prefers exceptions over manual boolean checks, use `validateAndThrow` (or its asynchronous equivalent `validateAndThrowAsync`). This will raise a `LucidValidationException` if validation fails:

```dart
try {
  validator.validateAndThrow(user);
} on LucidValidationException catch (e) {
  print(e.exceptions); // Access the list of ValidationExceptions
}
```

### Direct Exception Retrieval (`getExceptions` / `getExceptionsByKey`)

If you want to retrieve raw validation exceptions directly without checking `ValidationResult.exceptions`, you can use the following methods:
- **`getExceptions(entity)`**: Returns a flat `List<ValidationException>` of all failures encountered.
- **`getExceptionsByKey(entity, key)`**: Returns only the validation exceptions related to a specific property key.

```dart
// Retrieve all validation exceptions
final allExceptions = validator.getExceptions(user);

// Retrieve exceptions only for the email field
final emailExceptions = validator.getExceptionsByKey(user, 'email');
```

---

## Real-Time Field Inspection (`rulesForField` / `rulesForFieldAsync`)

For interactive user interfaces, you often want to show a real-time checklist (for example, password strength requirements) that updates as the user types.

Instead of writing duplicate logic, you can use `rulesForField` (or `rulesForFieldAsync` if any rules are asynchronous) to evaluate and retrieve the status of **all rules** registered for a specific field, regardless of whether they currently pass or fail.

Each returned `ExposedRuleResult` contains:
- **`code`**: The unique rule code (e.g. `notEmpty`, `minLength`).
- **`message`**: The formatted error message for that rule.
- **`isValid`**: A boolean indicating if the entity currently satisfies that specific rule.

### Example

```dart
final user = UserModel(
  email: 'test@example.com',
  password: 'short', // Fails length and character requirements
  age: 25,
  dateOfBirth: DateTime(2001, 1, 1),
);

final validator = UserValidator();
final rules = validator.rulesForField(user, 'password');

for (final rule in rules) {
  print('${rule.isValid ? '✓' : '✗'} [${rule.code}]: ${rule.message}');
}

// Output:
// ✓ [notEmpty]: 'password' must not be empty.
// ✗ [minLength]: Must be at least 8 characters long
// ✗ [mustHaveLowercase]: 'password' must have at least one lowercase letter.
// ...
```

---

## Built-In Validators

LucidValidation includes a rich set of built-in validation rules. 

> [!TIP]
> Almost all built-in rules have a nullable counterpart ending with the `OrNull` suffix (e.g., `validEmailOrNull()`), which permits `null` values but validates them if they are present.

### Common & Custom Validators

| Validator | Target Type | Description |
| :--- | :--- | :--- |
| `must(predicate)` | `T` | Custom validation using a synchronous predicate. |
| `mustWith(predicate)` | `T` | Custom validation with access to the parent entity. |
| `mustAsync(predicate)` | `T` | Custom asynchronous validation. |
| `mustWithAsync(predicate)` | `T` | Custom asynchronous validation with access to the parent entity. |
| `isNull()` | `T?` | Checks if the value is `null`. |
| `isNotNull()` | `T?` | Checks if the value is not `null`. |
| `equalTo(otherField)` | `T` | Checks if the value is equal to another field's value. |
| `notEqualTo(otherField)` | `T` | Checks if the value is not equal to another field's value. |
| `isInEnum(values)` | `T` | Checks if the value is contained within a list of allowed values (e.g. `MyEnum.values`). |

### String Validators

| Validator | Description |
| :--- | :--- |
| `isEmpty()` / `notEmpty()` | Checks if a string is empty or contains only whitespace / not empty. |
| `minLength(min)` / `maxLength(max)` | Asserts string length boundaries. |
| `length(min, max)` | Asserts string length is within a specific range. |
| `isAlphanumeric()` | Checks if the string contains only letters and digits. |
| `isNumeric()` | Checks if the string contains only numeric characters. |
| `isUppercase()` / `isLowercase()` | Checks if the string is entirely uppercase / lowercase. |
| `contains(substring)` | Checks if the string contains the specified substring. |
| `startsWith(prefix)` / `endsWith(suffix)` | Checks if the string starts/ends with a substring. |
| `matchesPattern(regex)` | Checks if the string matches a regular expression pattern. |
| `mustHaveLowercase()` / `mustHaveUppercase()` | Requires at least one lowercase / uppercase letter. |
| `mustHaveNumber()` / `mustHaveSpecialCharacter()` | Requires at least one numeric character / special character. |
| `hasNoSequentialRepeatedCharacters(length)` | Ensures there are no sequences of repeated characters (e.g. "aaa"). |
| `hasNoSequentialCharacters(length)` | Ensures there are no sequences of sequential characters (e.g. "123", "abc"). |

### Numeric Validators

| Validator | Description |
| :--- | :--- |
| `min(val)` / `max(val)` | Asserts a number is greater than/equal to `val` or less than/equal to `val`. |
| `range(min, max)` | Asserts a number is between `min` and `max` (inclusive). |
| `inclusiveBetween(min, max)` | Asserts value is within a range, including the bounds. |
| `exclusiveBetween(min, max)` | Asserts value is within a range, excluding the bounds. |
| `isPositive()` / `isNegative()` | Checks if a number is positive ($> 0$) / negative ($< 0$). |
| `isNonNegative()` / `isNonZero()` | Checks if a number is non-negative ($\ge 0$) / non-zero ($\ne 0$). |
| `isEven()` / `isOdd()` | Checks if a number is even / odd. |
| `multipleOf(factor)` | Checks if a number is a multiple of a given factor. |
| `precisionScale(precision, scale)` | Asserts maximum total digits (precision) and decimal places (scale). |

### Boolean Validators

| Validator | Description |
| :--- | :--- |
| `isTrue()` / `isFalse()` | Checks if the boolean value is strictly `true` / `false`. |

### DateTime Validators

| Validator | Description |
| :--- | :--- |
| `greaterThan(dateTime)` / `lessThan(dateTime)` | Checks if value is strictly after / before a specified `DateTime`. |
| `greaterThanOrEqualTo(dateTime)` / `lessThanOrEqualTo(dateTime)` | Checks if value is after / before or equal to a specified `DateTime`. |
| `inclusiveBetween(min, max)` / `exclusiveBetween(min, max)` | Asserts date is within a range, including / excluding bounds. |
| `inPast()` / `inFuture()` | Checks if the `DateTime` is in the past / future relative to evaluation time. |
| `afterField(otherField)` | Checks if the date is after another `DateTime` property of the same entity. |
| `beforeField(otherField)` | Checks if the date is before another `DateTime` property of the same entity. |

### Collections & Lists

| Validator | Target Type | Description |
| :--- | :--- | :--- |
| `minItems(min)` / `maxItems(max)` | `List<T>` | Asserts list item counts. |
| `listContains(item)` | `List<T>` | Checks if the list contains a specific item. |

### Web, Network, & Identification Formats

| Validator | Target Type | Description |
| :--- | :--- | :--- |
| `validEmail()` | `String` | Asserts a valid email format. |
| `validUrl()` / `httpUrl()` | `String` | Asserts a valid URL / valid HTTP or HTTPS URL. |
| `validUuid()` | `String` | Asserts a valid UUID (v4, v5, etc.). |
| `validIpv4()` / `validIpv6()` | `String` | Asserts a valid IPv4 / IPv6 address format. |
| `validCreditCard()` | `String` | Asserts a valid credit card format using Luhn algorithm. |

### Brazilian Formats (Localizations)

| Validator | Target Type | Description |
| :--- | :--- | :--- |
| `validCPF()` / `validCNPJ()` | `String` | Asserts valid Brazilian CPF / CNPJ digits. |
| `validCPFOrCNPJ()` / `validCEP()` | `String` | Asserts valid Brazilian CPF/CNPJ (combined check) / CEP format. |
| `validPhoneBR()` | `String` | Asserts a valid Brazilian phone format (e.g., `(xx) 9xxxx-xxxx` or `xx9xxxxxxxx`). |
| `validPhoneWithCountryCodeBR()` | `String` | Asserts a valid Brazilian phone format with country code (e.g., `+55xx9xxxxxxxx`). |

---

## Integration with Flutter

Using `lucid_validation` with Flutter `TextFormField` validation is clean and straightforward. Leverage the `byField` method to bind validation directly to your form fields.

You can do this by extending `LucidValidator` or by declaring the validator inline directly alongside your widget using `LucidValidator.inline`.

### Option A: Using a Dedicated Validator Class

```dart
import 'package:flutter/material.dart';
import 'package:lucid_validation/lucid_validation.dart';

class LoginForm extends StatelessWidget {
  final validator = CredentialsValidation();
  final credentials = CredentialsModel();

  LoginForm({super.key});

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

### Option B: Using an Inline Validator (`LucidValidator.inline`)

If you want to keep your validation rules right beside your form widget without creating a separate validator class:

```dart
import 'package:flutter/material.dart';
import 'package:lucid_validation/lucid_validation.dart';

class LoginForm extends StatelessWidget {
  final credentials = CredentialsModel();

  // Define the validator inline within your widget
  final validator = LucidValidator<CredentialsModel>.inline((v) {
    v.ruleFor((c) => c.email, key: 'email')
        .notEmpty()
        .validEmail();

    v.ruleFor((c) => c.password, key: 'password')
        .notEmpty()
        .minLength(8);
  });

  LoginForm({super.key});

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

> [!NOTE]
> **Architectural Recommendation**: Although inline validation is convenient for rapid UI prototyping or local forms, LucidValidation strongly recommends adopting **Domain-Driven Design (DDD)** practices. Ideally, your validation rules should reside in your project's **Domain Layer** as part of your core business logic. This ensures that your entities are kept valid across all application layers (controllers, APIs, and UI views).

---

## Cascade Mode

Cascade Mode controls validation rule execution once a failure is detected on a property.

### Available Modes

1. **`CascadeMode.continueExecution` (Default)**: Executes all rules in the validation chain for a property, even if preceding rules failed. Use this to collect all errors at once.
2. **`CascadeMode.stopOnFirstFailure`**: Aborts further checks on that specific property as soon as a failure is encountered. Excellent for stopping heavy or redundant checks.

Apply cascade settings using the `.cascade()` method at the end of the rule chain:

```dart
ruleFor((user) => user.password, key: 'password')
    .notEmpty()
    .minLength(8)
    .mustHaveLowercase()
    .mustHaveUppercase()
    .mustHaveNumber()
    .mustHaveSpecialCharacter()
    .cascade(CascadeMode.stopOnFirstFailure); // Halts validation on the first error found in this chain
```

---

## Conditional Execution

### The `when` Condition

Applies validation rules in a builder **only if** the provided condition evaluates to `true`:

```dart
ruleFor((user) => user.phoneNumber, key: 'phoneNumber')
    .when((user) => user.requiresPhoneNumber)
    .notEmpty()
    .must((value) => value.length == 10, message: 'Phone number must be 10 digits', code: 'phone_length');
```

### The `unless` Condition

The inverse of `when`: rules run **only when the condition evaluates to `false`**:

```dart
ruleFor((user) => user.companyName, key: 'companyName')
    .unless((user) => user.isIndividual)
    .notEmpty();
```

---

## Polymorphic & Branching Validations with `switchOn`

`switchOn` routes an **entire block of rules** based on a discriminator value (such as an `enum`, `String`, or `int`) derived from the entity. Only the rules for the matching case are executed; all others are ignored.

This is ideal for polymorphic entities where required fields change depending on the type selected:

```dart
enum PaymentType { creditCard, pix, bankTransfer }

class PaymentValidator extends LucidValidator<Payment> {
  PaymentValidator() {
    // Always-on rule: runs regardless of payment type
    ruleFor((p) => p.type, key: 'type').isNotNull();

    switchOn((p) => p.type, cases: {
      PaymentType.creditCard: (v) {
        v.ruleFor((p) => p.cardNumber, key: 'cardNumber').notEmpty().minLength(16);
        v.ruleFor((p) => p.cvv, key: 'cvv').isNumeric().length(3, 4);
      },
      PaymentType.pix: (v) {
        v.ruleFor((p) => p.pixKey, key: 'pixKey').notEmpty();
      },
    }, orElse: (v) {
      // Runs when no registered cases match
      v.ruleFor((p) => p.type, key: 'type')
          .must((_) => false, message: 'Unsupported payment type.', code: 'unsupported_type');
    });
  }
}
```

> [!NOTE]
> Unlike `when`, which applies to a single property chain, `switchOn` validates or skips a grouped block of different fields at once.

---

## Advanced Customization

### Fluent Overrides (`withMessage`, `withErrorCode`, `withName`)

Instead of inline parameters, you can customize the preceding rule in your chain using fluent extensions mirroring FluentValidation:

```dart
ruleFor((user) => user.email, key: 'email')
    .notEmpty().withMessage('Please inform your email.')
    .validEmail().withErrorCode('EMAIL_INVALID');
```

- **`withMessage(msg)`**: Overrides the error message of the preceding rule.
- **`withErrorCode(code)`**: Overrides the error code of the preceding rule.
- **`withName(displayName)`**: Sets a user-friendly display name (e.g. `'Date of birth'` instead of `'dateOfBirth'`) for error messages, while preserving the key for field mapping:

```dart
ruleFor((user) => user.dateOfBirth, key: 'dateOfBirth')
    .withName('Date of birth')
    .notEmpty(); // Output message: "'Date of birth' must not be empty."
```

### Data Sanitization with `normalize`

Transform and sanitize input values (e.g., trim whitespace, lower-case, or remove masks) **before** validations execute. This affects only the validation engine and does not mutate the original model:

```dart
ruleFor((user) => user.email, key: 'email')
    .normalize((email) => email.trim().toLowerCase())
    .notEmpty()
    .validEmail();
```

---

## Asynchronous Validation

For validation rules needing network calls, database lookups, or file system access, use `mustAsync` / `mustWithAsync` and execute your checks with `validateAsync` or `validateAndThrowAsync`:

```dart
class UserValidator extends LucidValidator<UserModel> {
  UserValidator(UserRepository repository) {
    ruleFor((user) => user.email, key: 'email')
        .notEmpty()
        .validEmail()
        .mustAsync(
          (email) async => !await repository.emailExists(email),
          message: 'Email already registered',
          code: 'email_taken',
        );
  }
}

// Validation run:
final result = await validator.validateAsync(user);
```

> [!IMPORTANT]
> If any validation chain contains asynchronous rules, calling the synchronous `validate()` or `byField()` will throw an `AsyncValidationException`. Always use `validateAsync` for asynchronous rules.

---

## Partitioning Rules with Rule Sets

Rule Sets allow you to partition rules for different workflows (such as creating vs updating entities). Rules defined outside any explicitly declared `ruleSet` are placed in the `default` set.

```dart
class UserValidator extends LucidValidator<UserModel> {
  UserValidator() {
    // Default rule set
    ruleFor((u) => u.email, key: 'email').notEmpty().validEmail();

    // Custom 'create' rule set
    ruleSet('create', () {
      ruleFor((u) => u.password, key: 'password').notEmpty().minLength(8);
    });
  }
}

final validator = UserValidator();

validator.validate(user);                       // Runs only default rules (email)
validator.validate(user, ruleSets: ['create']); // Runs only 'create' rules (password)
validator.validate(user, ruleSets: ['*']);      // Runs all rules (default + create)
```

---

## Reusing Logic with `include`

You can merge all rules from another validator targeting the same entity type. This prevents code repetition and keeps validators modular:

```dart
class FullUserValidator extends LucidValidator<UserModel> {
  FullUserValidator() {
    include(ContactInfoValidator());
    include(SecurityValidator());
  }
}
```

---

## Complex & Nested Validation

### Validating Objects with `setValidator`

To validate nested objects, assign a dedicated validator to the child property using the `setValidator` method:

```dart
class Customer {
  final String name;
  final Address address;

  Customer({required this.name, required this.address});
}

class Address {
  final String country;
  final String postcode;

  Address({required this.country, required this.postcode});
}

// Validators
class AddressValidator extends LucidValidator<Address> {
  AddressValidator() {
    ruleFor((address) => address.country, key: 'country').notEmpty();
    ruleFor((address) => address.postcode, key: 'postcode').notEmpty();
  }
}

class CustomerValidator extends LucidValidator<Customer> {
  CustomerValidator() {
    ruleFor((customer) => customer.name, key: 'name').notEmpty();
    ruleFor((customer) => customer.address, key: 'address').setValidator(AddressValidator());
  }
}
```

To fetch error validation status on a nested field using `byField`, use dot-notation:

```dart
final validator = CustomerValidator();
final postcodeValidationFunc = validator.byField(customer, 'address.postcode');
final errorMsg = postcodeValidationFunc(); // Returns the validation error for postcode, if any.
```

### Validating Collections with `setEach`

To validate a list of child objects, use `setEach` to apply a validator to each element individually. This tracks item index numbers in case of failure:

```dart
class Classroom {
  final String className;
  final TeacherModel teacher;
  final List<StudentModel> students;

  Classroom({required this.className, required this.teacher, required this.students});
}

class ClassroomValidator extends LucidValidator<Classroom> {
  ClassroomValidator() {
    ruleFor((c) => c.className, key: 'className').notEmpty();
    ruleFor((c) => c.teacher, key: 'teacher').setValidator(TeacherValidator());
    ruleFor((c) => c.students, key: 'students').setEach(StudentValidator());
  }
}
```

In the validation exceptions, index tracking is handled automatically:

```dart
final result = validator.validate(classroom);
final exceptions = result.exceptions;

// If the first student in the list failed validation:
print(exceptions[2].key);   // "name"
print(exceptions[2].index); // 0 (index of the failing item)
```

### Validating Simple Collections with `ruleForEach`

If you are validating collections containing simple primitive types (e.g. `List<String>`), use `ruleForEach`:

```dart
ruleForEach((order) => order.tags, key: 'tags')
    .notEmpty()
    .maxLength(20);
```

---

## Localization & Global Configuration

By default, error messages are generated in English. You can switch culture globally:

```dart
LucidValidation.global.culture = Culture('pt', 'BR');
```

### Custom Translations

To define custom translations or override existing messages, extend the `LanguageManager`:

```dart
class CustomLanguageManager extends LanguageManager {
  CustomLanguageManager() {
    addTranslation(Culture('pt', 'BR'), Language.code.equalTo, 'Mensagem customizada aqui');
  }
}

// Register custom language manager
LucidValidation.global.languageManager = CustomLanguageManager();
```

### Flutter Localization Delegate Integration

Integrate localization directly with Flutter's standard localization workflow using a custom `LocalizationsDelegate`:

```dart
class LucidLocalizationDelegate extends LocalizationsDelegate<Culture> {
  const LucidLocalizationDelegate();

  static const delegate = LucidLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return LucidValidation.global.languageManager.isSupported(
      locale.languageCode,
      locale.countryCode,
    );
  }

  @override
  Future<Culture> load(Locale locale) async {
    final culture = Culture(locale.languageCode, locale.countryCode ?? '');
    LucidValidation.global.culture = culture;
    return culture;
  }

  @override
  bool shouldReload(LocalizationsDelegate<Culture> old) => true;
}
```

Register the delegate in your `MaterialApp` or `CupertinoApp`:

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('pt', 'BR'),
    ],
    localizationsDelegates: const [
      LucidLocalizationDelegate.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    // ...
  );
}
```

---

## Creating Custom Validation Rules

Extend `SimpleValidationBuilder<T>` to build custom, reusable validation rules.

### 1. Composing Existing Rules

Combine existing rules into a single helper method:

```dart
extension StrongPasswordValidation on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> strongPassword() {
    return notEmpty()
        .minLength(8)
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumber()
        .mustHaveSpecialCharacter();
  }
}
```

### 2. Single Predicate Rules with `useValidation`

For custom logic, use `useValidation`. Provide a predicate `(value, entity) => bool`. You can optionally supply custom parameter tokens for message replacement:

```dart
extension MinWordsValidation on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> minWords(int min, {String? message, String? code}) {
    return useValidation(
      (value, entity) => value.trim().split(RegExp(r'\s+')).length >= min,
      code: code ?? 'minWords',
      message: message ?? "'{PropertyName}' must have at least {Min} words.",
      parameters: (value, entity) => {'Min': '$min'},
    );
  }
}
```

### 3. Asynchronous Custom Rules with `useValidationAsync`

For rules requiring external API calls or database checks, use `useValidationAsync`. The predicate must return a `Future<bool>`:

```dart
extension UniqueUsernameValidation on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> uniqueUsername(
    Future<bool> Function(String username) checkAvailable, {
    String? message,
    String? code,
  }) {
    return useValidationAsync(
      (value, entity) => checkAvailable(value),
      code: code ?? 'usernameTaken',
      message: message ?? "'{PropertyName}' is already taken.",
    );
  }
}
```

### 4. Advanced Custom Rules with `use` / `useAsync`

If you need absolute control over the created `ValidationException` on failure (for example, to dynamically format the entity type name, modify properties, or construct a highly customized payload), you can use `use` (sync) or `useAsync` (async) directly:

```dart
extension CustomRule on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> complexCustomCheck() {
    return use((value, entity) {
      if (value.startsWith('admin') && !entity.isAdminUser) {
        return ValidationException(
          key: key,
          message: 'Only admin users can define admin prefixes.',
          code: 'unauthorized_prefix',
          entity: 'UserModel',
        );
      }
      return null; // Return null if validation passes
    });
  }
}
```

---

## AI-Assisted Development (Copilot, Cursor, Gemini, etc.)

If you are using AI-powered coding assistants (such as Cursor, GitHub Copilot, Gemini, or Claude) to write or maintain validators in your codebase, we have prepared a specialized context instruction file.

Instruct your AI assistant to read the `SKILL.md` file, available in the root of this repository, before starting. It provides a fairly detailed guide covering built-in rules, complex nesting, custom validation extension patterns, and common architectural pitfalls.

---

## Contributing

Contributions are welcome! If you encounter issues, have feature requests, or want to contribute translations, please open an issue or submit a pull request on the [GitHub Repository](https://github.com/Flutterando/lucid_validation).

## License

This package is licensed under the MIT License. See the [LICENSE](file:///Users/wellignton.santos/freelance/lucid_validation/LICENSE) file for more information.
