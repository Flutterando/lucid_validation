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

  List<Map<String, dynamic>> exceptionToJson() {
    return exceptions.map((e) => e.toJson()).toList();
  }

  /// Groups the error messages by their property [key].
  ///
  /// This is ideal for building API/form responses, e.g.:
  /// ```json
  /// {
  ///   "email": ["'email' is not a valid email address."],
  ///   "password": ["'password' must not be empty."]
  /// }
  /// ```
  Map<String, List<String>> get errorsByKey {
    final map = <String, List<String>>{};
    for (final exception in exceptions) {
      map.putIfAbsent(exception.key, () => []).add(exception.message);
    }
    return map;
  }

  /// Returns the first error message associated with the given [key], or `null`
  /// if there is no error for that property.
  String? firstErrorFor(String key) {
    for (final exception in exceptions) {
      if (exception.key == key) return exception.message;
    }
    return null;
  }
}
