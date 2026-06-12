import '../lucid_validation.dart';

/// Abstract class for creating validation logic for a specific entity type [E].
///
/// [E] represents the type of the entity being validated.
abstract class LucidValidator<E> {
  final List<LucidValidationBuilder<dynamic, E>> _builders = [];

  String? _currentRuleSet;

  /// Creates a [LucidValidator]. Subclasses use this implicit constructor to register
  /// their rules in their own constructor body.
  LucidValidator();

  /// Creates a ready-to-use validator for entity type [E] without declaring a dedicated
  /// `LucidValidator` subclass.
  ///
  /// The [configure] callback receives the validator so you can register rules inline via
  /// [ruleFor] / [ruleForEach]. This is convenient for simple/dynamic validations and for
  /// nested validators passed to [LucidValidationBuilder.setValidator].
  ///
  /// Example:
  /// ```dart
  /// final validator = LucidValidator<User>.inline((v) {
  ///   v.ruleFor((u) => u.email, key: 'email').notEmpty().validEmail();
  ///   v.ruleFor((u) => u.password, key: 'password').notEmpty().minLength(8);
  /// });
  ///
  /// final result = validator.validate(user);
  /// ```
  factory LucidValidator.inline(
      void Function(LucidValidator<E> validator) configure) {
    final validator = _InlineValidator<E>();
    configure(validator);
    return validator;
  }

  addBuilder(LucidValidationBuilder<dynamic, E> builder) {
    _builders.add(builder);
  }

  /// Registers a validation rule for a specific property of the entity.
  ///
  /// [func] is a function that selects the property from the entity [E].
  /// [key] is an optional string that can be used to identify the property for validation purposes.
  ///
  /// Returns a [LucidValidationBuilder] that allows you to chain additional validation rules.
  ///
  /// Example:
  /// ```dart
  /// final validator = UserValidation();
  /// validator.ruleFor((user) => user.email).validEmail();
  /// ```
  LucidValidationBuilder<TProp, E> ruleFor<TProp>(
      TProp Function(E entity) selector,
      {required String key,
      String label = ''}) {
    final builder =
        _LucidValidationBuilder<TProp, E>(key, label, selector, this);
    builder.ruleSet = _currentRuleSet;
    _builders.add(builder);

    return builder;
  }

  /// Registers validation rules that apply to **each item** of a collection property,
  /// without requiring a separate `LucidValidator` class.
  ///
  /// This is the inline counterpart of `setEach`. The returned builder targets the
  /// item type [TItem], so you can chain rules directly on each element. Failures are
  /// reported with the collection [key] and the item's `index`.
  ///
  /// Example:
  /// ```dart
  /// ruleForEach((order) => order.tags, key: 'tags')
  ///     .notEmpty()
  ///     .maxLength(20);
  /// ```
  LucidValidationBuilder<TItem, TItem> ruleForEach<TItem>(
    Iterable<TItem> Function(E entity) selector, {
    required String key,
    String label = '',
  }) {
    final itemValidator = _InlineValidator<TItem>();
    final itemBuilder =
        itemValidator.ruleFor<TItem>((item) => item, key: key, label: label);

    final parentBuilder =
        _LucidValidationBuilder<Iterable<TItem>, E>(key, label, selector, this);
    parentBuilder.ruleSet = _currentRuleSet;
    parentBuilder.setEach(itemValidator);
    _builders.add(parentBuilder);

    return itemBuilder;
  }

  /// Groups the validation rules declared inside [rules] under a named rule set.
  ///
  /// Rule sets let you partition validations for different scenarios (for example
  /// `'create'` vs `'update'`) and execute only a subset on demand.
  ///
  /// Rules declared outside of any [ruleSet] belong to the `'default'` set. When
  /// [validate]/[validateAsync] is called without specifying rule sets, only the
  /// `'default'` set runs. Pass `ruleSets: ['*']` to run every rule.
  ///
  /// Example:
  /// ```dart
  /// class UserValidator extends LucidValidator<User> {
  ///   UserValidator() {
  ///     ruleFor((u) => u.email, key: 'email').notEmpty().validEmail();
  ///
  ///     ruleSet('create', () {
  ///       ruleFor((u) => u.password, key: 'password').notEmpty().minLength(8);
  ///     });
  ///   }
  /// }
  ///
  /// validator.validate(user, ruleSets: ['create']); // email + password
  /// validator.validate(user);                       // only email (default)
  /// ```
  void ruleSet(String name, void Function() rules) {
    final previous = _currentRuleSet;
    _currentRuleSet = name;
    try {
      rules();
    } finally {
      _currentRuleSet = previous;
    }
  }

  /// Includes all rules from another [validator] of the same entity type [E] into this one.
  ///
  /// This enables composing/reusing validators instead of duplicating rules. Any rule sets
  /// defined in the included validator are preserved.
  ///
  /// Example:
  /// ```dart
  /// class FullUserValidator extends LucidValidator<User> {
  ///   FullUserValidator() {
  ///     include(ContactInfoValidator());
  ///     include(AddressInfoValidator());
  ///   }
  /// }
  /// ```
  void include(LucidValidator<E> validator) {
    _builders.addAll(validator._builders);
  }

  /// Returns a validation function for a specific field identified by [key].
  ///
  /// The function returned can be used to validate a single field, typically in forms.
  ///
  /// Example:
  /// ```dart
  ///
  /// final validator = UserValidation();
  /// final emailValidator = validator.byField(user, 'email');
  /// String? validationResult = emailValidator('user@example.com');
  /// ```
  ///
  /// or
  /// ```dart
  ///
  /// void callback (errors) {}
  ///
  /// final validator = UserValidation();
  /// final emailValidator = validator.byField(user, 'email', overrideCallback: callback);
  /// emailValidator('user@example.com'); // return null when overrideCallback is not null
  /// ```
  String? Function([String?]) byField(
    E entity,
    String key, {
    Function(List<ValidationException>)? overrideCallback,
  }) {
    if (key.contains('.')) {
      final keys = key.split('.');

      final firstKey = keys.removeAt(0);
      final builder = _getBuilderByKey(firstKey);
      if (builder == null) {
        if (overrideCallback != null) {
          overrideCallback.call([]);
          return ([_]) => null;
        }

        return ([_]) => null;
      }

      return builder.nestedByField(entity, keys.join('.'));
    } else {
      final builder = _getBuilderByKey(key);

      if (builder == null) {
        if (overrideCallback != null) {
          overrideCallback.call([]);
          return ([_]) => null;
        }

        return ([_]) => null;
      }

      return ([_]) {
        final errors = builder.executeRules(entity);
        if (errors.isNotEmpty) {
          if (overrideCallback != null) {
            overrideCallback.call(errors);
            return null;
          }
          return errors.first.message;
        }
        if (overrideCallback != null) {
          overrideCallback.call([]);
        }
        return null;
      };
    }
  }

  LucidValidationBuilder? _getBuilderByKey(String key) {
    return _builders
        .where(
          (builder) => builder.key == key,
        )
        .firstOrNull;
  }

  bool _matchesRuleSet(String? builderRuleSet, List<String> requested) {
    if (requested.contains('*')) return true;
    return requested.contains(builderRuleSet ?? 'default');
  }

  /// Validates the entire entity [E] and returns a list of [ValidationException]s if any rules fail.
  ///
  /// This method iterates through all registered rules and checks if the entity meets all of them.
  ///
  /// By default only rules in the `'default'` rule set run. Pass [ruleSets] to select specific
  /// rule sets (or `['*']` for all). See [ruleSet] for details.
  ///
  /// Throws an [AsyncValidationException] if any asynchronous rule is registered. Use
  /// [validateAsync] in that case.
  ///
  /// Example:
  /// ```dart
  /// final validator = UserValidation();
  /// final errors = validator.validate(user);
  /// if (errors.isEmpty) {
  ///   print('All validations passed');
  /// } else {
  ///   print('Validation failed: ${errors.map((e) => e.message).join(', ')}');
  /// }
  /// ```
  ValidationResult validate(E entity, {List<String>? ruleSets}) {
    final exceptions = _runSync(entity, ruleSets);

    return ValidationResult(
      isValid: exceptions.isEmpty,
      exceptions: exceptions,
    );
  }

  /// Asynchronously validates the entire entity [E], supporting both synchronous and
  /// asynchronous rules (see `mustAsync`/`useAsync`).
  ///
  /// By default only rules in the `'default'` rule set run. Pass [ruleSets] to select specific
  /// rule sets (or `['*']` for all).
  ///
  /// Example:
  /// ```dart
  /// final result = await validator.validateAsync(user);
  /// if (result.isValid) {
  ///   print('All validations passed');
  /// }
  /// ```
  Future<ValidationResult> validateAsync(E entity,
      {List<String>? ruleSets}) async {
    final requested = ruleSets ?? const ['default'];
    final List<ValidationException> exceptions = [];

    for (var builder in _builders) {
      if (!_matchesRuleSet(builder.ruleSet, requested)) continue;

      exceptions.addAll(await builder.executeRulesAsync(entity));
      if (builder.getMode() == CascadeMode.stopOnFirstFailure &&
          exceptions.isNotEmpty) {
        break;
      }
    }

    return ValidationResult(
      isValid: exceptions.isEmpty,
      exceptions: exceptions,
    );
  }

  /// Validates the entity and throws a [LucidValidationException] if it is invalid.
  ///
  /// Returns the (valid) [ValidationResult] otherwise. This is convenient for
  /// service/use-case layers that prefer exceptions over checking `isValid`.
  ///
  /// Throws an [AsyncValidationException] if any asynchronous rule is registered.
  /// Use [validateAndThrowAsync] in that case.
  ValidationResult validateAndThrow(E entity, {List<String>? ruleSets}) {
    final result = validate(entity, ruleSets: ruleSets);
    if (!result.isValid) {
      throw LucidValidationException(result);
    }
    return result;
  }

  /// Asynchronous counterpart of [validateAndThrow]. Supports async rules.
  Future<ValidationResult> validateAndThrowAsync(E entity,
      {List<String>? ruleSets}) async {
    final result = await validateAsync(entity, ruleSets: ruleSets);
    if (!result.isValid) {
      throw LucidValidationException(result);
    }
    return result;
  }

  List<ValidationException> _runSync(E entity, List<String>? ruleSets) {
    final requested = ruleSets ?? const ['default'];
    final List<ValidationException> exceptions = [];

    for (var builder in _builders) {
      if (!_matchesRuleSet(builder.ruleSet, requested)) continue;

      exceptions.addAll(builder.executeRules(entity));
      if (builder.getMode() == CascadeMode.stopOnFirstFailure &&
          exceptions.isNotEmpty) {
        break;
      }
    }

    return exceptions;
  }

  /// **getExceptions**
  ///
  /// This function fetches and returns all validation exceptions associated with an entity.
  ///
  /// **Parameters:**
  ///   * `entity`: The entity to be validated.
  ///   * `ruleSets`: optional rule sets to run (defaults to `'default'`).
  ///
  /// **Return:**
  ///   * A list of validation exceptions encountered.
  ///
  /// **Description:**
  ///  The function iterates over all registered validation builders and executes the validation rules for each builder.
  ///  Exceptions encountered are added to a list and returned at the end.
  ///  If the cascade mode is set to 'stopOnFirstFailure', the function stops checking the remaining rules after the first exception.
  ///
  List<ValidationException> getExceptions(E entity, {List<String>? ruleSets}) {
    return _runSync(entity, ruleSets);
  }

  /// **getExceptions**
  ///
  /// This function fetches and returns all validation exceptions associated with an entity by key.
  ///
  /// **Parameters:**
  ///   * `entity`: The entity to be validated.
  ///   * `key`: key associated with validations.
  ///
  /// **Return:**
  ///   * A list of validation exceptions encountered by key.
  ///
  /// **Description:**
  ///  The function iterates over all registered validation builders and executes the validation rules for each builder.
  ///  Exceptions encountered are added to a list and returned at the end.
  ///  If the cascade mode is set to 'stopOnFirstFailure', the function stops checking the remaining rules after the first exception.
  ///
  List<ValidationException> getExceptionsByKey(E entity, String key) {
    final builder = _getBuilderByKey(key);

    if (builder == null) return [];

    final exceptions = builder.executeRules(entity);

    return exceptions.isNotEmpty ? exceptions : [];
  }

  /// Returns the evaluation status of **all** validation rules registered for the property
  /// identified by [key], regardless of whether they currently pass or fail.
  ///
  /// Each [ExposedRuleResult] carries the rule `code`, its translated `message`, and an
  /// `isValid` flag for the given [entity] state. This is ideal for driving real-time
  /// checklists (for example, password strength requirements) directly from the validator
  /// configuration.
  ///
  /// Returns an empty list when no property matches [key].
  ///
  /// Throws [AsyncValidationException] if the property has asynchronous rules. Use
  /// [rulesForFieldAsync] instead in that case.
  ///
  /// Example:
  /// ```dart
  /// final rules = validator.rulesForField(credentials, 'password');
  /// for (final rule in rules) {
  ///   print('${rule.isValid ? '✓' : '✗'} ${rule.message}');
  /// }
  /// ```
  List<ExposedRuleResult> rulesForField(E entity, String key) {
    final builder = _getBuilderByKey(key);
    if (builder == null) return [];

    return builder.exposeRules(entity);
  }

  /// Asynchronous counterpart of [rulesForField], supporting both synchronous and
  /// asynchronous rules.
  ///
  /// Returns an empty list when no property matches [key].
  Future<List<ExposedRuleResult>> rulesForFieldAsync(
      E entity, String key) async {
    final builder = _getBuilderByKey(key);
    if (builder == null) return [];

    return builder.exposeRulesAsync(entity);
  }

  /// Routes an entire block of validation rules based on a discriminator value
  /// derived from the entity.
  ///
  /// [selector] extracts the key used to pick the matching case.
  /// [cases] maps each possible key to a callback that registers rules on this
  /// validator via the normal [ruleFor]/[ruleForEach] API.
  /// [orElse] is an optional fallback callback that runs when the selector value
  /// does not match any key in [cases].
  ///
  /// At validation time **only the rules registered under the matching case
  /// run**; every other case is silently skipped. If no case matches and
  /// [orElse] is provided, its rules run instead. Rules declared outside
  /// [switchOn] (before or after the call) are unaffected and always run.
  ///
  /// Works with any type as discriminator — `String`, `enum`, `int`, etc.
  ///
  /// Example:
  /// ```dart
  /// class PaymentValidator extends LucidValidator<Payment> {
  ///   PaymentValidator() {
  ///     ruleFor((p) => p.type, key: 'type').notEmpty();
  ///
  ///     switchOn((p) => p.type, cases: {
  ///       PaymentType.creditCard: (v) {
  ///         v.ruleFor((p) => p.cardNumber, key: 'cardNumber')
  ///           .notEmpty()
  ///           .minLength(16);
  ///         v.ruleFor((p) => p.cvv, key: 'cvv')
  ///           .isNumeric()
  ///           .length(3, 4);
  ///       },
  ///       PaymentType.pix: (v) {
  ///         v.ruleFor((p) => p.pixKey, key: 'pixKey').notEmpty();
  ///       },
  ///     }, orElse: (v) {
  ///       v.ruleFor((p) => p.type, key: 'type')
  ///         .must((_) => false, 'Unsupported payment type.', 'unsupported_type');
  ///     });
  ///   }
  /// }
  /// ```
  void switchOn<K>(
    K Function(E entity) selector, {
    required Map<K, void Function(LucidValidator<E> v)> cases,
    void Function(LucidValidator<E> v)? orElse,
  }) {
    for (final entry in cases.entries) {
      final caseKey = entry.key;
      final configure = entry.value;

      final before = _builders.length;
      configure(this);
      final after = _builders.length;

      for (var i = before; i < after; i++) {
        _builders[i].when((entity) => selector(entity) == caseKey);
      }
    }

    if (orElse != null) {
      final before = _builders.length;
      orElse(this);
      final after = _builders.length;

      for (var i = before; i < after; i++) {
        _builders[i].when(
          (entity) => !cases.keys.contains(selector(entity)),
        );
      }
    }
  }
}

class _LucidValidationBuilder<TProp, Entity>
    extends LucidValidationBuilder<TProp, Entity> {
  _LucidValidationBuilder(super.key, super.label, super.selector, super.lucid);
}

/// A minimal concrete [LucidValidator] used internally by [LucidValidator.ruleForEach]
/// to host the per-item rules.
class _InlineValidator<T> extends LucidValidator<T> {}
