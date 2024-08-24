import './validator_error.dart';

class ValidatorResult {
  final bool isValid;
  final ValidatorError error;

  const ValidatorResult({
    required this.isValid,
    required this.error,
  });
}
