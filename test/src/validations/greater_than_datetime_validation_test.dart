import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('greater than validation ...', () {
    final validator = TestLucidValidator<EventModel>();
    final now = DateTime.now();

    validator
        .ruleFor((event) => event.start, key: 'start') //
        .greaterThan(now);

    final event = EventModel()..start = DateTime(2024, 8, 26);

    final result = validator.validate(event);

    expect(result.isValid, false);
    expect(result.exceptions.length, 1);
    expect(result.exceptions.first.message,
        "'start' must be greater than date '${now.toString()}'.");
  });
}
