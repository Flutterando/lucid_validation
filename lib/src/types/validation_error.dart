/// Represents an error that occurs during validation.
///
/// [ValidationError] provides details about the validation error, including
/// an optional key that identifies which field or property the error is associated with.
class ValidationError {
  /// The error message describing what went wrong during validation.
  final String message;

  /// An optional key that identifies the specific field or property related to the error.
  final String key;

  /// An optional code that identifies the specific validation error.
  final String code;

  /// Constructs a [ValidationError].
  ///
  /// [message] provides a description of the error.
  /// [key] optionally identifies the field or property related to the error.
  const ValidationError({
    required this.message,
    required this.code,
    this.key = '',
  });
}
