// ignore_for_file: public_member_api_docs
import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

enum Status { active, inactive, pending }

class Model {
  String email;
  String password;
  String username;
  String website;
  num quantity;
  num price;
  Status status;

  Model({
    this.email = '',
    this.password = '',
    this.username = '',
    this.website = '',
    this.quantity = 0,
    this.price = 0,
    this.status = Status.active,
  });
}

/// Inline validator helper so each test can declare rules on the fly.
class _Validator<T> extends LucidValidator<T> {
  _Validator(void Function(_Validator<T> v) configure) {
    configure(this);
  }
}

void main() {
  group('ValidationResult helpers', () {
    _Validator<Model> build() {
      return _Validator<Model>((v) {
        v.ruleFor((m) => m.email, key: 'email').notEmpty().validEmail();
        v.ruleFor((m) => m.password, key: 'password').notEmpty();
      });
    }

    test('errorsByKey groups messages per field', () {
      final result = build().validate(Model(email: '', password: ''));

      final errors = result.errorsByKey;
      expect(errors.keys, containsAll(['email', 'password']));
      expect(errors['email']!.length, 2); // notEmpty + validEmail
      expect(errors['password']!.length, 1);
    });

    test('firstErrorFor returns the first message for a key', () {
      final result = build().validate(Model(email: '', password: ''));

      expect(result.firstErrorFor('password'), isNotNull);
      expect(result.firstErrorFor('email'), result.exceptions.first.message);
      expect(result.firstErrorFor('unknown'), isNull);
    });

    test('validateAndThrow throws when invalid and returns when valid', () {
      final validator = build();

      expect(
        () => validator.validateAndThrow(Model(email: '', password: '')),
        throwsA(isA<LucidValidationException>()),
      );

      final ok =
          validator.validateAndThrow(Model(email: 'a@b.com', password: '123'));
      expect(ok.isValid, isTrue);
    });

    test('LucidValidationException exposes all errors', () {
      try {
        build().validateAndThrow(Model(email: '', password: ''));
        fail('should have thrown');
      } on LucidValidationException catch (e) {
        expect(e.errors.length, 3);
        expect(e.toString(), contains('LucidValidationException'));
      }
    });

    test('validateAndThrowAsync throws on async failure', () async {
      final validator = _Validator<Model>((v) {
        v.ruleFor((m) => m.email, key: 'email').mustAsync(
              (email) async => email.contains('@'),
              'invalid',
              'inv',
            );
      });

      await expectLater(
        validator.validateAndThrowAsync(Model(email: 'nope')),
        throwsA(isA<LucidValidationException>()),
      );
    });
  });

  group('inclusiveBetween (num)', () {
    _Validator<Model> build() => _Validator<Model>((v) {
          v.ruleFor((m) => m.quantity, key: 'quantity').inclusiveBetween(1, 10);
        });

    test('passes on the bounds', () {
      expect(build().validate(Model(quantity: 1)).isValid, isTrue);
      expect(build().validate(Model(quantity: 10)).isValid, isTrue);
    });

    test('fails outside the range', () {
      expect(build().validate(Model(quantity: 0)).isValid, isFalse);
      expect(build().validate(Model(quantity: 11)).isValid, isFalse);
    });

    test('OrNull passes on null', () {
      final validator = _Validator<Model>((v) {
        v
            .ruleFor((m) => m.quantity as num?, key: 'quantity')
            .inclusiveBetweenOrNull(1, 10);
      });
      expect(validator.validate(Model(quantity: 5)).isValid, isTrue);
    });
  });

  group('exclusiveBetween (num)', () {
    _Validator<Model> build() => _Validator<Model>((v) {
          v.ruleFor((m) => m.quantity, key: 'quantity').exclusiveBetween(1, 10);
        });

    test('fails on the bounds', () {
      expect(build().validate(Model(quantity: 1)).isValid, isFalse);
      expect(build().validate(Model(quantity: 10)).isValid, isFalse);
    });

    test('passes strictly inside', () {
      expect(build().validate(Model(quantity: 5)).isValid, isTrue);
    });
  });

  group('validUrl', () {
    _Validator<Model> build() => _Validator<Model>((v) {
          v.ruleFor((m) => m.website, key: 'website').validUrl();
        });

    test('accepts valid URLs', () {
      expect(
          build()
              .validate(Model(website: 'https://flutterando.com.br'))
              .isValid,
          isTrue);
      expect(
          build()
              .validate(Model(website: 'http://example.com/path?x=1'))
              .isValid,
          isTrue);
      expect(build().validate(Model(website: 'sub.domain.io')).isValid, isTrue);
    });

    test('rejects invalid URLs', () {
      expect(build().validate(Model(website: 'not a url')).isValid, isFalse);
      expect(build().validate(Model(website: 'http://')).isValid, isFalse);
    });
  });

  group('length', () {
    _Validator<Model> build() => _Validator<Model>((v) {
          v.ruleFor((m) => m.username, key: 'username').length(3, 8);
        });

    test('passes within range', () {
      expect(build().validate(Model(username: 'abc')).isValid, isTrue);
      expect(build().validate(Model(username: 'abcdefgh')).isValid, isTrue);
    });

    test('fails outside range', () {
      expect(build().validate(Model(username: 'ab')).isValid, isFalse);
      expect(build().validate(Model(username: 'abcdefghi')).isValid, isFalse);
    });
  });

  group('isInEnum', () {
    test('passes for an allowed enum value', () {
      final validator = _Validator<Model>((v) {
        v.ruleFor((m) => m.status, key: 'status').isInEnum(Status.values);
      });
      expect(validator.validate(Model(status: Status.pending)).isValid, isTrue);
    });

    test('fails for a value not in the provided set', () {
      final validator = _Validator<Model>((v) {
        v.ruleFor((m) => m.status, key: 'status').isInEnum(
          [Status.active, Status.inactive],
        );
      });
      expect(
          validator.validate(Model(status: Status.pending)).isValid, isFalse);
    });
  });

  group('precisionScale', () {
    _Validator<Model> build() => _Validator<Model>((v) {
          v.ruleFor((m) => m.price, key: 'price').precisionScale(5, 2);
        });

    test('passes within precision/scale', () {
      expect(build().validate(Model(price: 123.45)).isValid, isTrue);
      expect(build().validate(Model(price: 12.5)).isValid, isTrue);
      expect(build().validate(Model(price: 0.99)).isValid, isTrue);
    });

    test('fails when too many decimals', () {
      expect(build().validate(Model(price: 123.456)).isValid, isFalse);
    });

    test('fails when too many integer digits', () {
      // digits=5, scale=1 -> integer digits 4 > (precision - scale)=3
      expect(build().validate(Model(price: 1234.5)).isValid, isFalse);
    });

    test('ignoreTrailingZeros relaxes the scale check', () {
      final validator = _Validator<Model>((v) {
        v
            .ruleFor((m) => m.price, key: 'price')
            .precisionScale(5, 2, ignoreTrailingZeros: true);
      });
      expect(validator.validate(Model(price: 12.300)).isValid, isTrue);
    });
  });
}
