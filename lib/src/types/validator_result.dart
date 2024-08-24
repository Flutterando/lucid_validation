import 'validator_error.dart';

/// Represents the result of a validation rule.
///
/// [ValidatorResult] encapsulates whether the validation was successful
/// and, if not, provides the associated [ValidatorError].
class ValidatorResult {
  /// Indicates whether the validation was successful.
  final bool isValid;

  /// Provides details about the validation error if the validation failed.
  final ValidatorError error;

  /// Constructs a [ValidatorResult].
  ///
  /// [isValid] specifies whether the validation passed or failed.
  /// [error] provides the error details in case of a validation failure.
  const ValidatorResult({
    required this.isValid,
    required this.error,
  });
}
