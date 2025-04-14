import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('valid phone validation failed...', () {
    final validator = TestLucidValidator<UserModel>();

    validator
        .ruleFor((e) => e.phone, key: 'phone', label: 'Phone') //
        .validPhoneBR();

    final user = UserModel()..phone = '751234567';

    final result = validator.validate(user);

    expect(result.isValid, false);

    expect(result.exceptions.length, 1);

    final error = result.exceptions.first;

    expect(error.message, "'Phone' is not a valid phone number.");
  });

  test('valid phone validation ...', () {
    final validator = TestLucidValidator<UserModel>();

    validator
        .ruleFor((e) => e.phone, key: 'phone', label: 'Phone') //
        .validPhoneBR();

    final user = UserModel()..phone = '75912345678';

    final result = validator.validate(user);

    expect(result.isValid, true);
  });

  test('valid phone ddi validation failed...', () {
    final validator = TestLucidValidator<UserModel>();

    validator
        .ruleFor((e) => e.phone, key: 'phone', label: 'Phone') //
        .validPhoneWithCountryCodeBR();

    final user = UserModel()..phone = '751234567';

    final result = validator.validate(user);

    expect(result.isValid, false);

    expect(result.exceptions.length, 1);

    final error = result.exceptions.first;

    expect(error.message, '\'Phone\' is not a valid phone number with DDI.');
  });

  test('valid phone ddi validation ...', () {
    final validator = TestLucidValidator<UserModel>();

    validator
        .ruleFor((e) => e.phone, key: 'phone', label: 'Phone') //
        .validPhoneWithCountryCodeBR();

    final user = UserModel()..phone = '+5575912345678';

    final result = validator.validate(user);

    expect(result.isValid, true);
  });
}
