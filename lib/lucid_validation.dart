library lucid_validation;

export './extensions/extensions.dart';
export './lucid_validation_builder/validator_builder.dart';

import './lucid_validation_builder/validator_builder.dart';
import './dtos/dtos.dart';

abstract class LucidValidation<E> {
  final List<PropSelector<E, dynamic>> _propSelectors = [];

  LucidValidationBuilder<TProp> ruleFor<TProp>(TProp Function(E entity) func, {String key = ''}) {
    final builder = LucidValidationBuilder<TProp>(key: key);
    final propSelector = PropSelector<E, TProp>(selector: func, builder: builder);

    _propSelectors.add(propSelector);

    return builder;
  }

  String? Function(String?)? byField(String key) {
    return (value) {
      final propSelector = _propSelectors //
          .where((propSelector) => propSelector.builder.key == key)
          .firstOrNull;

      if (propSelector == null) return null;

      for (var rule in propSelector.builder.rules) {
        ValidatorResult result = rule(value);

        if (!result.isValid) {
          return result.error.message;
        }
      }
      return null;
    };
  }

  List<ValidatorError> validate(E entity) {
    List<ValidatorError> errors = [];

    for (var propSelector in _propSelectors) {
      var propValue = propSelector.selector(entity);

      for (var rule in propSelector.builder.rules) {
        var result = rule(propValue);

        if (result.isValid == false) {
          errors.add(result.error);
        }
      }
    }

    return errors;
  }
}
