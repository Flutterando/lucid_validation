part of 'lucid_validator.dart';

/// Defines the behavior of rule execution when a validation failure occurs.
///
/// The `CascadeMode` enum is used to control whether the validation process should
/// continue executing subsequent rules after a validation failure is encountered,
/// or stop immediately after the first failure.
///
/// This is useful for optimizing validation performance or ensuring that only the
/// most critical validation rules are checked first, potentially avoiding unnecessary
/// validations after a failure.
///
/// Available Modes:
///
/// - `continueExecution`: All validation rules for a property will be executed, even if one fails.
///   This is the default behavior and is useful when you want to collect all possible validation
///   errors for a property at once.
///
/// - `stopOnFirstFailure`: Validation will stop as soon as the first validation rule fails for
///   a property. This can be useful when you want to ensure that the most critical validation
///   rules are checked first and to avoid redundant checks after a failure.
///
/// Example:
///
/// ```dart
/// ruleFor((user) => user.password, key: 'password')
///     .notEmpty()
///     .minLength(8)
///     .cascade(CascadeMode.stopOnFirstFailure);
/// ```
///
/// In the example above, if the password is empty, the validation will stop immediately,
/// and the `minLength(8)` rule will not be executed. This can be useful for optimizing
/// performance or ensuring that more critical rules are evaluated first.
enum CascadeMode {
  /// Continue executing all validation rules for the property, even if one fails.
  /// This mode is useful when you want to collect all possible validation errors at once.
  continueExecution,

  /// Stop executing validation rules for the property as soon as the first failure is encountered.
  /// This mode is useful for optimizing validation performance or prioritizing critical checks.
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

  /// Adds a validation rule that checks if the [TProp] value satisfies the [validator] condition,
  /// considering the entire [Entity].
  ///
  /// The [mustWith] method allows you to create complex validation rules where the value of a property
  /// is validated in the context of the entire entity. This is useful for scenarios where the validation
  /// of one property depends on the value of another property in the same entity.
  ///
  /// [validator] is a function that takes the current value of the property being validated and the entire entity,
  /// and returns a boolean indicating whether the value is valid.
  /// [message] is the error message that will be returned if the validation fails.
  /// [code] is an optional error code that can be used for translation or error handling purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((user) => user.confirmPassword, key: 'confirmPassword')
  ///     .mustWith((confirmPassword, user) => confirmPassword == user.password,
  ///               'Passwords do not match',
  ///               'password_mismatch');
  /// ```
  LucidValidationBuilder<TProp, Entity> mustWith(
    bool Function(TProp value, Entity entity) validator,
    String message,
    String code,
  ) {
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

  /// Sets the [CascadeMode] for the validation rules associated with this property.
  ///
  /// The [cascade] method allows you to control the behavior of rule execution when a validation failure occurs.
  /// By default, all validation rules are executed even if one fails. However, by setting the [CascadeMode],
  /// you can specify whether validation should stop after the first failure (`CascadeMode.stopOnFirstFailure`)
  /// or continue executing all rules (`CascadeMode.continueExecution`).
  ///
  /// [mode] is the [CascadeMode] that determines whether to continue or stop validation after a failure.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((user) => user.password, key: 'password')
  ///     .notEmpty()
  ///     .minLength(8)
  ///     .cascade(CascadeMode.stopOnFirstFailure);
  /// ```
  ///
  /// In the example above, if the password is empty, the validation will stop immediately, and the `minLength(8)` rule
  /// will not be executed. This can be useful for optimizing performance or ensuring that more critical rules are
  /// evaluated first.
  LucidValidationBuilder<TProp, Entity> cascade(CascadeMode mode) {
    _mode = mode;
    return this;
  }
}
