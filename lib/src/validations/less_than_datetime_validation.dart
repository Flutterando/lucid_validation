part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [DateTime] properties to add a less than validation.
///
/// This extension adds a `lessThan` method that can be used to ensure that
/// a date is less than a specified date.
extension LessThanDatetimeValidation on SimpleValidationBuilder<DateTime> {
  /// Adds a validation rule that checks if the [DateTime] is greater than [comparison].
  ///
  /// [comparison] is the date and time value must be less than.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.end, key: 'start') //
  ///   .lessThan(DateTime.now());
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<DateTime> lessThan(
    DateTime comparison, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value.isBefore(comparison),
      code: code ?? Language.code.lessThanDateTime,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': comparison.toString()},
    );
  }
}

extension LessThanDatetimeNullableValidation
    on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] is greater than [comparison].
  ///
  /// [comparison] is the date and time value must be less than.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.end, key: 'start') //  event.end is nullable
  ///   .lessThan(DateTime.now());
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<DateTime?> lessThan(
    DateTime comparison, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value != null && value.isBefore(comparison),
      code: code ?? Language.code.lessThanDateTime,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': comparison.toString()},
    );
  }
}

extension LessThanDatetimeOrNullableValidation
    on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] is greater than [comparison] or [null].
  ///
  /// [comparison] is the date and time value must be less than.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.end, key: 'start') //
  ///   .lessThanOrNull(DateTime.now());
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<DateTime?> lessThanOrNull(
    DateTime comparison, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value == null || value.isBefore(comparison),
      code: code ?? Language.code.lessThanDateTime,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': comparison.toString()},
    );
  }
}
