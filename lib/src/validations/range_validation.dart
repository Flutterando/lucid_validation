part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a range validation.
///
/// This extension adds a `range` method that can be used to ensure that a number
/// is within a specified range.
extension RangeValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] is within the range of [min] and [max].
  ///
  /// [min] and [max] define the acceptable range for the number.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be between $min and $max".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.age, key: 'age')
  ///   .range(18, 65);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{From}**: The minimum value of the range.
  /// - **{To}**: The maximum value of the range.
  /// - **{PropertyValue}**: The value of the property.
  ///
  SimpleValidationBuilder<num> range(num min, num max,
      {String? message, String? code}) {
    return use(
      (value, entity) {
        if (value >= min && value <= max) return null;

        final currentCode = code ?? Language.code.range;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': label.isNotEmpty ? label : key,
            'From': '$min',
            'To': '$max',
            'PropertyValue': '$value',
          },
          defaultMessage: message,
        );

        return ValidationException(message: currentMessage, code: currentCode);
      },
    );
  }
}
