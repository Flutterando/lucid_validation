/// Represents an error that occurs during validation.
///
/// [ValidationException] provides details about the validation error, including
/// an optional key that identifies which field or property the error is associated with.
class ValidationException implements Exception {
  /// The error message describing what went wrong during validation.
  final String message;

  /// An optional key that identifies the specific field or property related to the error.
  final String key;

  /// An optional code that identifies the specific validation error.
  final String code;

  final int? index;

  final String entity;

  /// Constructs a [ValidationException].
  ///
  /// [message] provides a description of the error.
  /// [key] optionally identifies the field or property related to the error.
  const ValidationException({
    required this.message,
    required this.code,
    required this.entity,
    this.key = '',
    this.index,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (key.isNotEmpty) 'key': key,
      if (entity.isNotEmpty) 'entity': entity,
      if (code.isNotEmpty) 'code': code,
      if (index != null) 'index': index,
    };
  }

  ValidationException copyWith({
    String? message,
    String? entity,
    String? key,
    String? code,
    int? index,
  }) {
    return ValidationException(
      message: message ?? this.message,
      entity: entity ?? this.entity,
      code: code ?? this.code,
      key: key ?? this.key,
      index: index ?? this.index,
    );
  }
}
