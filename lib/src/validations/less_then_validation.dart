part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a less than validation.
///
/// This extension adds a `lessThan` method that can be used to ensure that a number
/// is less than a specified value.
extension LessThanValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] is less than [maxValue].
  ///
  /// [maxValue] is the value that the number must be less than.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be less than $maxValue".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.discount, key: 'discount')
  ///   .lessThan(100);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<num> lessThan(num maxValue,
      {String? message, String? code}) {
    return use(
      (value, entity) {
        if (value < maxValue) return null;

        final currentCode = code ?? Language.code.lessThan;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': label.isNotEmpty ? label : key,
            'ComparisonValue': '$maxValue',
          },
          defaultMessage: message,
        );

        return ValidationException(message: currentMessage, code: currentCode);
      },
    );
  }
}
