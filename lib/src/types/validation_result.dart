import 'validation_exception.dart';

/// Represents the result of a validation rule.
///
/// [ValidationResult] encapsulates whether the validation was successful
/// and, if not, provides the associated [ValidationException].
class ValidationResult {
  /// Indicates whether the validation was successful.
  final bool isValid;

  /// Provides details about the validation error if the validation failed.
  final List<ValidationException> exceptions;

  /// Constructs a [ValidationResult].
  ///
  /// [isValid] specifies whether the validation passed or failed.
  /// [exceptions] provides the exceptions details in case of a validation failure.
  const ValidationResult({
    required this.isValid,
    required this.exceptions,
  });
}
