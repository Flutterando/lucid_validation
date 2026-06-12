part of 'validations.dart';

extension MaxItemsValidation<T> on SimpleValidationBuilder<List<T>> {
  /// Adds a validation rule that checks if the [List] has at most [max] items.
  ///
  /// [max] is the maximum number of items allowed.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((cart) => cart.products, key: 'products')
  ///   .maxItems(10);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{MaxItems}**: The maximum number of items.
  /// - **{TotalItems}**: The actual number of items.
  ///
  SimpleValidationBuilder<List<T>> maxItems(int max,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value.length <= max,
      code: code ?? Language.code.maxItems,
      message: message,
      parameters: (value, entity) => {
        'MaxItems': '$max',
        'TotalItems': '${value.length}',
      },
    );
  }
}

extension MaxItemsNullableValidation<T> on SimpleValidationBuilder<List<T>?> {
  /// Adds a validation rule that checks if the [List?] has at most [max] items.
  ///
  /// Fails if the value is null or has more than [max] items.
  SimpleValidationBuilder<List<T>?> maxItems(int max,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value.length <= max,
      code: code ?? Language.code.maxItems,
      message: message,
      parameters: (value, entity) => {
        'MaxItems': '$max',
        'TotalItems': '${value?.length ?? 0}',
      },
    );
  }
}

extension MaxItemsOrNullableValidation<T> on SimpleValidationBuilder<List<T>?> {
  /// Adds a validation rule that checks if the [List?] has at most [max] items or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and has more than [max] items.
  SimpleValidationBuilder<List<T>?> maxItemsOrNull(int max,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value.length <= max,
      code: code ?? Language.code.maxItems,
      message: message,
      parameters: (value, entity) => {
        'MaxItems': '$max',
        'TotalItems': '${value?.length ?? 0}',
      },
    );
  }
}
