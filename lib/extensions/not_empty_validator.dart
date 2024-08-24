import '../lucid_validation_builder/validator_builder.dart';

extension NotEmptyValidator on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> notEmpty(String message) {
    return registerRule((value) => value.isNotEmpty, message);
  }
}
