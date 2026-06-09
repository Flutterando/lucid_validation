// ignore_for_file: public_member_api_docs
import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

class Member {
  String name;
  String email;
  int age;

  Member({this.name = '', this.email = '', this.age = 0});
}

/// Helper validator that runs a configuration callback so each test can declare
/// its rules inline (mirrors the helper used in new_features_test.dart).
class _InlineTestValidator<T> extends LucidValidator<T> {
  _InlineTestValidator(void Function(_InlineTestValidator<T> v) configure) {
    configure(this);
  }
}

void main() {
  group('useValidation (sync)', () {
    test('passes when the predicate is satisfied', () {
      final validator = _InlineTestValidator<Member>((v) {
        v.ruleFor((m) => m.name, key: 'name').useValidation(
              (value, entity) => value.isNotEmpty,
              code: 'name_required',
            );
      });

      expect(validator.validate(Member(name: 'Alice')).isValid, isTrue);
    });

    test('fails carrying the provided code', () {
      final validator = _InlineTestValidator<Member>((v) {
        v.ruleFor((m) => m.name, key: 'name').useValidation(
              (value, entity) => value.isNotEmpty,
              code: 'name_required',
            );
      });

      final result = validator.validate(Member(name: ''));
      expect(result.isValid, isFalse);
      expect(result.exceptions.single.code, 'name_required');
      expect(result.exceptions.single.key, 'name');
    });

    test('resolves the localized message from a known code', () {
      final validator = _InlineTestValidator<Member>((v) {
        v.ruleFor((m) => m.name, key: 'name').useValidation(
              (value, entity) => value.isNotEmpty,
              code: Language.code.notEmpty,
            );
      });

      final result = validator.validate(Member(name: ''));
      expect(result.exceptions.single.message, "'name' must not be empty.");
    });

    test('substitutes extra parameters into the localized message', () {
      final validator = _InlineTestValidator<Member>((v) {
        v.ruleFor((m) => m.name, key: 'name').useValidation(
              (value, entity) => value.length >= 5,
              code: Language.code.minLength,
              parameters: (value, entity) => {
                'MinLength': '5',
                'TotalLength': '${value.length}',
              },
            );
      });

      final result = validator.validate(Member(name: 'ab'));
      expect(
        result.exceptions.single.message,
        "The length of 'name' must be at least 5 characters. "
        "You entered 2 characters.",
      );
    });

    test('honors a custom message over the localized one', () {
      final validator = _InlineTestValidator<Member>((v) {
        v.ruleFor((m) => m.name, key: 'name').useValidation(
              (value, entity) => value.isNotEmpty,
              code: Language.code.notEmpty,
              message: 'Please inform the name',
            );
      });

      final result = validator.validate(Member(name: ''));
      expect(result.exceptions.single.message, 'Please inform the name');
    });

    test('uses {PropertyName} from withName', () {
      final validator = _InlineTestValidator<Member>((v) {
        v
            .ruleFor((m) => m.name, key: 'name')
            .withName('Full name')
            .useValidation(
              (value, entity) => value.isNotEmpty,
              code: Language.code.notEmpty,
            );
      });

      final result = validator.validate(Member(name: ''));
      expect(result.exceptions.single.message, contains('Full name'));
    });

    test('the predicate receives the whole entity', () {
      final validator = _InlineTestValidator<Member>((v) {
        v.ruleFor((m) => m.name, key: 'name').useValidation(
              (value, entity) => value != entity.email,
              code: 'name_equals_email',
            );
      });

      expect(
        validator.validate(Member(name: 'a@b.com', email: 'a@b.com')).isValid,
        isFalse,
      );
      expect(
        validator.validate(Member(name: 'Alice', email: 'a@b.com')).isValid,
        isTrue,
      );
    });
  });

  group('useValidation integrates with rule exposition', () {
    _InlineTestValidator<Member> build() {
      return _InlineTestValidator<Member>((v) {
        v.ruleFor((m) => m.name, key: 'name').useValidation(
              (value, entity) => value.isNotEmpty,
              code: Language.code.notEmpty,
            );
      });
    }

    test('reports code and translated message when satisfied', () {
      final rule = build().rulesForField(Member(name: 'ok'), 'name').single;
      expect(rule.isValid, isTrue);
      expect(rule.code, Language.code.notEmpty);
      expect(rule.message, "'name' must not be empty.");
    });

    test('reports the failure state when not satisfied', () {
      final rule = build().rulesForField(Member(name: ''), 'name').single;
      expect(rule.isValid, isFalse);
      expect(rule.code, Language.code.notEmpty);
    });
  });

  group('useValidationAsync', () {
    _InlineTestValidator<Member> build(Set<String> taken) {
      return _InlineTestValidator<Member>((v) {
        v.ruleFor((m) => m.email, key: 'email').useValidationAsync(
              (value, entity) async => !taken.contains(value),
              code: 'email_taken',
            );
      });
    }

    test('validateAsync fails carrying the code', () async {
      final result = await build({'taken@x.com'})
          .validateAsync(Member(email: 'taken@x.com'));
      expect(result.isValid, isFalse);
      expect(result.exceptions.single.code, 'email_taken');
    });

    test('validateAsync passes when the predicate resolves true', () async {
      final result = await build({'taken@x.com'})
          .validateAsync(Member(email: 'free@x.com'));
      expect(result.isValid, isTrue);
    });

    test('sync validate throws AsyncValidationException', () {
      expect(
        () => build({'taken@x.com'}).validate(Member(email: 'taken@x.com')),
        throwsA(isA<AsyncValidationException>()),
      );
    });

    test('is exposed through rulesForFieldAsync', () async {
      final rules = await build({'taken@x.com'})
          .rulesForFieldAsync(Member(email: 'taken@x.com'), 'email');
      expect(rules.single.isValid, isFalse);
      expect(rules.single.code, 'email_taken');
    });
  });
}
