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
  /// final builder = LucidValidationBuilder<String>(key: 'newUsername');
  /// builder.notEqualTo('oldUsername');
  /// ```
  LucidValidationBuilder<T, dynamic> notEqualTo(T Function(E entity) predicate, {String message = r'Must not be equal', String code = 'not_equal_to_error'}) {
    return mustWith(
      (value, entity) {
        final comparison = predicate(entity);
        return value != comparison;
      },
      message,
      code,
    );
  }
}
