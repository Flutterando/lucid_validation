import '../lucid_validation_builder/validator_builder.dart';

extension MustHaveLowercase on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> mustHaveLowercase(String message) {
    return registerRule((value) => RegExp(r'[a-z]').hasMatch(value), message);
  }
}
