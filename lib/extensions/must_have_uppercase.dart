import '../lucid_validation_builder/validator_builder.dart';

extension MustHaveUppercase on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> mustHaveUppercase(String message) {
    return registerRule((String value) => RegExp(r'[A-Z]').hasMatch(value), message);
  }
}
