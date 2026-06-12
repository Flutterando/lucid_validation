---
name: lucid-validation-assistant
description: Instructions and guidelines for AI models writing, debugging, and extending validators in the LucidValidation codebase.
---

# LucidValidation AI Developer Guide

This guide contains everything an AI assistant or human developer needs to know to work with the **LucidValidation** package. Use it as a reference for syntax, API surface, architectural patterns, and extension methodologies.

---

## 1. Core Architecture

LucidValidation is inspired by FluentValidation (C#). It evaluates validation rules against models s s.

### Key Classes

1. **`LucidValidator<E>`**: The base abstract class. Subclasses extend this with their target entity type `E` (e.g. `UserValidator extends LucidValidator<User>`).
   - Registers validation builders in the constructor.
   - Triggers validations via `validate` or `validateAsync`.
2. **`LucidValidationBuilder<TProp, Entity>`**: Extends the validator to define rules for a specific property of type `TProp` extracted from the parent `Entity`.
3. **`SimpleValidationBuilder<T>`**: Alias of `LucidValidationBuilder<T, T>`, used when validating primitive values or when writing extensions that don't depend on the parent entity.
4. **`ValidationException`**: Holds validation details (message, code, key, entity, index).
5. **`ValidationResult`**: Wraps the execution result (`isValid`, `exceptions`, `errorsByKey`, `firstErrorFor`).

### Sync vs. Async Rule Engine

> [!IMPORTANT]
> - **Sync validations**: Registered using `must`, `use`, or `useValidation`. Executed via `validate(entity)`.
> - **Async validations**: Registered using `mustAsync`, `useAsync`, or `useValidationAsync`. Executed via `validateAsync(entity)`.
> - **Critical Pitfall**: If a validator contains *any* async rules, calling `validate()` will throw an `AsyncValidationException`. You must use `validateAsync()` in this case.

---

## 2. Built-In Validators

All built-in validation rules are implemented as extensions on `SimpleValidationBuilder<T>` or `LucidValidationBuilder<T, E>`.

### Common & Core
- `must(bool Function(T value) predicate, String message, String code)`: Custom check.
- `mustWith(bool Function(T value, E entity) predicate, String message, String code)`: Custom check with entity context.
- `mustAsync(Future<bool> Function(T value) predicate, ...)`: Async custom check.
- `mustWithAsync(Future<bool> Function(T value, E entity) predicate, ...)`: Async custom check with entity context.
- `isNull()`, `isNotNull()`: Check for nullability.
- `equalTo(T Function(E) comparison)`: Check equality to another field.
- `notEqualTo(T Function(E) comparison)`: Check inequality to another field.
- `isInEnum(List<T> values)`: Check value is in allowed list (e.g. `MyEnum.values`).

### String Checks
- `isEmpty()`, `notEmpty()`: Checks if string is empty / not empty.
- `minLength(int)`, `maxLength(int)`, `length(min, max)`: Length constraints.
- `isAlphanumeric()`, `isNumeric()`: Character set validations.
- `isUppercase()`, `isLowercase()`: Casing constraints.
- `contains(String)`, `startsWith(String)`, `endsWith(String)`: Substring checks.
- `matchesPattern(Pattern)`: Regular expression validation.
- `mustHaveLowercase()`, `mustHaveUppercase()`: Character type presence.
- `mustHaveNumber()`, `mustHaveSpecialCharacter()`: Character type presence (note: `mustHaveNumber` is singular).
- `hasNoSequentialRepeatedCharacters(int length)`: Rejects sequences like `"aaa"`.
- `hasNoSequentialCharacters(int length)`: Rejects sequences like `"123"` or `"abc"`.

### Numeric & Boolean Checks
- `min(num)`, `max(num)`: Value bounds.
- `range(min, max)`, `inclusiveBetween(min, max)`, `exclusiveBetween(min, max)`: Range bounds.
- `isPositive()`, `isNegative()`, `isNonNegative()`, `isNonZero()`: Sign checks.
- `isEven()`, `isOdd()`: Modulo checks.
- `multipleOf(num factor)`: Divisibility check.
- `precisionScale(int precision, int scale)`: Digits and decimal bounds.
- `isTrue()`, `isFalse()`: Strictly boolean checks.

### DateTime Checks
- `greaterThan(DateTime)`, `greaterThanOrEqualTo(DateTime)`: Min date checks.
- `lessThan(DateTime)`, `lessThanOrEqualTo(DateTime)`: Max date checks.
- `inclusiveBetween(DateTime, DateTime)`, `exclusiveBetween(DateTime, DateTime)`: Date range checks.
- `inPast()`, `inFuture()`: Time-relative checks.
- `afterField(DateTime Function(E) other)`: Asserts date is after another property.
- `beforeField(DateTime Function(E) other)`: Asserts date is before another property.

### Collections & Lists
- `minItems(int)`, `maxItems(int)`: Iterable length bounds.
- `listContains(T item)`: Item presence in list.

### Web, Network, & Identification
- `validEmail()`: Valid email format.
- `validUrl()`, `httpUrl()`: Valid URL / HTTP(S) URL.
- `validUuid()`: Valid UUID format (note: `validUuid` is camelCased).
- `validIpv4()`, `validIpv6()`: IPv4 / IPv6 addresses (note: lowercase `pv`).
- `validCreditCard()`: Luhn algorithm check.

### Brazilian Formats
- `validCPF()`, `validCNPJ()`, `validCPFOrCNPJ()`, `validCEP()`: Brazilian national identifiers.
- `validPhoneBR()`, `validPhoneWithCountryCodeBR()`: Brazilian telephone numbers.

---

## 3. Composition & Complex Nesting

### Validator Composition (`include`)
To combine multiple validators for the same entity class:
```dart
class FullUserValidator extends LucidValidator<UserModel> {
  FullUserValidator() {
    include(ContactValidator());
    include(BillingValidator());
  }
}
```

### Nesting Single Objects (`setValidator`)
Use `setValidator` to delegate validation of a sub-property to a dedicated validator:
```dart
class CustomerValidator extends LucidValidator<Customer> {
  CustomerValidator() {
    ruleFor((c) => c.address, key: 'address').setValidator(AddressValidator());
  }
}
```

### Nesting Iterables (`setEach`)

Use `setEach` to apply a validator to every item inside a collection, which automatically tracks item index:
```dart
ruleFor((c) => c.students, key: 'students').setEach(StudentValidator());
```

### Inline Iterable Validation (`ruleForEach`)

Use `ruleForEach` when validating lists of primitive values or inline rules:
```dart
ruleForEach((order) => order.tags, key: 'tags').notEmpty().maxLength(10);
```

---

## 4. Localization & Custom Languages

Global language setting is managed via the `Culture` object:
```dart
LucidValidation.global.culture = Culture('en', 'US');
```

### Overriding Translations Globally
Override individual translations s s dynamically using `LanguageManager`:
```dart
class CustomLanguageManager extends LanguageManager {
  CustomLanguageManager() {
    // Override a specific translation code
    addTranslation(Culture('pt', 'BR'), Language.code.equalTo, 'O valor deve ser idêntico a {ComparisonValue}.');
  }
}

// Assign it globally
LucidValidation.global.languageManager = CustomLanguageManager();
```

### Implementing a New Language
To add a new language, subclass `Language` from `lib/src/localization/language.dart` and pass a map of s s translation keys in the call to `super()`:

```dart
import 'package:lucid_validation/src/localization/language.dart';

class SpanishLanguage extends Language {
  SpanishLanguage()
      : super({
          Language.code.notEmpty: "'{PropertyName}' no puede estar vacío.",
          Language.code.validEmail: "'{PropertyName}' no es un correo electrónico válido.",
          // Add translations for all Language.code.* keys
        });
}
```

---

## 5. Creating Custom Validation Rules

Custom rules are declared as Dart extensions on `SimpleValidationBuilder<T>` (for entity-agnostic rules) or `LucidValidationBuilder<T, E>` (for entity-aware rules).

### Method 1: Composing Existing Rules
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

### Method 2: Synchronous Rules using `useValidation` (Simple Predicate)
Use this when you want the validation engine to handle formatting and `ValidationException` creation:
```dart
extension CustomMinWords on SimpleValidationBuilder<String> {
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

### Method 3: Asynchronous Rules using `useValidationAsync`
For database lookups or HTTP calls, s:
```dart
extension UniqueUsername on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> uniqueUsername(
    Future<bool> Function(String username) isUnique, {
    String? message,
    String? code,
  }) {
    return useValidationAsync(
      (value, entity) => isUnique(value),
      code: code ?? 'usernameTaken',
      message: message ?? "'{PropertyName}' is already taken.",
    );
  }
}
```

### Method 4: S/Async Rules with Full Exception Control (`use` / `useAsync`)
Use `use` (sync) or `useAsync` (async) when you want to construct the `ValidationException` manually (e.g. dynamic keys, nested properties, customized entity names):
```dart
extension CustomPrefixCheck on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> checkPrefix(String prefix) {
    return use((value, entity) {
      if (!value.startsWith(prefix)) {
        return ValidationException(
          key: key,
          message: "'{PropertyName}' must start with '$prefix'.",
          code: 'invalid_prefix',
          entity: 'CustomEntity',
        );
      }
      return null; // Return null if validation passes
    });
  }
}
```

---

## 6. Advanced Practical Examples

### Example A: Flutter Form Integration

You can integrate validations in your Flutter forms by defining a dedicated validator class (recommended for clean architecture / Domain Layer validations) or inline directly within your Widget (recommended for rapid prototyping or purely UI-focused validation).

#### Option A1: Class-Based Validator (Recommended for Domain Layer)

First, create a dedicated validation class:

```dart
import 'package:lucid_validation/lucid_validation.dart';

class UserRegisterForm {
  String email = '';
  String username = '';
}

class UserRegisterValidator extends LucidValidator<UserRegisterForm> {
  UserRegisterValidator() {
    ruleFor((c) => c.email, key: 'email')
        .notEmpty()
        .validEmail();

    ruleFor((c) => c.username, key: 'username')
        .notEmpty()
        .minLength(3);
  }
}
```

Then, use it in your Widget:

```dart
import 'package:flutter/material.dart';
import 'package:lucid_validation/lucid_validation.dart';

class RegisterFormWidget extends StatelessWidget {
  final credentials = UserRegisterForm();
  final validator = UserRegisterValidator();

  RegisterFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(hintText: 'Email'),
            onChanged: (val) => credentials.email = val,
            validator: validator.byField(credentials, 'email'),
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Username'),
            onChanged: (val) => credentials.username = val,
            validator: validator.byField(credentials, 'username'),
          ),
        ],
      ),
    );
  }
}
```

#### Option A2: Inline Validator (`LucidValidator.inline`)

Define the validator directly within your Widget to keep validations local to the UI file:

```dart
import 'package:flutter/material.dart';
import 'package:lucid_validation/lucid_validation.dart';

class RegisterFormWidgetInline extends StatelessWidget {
  final credentials = UserRegisterForm();

  // Define the validator inline on the class
  final validator = LucidValidator<UserRegisterForm>.inline((v) {
    v.ruleFor((c) => c.email, key: 'email')
        .notEmpty()
        .validEmail();

    v.ruleFor((c) => c.username, key: 'username')
        .notEmpty()
        .minLength(3);
  });

  RegisterFormWidgetInline({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(hintText: 'Email'),
            onChanged: (val) => credentials.email = val,
            validator: validator.byField(credentials, 'email'),
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Username'),
            onChanged: (val) => credentials.username = val,
            validator: validator.byField(credentials, 'username'),
          ),
        ],
      ),
    );
  }
}
```

### Example B: Real-Time Password Strength Checklist

This example demonstrates how to use `rulesForField` to drive a checklist UI indicating to the user in real-time which password criteria are met as they type.

```dart
import 'package:flutter/material.dart';
import 'package:lucid_validation/lucid_validation.dart';

class PasswordChecklistWidget extends StatefulWidget {
  const PasswordChecklistWidget({super.key});

  @override
  State<PasswordChecklistWidget> createState() => _PasswordChecklistWidgetState();
}

class _PasswordChecklistWidgetState extends State<PasswordChecklistWidget> {
  String _password = '';

  final validator = LucidValidator<String>.inline((v) {
    v.ruleFor((p) => p, key: 'password')
        .notEmpty().withErrorCode('required')
        .minLength(8).withErrorCode('length')
        .mustHaveUppercase().withErrorCode('uppercase')
        .mustHaveNumber().withErrorCode('number')
        .mustHaveSpecialCharacter().withErrorCode('special');
  });

  @override
  Widget build(BuildContext context) {
    // Evaluate all rules for the password field against the current string state
    final rules = validator.rulesForField(_password, 'password');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (value) => setState(() => _password = value),
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        ...rules.map((rule) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Icon(
                  rule.isValid ? Icons.check_circle : Icons.cancel,
                  color: rule.isValid ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  rule.message,
                  style: TextStyle(
                    color: rule.isValid ? Colors.green[800] : Colors.red[800],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
```

### Example C: Complex Nested Entity Graph Validation

This example showcases a full order-placement schema with:
- Nested object validation (`setValidator`).
- List validation with item index tracking (`setEach` and `minItems`).
- Polymorphic branching of nested objects based on a discriminator (`switchOn`).

```dart
import 'package:lucid_validation/lucid_validation.dart';

// Domain Models
class Order {
  final Customer customer;
  final List<OrderItem> items;
  final PaymentDetails payment;
  final String status;

  Order({
    required this.customer,
    required this.items,
    required this.payment,
    required this.status,
  });
}

class Customer {
  final String name;
  final String email;

  Customer({required this.name, required this.email});
}

class OrderItem {
  final String sku;
  final int quantity;
  final double price;

  OrderItem({required this.sku, required this.quantity, required this.price});
}

class PaymentDetails {
  final String type; // 'credit', 'pix', 'bank_transfer'
  final String? cardNumber;
  final String? pixKey;

  PaymentDetails({required this.type, this.cardNumber, this.pixKey});
}

// Validator
class OrderValidator extends LucidValidator<Order> {
  OrderValidator() {
    // Flat field check
    ruleFor((o) => o.status, key: 'status').notEmpty();

    // Nested object validator
    ruleFor((o) => o.customer, key: 'customer').setValidator(
      LucidValidator<Customer>.inline((v) {
        v.ruleFor((c) => c.name, key: 'name').notEmpty();
        v.ruleFor((c) => c.email, key: 'email').notEmpty().validEmail();
      }),
    );

    // List validation with item index tracking
    ruleFor((o) => o.items, key: 'items')
        .minItems(1, message: 'Your order must contain at least one item.')
        .setEach(
          LucidValidator<OrderItem>.inline((v) {
            v.ruleFor((i) => i.sku, key: 'sku').notEmpty().maxLength(10);
            v.ruleFor((i) => i.quantity, key: 'quantity').min(1);
            v.ruleFor((i) => i.price, key: 'price').isPositive();
          }),
        );

    // Nested object with polymorphic validation using switchOn
    ruleFor((o) => o.payment, key: 'payment').setValidator(
      LucidValidator<PaymentDetails>.inline((v) {
        v.ruleFor((p) => p.type, key: 'type').notEmpty();

        v.switchOn((p) => p.type, cases: {
          'credit': (inner) {
            inner.ruleFor((p) => p.cardNumber!, key: 'cardNumber').notEmpty().validCreditCard();
          },
          'pix': (inner) {
            inner.ruleFor((p) => p.pixKey!, key: 'pixKey').notEmpty();
          },
        });
      }),
    );
  }
}

// Executing Validation
void main() {
  final order = Order(
    status: 'pending',
    customer: Customer(name: 'Alice', email: 'invalid-email'),
    items: [
      OrderItem(sku: 'SKU123', quantity: 0, price: -5.0), // invalid quantity/price
    ],
    payment: PaymentDetails(type: 'credit', cardNumber: ''), // missing credit card number
  );

  final result = OrderValidator().validate(order);
  
  print(result.isValid); // false
  print(result.errorsByKey);
  // Output maps errors to nested paths & indices:
  // {
  //   "customer.email": ["'email' is not a valid email address."],
  //   "items.quantity": ["'quantity' must be greater than or equal to 1. You entered 0."],
  //   "items.price": ["'price' must be a positive number."],
  //   "payment.cardNumber": ["'cardNumber' must not be empty."]
  // }
}
```
