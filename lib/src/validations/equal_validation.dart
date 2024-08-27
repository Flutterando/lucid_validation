part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [T] properties to add an equality validation.
///
/// This extension adds an `equalTo` method that can be used to ensure that a value
/// is equal to a specific value.
extension EqualValidation<T, E> on LucidValidationBuilder<T, E> {
  /// Adds a validation rule that checks if the value is equal to [comparison].
  ///
  /// [predicate] is a function that returns the value to compare against.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.confirmPassword, key: 'confirmPassword')
  ///   .equalTo((user) => user.password);
  ///
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  LucidValidationBuilder<T, E> equalTo(
    T Function(E entity) predicate, {
    String? message,
    String? code,
  }) {
    return use(
      (value, entity) {
        final comparison = predicate(entity);
        if (value == comparison) return null;

        final currentCode = code ?? Language.code.equalTo;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': key,
            'ComparisonValue': '$comparison',
          },
          defaultMessage: message,
        );

        return ValidationException(message: currentMessage, code: currentCode);
      },
    );
  }
}
