import '../lucid_validation_builder/validator_builder.dart';

extension MaxLengthValidator on LucidValidationBuilder<String> {
  LucidValidationBuilder<String> maxLength(int num, {required String message}) {
    return registerRule((value) => value.length <= num, message);
  }
}
