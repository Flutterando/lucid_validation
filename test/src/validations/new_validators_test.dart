// ignore_for_file: public_member_api_docs
import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

class _Entity<T> {
  final T value;
  const _Entity(this.value);
}

class _Validator<T> extends LucidValidator<_Entity<T>> {
  _Validator(void Function(_Validator<T> v) configure) {
    configure(this);
  }
}

class _Event {
  final DateTime start;
  final DateTime end;
  const _Event({required this.start, required this.end});
}

class _EventValidator extends LucidValidator<_Event> {
  _EventValidator(void Function(_EventValidator v) configure) {
    configure(this);
  }
}

void main() {
  // ---------------------------------------------------------------------------
  // String validators
  // ---------------------------------------------------------------------------

  group('isAlphanumeric', () {
    _Validator<String> build() => _Validator<String>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isAlphanumeric(),
        );

    test('passes for letters and digits', () {
      expect(build().validate(_Entity('abc123')).isValid, isTrue);
    });

    test('fails when value contains a space', () {
      expect(build().validate(_Entity('abc 123')).isValid, isFalse);
    });

    test('fails when value contains a special character', () {
      expect(build().validate(_Entity('abc!')).isValid, isFalse);
    });

    test('returns correct code on failure', () {
      final result = build().validate(_Entity('@bad'));
      expect(result.exceptions.single.code, Language.code.alphanumeric);
    });
  });

  group('isNumeric', () {
    _Validator<String> build() => _Validator<String>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isNumeric(),
        );

    test('passes for all digits', () {
      expect(build().validate(_Entity('12345')).isValid, isTrue);
    });

    test('fails when value contains a letter', () {
      expect(build().validate(_Entity('123a')).isValid, isFalse);
    });

    test('returns correct code on failure', () {
      expect(
        build().validate(_Entity('1.5')).exceptions.single.code,
        Language.code.isNumeric,
      );
    });
  });

  group('isUppercase', () {
    _Validator<String> build() => _Validator<String>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isUppercase(),
        );

    test('passes when value is all uppercase', () {
      expect(build().validate(_Entity('HELLO')).isValid, isTrue);
    });

    test('passes when value has digits and uppercase', () {
      expect(build().validate(_Entity('ABC123')).isValid, isTrue);
    });

    test('fails when value has a lowercase letter', () {
      expect(build().validate(_Entity('Hello')).isValid, isFalse);
    });
  });

  group('isLowercase', () {
    _Validator<String> build() => _Validator<String>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isLowercase(),
        );

    test('passes when value is all lowercase', () {
      expect(build().validate(_Entity('hello')).isValid, isTrue);
    });

    test('fails when value has an uppercase letter', () {
      expect(build().validate(_Entity('Hello')).isValid, isFalse);
    });
  });

  group('contains', () {
    _Validator<String> build() => _Validator<String>(
          (v) => v.ruleFor((e) => e.value, key: 'v').contains('@'),
        );

    test('passes when value contains the substring', () {
      expect(build().validate(_Entity('user@example.com')).isValid, isTrue);
    });

    test('fails when value does not contain the substring', () {
      expect(build().validate(_Entity('userexample.com')).isValid, isFalse);
    });

    test('error message includes the required substring', () {
      final result = build().validate(_Entity('no-at-sign'));
      expect(result.exceptions.single.message, contains('@'));
    });
  });

  group('startsWith', () {
    _Validator<String> build() => _Validator<String>(
          (v) => v.ruleFor((e) => e.value, key: 'v').startsWith('/api'),
        );

    test('passes when value starts with the prefix', () {
      expect(build().validate(_Entity('/api/users')).isValid, isTrue);
    });

    test('fails when value does not start with the prefix', () {
      expect(build().validate(_Entity('/v1/users')).isValid, isFalse);
    });
  });

  group('endsWith', () {
    _Validator<String> build() => _Validator<String>(
          (v) => v.ruleFor((e) => e.value, key: 'v').endsWith('.dart'),
        );

    test('passes when value ends with the suffix', () {
      expect(build().validate(_Entity('main.dart')).isValid, isTrue);
    });

    test('fails when value does not end with the suffix', () {
      expect(build().validate(_Entity('main.js')).isValid, isFalse);
    });
  });

  group('validUuid', () {
    _Validator<String> build() => _Validator<String>(
          (v) => v.ruleFor((e) => e.value, key: 'v').validUuid(),
        );

    test('passes for a valid v4 UUID', () {
      expect(
        build()
            .validate(_Entity('550e8400-e29b-41d4-a716-446655440000'))
            .isValid,
        isTrue,
      );
    });

    test('fails for a non-UUID string', () {
      expect(build().validate(_Entity('not-a-uuid')).isValid, isFalse);
    });

    test('fails for a UUID missing hyphens', () {
      expect(
        build()
            .validate(_Entity('550e8400e29b41d4a716446655440000'))
            .isValid,
        isFalse,
      );
    });
  });

  group('validIpv4', () {
    _Validator<String> build() => _Validator<String>(
          (v) => v.ruleFor((e) => e.value, key: 'v').validIpv4(),
        );

    test('passes for a valid IPv4 address', () {
      expect(build().validate(_Entity('192.168.1.1')).isValid, isTrue);
    });

    test('passes for 0.0.0.0', () {
      expect(build().validate(_Entity('0.0.0.0')).isValid, isTrue);
    });

    test('passes for 255.255.255.255', () {
      expect(build().validate(_Entity('255.255.255.255')).isValid, isTrue);
    });

    test('fails for octet > 255', () {
      expect(build().validate(_Entity('256.0.0.0')).isValid, isFalse);
    });

    test('fails for missing octet', () {
      expect(build().validate(_Entity('192.168.1')).isValid, isFalse);
    });

    test('fails for letters', () {
      expect(build().validate(_Entity('abc.def.ghi.jkl')).isValid, isFalse);
    });

    test('fails for leading zeros', () {
      expect(build().validate(_Entity('01.02.03.04')).isValid, isFalse);
    });
  });

  group('validIpv6', () {
    _Validator<String> build() => _Validator<String>(
          (v) => v.ruleFor((e) => e.value, key: 'v').validIpv6(),
        );

    test('passes for a full IPv6 address', () {
      expect(
        build()
            .validate(_Entity('2001:0db8:85a3:0000:0000:8a2e:0370:7334'))
            .isValid,
        isTrue,
      );
    });

    test('passes for compressed IPv6 (::1)', () {
      expect(build().validate(_Entity('::1')).isValid, isTrue);
    });

    test('passes for all zeros compressed (::)', () {
      expect(build().validate(_Entity('::')).isValid, isTrue);
    });

    test('fails for an IPv4 address', () {
      expect(build().validate(_Entity('192.168.1.1')).isValid, isFalse);
    });

    test('fails for a random string', () {
      expect(build().validate(_Entity('not-ipv6')).isValid, isFalse);
    });
  });

  group('httpUrl', () {
    _Validator<String> build() => _Validator<String>(
          (v) => v.ruleFor((e) => e.value, key: 'v').httpUrl(),
        );

    test('passes for an http URL', () {
      expect(
          build().validate(_Entity('http://example.com')).isValid, isTrue);
    });

    test('passes for an https URL', () {
      expect(
          build().validate(_Entity('https://example.com/path')).isValid,
          isTrue);
    });

    test('fails for an ftp URL', () {
      expect(
          build().validate(_Entity('ftp://example.com')).isValid, isFalse);
    });

    test('fails for a plain domain without scheme', () {
      expect(
          build().validate(_Entity('example.com')).isValid, isFalse);
    });

    test('fails for an empty string', () {
      expect(build().validate(_Entity('')).isValid, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // num validators
  // ---------------------------------------------------------------------------

  group('isPositive', () {
    _Validator<num> build() => _Validator<num>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isPositive(),
        );

    test('passes for a positive number', () {
      expect(build().validate(_Entity<num>(1)).isValid, isTrue);
    });

    test('fails for zero', () {
      expect(build().validate(_Entity<num>(0)).isValid, isFalse);
    });

    test('fails for a negative number', () {
      expect(build().validate(_Entity<num>(-1)).isValid, isFalse);
    });
  });

  group('isNegative', () {
    _Validator<num> build() => _Validator<num>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isNegative(),
        );

    test('passes for a negative number', () {
      expect(build().validate(_Entity<num>(-1)).isValid, isTrue);
    });

    test('fails for zero', () {
      expect(build().validate(_Entity<num>(0)).isValid, isFalse);
    });

    test('fails for a positive number', () {
      expect(build().validate(_Entity<num>(1)).isValid, isFalse);
    });
  });

  group('isNonNegative', () {
    _Validator<num> build() => _Validator<num>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isNonNegative(),
        );

    test('passes for zero', () {
      expect(build().validate(_Entity<num>(0)).isValid, isTrue);
    });

    test('passes for a positive number', () {
      expect(build().validate(_Entity<num>(5)).isValid, isTrue);
    });

    test('fails for a negative number', () {
      expect(build().validate(_Entity<num>(-1)).isValid, isFalse);
    });
  });

  group('isNonZero', () {
    _Validator<num> build() => _Validator<num>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isNonZero(),
        );

    test('passes for a positive number', () {
      expect(build().validate(_Entity<num>(1)).isValid, isTrue);
    });

    test('passes for a negative number', () {
      expect(build().validate(_Entity<num>(-1)).isValid, isTrue);
    });

    test('fails for zero', () {
      expect(build().validate(_Entity<num>(0)).isValid, isFalse);
    });
  });

  group('multipleOf', () {
    _Validator<num> build(num divisor) => _Validator<num>(
          (v) => v.ruleFor((e) => e.value, key: 'v').multipleOf(divisor),
        );

    test('passes when value is a multiple of the divisor', () {
      expect(build(5).validate(_Entity<num>(15)).isValid, isTrue);
    });

    test('fails when value is not a multiple of the divisor', () {
      expect(build(5).validate(_Entity<num>(13)).isValid, isFalse);
    });

    test('error message includes the divisor', () {
      final result = build(7).validate(_Entity<num>(10));
      expect(result.exceptions.single.message, contains('7'));
    });
  });

  group('isEven', () {
    _Validator<num> build() => _Validator<num>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isEven(),
        );

    test('passes for an even number', () {
      expect(build().validate(_Entity<num>(4)).isValid, isTrue);
    });

    test('fails for an odd number', () {
      expect(build().validate(_Entity<num>(3)).isValid, isFalse);
    });

    test('passes for zero', () {
      expect(build().validate(_Entity<num>(0)).isValid, isTrue);
    });
  });

  group('isOdd', () {
    _Validator<num> build() => _Validator<num>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isOdd(),
        );

    test('passes for an odd number', () {
      expect(build().validate(_Entity<num>(3)).isValid, isTrue);
    });

    test('fails for an even number', () {
      expect(build().validate(_Entity<num>(4)).isValid, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // bool validators
  // ---------------------------------------------------------------------------

  group('isTrue', () {
    _Validator<bool> build() => _Validator<bool>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isTrue(),
        );

    test('passes when value is true', () {
      expect(build().validate(_Entity(true)).isValid, isTrue);
    });

    test('fails when value is false', () {
      expect(build().validate(_Entity(false)).isValid, isFalse);
    });

    test('returns correct code on failure', () {
      expect(
        build().validate(_Entity(false)).exceptions.single.code,
        Language.code.isTrue,
      );
    });
  });

  group('isFalse', () {
    _Validator<bool> build() => _Validator<bool>(
          (v) => v.ruleFor((e) => e.value, key: 'v').isFalse(),
        );

    test('passes when value is false', () {
      expect(build().validate(_Entity(false)).isValid, isTrue);
    });

    test('fails when value is true', () {
      expect(build().validate(_Entity(true)).isValid, isFalse);
    });

    test('returns correct code on failure', () {
      expect(
        build().validate(_Entity(true)).exceptions.single.code,
        Language.code.isFalse,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // List validators
  // ---------------------------------------------------------------------------

  group('minItems', () {
    _Validator<List<String>> build(int min) => _Validator<List<String>>(
          (v) => v.ruleFor((e) => e.value, key: 'v').minItems(min),
        );

    test('passes when list has enough items', () {
      expect(build(2).validate(_Entity(['a', 'b', 'c'])).isValid, isTrue);
    });

    test('passes exactly at the minimum', () {
      expect(build(2).validate(_Entity(['a', 'b'])).isValid, isTrue);
    });

    test('fails when list has fewer items', () {
      expect(build(3).validate(_Entity(['a'])).isValid, isFalse);
    });

    test('error message includes MinItems and TotalItems', () {
      final result = build(3).validate(_Entity(['a']));
      expect(result.exceptions.single.message, contains('3'));
      expect(result.exceptions.single.message, contains('1'));
    });
  });

  group('maxItems', () {
    _Validator<List<String>> build(int max) => _Validator<List<String>>(
          (v) => v.ruleFor((e) => e.value, key: 'v').maxItems(max),
        );

    test('passes when list has fewer items than the max', () {
      expect(build(5).validate(_Entity(['a', 'b'])).isValid, isTrue);
    });

    test('passes exactly at the maximum', () {
      expect(build(2).validate(_Entity(['a', 'b'])).isValid, isTrue);
    });

    test('fails when list exceeds the maximum', () {
      expect(build(2).validate(_Entity(['a', 'b', 'c'])).isValid, isFalse);
    });
  });

  group('listContains', () {
    _Validator<List<String>> build() => _Validator<List<String>>(
          (v) => v.ruleFor((e) => e.value, key: 'v').listContains('admin'),
        );

    test('passes when list contains the required item', () {
      expect(build().validate(_Entity(['user', 'admin'])).isValid, isTrue);
    });

    test('fails when list does not contain the required item', () {
      expect(build().validate(_Entity(['user'])).isValid, isFalse);
    });

    test('error message includes the required item', () {
      final result = build().validate(_Entity(['user']));
      expect(result.exceptions.single.message, contains('admin'));
    });
  });

  // ---------------------------------------------------------------------------
  // DateTime validators
  // ---------------------------------------------------------------------------

  group('inPast', () {
    _Validator<DateTime> build() => _Validator<DateTime>(
          (v) => v.ruleFor((e) => e.value, key: 'v').inPast(),
        );

    test('passes for a date in the past', () {
      expect(
        build()
            .validate(_Entity(DateTime.now().subtract(const Duration(days: 1))))
            .isValid,
        isTrue,
      );
    });

    test('fails for a date in the future', () {
      expect(
        build()
            .validate(_Entity(DateTime.now().add(const Duration(days: 1))))
            .isValid,
        isFalse,
      );
    });
  });

  group('inFuture', () {
    _Validator<DateTime> build() => _Validator<DateTime>(
          (v) => v.ruleFor((e) => e.value, key: 'v').inFuture(),
        );

    test('passes for a date in the future', () {
      expect(
        build()
            .validate(_Entity(DateTime.now().add(const Duration(days: 1))))
            .isValid,
        isTrue,
      );
    });

    test('fails for a date in the past', () {
      expect(
        build()
            .validate(
                _Entity(DateTime.now().subtract(const Duration(days: 1))))
            .isValid,
        isFalse,
      );
    });
  });

  group('afterField', () {
    _EventValidator build() => _EventValidator(
          (v) => v
              .ruleFor((e) => e.end, key: 'end')
              .afterField((e) => e.start),
        );

    test('passes when end is after start', () {
      final event = _Event(
        start: DateTime(2025, 1, 1),
        end: DateTime(2025, 1, 2),
      );
      expect(build().validate(event).isValid, isTrue);
    });

    test('fails when end is before start', () {
      final event = _Event(
        start: DateTime(2025, 1, 2),
        end: DateTime(2025, 1, 1),
      );
      expect(build().validate(event).isValid, isFalse);
    });

    test('fails when end equals start', () {
      final date = DateTime(2025, 1, 1);
      expect(build().validate(_Event(start: date, end: date)).isValid, isFalse);
    });
  });

  group('beforeField', () {
    _EventValidator build() => _EventValidator(
          (v) => v
              .ruleFor((e) => e.start, key: 'start')
              .beforeField((e) => e.end),
        );

    test('passes when start is before end', () {
      final event = _Event(
        start: DateTime(2025, 1, 1),
        end: DateTime(2025, 1, 2),
      );
      expect(build().validate(event).isValid, isTrue);
    });

    test('fails when start is after end', () {
      final event = _Event(
        start: DateTime(2025, 1, 2),
        end: DateTime(2025, 1, 1),
      );
      expect(build().validate(event).isValid, isFalse);
    });
  });
}
