import '../lucid_validation_builder/validator_builder.dart';

extension MustHaveNumbers on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> mustHaveNumbers(String message) {
    return registerRule((value) => RegExp(r'[0-9]').hasMatch(value), message);
  }
}
