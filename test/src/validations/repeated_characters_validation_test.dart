import 'package:lucid_validation/src/validations/validations.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  group('hasNoSequentialRepeatedCharacters', () {
    test('should fail when repeated characters sequence is present', () {
      final validator = TestLucidValidator<UserModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialRepeatedCharacters(sequenceLength: 3);

      final user = UserModel()..password = 'aaabbb';

      final result = validator.validate(user);

      expect(result.isValid, false);
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.code, 'sequentialRepeatedCharacters');
    });

    test('should pass when no repeated character sequence is present', () {
      final validator = TestLucidValidator<UserModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialRepeatedCharacters(sequenceLength: 3);

      final user = UserModel()..password = 'abcde';

      final result = validator.validate(user);

      expect(result.isValid, true);
    });
  });

  group('hasNoSequentialRepeatedCharacters (nullable)', () {
    test('should fail when repeated characters sequence is present', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialRepeatedCharacters(sequenceLength: 3);

      final user = UserNullableModel()..password = '1111';

      final result = validator.validate(user);

      expect(result.isValid, false);
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.code, 'sequentialRepeatedCharacters');
    });

    test('should pass when nullable string has no repeated character sequence',
        () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialRepeatedCharacters(sequenceLength: 3);

      final user = UserNullableModel()..password = 'abcd';

      final result = validator.validate(user);

      expect(result.isValid, true);
    });

    test('should pass when nullable string is null', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialRepeatedCharacters(sequenceLength: 3);

      final user = UserNullableModel()..password = null;

      final result = validator.validate(user);

      expect(result.isValid, true);
    });
  });

  group('hasNoSequentialRepeatedCharactersOrNull', () {
    test('should fail when repeated characters sequence is present', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialRepeatedCharactersOrNull(sequenceLength: 3);

      final user = UserNullableModel()..password = 'zzzzy';

      final result = validator.validate(user);

      expect(result.isValid, false);
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.code, 'sequentialRepeatedCharacters');
    });

    test('should pass when repeated characters sequence is not present', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialRepeatedCharactersOrNull(sequenceLength: 3);

      final user = UserNullableModel()..password = 'abcd123';

      final result = validator.validate(user);

      expect(result.isValid, true);
    });

    test('should pass when value is null', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialRepeatedCharactersOrNull(sequenceLength: 3);

      final user = UserNullableModel()..password = null;

      final result = validator.validate(user);

      expect(result.isValid, true);
    });
  });
}
