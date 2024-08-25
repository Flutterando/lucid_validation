import 'validation_error.dart';

/// Represents the result of a validation rule.
///
/// [ValidationResult] encapsulates whether the validation was successful
/// and, if not, provides the associated [ValidationError].
class ValidationResult {
  /// Indicates whether the validation was successful.
  final bool isValid;

  /// Provides details about the validation error if the validation failed.
  final List<ValidationError> errors;

  /// Constructs a [ValidationResult].
  ///
  /// [isValid] specifies whether the validation passed or failed.
  /// [errors] provides the errors details in case of a validation failure.
  const ValidationResult({
    required this.isValid,
    required this.errors,
  });
}
