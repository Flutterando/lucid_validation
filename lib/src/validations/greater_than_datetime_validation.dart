part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [DateTime] properties to add a greater than validation.
///
/// This extension adds a `greaterThan` method that can be used to ensure that
/// a date is greater than a specified date.
extension GreaterThanDateTimeValidation on SimpleValidationBuilder<DateTime> {
  /// Adds a validation rule that checks if the [DateTime] is greater than [comparison].
  ///
  /// [comparison] is the date and time value must be greater than.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.start, key: 'start') //
  ///   .greaterThan(DateTime.now());
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<DateTime> greaterThan(
    DateTime comparison, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value.isAfter(comparison),
      code: code ?? Language.code.greaterThanDatetime,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': comparison.toString()},
    );
  }
}

extension GreaterThanDateTimeNullableValidation
    on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] is greater than [comparison].
  ///
  /// [comparison] is the date and time value must be greater than.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.start, key: 'start') //  event.start is nullable
  ///   .greaterThan(DateTime.now());
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<DateTime?> greaterThan(
    DateTime comparison, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value != null && value.isAfter(comparison),
      code: code ?? Language.code.greaterThanDatetime,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': comparison.toString()},
    );
  }
}

extension GreaterThanDateTimeOrNullableValidation
    on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] is greater than [comparison] or [null].
  ///
  /// [comparison] is the date and time value must be greater than.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.start, key: 'start') //
  ///   .greaterThanOrNull(DateTime.now());
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<DateTime?> greaterThanOrNull(
    DateTime comparison, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value == null || value.isAfter(comparison),
      code: code ?? Language.code.greaterThanDatetime,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': comparison.toString()},
    );
  }
}
