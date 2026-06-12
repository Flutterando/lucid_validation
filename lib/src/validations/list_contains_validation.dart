part of 'validations.dart';

extension ListContainsValidation<T> on SimpleValidationBuilder<List<T>> {
  /// Adds a validation rule that checks if the [List] contains [item].
  ///
  /// [item] is the item that must be present in the list.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((user) => user.roles, key: 'roles')
  ///   .listContains('admin');
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{RequiredItem}**: The required item.
  ///
  SimpleValidationBuilder<List<T>> listContains(T item,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value.contains(item),
      code: code ?? Language.code.listContains,
      message: message,
      parameters: (value, entity) => {'RequiredItem': '$item'},
    );
  }
}

extension ListContainsNullableValidation<T>
    on SimpleValidationBuilder<List<T>?> {
  /// Adds a validation rule that checks if the [List?] contains [item].
  ///
  /// Fails if the value is null or does not contain [item].
  SimpleValidationBuilder<List<T>?> listContains(T item,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value != null && value.contains(item),
      code: code ?? Language.code.listContains,
      message: message,
      parameters: (value, entity) => {'RequiredItem': '$item'},
    );
  }
}

extension ListContainsOrNullableValidation<T>
    on SimpleValidationBuilder<List<T>?> {
  /// Adds a validation rule that checks if the [List?] contains [item] or is null.
  ///
  /// Passes if value is null. Fails if value is non-null and does not contain [item].
  SimpleValidationBuilder<List<T>?> listContainsOrNull(T item,
      {String? message, String? code}) {
    return useValidation(
      (value, entity) => value == null || value.contains(item),
      code: code ?? Language.code.listContains,
      message: message,
      parameters: (value, entity) => {'RequiredItem': '$item'},
    );
  }
}
