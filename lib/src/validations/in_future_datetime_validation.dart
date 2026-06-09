part of 'validations.dart';

extension InFutureDatetimeValidation on SimpleValidationBuilder<DateTime> {
  /// Adds a validation rule that checks if the [DateTime] value is in the future.
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
  /// ruleFor((event) => event.scheduledAt, key: 'scheduledAt')
  ///   .inFuture();
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  ///
  SimpleValidationBuilder<DateTime> inFuture({String? message, String? code}) {
    return useValidation(
      (value, entity) => value.isAfter(DateTime.now()),
      code: code ?? Language.code.inFuture,
      message: message,
    );
  }
}

extension InFutureNullableDatetimeValidation
    on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] value is in the future.
  ///
  /// Fails if the value is null or not in the future.
  SimpleValidationBuilder<DateTime?> inFuture({String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value.isAfter(DateTime.now()),
      code: code ?? Language.code.inFuture,
      message: message,
    );
  }
}

extension InFutureOrNullableDatetimeValidation
    on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] value is in the future or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and not in the future.
  SimpleValidationBuilder<DateTime?> inFutureOrNull(
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value.isAfter(DateTime.now()),
      code: code ?? Language.code.inFuture,
      message: message,
    );
  }
}
