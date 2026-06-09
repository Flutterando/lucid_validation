/// Represents the evaluation status of a single validation rule for a property.
///
/// Returned by [LucidValidator.rulesForField] / [LucidValidator.rulesForFieldAsync]
/// to allow building real-time checklists (for example, password strength
/// requirements) driven directly by the validator configuration.
class ExposedRuleResult {
  /// The validation code representing the rule (e.g. `'minLength'`, `'mustHaveNumber'`).
  final String code;

  /// The translated descriptive message of the rule.
  final String message;

  /// Indicates whether the rule is currently satisfied for the given entity state.
  final bool isValid;

  const ExposedRuleResult({
    required this.code,
    required this.message,
    required this.isValid,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExposedRuleResult &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          message == other.message &&
          isValid == other.isValid;

  @override
  int get hashCode => Object.hash(code, message, isValid);

  @override
  String toString() =>
      'ExposedRuleResult(code: $code, isValid: $isValid, message: $message)';
}
