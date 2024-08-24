part of 'lucid_validation.dart';

/// Builder class used to define validation rules for a specific property type [TProp].
///
/// [TProp] represents the type of the property being validated.
typedef RuleFunc<TProp> = ValidatorResult Function(TProp value);

class LucidValidationBuilder<TProp> {
  final String key;
  final List<RuleFunc<TProp>> _rules = [];

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
  /// builder.registerRule((username) => username.isNotEmpty, 'Username cannot be empty');
  /// ```
  LucidValidationBuilder<TProp> registerRule(bool Function(TProp value) validator, String message, String code) {
    _rules.add(
      (value) => ValidatorResult(
        isValid: validator(value),
        error: ValidatorError(
          message: message,
          key: key,
          code: code,
        ),
      ),
    );

    return this;
  }
}
