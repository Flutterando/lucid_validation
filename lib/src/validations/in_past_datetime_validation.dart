part of 'validations.dart';

extension InPastDatetimeValidation on SimpleValidationBuilder<DateTime> {
  /// Adds a validation rule that checks if the [DateTime] value is in the past.
  ///
  /// The comparison is made against [DateTime.now] at the time of validation.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((user) => user.birthDate, key: 'birthDate')
  ///   .inPast();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<DateTime> inPast({String? message, String? code}) {
    return useValidation(
      (value, entity) => value.isBefore(DateTime.now()),
      code: code ?? Language.code.inPast,
      message: message,
    );
  }
}

extension InPastNullableDatetimeValidation on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] value is in the past.
  ///
  /// Fails if the value is null or not in the past.
  SimpleValidationBuilder<DateTime?> inPast({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value.isBefore(DateTime.now()),
      code: code ?? Language.code.inPast,
      message: message,
    );
  }
}

extension InPastOrNullableDatetimeValidation
    on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] value is in the past or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and not in the past.
  SimpleValidationBuilder<DateTime?> inPastOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value.isBefore(DateTime.now()),
      code: code ?? Language.code.inPast,
      message: message,
    );
  }
}
