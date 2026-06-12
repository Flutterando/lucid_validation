// ignore_for_file: public_member_api_docs
import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

class Account {
  String email;
  String password;
  String? companyName;
  bool isIndividual;
  List<String> tags;

  Account({
    this.email = '',
    this.password = '',
    this.companyName,
    this.isIndividual = true,
    this.tags = const [],
  });
}

class Address {
  String street;
  String city;

  Address({this.street = '', this.city = ''});
}

class Customer {
  String name;
  Address address;

  Customer({this.name = '', Address? address}) : address = address ?? Address();
}

enum Role { admin, user, guest }

class Profile {
  String url;
  num age;
  DateTime start;
  String? nickname;
  Role role;

  Profile({
    this.url = '',
    this.age = 0,
    DateTime? start,
    this.nickname,
    this.role = Role.user,
  }) : start = start ?? DateTime(2020);
}

void main() {
  group('#1 withMessage / withErrorCode / withName', () {
    test('withMessage overrides the message of the previous rule', () {
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleFor((a) => a.email, key: 'email') //
            .notEmpty()
            .withMessage('Informe o e-mail');
      });

      final result = validator.validate(Account(email: ''));

      expect(result.isValid, isFalse);
      expect(result.exceptions.first.message, 'Informe o e-mail');
    });

    test('withErrorCode overrides only the previous rule code', () {
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleFor((a) => a.email, key: 'email') //
            .notEmpty()
            .withErrorCode('EMAIL_REQUIRED')
            .validEmail()
            .withErrorCode('EMAIL_INVALID');
      });

      late ValidationResult result = validator.validate(Account(email: ''));

      // notEmpty passes, validEmail fails -> only the EMAIL_INVALID code.
      expect(result.exceptions.length, 2);
      expect(result.exceptions.first.code, 'EMAIL_REQUIRED');

      result = validator.validate(Account(email: 'not-an-email'));

      // notEmpty passes, validEmail fails -> only the EMAIL_INVALID code.
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.code, 'EMAIL_INVALID');
    });

    test('withName changes {PropertyName} but keeps the field key', () {
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleFor((a) => a.email, key: 'email') //
            .withName('E-mail')
            .notEmpty();
      });

      final result = validator.validate(Account(email: ''));

      expect(result.exceptions.first.message, contains('E-mail'));
      expect(result.exceptions.first.key, 'email');
    });

    test('withMessage replaces {PropertyName} (withName chained before)', () {
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleFor((a) => a.email, key: 'email')
            .withName('E-mail')
            .notEmpty()
            .withMessage('{PropertyName} cannot be empty');
      });

      final result = validator.validate(Account(email: ''));

      expect(result.exceptions.first.message, 'E-mail cannot be empty');
    });

    test('withMessage replaces {PropertyName} (withName chained after)', () {
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleFor((a) => a.email, key: 'email')
            .notEmpty()
            .withMessage('{PropertyName} cannot be empty')
            .withName('the tag');
      });

      final result = validator.validate(Account(email: ''));

      expect(result.exceptions.first.message, 'the tag cannot be empty');
    });

    test('withMessage uses the key when no withName is provided', () {
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleFor((a) => a.email, key: 'email')
            .notEmpty()
            .withMessage('{PropertyName} cannot be empty');
      });

      final result = validator.validate(Account(email: ''));

      expect(result.exceptions.first.message, 'email cannot be empty');
    });
  });

  group('#2 async validation', () {
    test('mustAsync fails when the future resolves to false', () async {
      final taken = {'taken@email.com'};
      final validator = _InlineTestValidator<Account>((v) {
        v.ruleFor((a) => a.email, key: 'email').mustAsync(
              (email) async => !taken.contains(email),
              'E-mail already registered',
              'email_taken',
            );
      });

      final invalid =
          await validator.validateAsync(Account(email: 'taken@email.com'));
      final valid =
          await validator.validateAsync(Account(email: 'free@email.com'));

      expect(invalid.isValid, isFalse);
      expect(invalid.exceptions.first.code, 'email_taken');
      expect(valid.isValid, isTrue);
    });

    test('sync validate throws when async rules are present', () {
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleFor((a) => a.email, key: 'email')
            .mustAsync((email) async => true, 'x', 'x');
      });

      expect(
        () => validator.validate(Account(email: 'a@b.com')),
        throwsA(isA<AsyncValidationException>()),
      );
    });

    test('validateAsync runs sync and async rules together', () async {
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleFor((a) => a.email, key: 'email')
            .notEmpty()
            .mustAsync((email) async => email.contains('@'), 'invalid', 'inv');
      });

      final result = await validator.validateAsync(Account(email: ''));
      // notEmpty fails (sync) and async also fails.
      expect(result.exceptions.length, 2);
    });
  });

  group('#3 ruleForEach inline', () {
    test('applies rules to each item with index tracking', () {
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleForEach((a) => a.tags, key: 'tags') //
            .notEmpty()
            .maxLength(5);
      });

      final result = validator.validate(
        Account(tags: ['ok', '', 'toolong']),
      );

      expect(result.isValid, isFalse);
      // index 1 empty, index 2 too long
      final indexes = result.exceptions.map((e) => e.index).toList();
      expect(indexes, containsAll([1, 2]));
      expect(result.exceptions.every((e) => e.key == 'tags'), isTrue);
    });
  });

  group('#4 RuleSets', () {
    _InlineTestValidator<Account> build() {
      return _InlineTestValidator<Account>((v) {
        v.ruleFor((a) => a.email, key: 'email').notEmpty();
        v.ruleSet('create', () {
          v.ruleFor((a) => a.password, key: 'password').notEmpty();
        });
      });
    }

    test('default validate runs only the default set', () {
      final result = build().validate(Account(email: '', password: ''));
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.key, 'email');
    });

    test('named rule set runs only its rules', () {
      final result = build()
          .validate(Account(email: '', password: ''), ruleSets: ['create']);
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.key, 'password');
    });

    test('wildcard runs all sets', () {
      final result =
          build().validate(Account(email: '', password: ''), ruleSets: ['*']);
      expect(result.exceptions.length, 2);
    });
  });

  group('#5 include', () {
    test('merges rules from another validator of the same entity', () {
      final emailValidator = _InlineTestValidator<Account>((v) {
        v.ruleFor((a) => a.email, key: 'email').notEmpty();
      });
      final passwordValidator = _InlineTestValidator<Account>((v) {
        v.ruleFor((a) => a.password, key: 'password').notEmpty();
      });

      final composed = _InlineTestValidator<Account>((v) {
        v.include(emailValidator);
        v.include(passwordValidator);
      });

      final result = composed.validate(Account(email: '', password: ''));
      expect(result.exceptions.length, 2);
    });
  });

  group('#6 unless', () {
    test('rule runs only when condition is false', () {
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleFor((a) => a.companyName ?? '', key: 'companyName') //
            .unless((a) => a.isIndividual)
            .notEmpty();
      });

      final individual = validator.validate(Account(isIndividual: true));
      final company =
          validator.validate(Account(isIndividual: false, companyName: ''));

      expect(individual.isValid, isTrue);
      expect(company.isValid, isFalse);
    });

    test('when and unless compose', () {
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleFor((a) => a.companyName ?? '', key: 'companyName')
            .when((a) => a.email.isNotEmpty)
            .unless((a) => a.isIndividual)
            .notEmpty();
      });

      // email empty -> when false -> skipped
      expect(
        validator.validate(Account(email: '', isIndividual: false)).isValid,
        isTrue,
      );
      // email present + not individual -> runs and fails
      expect(
        validator
            .validate(Account(email: 'a@b.com', isIndividual: false))
            .isValid,
        isFalse,
      );
    });
  });

  group('#7 normalize', () {
    test('sanitizes value before validation without mutating the entity', () {
      final account = Account(email: '  A@B.COM  ');
      final validator = _InlineTestValidator<Account>((v) {
        v
            .ruleFor((a) => a.email, key: 'email') //
            .normalize((email) => email.trim().toLowerCase())
            .validEmail();
      });

      final result = validator.validate(account);

      expect(result.isValid, isTrue);
      // original entity untouched
      expect(account.email, '  A@B.COM  ');
    });
  });

  group('#8 LucidValidator.inline factory', () {
    test('creates a usable validator without declaring a subclass', () {
      final validator = LucidValidator<Account>.inline((v) {
        v.ruleFor((a) => a.email, key: 'email').notEmpty().validEmail();
        v.ruleFor((a) => a.password, key: 'password').notEmpty().minLength(8);
      });

      final invalid =
          validator.validate(Account(email: 'invalid-email', password: '123'));
      final valid = validator
          .validate(Account(email: 'user@email.com', password: '12345678'));

      expect(invalid.isValid, isFalse);
      // invalid email + short password
      expect(invalid.exceptions.map((e) => e.key),
          containsAll(['email', 'password']));
      expect(valid.isValid, isTrue);
    });

    test('byField works on an inline validator', () {
      final validator = LucidValidator<Account>.inline((v) {
        v.ruleFor((a) => a.email, key: 'email').notEmpty().validEmail();
      });

      final account = Account(email: '');
      final emailValidator = validator.byField(account, 'email');

      expect(emailValidator(), isNotNull);

      account.email = 'user@email.com';
      expect(emailValidator(), isNull);
    });

    test('inline validator can be used as a nested setValidator', () {
      final validator = LucidValidator<Customer>.inline((v) {
        v.ruleFor((c) => c.name, key: 'name').notEmpty();
        v.ruleFor((c) => c.address, key: 'address').setValidator(
          LucidValidator<Address>.inline((a) {
            a.ruleFor((x) => x.street, key: 'street').notEmpty();
            a.ruleFor((x) => x.city, key: 'city').notEmpty();
          }),
        );
      });

      final result = validator.validate(
        Customer(name: '', address: Address(street: '', city: 'NY')),
      );

      expect(result.isValid, isFalse);
      // name empty + nested street empty, but city is valid
      final keys = result.exceptions.map((e) => e.key).toList();
      expect(keys, containsAll(['name', 'street']));
      expect(keys, isNot(contains('city')));
    });
  });

  group('#9 rulesForField (rule exposition)', () {
    LucidValidator<Account> buildPasswordValidator() {
      return LucidValidator<Account>.inline((v) {
        v
            .ruleFor((a) => a.password, key: 'password')
            .notEmpty()
            .minLength(8)
            .mustHaveLowercase()
            .mustHaveUppercase()
            .mustHaveNumber()
            .mustHaveSpecialCharacter();
      });
    }

    test('returns one result per rule with the expected codes', () {
      final rules = buildPasswordValidator()
          .rulesForField(Account(password: ''), 'password');

      expect(rules.length, 6);
      expect(
        rules.map((r) => r.code).toList(),
        [
          Language.code.notEmpty,
          Language.code.minLength,
          Language.code.mustHaveLowercase,
          Language.code.mustHaveUppercase,
          Language.code.mustHaveNumber,
          Language.code.mustHaveSpecialCharacter,
        ],
      );
    });

    test('tracks the satisfied state of every rule as the value changes', () {
      final validator = buildPasswordValidator();

      // Empty -> every rule fails.
      final empty = validator.rulesForField(Account(password: ''), 'password');
      expect(empty.every((r) => !r.isValid), isTrue);

      // Partially valid -> only some rules pass.
      final partial =
          validator.rulesForField(Account(password: 'abcdefgh'), 'password');
      final partialByCode = {for (final r in partial) r.code: r.isValid};
      expect(partialByCode[Language.code.notEmpty], isTrue);
      expect(partialByCode[Language.code.minLength], isTrue);
      expect(partialByCode[Language.code.mustHaveLowercase], isTrue);
      expect(partialByCode[Language.code.mustHaveUppercase], isFalse);
      expect(partialByCode[Language.code.mustHaveNumber], isFalse);
      expect(partialByCode[Language.code.mustHaveSpecialCharacter], isFalse);

      // Fully valid -> every rule passes.
      final strong =
          validator.rulesForField(Account(password: 'Abcdef1!'), 'password');
      expect(strong.every((r) => r.isValid), isTrue);
    });

    test('exposes the translated message even when a rule is satisfied', () {
      final validator = LucidValidator<Account>.inline((v) {
        v.ruleFor((a) => a.password, key: 'password').notEmpty();
      });

      // Satisfied rule -> message comes from the rule metadata (translation).
      final satisfied =
          validator.rulesForField(Account(password: 'secret'), 'password');
      expect(satisfied.single.isValid, isTrue);
      expect(satisfied.single.message, "'password' must not be empty.");

      // Failing rule -> message comes from the produced exception.
      final failing =
          validator.rulesForField(Account(password: ''), 'password');
      expect(failing.single.isValid, isFalse);
      expect(failing.single.message, "'password' must not be empty.");
    });

    test('honours localized messages via the global culture', () {
      addTearDown(() => LucidValidation.global.culture = Culture('en'));
      LucidValidation.global.culture = Culture('pt');

      final validator = LucidValidator<Account>.inline((v) {
        v.ruleFor((a) => a.password, key: 'password').notEmpty();
      });

      final rules =
          validator.rulesForField(Account(password: 'secret'), 'password');

      expect(rules.single.message, "'password' não pode estar vazio.");
    });

    test('uses a custom message for the exposed rule when provided', () {
      final validator = LucidValidator<Account>.inline((v) {
        v
            .ruleFor((a) => a.password, key: 'password')
            .notEmpty(message: 'Password is required');
      });

      final satisfied =
          validator.rulesForField(Account(password: 'secret'), 'password');
      final failing =
          validator.rulesForField(Account(password: ''), 'password');

      expect(satisfied.single.message, 'Password is required');
      expect(failing.single.message, 'Password is required');
    });

    test('reflects withName in the exposed message', () {
      final validator = LucidValidator<Account>.inline((v) {
        v.ruleFor((a) => a.email, key: 'email').withName('E-mail').notEmpty();
      });

      final rules = validator.rulesForField(Account(email: 'a@b.com'), 'email');

      expect(rules.single.isValid, isTrue);
      expect(rules.single.message, "'E-mail' must not be empty.");
    });

    test('returns an empty list for an unknown key', () {
      final validator = LucidValidator<Account>.inline((v) {
        v.ruleFor((a) => a.email, key: 'email').notEmpty();
      });

      expect(validator.rulesForField(Account(), 'does-not-exist'), isEmpty);
    });

    test('throws AsyncValidationException when the field has async rules', () {
      final validator = LucidValidator<Account>.inline((v) {
        v
            .ruleFor((a) => a.email, key: 'email')
            .mustAsync((email) async => email.isNotEmpty, 'invalid', 'inv');
      });

      expect(
        () => validator.rulesForField(Account(email: 'a@b.com'), 'email'),
        throwsA(isA<AsyncValidationException>()),
      );
    });
  });

  group('#10 rulesForFieldAsync', () {
    test('evaluates sync and async rules together', () async {
      final taken = {'taken@email.com'};
      final validator = LucidValidator<Account>.inline((v) {
        v.ruleFor((a) => a.email, key: 'email').notEmpty().mustAsync(
              (email) async => !taken.contains(email),
              'E-mail already registered',
              'email_taken',
            );
      });

      final freeRules = await validator.rulesForFieldAsync(
          Account(email: 'free@email.com'), 'email');
      expect(freeRules.length, 2);
      expect(freeRules.every((r) => r.isValid), isTrue);

      final takenRules = await validator.rulesForFieldAsync(
          Account(email: 'taken@email.com'), 'email');
      final byCode = {for (final r in takenRules) r.code: r.isValid};
      expect(byCode[Language.code.notEmpty], isTrue);
      expect(byCode['email_taken'], isFalse);
    });

    test('returns an empty list for an unknown key', () async {
      final validator = LucidValidator<Account>.inline((v) {
        v.ruleFor((a) => a.email, key: 'email').notEmpty();
      });

      expect(
        await validator.rulesForFieldAsync(Account(), 'unknown'),
        isEmpty,
      );
    });
  });

  group('#11 exposeRules wired across assorted validators', () {
    LucidValidator<Profile> buildProfileValidator() {
      return LucidValidator<Profile>.inline((v) {
        v.ruleFor((p) => p.url, key: 'url').validUrl();
        v.ruleFor((p) => p.age, key: 'age').min(18).inclusiveBetween(0, 120);
        v.ruleFor((p) => p.start, key: 'start').greaterThan(DateTime(2019));
        v.ruleFor((p) => p.nickname, key: 'nickname').isNotNull();
        v.ruleFor((p) => p.role, key: 'role').isInEnum(Role.values);
      });
    }

    test('every satisfied rule carries a non-empty code and message', () {
      final validator = buildProfileValidator();
      final valid = Profile(
        url: 'https://example.com',
        age: 30,
        start: DateTime(2021),
        nickname: 'neo',
        role: Role.admin,
      );

      for (final key in ['url', 'age', 'start', 'nickname', 'role']) {
        final rules = validator.rulesForField(valid, key);
        expect(rules, isNotEmpty, reason: 'no rules exposed for $key');
        for (final rule in rules) {
          expect(rule.isValid, isTrue, reason: '$key rule should be valid');
          expect(rule.code, isNotEmpty, reason: '$key rule missing code');
          expect(rule.message, isNotEmpty, reason: '$key rule missing message');
        }
      }
    });

    test('exposes the proper codes and failing state for invalid values', () {
      final validator = buildProfileValidator();
      final invalid = Profile(
        url: 'not a url',
        age: 5,
        start: DateTime(2018),
        nickname: null,
        role: Role.guest,
      );

      expect(
        validator.rulesForField(invalid, 'url').single,
        isA<ExposedRuleResult>()
            .having((r) => r.code, 'code', Language.code.validUrl)
            .having((r) => r.isValid, 'isValid', isFalse),
      );

      // age: min(18) fails, inclusiveBetween(0,120) passes.
      final ageRules = {
        for (final r in validator.rulesForField(invalid, 'age'))
          r.code: r.isValid
      };
      expect(ageRules[Language.code.min], isFalse);
      expect(ageRules[Language.code.inclusiveBetween], isTrue);

      expect(
        validator.rulesForField(invalid, 'start').single.isValid,
        isFalse,
      );
      expect(
        validator.rulesForField(invalid, 'nickname').single.code,
        Language.code.isNotNull,
      );
      expect(
        validator.rulesForField(invalid, 'nickname').single.isValid,
        isFalse,
      );
    });
  });
}

/// Small helper validator that takes a configuration callback so each test can
/// declare its rules inline.
class _InlineTestValidator<T> extends LucidValidator<T> {
  _InlineTestValidator(void Function(_InlineTestValidator<T> v) configure) {
    configure(this);
  }
}
