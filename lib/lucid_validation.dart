/// LucidValidation
///
/// A Dart/Flutter package for building strongly typed validation rules, inspired by FluentValidation.
/// Created by the Flutterando community, this package aims to provide a flexible and powerful way
/// to validate your models in Flutter and Dart projects.
///
/// ## Features
///
/// - Strongly typed validation rules.
/// - Fluent API for defining validations.
/// - Extensible with custom validators.
/// - Easy to integrate with any Dart or Flutter project.
///
/// ## Example
///
/// ```dart
/// import 'package:lucid_validation/lucid_validation.dart';
///
/// class UserModel {
///   String email;
///   String password;
///   int age;
///   String phone;
///
///   UserModel({
///     required this.email,
///     required this.password,
///     required this.age,
///     required this.phone,
///   });
///
///   factory UserModel.empty() => UserModel(email: '', password: '', age: 18, phone: '');
/// }
///
/// class UserValidation extends LucidValidation<UserModel> {
///   UserValidation() {
///     ruleFor((user) => user.email, key: 'email')
///         .notEmpty()
///         .validEmail();
///
///     ruleFor((user) => user.password, key: 'password')
///         .customValidPassword();
///
///     ruleFor((user) => user.age, key: 'age')
///         .min(18, message: 'Minimum age is 18 years');
///
///     ruleFor((user) => user.phone, key: 'phone')
///         .customValidPhone('Phone invalid format');
///   }
/// }
/// ```
///
/// For more details, check out the full documentation and examples.
///
library lucid_validation;

export 'src/lucid_validator.dart';
export 'src/types/types.dart';
export 'src/validations/validations.dart';
