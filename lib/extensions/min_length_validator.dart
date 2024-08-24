import '../lucid_validation_builder/validator_builder.dart';

extension MinLengthValidator on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> minLength(int num, {required String message}) {
    return registerRule((value) => value.length >= num, message);
  }
}
