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

/// Signature for a synchronous validation rule.
///
/// [TProp] represents the type of the property being validated.
typedef RuleFunc<Entity> = ValidationException? Function(Entity entity);

/// Signature for an asynchronous validation rule.
typedef AsyncRuleFunc<Entity> = Future<ValidationException?> Function(
    Entity entity);

typedef SimpleValidationBuilder<T> = LucidValidationBuilder<T, dynamic>;

/// Thrown when a synchronous validation entry point (such as [LucidValidator.validate]
/// or [LucidValidator.byField]) is used on a property that contains asynchronous rules
/// (registered via [LucidValidationBuilder.mustAsync] / [LucidValidationBuilder.useAsync]).
///
/// Use [LucidValidator.validateAsync] instead.
class AsyncValidationException implements Exception {
  /// The key of the property that contains asynchronous rules.
  final String key;

  AsyncValidationException(this.key);

  @override
  String toString() =>
      'AsyncValidationException: the property "$key" has asynchronous rules. '
      'Use validateAsync() instead of validate()/byField().';
}

/// Internal representation of a single validation rule that may be synchronous or asynchronous.
class _Rule<Entity> {
  final RuleFunc<Entity>? _sync;
  final AsyncRuleFunc<Entity>? _async;

  /// The validation code associated with this rule (e.g. `'minLength'`), when known.
  ///
  /// Used by the rule exposition API ([LucidValidator.rulesForField]) to report the
  /// rule's code/message even when the rule is currently satisfied.
  final String? code;

  /// The custom (default) message associated with this rule, when provided.
  final String? message;

  const _Rule.sync(RuleFunc<Entity> rule, {this.code, this.message})
      : _sync = rule,
        _async = null;

  const _Rule.async(AsyncRuleFunc<Entity> rule, {this.code, this.message})
      : _async = rule,
        _sync = null;

  bool get isAsync => _async != null;

  ValidationException? runSync(Entity entity) => _sync!(entity);

  Future<ValidationException?> runAsync(Entity entity) {
    if (_async != null) return _async!(entity);
    return Future.value(_sync!(entity));
  }
}

/// Builder class used to define validation rules for a specific property type [TProp].
///
/// [TProp] represents the type of the property being validated.
abstract class LucidValidationBuilder<TProp, Entity> {
  final String key;
  String label;
  TProp Function(Entity entity) _selector;
  final List<_Rule<Entity>> _rules = [];
  var _mode = CascadeMode.continueExecution;
  LucidValidator<TProp>? _nestedValidator;
  final LucidValidator _lucid;

  /// The name of the rule set this builder belongs to, or `null` for the default set.
  String? ruleSet;

  bool Function(Entity entity)? _condition;

  /// Creates a [LucidValidationBuilder] instance with an optional [key].
  ///
  /// The [key] can be used to identify this specific validation in a larger validation context.
  LucidValidationBuilder(this.key, this.label, this._selector, this._lucid);

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
        entity: extractClassName(entity.toString()),
        message: message,
        key: key,
        code: code,
      );
    }

    return use(callback, code: code, message: message);
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
          entity: extractClassName(entity.toString()),
          message: message,
          key: key,
          code: code,
        );
      },
      code: code,
      message: message,
    );
  }

  /// Adds an **asynchronous** validation rule for the property.
  ///
  /// The [mustAsync] method is the async counterpart of [must]. It is useful for validations
  /// that depend on I/O, such as checking the database or calling an external API
  /// (for example, verifying that an e-mail is not already registered).
  ///
  /// [validator] is a function that takes the current value of the property and returns a
  /// `Future<bool>` resolving to `true` when the value is valid.
  /// [message] is the error message returned when the validation fails.
  /// [code] identifies the specific validation error.
  ///
  /// Validators that register async rules must be executed with [LucidValidator.validateAsync].
  ///
  /// Example:
  /// ```dart
  /// ruleFor((user) => user.email, key: 'email')
  ///     .mustAsync((email) async => !await repository.emailExists(email),
  ///                'E-mail already registered',
  ///                'email_taken');
  /// ```
  LucidValidationBuilder<TProp, Entity> mustAsync(
    Future<bool> Function(TProp value) validator,
    String message,
    String code,
  ) {
    return useAsync(
      (value, entity) async {
        if (await validator(value)) {
          return null;
        }

        return ValidationException(
          entity: extractClassName(entity.toString()),
          message: message,
          key: key,
          code: code,
        );
      },
      code: code,
      message: message,
    );
  }

  /// Adds an **asynchronous** validation rule that also receives the entire [Entity].
  ///
  /// This is the async counterpart of [mustWith].
  ///
  /// Example:
  /// ```dart
  /// ruleFor((user) => user.username, key: 'username')
  ///     .mustWithAsync((username, user) async => await repo.isAvailable(username, user.tenantId),
  ///                    'Username already in use',
  ///                    'username_taken');
  /// ```
  LucidValidationBuilder<TProp, Entity> mustWithAsync(
    Future<bool> Function(TProp value, Entity entity) validator,
    String message,
    String code,
  ) {
    return useAsync(
      (value, entity) async {
        if (await validator(value, entity)) {
          return null;
        }

        return ValidationException(
          entity: extractClassName(entity.toString()),
          message: message,
          key: key,
          code: code,
        );
      },
      code: code,
      message: message,
    );
  }

  /// Adds a validation rule to the LucidValidationBuilder.
  ///
  /// The [rule] parameter is a function that takes an [Entity] object as input and returns a [ValidationException] object.
  /// This method adds the [rule] to the list of validation rules in the LucidValidationBuilder.
  ///
  /// [code] and [message] are optional metadata describing the rule. They are not used during
  /// regular validation (the [rule] itself produces the failure), but they let the rule
  /// exposition API ([LucidValidator.rulesForField]) report the rule's translated description
  /// even when it is currently satisfied.
  ///
  /// Returns the current instance of the LucidValidationBuilder.
  LucidValidationBuilder<TProp, Entity> use(
    ValidationException? Function(TProp value, Entity entity) rule, {
    String? code,
    String? message,
  }) {
    _rules.add(_Rule.sync((entity) => rule(_selector(entity), entity),
        code: code, message: message));
    return this;
  }

  /// Adds an asynchronous validation rule to the LucidValidationBuilder.
  ///
  /// This is the async counterpart of [use]. Validators that register async rules must be
  /// executed through [LucidValidator.validateAsync].
  ///
  /// See [use] for the meaning of [code] and [message].
  LucidValidationBuilder<TProp, Entity> useAsync(
    Future<ValidationException?> Function(TProp value, Entity entity) rule, {
    String? code,
    String? message,
  }) {
    _rules.add(_Rule.async((entity) => rule(_selector(entity), entity),
        code: code, message: message));
    return this;
  }

  /// Builds a [ValidationException] for this property, resolving the localized message for
  /// [code] via the active language manager.
  ///
  /// The `{PropertyName}` placeholder is filled from [withName]/[key], and any additional
  /// [parameters] are merged in. A non-null [message] overrides the localized message.
  ///
  /// Shared by [useValidation] and [useValidationAsync]; can also be used directly when a
  /// validator needs to build the exception itself.
  ValidationException buildValidationException(
    Entity entity, {
    required String code,
    String? message,
    Map<String, String> parameters = const {},
  }) {
    final resolvedMessage = LucidValidation.global.languageManager.translate(
      code,
      parameters: {
        'PropertyName': label.isNotEmpty ? label : key,
        ...parameters,
      },
      defaultMessage: message,
    );

    return ValidationException(
      entity: extractClassName(entity.toString()),
      message: resolvedMessage,
      code: code,
      key: key,
    );
  }

  /// Registers a **synchronous**, localized validation rule.
  ///
  /// When [validator] returns `false`, the builder resolves the message for [code]
  /// (injecting `{PropertyName}` plus any [parameters]) and builds the [ValidationException]
  /// for you — so validators don't need to construct it by hand. A custom [message] overrides
  /// the localized one. [code]/[message] are also recorded so the rule can be reported by
  /// [LucidValidator.rulesForField] even while satisfied.
  ///
  /// Example:
  /// ```dart
  /// SimpleValidationBuilder<String> minLength(int n, {String? message, String? code}) =>
  ///     useValidation(
  ///       (value, _) => value.length >= n,
  ///       code: code ?? Language.code.minLength,
  ///       message: message,
  ///       parameters: (value, _) => {'MinLength': '$n', 'TotalLength': '${value.length}'},
  ///     );
  /// ```
  LucidValidationBuilder<TProp, Entity> useValidation(
    bool Function(TProp value, Entity entity) validator, {
    required String code,
    String? message,
    Map<String, String> Function(TProp value, Entity entity)? parameters,
  }) {
    return use(
      (value, entity) => validator(value, entity)
          ? null
          : buildValidationException(
              entity,
              code: code,
              message: message,
              parameters: parameters?.call(value, entity) ?? const {},
            ),
      code: code,
      message: message,
    );
  }

  /// Asynchronous counterpart of [useValidation]; the [validator] returns a `Future<bool>`.
  ///
  /// Validators registered through this method must be executed with
  /// [LucidValidator.validateAsync].
  LucidValidationBuilder<TProp, Entity> useValidationAsync(
    Future<bool> Function(TProp value, Entity entity) validator, {
    required String code,
    String? message,
    Map<String, String> Function(TProp value, Entity entity)? parameters,
  }) {
    return useAsync(
      (value, entity) async => await validator(value, entity)
          ? null
          : buildValidationException(
              entity,
              code: code,
              message: message,
              parameters: parameters?.call(value, entity) ?? const {},
            ),
      code: code,
      message: message,
    );
  }

  LucidValidationBuilder<T, Entity> useNotNull<T extends Object>(
    ValidationException? Function(TProp value, Entity entity) rule, {
    String? code,
    String? message,
  }) {
    _rules.add(_Rule.sync((entity) => rule(_selector(entity), entity),
        code: code, message: message));

    final builder =
        _LucidValidationBuilder<T, Entity>(key, label, (Entity entity) {
      final value = _selector(entity) as T;
      return value;
    }, _lucid);

    builder.ruleSet = ruleSet;

    _mode = CascadeMode.stopOnFirstFailure;

    _lucid.addBuilder(builder);
    return builder;
  }

  /// Overrides the error [message] of the **most recently declared** validation rule.
  ///
  /// This mirrors FluentValidation's `WithMessage`, allowing a fluent, chained customization
  /// of messages instead of passing them inline to each validator.
  ///
  /// The `{PropertyName}` placeholder is supported and replaced with this property's
  /// display name (see [withName]) or its `key`. The substitution is resolved when the
  /// rule runs, so it works regardless of whether [withName] is chained before or after.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((u) => u.email, key: 'email')
  ///     .notEmpty().withMessage('Please inform your e-mail')
  ///     .validEmail().withMessage('{PropertyName} format is invalid');
  /// ```
  LucidValidationBuilder<TProp, Entity> withMessage(String message) {
    _overrideLast((exception) =>
        exception.copyWith(message: _resolvePropertyName(message)));
    return this;
  }

  String _resolvePropertyName(String message) {
    final propertyName = label.isNotEmpty ? label : key;
    return message.replaceAll('{PropertyName}', propertyName);
  }

  /// Overrides the error [code] of the **most recently declared** validation rule.
  ///
  /// This mirrors FluentValidation's `WithErrorCode`.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((u) => u.email, key: 'email')
  ///     .validEmail().withErrorCode('EMAIL_INVALID');
  /// ```
  LucidValidationBuilder<TProp, Entity> withErrorCode(String code) {
    _overrideLast((exception) => exception.copyWith(code: code));
    return this;
  }

  /// Overrides the display name (`{PropertyName}`) used in this property's messages.
  ///
  /// This mirrors FluentValidation's `WithName`/`OverridePropertyName`. The provided [name]
  /// is used as `{PropertyName}` for every rule of this property, while the field [key]
  /// (used by `byField`) remains unchanged.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((u) => u.dob, key: 'dob')
  ///     .withName('Date of birth')
  ///     .notEmpty();
  /// ```
  LucidValidationBuilder<TProp, Entity> withName(String name) {
    label = name;
    return this;
  }

  void _overrideLast(
      ValidationException Function(ValidationException exception) transform) {
    if (_rules.isEmpty) return;

    final last = _rules.removeLast();
    if (last.isAsync) {
      _rules.add(_Rule.async(
        (entity) async {
          final exception = await last.runAsync(entity);
          return exception == null ? null : transform(exception);
        },
        code: last.code,
        message: last.message,
      ));
    } else {
      _rules.add(_Rule.sync(
        (entity) {
          final exception = last.runSync(entity);
          return exception == null ? null : transform(exception);
        },
        code: last.code,
        message: last.message,
      ));
    }
  }

  /// Resolves the translated (and `{PropertyName}`-substituted) message for a rule [code].
  ///
  /// [customMessage] takes precedence over the localized translation, mirroring how the
  /// validators resolve their messages at failure time. Used by the rule exposition API to
  /// describe a rule even when it is currently satisfied.
  String _getTranslatedMessage(String code, String? customMessage) {
    return LucidValidation.global.languageManager.translate(
      code,
      parameters: {
        'PropertyName': label.isNotEmpty ? label : key,
      },
      defaultMessage: customMessage,
    );
  }

  ExposedRuleResult _toExposedResult(
      _Rule<Entity> rule, ValidationException? exception) {
    final isValid = exception == null;

    final code = exception?.code ?? rule.code ?? '';
    final message = exception?.message ??
        (rule.code != null
            ? _getTranslatedMessage(rule.code!, rule.message)
            : rule.message ?? '');

    return ExposedRuleResult(code: code, message: message, isValid: isValid);
  }

  /// Evaluates every rule registered for this property against [entity] and reports its
  /// current state as a list of [ExposedRuleResult].
  ///
  /// Throws [AsyncValidationException] if any registered rule is asynchronous; use
  /// [exposeRulesAsync] in that case.
  List<ExposedRuleResult> exposeRules(Entity entity) {
    final results = <ExposedRuleResult>[];
    for (final rule in _rules) {
      if (rule.isAsync) {
        throw AsyncValidationException(key);
      }
      final exception = rule.runSync(entity);
      results.add(_toExposedResult(rule, exception));
    }
    return results;
  }

  /// Asynchronous counterpart of [exposeRules], supporting both sync and async rules.
  Future<List<ExposedRuleResult>> exposeRulesAsync(Entity entity) async {
    final results = <ExposedRuleResult>[];
    for (final rule in _rules) {
      final exception = await rule.runAsync(entity);
      results.add(_toExposedResult(rule, exception));
    }
    return results;
  }

  /// Normalizes (sanitizes) the property value **before** any validation rule runs.
  ///
  /// The [sanitizer] receives the raw selected value and returns the value that all
  /// validation rules of this property will see. This is ideal for trimming whitespace,
  /// removing masks, lower-casing, etc., keeping sanitization out of the rules themselves.
  ///
  /// The transformation only affects validation; it does not mutate the original entity.
  /// It applies to every rule of this property regardless of chain position, so declare it
  /// first for readability.
  ///
  /// Example:
  /// ```dart
  /// ruleFor((u) => u.email, key: 'email')
  ///     .normalize((email) => email.trim().toLowerCase())
  ///     .notEmpty()
  ///     .validEmail();
  /// ```
  LucidValidationBuilder<TProp, Entity> normalize(
      TProp Function(TProp value) sanitizer) {
    final previousSelector = _selector;
    _selector = (entity) => sanitizer(previousSelector(entity));
    return this;
  }

  CascadeMode getMode() {
    return _mode;
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

  /// Allows you to apply a validator to each item in a collection of Objects.
  ///
  /// The `setEach` method is useful for validating lists or other collections of objects where
  /// each item in the collection must be validated individually with the same set of rules.
  ///
  /// [itemValidator] is a `LucidValidator` that will be applied to each item in the list.
  ///
  /// Example:
  ///
  /// ```dart
  /// ruleFor((form) => form.addresses, key: 'addresses')
  ///   .setEach(AddressValidator());
  /// ```
  void setEach(LucidValidator<dynamic> itemValidator) {
    _nestedValidator = _EachValidatorWrapper<TProp>(itemValidator);
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
  /// `when` and [unless] compose: combining them requires all conditions to hold.
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
    final previous = _condition;
    _condition =
        (entity) => (previous?.call(entity) ?? true) && condition(entity);
    return this;
  }

  /// Adds a conditional execution rule that runs the validation logic **only when** the
  /// given [condition] is `false`. It is the inverse of [when].
  ///
  /// `unless` and [when] compose: combining them requires all conditions to hold.
  ///
  /// Example:
  ///
  /// ```dart
  /// ruleFor((user) => user.companyName, key: 'companyName')
  ///     .unless((user) => user.isIndividual)
  ///     .notEmpty();
  /// ```
  ///
  /// In the example above, the `companyName` is only validated when the user is **not** an individual.
  LucidValidationBuilder<TProp, Entity> unless(
      bool Function(Entity entity) condition) {
    final previous = _condition;
    _condition =
        (entity) => (previous?.call(entity) ?? true) && !condition(entity);
    return this;
  }

  /// Executes all validation rules associated with this property and returns a list of [ValidationException]s.
  ///
  /// Throws an [AsyncValidationException] if any asynchronous rule is registered for this property.
  /// Use [executeRulesAsync] / [LucidValidator.validateAsync] in that case.
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
        if (rule.isAsync) {
          throw AsyncValidationException(key);
        }

        final exception = rule.runSync(entity);

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

  /// Asynchronously executes all validation rules associated with this property and returns a
  /// list of [ValidationException]s. Supports both synchronous and asynchronous rules.
  Future<List<ValidationException>> executeRulesAsync(Entity entity) async {
    final byPass = _condition?.call(entity) ?? true;
    if (!byPass) {
      return [];
    }

    final exceptions = <ValidationException>[];

    if (_nestedValidator != null) {
      final nestedResult =
          await _nestedValidator!.validateAsync(_selector(entity));
      exceptions.addAll(nestedResult.exceptions);
    } else {
      for (var rule in _rules) {
        final exception = await rule.runAsync(entity);

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

class _LucidValidationBuilder<TProp, Entity>
    extends LucidValidationBuilder<TProp, Entity> {
  _LucidValidationBuilder(super.key, super.label, super.selector, super.lucid);
}

/// A wrapper around a `LucidValidator` used for validating each item in a collection of objects.
///
/// The `_EachValidatorWrapper` class allows you to apply a single `LucidValidator` instance
/// to each element of a list or iterable of values. This is useful when validating collections
/// where each item must be validated using the same set of rules.
///
/// This class is typically used internally by the `setEach` method of `LucidValidationBuilder`,
/// which enables nested validation for list properties.
///
/// Example:
///
/// ```dart
/// ruleFor((form) => form.contacts, key: 'contacts')
///   .setEach(ContactValidator());
/// ```
///
/// In this example, each item in the `contacts` list will be validated using the `ContactValidator`.
class _EachValidatorWrapper<T> extends LucidValidator<T> {
  /// The validator that will be applied to each item in the collection.
  final LucidValidator<dynamic> _validator;

  _EachValidatorWrapper(this._validator);

  /// Validates each item in the [value] iterable using the wrapped validator.
  ///
  /// Iterates over each item in the [value], applies the wrapped validator to it,
  /// and collects all `ValidationException`s. Each exception is annotated with the
  /// index of the item in the collection.
  ///
  /// Returns a [ValidationResult] containing the list of exceptions and an
  /// `isValid` flag indicating whether all items are valid.
  @override
  ValidationResult validate(T value, {List<String>? ruleSets}) {
    final exceptions = <ValidationException>[];

    if (value is Iterable) {
      var index = 0;
      for (final item in value) {
        final result = _validator.validate(item, ruleSets: ruleSets);
        final indexed = result.exceptions.map((e) {
          return e.copyWith(
            key: e.key,
            index: index,
          );
        });
        exceptions.addAll(indexed);
        index++;
      }
    }

    return ValidationResult(
        exceptions: exceptions, isValid: exceptions.isEmpty);
  }

  /// Asynchronously validates each item in the [value] iterable using the wrapped validator.
  @override
  Future<ValidationResult> validateAsync(T value,
      {List<String>? ruleSets}) async {
    final exceptions = <ValidationException>[];

    if (value is Iterable) {
      var index = 0;
      for (final item in value) {
        final result = await _validator.validateAsync(item, ruleSets: ruleSets);
        final indexed = result.exceptions.map((e) {
          return e.copyWith(
            key: e.key,
            index: index,
          );
        });
        exceptions.addAll(indexed);
        index++;
      }
    }

    return ValidationResult(
        exceptions: exceptions, isValid: exceptions.isEmpty);
  }

  /// Retrieves the validation message for a specific field from each item in the iterable.
  ///
  /// This method searches each item in the [value] collection and returns the first non-null
  /// validation message for the given [key]. If none are found, `null` is returned.
  ///
  /// Optionally, an [overrideCallback] can be provided to customize how the list of
  /// `ValidationException`s is interpreted.
  ///
  /// Returns a function that optionally takes a suffix and returns a validation message string or `null`.
  @override
  String? Function([String?]) byField(
    T value,
    String key, {
    dynamic Function(List<ValidationException>)? overrideCallback,
  }) {
    if (value is Iterable) {
      return ([String? suffix]) {
        for (final item in value) {
          final result =
              _validator.byField(item, key, overrideCallback: overrideCallback);
          final res = result(suffix);
          if (res != null) {
            return res;
          }
        }
        return null;
      };
    }

    return ([String? _]) => null;
  }
}
