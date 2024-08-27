part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a greater than validation.
///
/// This extension adds a `greaterThan` method that can be used to ensure that a number
/// is greater than a specified value.
extension GreaterThanValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] is greater than [minValue].
  ///
  /// [minValue] is the value that the number must be greater than.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.age, key: 'age')
  ///   .greaterThan(18);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  SimpleValidationBuilder<num> greaterThan(
    num minValue, {
    String? message,
    String? code,
  }) {
    return use((value, entity) {
      if (value > minValue) return null;

      final currentCode = code ?? Language.code.greaterThan;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': key,
          'ComparisonValue': '$minValue',
        },
        defaultMessage: message,
      );

      return ValidationError(message: currentMessage, code: currentCode);
    });
  }
}
