part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [DateTime] properties to add a greater than validation.
///
/// This extension adds a `greaterThanOrEqualTo` method that can be used to ensure that
/// a date is greater than or equal to a specified date.
extension GreaterThanOrEqualToDateTimeValidation
    on SimpleValidationBuilder<DateTime> {
  /// Adds a validation rule that checks if the [DateTime] is greater than [comparison].
  ///
  /// [comparison] is the date and time value must be greater than or equal.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.start, key: 'start') //
  ///   .greaterThanOrEqualTo(DateTime.now());
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<DateTime> greaterThanOrEqualTo(
    DateTime comparison, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) =>
          value.isAfter(comparison) || value.isAtSameMomentAs(comparison),
      code: code ?? Language.code.greaterThanOrEqualToDateTime,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': comparison.toString()},
    );
  }
}

extension GreaterThanOrEqualToDateTimeNullableValidation
    on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] is greater than [comparison].
  ///
  /// [comparison] is the date and time value must be greater than or equal.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.start, key: 'start') // event.start is nullable
  ///   .greaterThanOrEqualTo(DateTime.now());
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<DateTime?> greaterThanOrEqualTo(
    DateTime comparison, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) =>
          value != null &&
          (value.isAfter(comparison) || value.isAtSameMomentAs(comparison)),
      code: code ?? Language.code.greaterThanOrEqualToDateTime,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': comparison.toString()},
    );
  }
}

extension GreaterThanOrEqualToDateTimeOrNullableValidation
    on SimpleValidationBuilder<DateTime?> {
  /// Adds a validation rule that checks if the [DateTime?] is greater than [comparison] or [null].
  ///
  /// [comparison] is the date and time value must be greater than or equal.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.start, key: 'start') //
  ///   .greaterThanOrEqualToOrNull(DateTime.now());
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<DateTime?> greaterThanOrEqualToOrNull(
    DateTime comparison, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) =>
          value == null ||
          (value.isAfter(comparison) || value.isAtSameMomentAs(comparison)),
      code: code ?? Language.code.greaterThanOrEqualToDateTime,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': comparison.toString()},
    );
  }
}
