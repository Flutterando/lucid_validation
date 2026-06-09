part of 'validations.dart';

extension AfterFieldDatetimeValidation<E>
    on LucidValidationBuilder<DateTime, E> {
  /// Adds a validation rule that checks if the [DateTime] value is after the date
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
  /// ruleFor((event) => event.endDate, key: 'endDate')
  ///   .afterField((event) => event.startDate);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ComparisonValue}**: The comparison date value.
  ///
  LucidValidationBuilder<DateTime, E> afterField(
    DateTime Function(E entity) other, {
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => value.isAfter(other(entity)),
      code: code ?? Language.code.afterField,
      message: message,
      parameters: (value, entity) => {'ComparisonValue': '${other(entity)}'},
    );
  }
}
