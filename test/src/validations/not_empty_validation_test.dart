import 'package:lucid_validation/src/validations/validations.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('not empty validation...', () {
    final validator = TestLucidValidator<UserModel>();
    validator
        .ruleFor((user) => user.password, key: 'password') //
        .notEmpty();

    final user = UserModel()..password = '';

    final result = validator.validate(user);

    expect(result.isValid, false);
    expect(result.exceptions.length, 1);
    expect(result.exceptions.first.message, "'password' must not be empty.");
  });

  test('not empty validation or null...', () {
    final validator = TestLucidValidator<UserNullableModel>();
    validator
        .ruleFor((user) => user.password, key: 'password') //
        .notEmptyOrNull();

    final user = UserNullableModel()..password = null;

    final result = validator.validate(user);

    expect(result.isValid, false);
  });

  group('NotEmptyOrNullableValidation', () {
    late TestLucidValidator<UserNullableModel> validator;

    setUp(() {
      validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .notEmptyOrNull();
    });

    test('should fail when string is null', () {
      final entity = UserNullableModel()..password = null;
      final result = validator.validate(entity);

      expect(result.isValid, isFalse);
      expect(result.exceptions, hasLength(1));
      expect(result.exceptions.first.key, equals('password'));
    });

    test('should fail when string is empty', () {
      final entity = UserNullableModel()..password = '';
      final result = validator.validate(entity);

      expect(result.isValid, isFalse);
      expect(result.exceptions, hasLength(1));
      expect(result.exceptions.first.key, equals('password'));
    });

    test('should pass when string is not null and not empty', () {
      final entity = UserNullableModel()..password = 'ValidPassword123';
      final result = validator.validate(entity);

      expect(result.isValid, isTrue);
      expect(result.exceptions, isEmpty);
    });
  });
}
