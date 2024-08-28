part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [DateTime] properties to add a less than validation.
///
/// This extension adds a `lessThanOrEqualTo` method that can be used to ensure that
/// a date is less than or equal to a specified date.
extension LessThanOrEqualToDatetimeValidation on SimpleValidationBuilder<DateTime> {
  /// Adds a validation rule that checks if the [DateTime] is greater than [comparison].
  ///
  /// [comparison] is the date and time value must be less than or equal to.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.end, key: 'start') //
  ///   .lessThanOrEqualTo(DateTime.now());
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<DateTime> lessThanOrEqualTo(
    DateTime comparison, {
    String? message,
    String? code,
  }) {
    return use((value, entity) {
      if (value.isBefore(comparison) || value.isAtSameMomentAs(comparison)) return null;

      final currentCode = code ?? Language.code.lessThanOrEqualToDateTime;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': key,
          'ComparisonValue': comparison.toString(),
        },
        defaultMessage: message,
      );

      return ValidationException(message: currentMessage, code: currentCode);
    });
  }
}
