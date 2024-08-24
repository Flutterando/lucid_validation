import '../lucid_validation_builder/validator_builder.dart';

extension MinValidator on LucidValidationBuilder<num> {
  LucidValidationBuilder<num> min(num num, {required String message}) {
    return registerRule((value) => value >= num, message);
  }
}
