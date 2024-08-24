import '../lucid_validation_builder/validator_builder.dart';

class PropSelector<E, TProp> {
  final TProp Function(E entity) selector;
  final LucidValidationBuilder<TProp> builder;

  PropSelector({required this.selector, required this.builder});
}
