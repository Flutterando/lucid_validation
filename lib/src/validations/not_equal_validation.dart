part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [T] properties to add a non-equality validation.
///
/// This extension adds a `notEqualTo` method that can be used to ensure that a value
/// is not equal to a specific value.
extension NotEqualValidation<T, E> on LucidValidationBuilder<T, E> {
  /// Adds a validation rule that checks if the value is not equal to [comparison].
  ///
  /// [predicate] is the value that the field must not match.
  /// [message] is the error message returned if the validation fails. Defaults to "Must not be equal to $comparison".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.newUsername, key: 'newUsername')
  ///   .notEqualTo((user) => user.oldUsername);
  /// ```
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The value to compare against.
  ///
  LucidValidationBuilder<T, dynamic> notEqualTo(T Function(E entity) predicate, {String? message, String? code}) {
    return use(
      (value, entity) {
        final comparison = predicate(entity);
        if (value != comparison) return null;

        final currentCode = code ?? Language.code.notEqualTo;
        final currentMessage = LucidValidation.global.languageManager.translate(
          currentCode,
          parameters: {
            'PropertyName': key,
            'ComparisonValue': '$comparison',
          },
          defaultMessage: message,
        );

        return ValidationError(message: currentMessage, code: currentCode);
      },
    );
  }
}
