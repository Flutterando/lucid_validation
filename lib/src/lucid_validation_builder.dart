import '../lucid_validation.dart';

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
typedef RuleFunc<Entity> = ValidationException? Function(Entity entity);

typedef SimpleValidationBuilder<T> = LucidValidationBuilder<T, dynamic>;

abstract class LucidValidationBuilder<TProp, Entity> {
  final String key;
  final String label;
  final TProp Function(Entity entity) _selector;
  final List<RuleFunc<Entity>> _rules = [];
  var _mode = CascadeMode.continueExecution;
  LucidValidator<TProp>? _nestedValidator;

  bool Function(Entity entity)? _condition;

  /// Creates a [LucidValidationBuilder] instance with an optional [key].
  ///
  /// The [key] can be used to identify this specific validation in a larger validation context.
  LucidValidationBuilder(this.key, this.label, this._selector);

  String? Function([String?]) nestedByField(Entity entity, String key) {
    if (_nestedValidator == null) {
      return ([_]) => null;
    }

    return _nestedValidator!.byField(_selector(entity), key);
  }

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
  LucidValidationBuilder<TProp, Entity> must(
      bool Function(TProp value) validator, String message, String code) {
    ValidationException? callback(value, entity) {
      if (validator(value)) {
        return null;
      }
      return ValidationException(
        message: message,
        key: key,
        code: code,
      );
    }

    return use(callback);
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
    return use(
      (value, entity) {
        if (validator(value, entity)) {
          return null;
        }

        return ValidationException(
          message: message,
          key: key,
          code: code,
        );
      },
    );
  }

  /// Adds a validation rule to the LucidValidationBuilder.
  ///
  /// The [rule] parameter is a function that takes an [Entity] object as input and returns a [ValidationException] object.
  /// This method adds the [rule] to the list of validation rules in the LucidValidationBuilder.
  ///
  /// Returns the current instance of the LucidValidationBuilder.
  LucidValidationBuilder<TProp, Entity> use(
    ValidationException? Function(TProp value, Entity entity) rule,
  ) {
    _rules.add((entity) => rule(_selector(entity), entity));
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

  /// Allows the integration of another `LucidValidator` to validate nested properties.
  ///
  /// The `setValidator` method enables you to nest another `LucidValidator` within the current validation context.
  /// This is particularly useful when dealing with complex models that contain nested objects or properties.
  /// By setting a nested validator, you can apply validation rules to the properties of the nested object
  /// within the context of the parent object.
  ///
  /// [validator] is an instance of `LucidValidator` that will be applied to the nested property.
  ///
  /// Example:
  ///
  /// ```dart
  ///   .ruleFor((user) => user.address, key: 'address')
  ///       .setValidator(AddressValidator()); // Integrating the nested validator
  ///
  /// ```
  void setValidator(LucidValidator<TProp> validator) {
    _nestedValidator = validator;
  }

  /// Adds a conditional execution rule for the validation logic based on the given [condition].
  ///
  /// The `when` method allows you to specify a condition that must be met for the validation rules
  /// within this builder to be executed. If the condition is not met, the validation rules are skipped,
  /// and the property is considered valid by default.
  ///
  /// This is particularly useful for scenarios where certain validation rules should only apply
  /// under specific circumstances, such as when a certain property is set to a particular value.
  ///
  /// [condition] is a function that takes the entire entity and returns a boolean indicating whether
  /// the validation rules should be applied.
  ///
  /// Example:
  ///
  /// ```dart
  /// ruleFor((user) => user.phoneNumber, key: 'phoneNumber')
  ///     .when((user) => user.requiresPhoneNumber)
  ///     .must((value) => value.isNotEmpty, 'Phone number is required', 'phone_required')
  ///     .must((value) => value.length == 10, 'Phone number must be 10 digits', 'phone_length');
  /// ```
  ///
  /// In the example above, the phone number validation rules are only applied if the user's `requiresPhoneNumber`
  /// property is true. If the condition is false, the phone number field will be considered valid, and the
  /// associated rules will not be executed.
  LucidValidationBuilder<TProp, Entity> when(
      bool Function(Entity entity) condition) {
    _condition = condition;
    return this;
  }

  /// Executes all validation rules associated with this property and returns a list of [ValidationException]s.
  List<ValidationException> executeRules(Entity entity) {
    final byPass = _condition?.call(entity) ?? true;
    if (!byPass) {
      return [];
    }

    final exceptions = <ValidationException>[];

    if (_nestedValidator != null) {
      final nestedExceptions =
          _nestedValidator!.validate(_selector(entity)).exceptions;
      exceptions.addAll(nestedExceptions);
    } else {
      for (var rule in _rules) {
        final exception = rule(entity);

        if (exception != null) {
          exceptions.add(exception);

          if (_mode == CascadeMode.stopOnFirstFailure) {
            break;
          }
        }
      }
    }

    return exceptions;
  }
}
