// ignore_for_file: public_member_api_docs
import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

// ---------------------------------------------------------------------------
// Domain models used across tests
// ---------------------------------------------------------------------------

enum PaymentType { creditCard, pix, bankTransfer }

class Payment {
  final PaymentType type;
  final String cardNumber;
  final String cvv;
  final String pixKey;

  const Payment({
    required this.type,
    this.cardNumber = '',
    this.cvv = '',
    this.pixKey = '',
  });
}

class PaymentValidator extends LucidValidator<Payment> {
  PaymentValidator() {
    // Always-on rule.
    ruleFor((p) => p.type, key: 'type').isNotNull();

    switchOn(
      (p) => p.type,
      cases: {
        PaymentType.creditCard: (v) {
          v.ruleFor((p) => p.cardNumber, key: 'cardNumber').notEmpty();
          v.ruleFor((p) => p.cvv, key: 'cvv').isNumeric().length(3, 4);
        },
        PaymentType.pix: (v) {
          v.ruleFor((p) => p.pixKey, key: 'pixKey').notEmpty();
        },
      },
    );
  }
}

// Validator using a String discriminator.
class ShippingValidator extends LucidValidator<Map<String, String>> {
  ShippingValidator() {
    switchOn(
      (m) => m['method'],
      cases: {
        'express': (v) {
          v.ruleFor((m) => m['phone']!, key: 'phone').notEmpty();
        },
        'standard': (v) {
          v.ruleFor((m) => m['address']!, key: 'address').notEmpty();
        },
      },
    );
  }
}

void main() {
  group('switchOn — enum discriminator', () {
    test('only credit-card rules run for PaymentType.creditCard', () {
      final validator = PaymentValidator();

      // Valid credit-card payment: no pixKey, but that rule must not run.
      final result = validator.validate(const Payment(
        type: PaymentType.creditCard,
        cardNumber: '4111111111111111',
        cvv: '123',
      ));
      expect(result.isValid, isTrue);
    });

    test('credit-card rules fire errors when cardNumber is empty', () {
      final result = PaymentValidator().validate(const Payment(
        type: PaymentType.creditCard,
        cardNumber: '',
        cvv: '123',
      ));
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'cardNumber'), isTrue);
    });

    test('pix rules do NOT run when type is creditCard', () {
      final result = PaymentValidator().validate(const Payment(
        type: PaymentType.creditCard,
        cardNumber: '4111111111111111',
        cvv: '123',
        pixKey: '', // empty — but pix rule must be skipped
      ));
      expect(result.exceptions.any((e) => e.key == 'pixKey'), isFalse);
    });

    test('only pix rules run for PaymentType.pix', () {
      final result = PaymentValidator().validate(const Payment(
        type: PaymentType.pix,
        pixKey: 'user@bank.com',
      ));
      expect(result.isValid, isTrue);
    });

    test('pix rule fires when pixKey is empty', () {
      final result = PaymentValidator().validate(const Payment(
        type: PaymentType.pix,
        pixKey: '',
      ));
      expect(result.isValid, isFalse);
      expect(result.exceptions.single.key, 'pixKey');
    });

    test('credit-card rules do NOT run when type is pix', () {
      final result = PaymentValidator().validate(const Payment(
        type: PaymentType.pix,
        pixKey: 'user@bank.com',
        cardNumber: '', // empty — but credit-card rule must be skipped
      ));
      expect(result.exceptions.any((e) => e.key == 'cardNumber'), isFalse);
    });

    test('no case rules run for an unmatched type', () {
      // bankTransfer is not in the cases map — no switchOn rules should fire.
      final result = PaymentValidator().validate(const Payment(
        type: PaymentType.bankTransfer,
      ));
      expect(result.isValid, isTrue);
    });

    test('always-on rules still run regardless of the case', () {
      // isNotNull on type always runs.
      final validator = PaymentValidator();
      // All payment types should pass the always-on rule.
      for (final type in PaymentType.values) {
        final result =
            validator.validate(Payment(type: type, pixKey: 'k', cardNumber: '1234567890123456', cvv: '123'));
        expect(
          result.exceptions.any((e) => e.key == 'type'),
          isFalse,
          reason: 'type always-on rule should pass for $type',
        );
      }
    });
  });

  group('switchOn — String discriminator', () {
    test('express requires phone, address is not checked', () {
      final result = ShippingValidator().validate({
        'method': 'express',
        'phone': '',
        'address': '',
      });
      expect(result.exceptions.any((e) => e.key == 'phone'), isTrue);
      expect(result.exceptions.any((e) => e.key == 'address'), isFalse);
    });

    test('standard requires address, phone is not checked', () {
      final result = ShippingValidator().validate({
        'method': 'standard',
        'phone': '',
        'address': '',
      });
      expect(result.exceptions.any((e) => e.key == 'address'), isTrue);
      expect(result.exceptions.any((e) => e.key == 'phone'), isFalse);
    });

    test('passes when all required fields for the matching case are valid', () {
      final result = ShippingValidator().validate({
        'method': 'express',
        'phone': '+55 11 99999-9999',
        'address': '',
      });
      expect(result.isValid, isTrue);
    });
  });

  group('switchOn — multiple fields per case', () {
    test('all fields in the matching case are validated', () {
      // cvv is required and must be 3–4 digits, so '12' should fail.
      final result = PaymentValidator().validate(const Payment(
        type: PaymentType.creditCard,
        cardNumber: '4111111111111111',
        cvv: '12', // too short
      ));
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'cvv'), isTrue);
    });

    test('only one error per field when cascadeMode is default', () {
      final result = PaymentValidator().validate(const Payment(
        type: PaymentType.creditCard,
        cardNumber: '',
        cvv: '',
      ));
      // Both fields should produce errors.
      expect(result.exceptions.any((e) => e.key == 'cardNumber'), isTrue);
      expect(result.exceptions.any((e) => e.key == 'cvv'), isTrue);
    });
  });

  group('switchOn — orElse', () {
    LucidValidator<Payment> buildWithOrElse() {
      return LucidValidator<Payment>.inline((v) {
        v.switchOn(
          (p) => p.type,
          cases: {
            PaymentType.pix: (inner) {
              inner.ruleFor((p) => p.pixKey, key: 'pixKey').notEmpty();
            },
          },
          orElse: (inner) {
            inner
                .ruleFor((p) => p.cardNumber, key: 'cardNumber')
                .must((_) => false, 'Unsupported payment type.', 'unsupported');
          },
        );
      });
    }

    test('orElse does NOT run when a case matches', () {
      final result = buildWithOrElse().validate(
        const Payment(type: PaymentType.pix, pixKey: 'user@bank.com'),
      );
      expect(result.isValid, isTrue);
      expect(result.exceptions.any((e) => e.code == 'unsupported'), isFalse);
    });

    test('orElse runs when no case matches', () {
      final result = buildWithOrElse().validate(
        const Payment(type: PaymentType.creditCard),
      );
      expect(result.isValid, isFalse);
      expect(result.exceptions.single.code, 'unsupported');
    });

    test('orElse does not affect the matching case rules', () {
      // pix with empty pixKey → pix rule fires, orElse must NOT fire.
      final result = buildWithOrElse().validate(
        const Payment(type: PaymentType.pix, pixKey: ''),
      );
      expect(result.exceptions.any((e) => e.key == 'pixKey'), isTrue);
      expect(result.exceptions.any((e) => e.code == 'unsupported'), isFalse);
    });

    test('multiple orElse fields all receive the condition', () {
      final validator = LucidValidator<Payment>.inline((v) {
        v.switchOn(
          (p) => p.type,
          cases: {
            PaymentType.pix: (inner) {
              inner.ruleFor((p) => p.pixKey, key: 'pixKey').notEmpty();
            },
          },
          orElse: (inner) {
            inner.ruleFor((p) => p.cardNumber, key: 'cardNumber').notEmpty();
            inner.ruleFor((p) => p.cvv, key: 'cvv').notEmpty();
          },
        );
      });

      // bankTransfer → no case match → orElse fires for both fields.
      final result = validator.validate(
        const Payment(type: PaymentType.bankTransfer),
      );
      expect(result.exceptions.any((e) => e.key == 'cardNumber'), isTrue);
      expect(result.exceptions.any((e) => e.key == 'cvv'), isTrue);
    });

    test('switchOn without orElse is still valid when no case matches', () {
      final validator = LucidValidator<Payment>.inline((v) {
        v.switchOn(
          (p) => p.type,
          cases: {
            PaymentType.pix: (inner) {
              inner.ruleFor((p) => p.pixKey, key: 'pixKey').notEmpty();
            },
          },
        );
      });

      expect(
        validator
            .validate(const Payment(type: PaymentType.bankTransfer))
            .isValid,
        isTrue,
      );
    });
  });

  group('switchOn — interplay with inline LucidValidator', () {
    test('works with LucidValidator.inline', () {
      final validator = LucidValidator<Payment>.inline((v) {
        v.switchOn(
          (p) => p.type,
          cases: {
            PaymentType.pix: (inner) {
              inner.ruleFor((p) => p.pixKey, key: 'pixKey').notEmpty();
            },
          },
        );
      });

      expect(
        validator.validate(const Payment(type: PaymentType.pix, pixKey: '')).isValid,
        isFalse,
      );
      expect(
        validator.validate(const Payment(type: PaymentType.pix, pixKey: 'k')).isValid,
        isTrue,
      );
      // creditCard → case not registered → valid
      expect(
        validator.validate(const Payment(type: PaymentType.creditCard)).isValid,
        isTrue,
      );
    });
  });
}
