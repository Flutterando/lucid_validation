part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [DateTime] properties to add a inclusive between validation.
///
/// This extension adds an `inclusiveBetween` method that can be used to
/// ensure that a date is inclusive between two specified dates.
extension InclusiveBetweenDatetimeValidation
    on SimpleValidationBuilder<DateTime> {
  /// Adds a validation rule that checks if the [DateTime] is greater than [comparison].
  ///
  /// [start] is the date and time value must be greater than or equal to.
  /// [end] is the date and time value must be less than or equal to.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.start, key: 'start') //
  ///   .inclusiveBetween(start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{StartValue}**: The value must be greater than or equal to.
  /// - **{EndValue}**: The value must be less than or equal to.
  ///
  SimpleValidationBuilder<DateTime> inclusiveBetween({
    required DateTime start,
    required DateTime end,
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) =>
          value.isAfter(start) ||
          value.isAtSameMomentAs(start) && value.isBefore(end) ||
          value.isAtSameMomentAs(end),
      code: code ?? Language.code.inclusiveBetweenDatetime,
      message: message,
      parameters: (value, entity) => {
        'StartValue': start.toString(),
        'EndValue': end.toString(),
      },
    );
  }
}

extension InclusiveBetweenDatetimeNullableValidation
    on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] is greater than [comparison].
  ///
  /// [start] is the date and time value must be greater than or equal to.
  /// [end] is the date and time value must be less than or equal to.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.start, key: 'start') // event.start is nullable
  ///   .inclusiveBetween(start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{StartValue}**: The value must be greater than or equal to.
  /// - **{EndValue}**: The value must be less than or equal to.
  ///
  SimpleValidationBuilder<DateTime?> inclusiveBetween({
    required DateTime start,
    required DateTime end,
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) =>
          value != null &&
          (value.isAfter(start) ||
              value.isAtSameMomentAs(start) && value.isBefore(end) ||
              value.isAtSameMomentAs(end)),
      code: code ?? Language.code.inclusiveBetweenDatetime,
      message: message,
      parameters: (value, entity) => {
        'StartValue': start.toString(),
        'EndValue': end.toString(),
      },
    );
  }
}

extension InclusiveBetweenDatetimeOrNullableValidation
    on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] is greater than [comparison] or [null].
  ///
  /// [start] is the date and time value must be greater than or equal to.
  /// [end] is the date and time value must be less than or equal to.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.start, key: 'start') //
  ///   .inclusiveBetweenOrNull(start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{StartValue}**: The value must be greater than or equal to.
  /// - **{EndValue}**: The value must be less than or equal to.
  ///
  SimpleValidationBuilder<DateTime?> inclusiveBetweenOrNull({
    required DateTime start,
    required DateTime end,
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) =>
          value == null ||
          (value.isAfter(start) ||
              value.isAtSameMomentAs(start) && value.isBefore(end) ||
              value.isAtSameMomentAs(end)),
      code: code ?? Language.code.inclusiveBetweenDatetime,
      message: message,
      parameters: (value, entity) => {
        'StartValue': start.toString(),
        'EndValue': end.toString(),
      },
    );
  }
}
