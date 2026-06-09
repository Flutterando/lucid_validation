import 'validation_exception.dart';
import 'validation_result.dart';

/// Aggregate exception thrown by `LucidValidator.validateAndThrow` /
/// `validateAndThrowAsync` when validation fails.
///
/// Unlike [ValidationException] (which represents a single rule failure), this
/// exception carries the whole [ValidationResult], exposing every failure.
class LucidValidationException implements Exception {
  /// The validation result that caused this exception.
  final ValidationResult result;

  LucidValidationException(this.result);

  /// All validation failures collected during validation.
  List<ValidationException> get errors => result.exceptions;

  @override
  String toString() {
    final messages = errors.map((e) => e.message).join(', ');
    return 'LucidValidationException: $messages';
  }
}
