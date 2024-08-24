import '../dtos/dtos.dart';

typedef RuleFunc = List<ValidatorResult Function(dynamic value)>;

class LucidValidationBuilder<TProp> {
  final String key;
  final RuleFunc rules = [];

  LucidValidationBuilder({this.key = ''});
  LucidValidationBuilder<TProp> registerRule(bool Function(TProp dync) validator, message) {
    rules.add(
      (dynamic param) => ValidatorResult(
        isValid: validator(param),
        error: ValidatorError(message: message, key: key),
      ),
    );

    return this;
  }
}
