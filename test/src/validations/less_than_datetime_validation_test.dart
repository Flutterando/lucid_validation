import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('less than validation ...', () {
    final validator = TestLucidValidator<EventModel>();
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));

    validator
        .ruleFor((event) => event.end, key: 'end') //
        .lessThan(now);

    final event = EventModel()..end = tomorrow;

    final result = validator.validate(event);

    expect(result.isValid, false);
    expect(result.exceptions.length, 1);
    expect(result.exceptions.first.message,
        "'end' must be less than date '${now.toString()}'.");
  });
}
