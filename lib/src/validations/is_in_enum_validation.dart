part of 'validations.dart';

/// Extension to validate that a value is one of a set of allowed values,
/// typically the values of an `enum`.
extension IsInEnumValidation<T extends Object> on SimpleValidationBuilder<T> {
  /// Adds a validation rule that checks if the value is contained in [values].
  ///
  /// Pass the enum's `values` (e.g. `Status.values`) or any allowed set.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((order) => order.status, key: 'status')
  ///   .isInEnum(Status.values);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{PropertyValue}**: The value of the property.
  SimpleValidationBuilder<T> isInEnum(List<T> values,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => values.contains(value),
      code: code ?? Language.code.isInEnum,
      message: message,
      parameters: (value, entity) => {'PropertyValue': '$value'},
    );
  }
}

extension IsInEnumOrNullableValidation<T extends Object>
    on SimpleValidationBuilder<T?> {
  /// Adds a validation rule that checks if the value is contained in [values] or is `null`.
  ///
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{PropertyValue}**: The value of the property.
  SimpleValidationBuilder<T?> isInEnumOrNull(List<T> values,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || values.contains(value),
      code: code ?? Language.code.isInEnum,
      message: message,
      parameters: (value, entity) => {'PropertyValue': '$value'},
    );
  }
}
