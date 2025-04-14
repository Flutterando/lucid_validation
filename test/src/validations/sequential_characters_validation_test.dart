import 'package:lucid_validation/src/validations/validations.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  group('hasNoSequentialCharacters', () {
    test('should fail when sequential characters are present (ascending)', () {
      final validator = TestLucidValidator<UserModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharacters(sequenceLength: 3);

      final user = UserModel()..password = 'abc';

      final result = validator.validate(user);

      expect(result.isValid, false);
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.code, 'sequentialCharactersNotAllowed');
    });

    test('should fail when sequential characters are present (descending)', () {
      final validator = TestLucidValidator<UserModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharacters(sequenceLength: 3);

      final user = UserModel()..password = 'cba';

      final result = validator.validate(user);

      expect(result.isValid, false);
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.code, 'sequentialCharactersNotAllowed');
    });

    test('should pass when no sequential characters are present', () {
      final validator = TestLucidValidator<UserModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharacters(sequenceLength: 3);

      final user = UserModel()..password = 'password123';

      final result = validator.validate(user);

      expect(result.isValid, false);
    });

    test('should respect the sequenceLength', () {
      final validator = TestLucidValidator<UserModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharacters(sequenceLength: 4);

      final user = UserModel()..password = 'abc'; // only 3 sequential

      final result = validator.validate(user);

      expect(result.isValid, true); // No error because sequence length is 4
    });
  });

  group('hasNoSequentialCharacters (nullable)', () {
    test('should fail when sequential characters are present (ascending)', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharacters(sequenceLength: 3);

      final user = UserNullableModel()..password = 'abc';

      final result = validator.validate(user);

      expect(result.isValid, false);
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.code, 'sequentialCharactersNotAllowed');
    });

    test('should fail when sequential characters are present (descending)', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharacters(sequenceLength: 3);

      final user = UserNullableModel()..password = 'cba';

      final result = validator.validate(user);

      expect(result.isValid, false);
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.code, 'sequentialCharactersNotAllowed');
    });

    test('should pass when nullable string has no sequential characters', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharacters(sequenceLength: 3);

      final user = UserNullableModel()..password = 'randompassword';

      final result = validator.validate(user);

      expect(result.isValid, true);
    });

    test('should pass when nullable string is null', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharacters(sequenceLength: 3);

      final user = UserNullableModel()..password = null;

      final result = validator.validate(user);

      expect(result.isValid, true);
    });
  });

  group('hasNoSequentialCharactersOrNull', () {
    test('should fail when sequential characters are present (ascending)', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharactersOrNull(sequenceLength: 3);

      final user = UserNullableModel()..password = 'abc';

      final result = validator.validate(user);

      expect(result.isValid, false);
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.code, 'sequentialCharactersNotAllowed');
    });

    test('should fail when sequential characters are present (descending)', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharactersOrNull(sequenceLength: 3);

      final user = UserNullableModel()..password = 'cba';

      final result = validator.validate(user);

      expect(result.isValid, false);
      expect(result.exceptions.length, 1);
      expect(result.exceptions.first.code, 'sequentialCharactersNotAllowed');
    });

    test('should pass when no sequential characters are present', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharactersOrNull(sequenceLength: 3);

      final user = UserNullableModel()..password = 'somevalue';

      final result = validator.validate(user);

      expect(result.isValid, true);
    });

    test('should pass when value is null', () {
      final validator = TestLucidValidator<UserNullableModel>();
      validator
          .ruleFor((user) => user.password, key: 'password')
          .hasNoSequentialCharactersOrNull(sequenceLength: 3);

      final user = UserNullableModel()..password = null;

      final result = validator.validate(user);

      expect(result.isValid, true);
    });
  });
}
