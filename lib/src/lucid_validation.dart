import '../lucid_validation.dart';

part 'validator_builder.dart';

class _PropSelector<E, TProp> {
  final TProp Function(E entity) selector;
  final LucidValidationBuilder<TProp, E> builder;

  _PropSelector({required this.selector, required this.builder});
}

/// Abstract class for creating validation logic for a specific entity type [E].
///
/// [E] represents the type of the entity being validated.
abstract class LucidValidation<E> {
  final List<_PropSelector<E, dynamic>> _propSelectors = [];

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
  LucidValidationBuilder<TProp, E> ruleFor<TProp>(TProp Function(E entity) func, {String key = ''}) {
    final builder = LucidValidationBuilder<TProp, E>(key: key);
    final propSelector = _PropSelector<E, TProp>(selector: func, builder: builder);

    _propSelectors.add(propSelector);

    return builder;
  }

  /// Returns a validation function for a specific field identified by [key].
  ///
  /// The function returned can be used to validate a single field, typically in forms.
  ///
  /// Example:
  /// ```dart
  /// final validator = UserValidation();
  /// final emailValidator = validator.byField('email');
  /// String? validationResult = emailValidator('user@example.com');
  /// ```
  String? Function([String?])? byField(E entity, String key) {
    final propSelector = _propSelectors
        .where(
          (propSelector) => propSelector.builder.key == key,
        )
        .firstOrNull;

    if (propSelector == null) return null;

    return ([_]) {
      final builder = propSelector.builder;
      final value = propSelector.selector(entity);
      final rules = builder._rules.cast<RuleFunc<String, E>>();
      for (var rule in rules) {
        final result = rule(value, entity);

        if (!result.isValid) {
          return result.error.message;
        }
      }
      return null;
    };
  }

  /// Validates the entire entity [E] and returns a list of [ValidatorError]s if any rules fail.
  ///
  /// This method iterates through all registered rules and checks if the entity meets all of them.
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
  List<ValidatorError> validate(E entity) {
    final List<ValidatorError> errors = [];

    for (var propSelector in _propSelectors) {
      final propValue = propSelector.selector(entity);
      final mode = propSelector.builder._mode;

      for (var rule in propSelector.builder._rules) {
        final result = rule(propValue, entity);

        if (!result.isValid) {
          errors.add(result.error);
          if (mode == CascadeMode.stopOnFirstFailure) {
            break;
          }
        }
      }
    }

    return errors;
  }
}
