/// Represents an error that occurs during validation.
///
/// [ValidatorError] provides details about the validation error, including
/// an optional key that identifies which field or property the error is associated with.
class ValidatorError {
  /// The error message describing what went wrong during validation.
  final String message;

  /// An optional key that identifies the specific field or property related to the error.
  final String key;

  /// An optional code that identifies the specific validation error.
  final String code;

  /// Constructs a [ValidatorError].
  ///
  /// [message] provides a description of the error.
  /// [key] optionally identifies the field or property related to the error.
  const ValidatorError({
    required this.message,
    required this.code,
    this.key = '',
  });
}
