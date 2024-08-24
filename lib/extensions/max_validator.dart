import '../lucid_validation_builder/validator_builder.dart';

extension MaxValidator on LucidValidationBuilder<num> {
  LucidValidationBuilder<num> max(num num, {required String message}) {
    return registerRule((value) => value >= num, message);
  }
}
