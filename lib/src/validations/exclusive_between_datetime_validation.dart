part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [DateTime] properties to add a exclusive between validation.
///
/// This extension adds an `inclusiveBetween` method that can be used to
/// ensure that a date is exclusive between two specified dates.
extension ExclusiveBetweenDatetimeValidation on SimpleValidationBuilder<DateTime> {
  /// Adds a validation rule that checks if the [DateTime] is greater than [comparison].
  ///
  /// [start] is the date and time value must be greater than.
  /// [end] is the date and time value must be less than.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// .ruleFor((event) => event.start, key: 'start') //
  ///   .exclusiveBetween(start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{StartValue}**: The value must be greater than or equal to.
  /// - **{EndValue}**: The value must be less than or equal to.
  ///
  SimpleValidationBuilder<DateTime> exclusiveBetween({
    required DateTime start,
    required DateTime end,
    String? message,
    String? code,
  }) {
    return use((value, entity) {
      if (value.isAfter(start) && value.isBefore(end)) return null;

      final currentCode = code ?? Language.code.exclusiveBetweenDatetime;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': key,
          'StartValue': start.toString(),
          'EndValue': end.toString(),
        },
        defaultMessage: message,
      );

      return ValidationException(message: currentMessage, code: currentCode);
    });
  }
}
