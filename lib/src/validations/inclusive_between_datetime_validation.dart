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
    return use((value, entity) {
      if (value.isAfter(start) ||
          value.isAtSameMomentAs(start) && value.isBefore(end) ||
          value.isAtSameMomentAs(end)) return null;

      final currentCode = code ?? Language.code.inclusiveBetweenDatetime;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
          'StartValue': start.toString(),
          'EndValue': end.toString(),
        },
        defaultMessage: message,
      );

      return ValidationException(message: currentMessage, code: currentCode);
    });
  }
}
