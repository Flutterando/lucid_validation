import '../lucid_validation_builder/validator_builder.dart';

extension ValidEmailValidator on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> validEmail(String message) {
    return registerRule((value) => RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$').hasMatch(value), message);
  }
}
