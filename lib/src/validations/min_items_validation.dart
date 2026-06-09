part of 'validations.dart';

extension MinItemsValidation<T> on SimpleValidationBuilder<List<T>> {
  /// Adds a validation rule that checks if the [List] has at least [min] items.
  ///
  /// [min] is the minimum number of items required.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((order) => order.items, key: 'items')
  ///   .minItems(1);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{MinItems}**: The minimum number of items.
  /// - **{TotalItems}**: The actual number of items.
  ///
  SimpleValidationBuilder<List<T>> minItems(int min,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value.length >= min,
      code: code ?? Language.code.minItems,
      message: message,
      parameters: (value, entity) => {
        'MinItems': '$min',
        'TotalItems': '${value.length}',
      },
    );
  }
}

extension MinItemsNullableValidation<T> on SimpleValidationBuilder<List<T>?> {
  /// Adds a validation rule that checks if the [List?] has at least [min] items.
  ///
  /// Fails if the value is null or has fewer than [min] items.
  SimpleValidationBuilder<List<T>?> minItems(int min,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value.length >= min,
      code: code ?? Language.code.minItems,
      message: message,
      parameters: (value, entity) => {
        'MinItems': '$min',
        'TotalItems': '${value?.length ?? 0}',
      },
    );
  }
}

extension MinItemsOrNullableValidation<T> on SimpleValidationBuilder<List<T>?> {
  /// Adds a validation rule that checks if the [List?] has at least [min] items or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and has fewer than [min] items.
  SimpleValidationBuilder<List<T>?> minItemsOrNull(int min,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value.length >= min,
      code: code ?? Language.code.minItems,
      message: message,
      parameters: (value, entity) => {
        'MinItems': '$min',
        'TotalItems': '${value?.length ?? 0}',
      },
    );
  }
}
