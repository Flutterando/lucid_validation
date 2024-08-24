import '../lucid_validation_builder/validator_builder.dart';

extension MustHaveSpecialCharacter on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> mustHaveSpecialCharacter(String message) {
    return registerRule((value) => RegExp(r'[!@#\$%\^&\*(),.?":{}|<>]').hasMatch(value), message);
  }
}
