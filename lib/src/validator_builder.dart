part of 'lucid_validation.dart';

enum CascadeMode {
  continueExecution,
  stopOnFirstFailure,
}

/// Builder class used to define validation rules for a specific property type [TProp].
///
/// [TProp] represents the type of the property being validated.
typedef RuleFunc<TProp, Entity> = ValidatorResult Function(dynamic value, dynamic entity);

class LucidValidationBuilder<TProp, Entity> {
  final String key;
  final List<RuleFunc<TProp, Entity>> _rules = [];
  var _mode = CascadeMode.continueExecution;

  /// Creates a [LucidValidationBuilder] instance with an optional [key].
  ///
  /// The [key] can be used to identify this specific validation in a larger validation context.
  LucidValidationBuilder({this.key = ''});

  /// Registers a validation rule for the property.
  ///
  /// [validator] is a function that returns `true` if the property is valid and `false` otherwise.
  /// [message] is the error message returned when the validation fails.
  ///
  /// Returns this [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// final builder = LucidValidationBuilder<String>(key: 'username');
  /// builder.must((username) => username.isNotEmpty, 'Username cannot be empty');
  /// ```
  LucidValidationBuilder<TProp, Entity> must(bool Function(TProp value) validator, String message, String code) {
    ValidatorResult callback(value, entity) => ValidatorResult(
          isValid: validator(value),
          error: ValidatorError(
            message: message,
            key: key,
            code: code,
          ),
        );

    _rules.add(callback);

    return this;
  }

  LucidValidationBuilder<TProp, Entity> mustWith(bool Function(TProp value, Entity enntity) validator, String message, String code) {
    ValidatorResult callback(value, entity) => ValidatorResult(
          isValid: validator(value, entity),
          error: ValidatorError(
            message: message,
            key: key,
            code: code,
          ),
        );

    _rules.add(callback);

    return this;
  }

  /// Changes the cascade mode for this validation.
  LucidValidationBuilder<TProp, Entity> cascade(CascadeMode mode) {
    _mode = mode;
    return this;
  }
}
