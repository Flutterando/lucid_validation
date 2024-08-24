part of 'validators.dart';

/// Extension on [LucidValidationBuilder] for [T] properties to add an equality validation.
///
/// This extension adds an `equalTo` method that can be used to ensure that a value
/// is equal to a specific value.
extension EqualValidator<T, E> on LucidValidationBuilder<T, E> {
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
  /// final builder = LucidValidationBuilder<String>(key: 'confirmPassword');
  /// builder.equalTo('password123');
  /// ```
  LucidValidationBuilder<T, E> equalTo(T Function(E entity) predicate, {String message = r'Must be equal', String code = 'equal_error'}) {
    return mustWith(
      (value, entity) {
        final comparison = predicate(entity);
        return value == comparison;
      },
      message,
      code,
    );
  }
}
