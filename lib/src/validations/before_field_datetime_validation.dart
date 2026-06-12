part of 'validations.dart';

extension BeforeFieldDatetimeValidation<E>
    on LucidValidationBuilder<DateTime, E> {
  /// Adds a validation rule that checks if the [DateTime] value is before the date
  /// returned by [other].
  ///
  /// [other] is a function that extracts the comparison [DateTime] from the entity.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((event) => event.startDate, key: 'startDate')
  ///   .beforeField((event) => event.endDate);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The comparison date value.
  ///
  LucidValidationBuilder<DateTime, E> beforeField(
    DateTime Function(E entity) other, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value.isBefore(other(entity)),
      code: code ?? Language.code.beforeField,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': '${other(entity)}'},
    );
  }
}
