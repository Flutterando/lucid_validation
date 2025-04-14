import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import 'mocks/mocks.dart';

void main() {
  test('byfield normal', () {
    final validator = TestLucidValidator<UserModel>();

    validator.ruleFor((model) => model.age, key: 'age').greaterThan(17);
    validator.ruleFor((model) => model.email, key: 'email').notEmpty();

    final user = UserModel()..age = 16;

    final ageValidator = validator.byField(user, 'age');

    expect(ageValidator(), isNotNull);

    user.age = 18;

    expect(ageValidator(), null);

    final emailValidator = validator.byField(user, 'email');

    expect(emailValidator(), isNotNull);

    user.email = 'test@gmail.com';

    expect(emailValidator(), null);

    final phoneValidator = validator.byField(user, 'phone');
    user.phone = '75912345678';

    expect(phoneValidator(), null);
  });

  group('nested byfield normal', () {
    final flagValidator = TestLucidValidator<Flag>();
    flagValidator.ruleFor((flag) => flag.value, key: 'value').equalTo((entity) => true);

    final categoryValidator = TestLucidValidator<CategoryModel>();
    categoryValidator.ruleFor((category) => category.name, key: 'name').notEmpty();
    categoryValidator.ruleFor((category) => category.flag, key: 'flag').setValidator(flagValidator);

    final productValidator = TestLucidValidator<ProductModel>();
    productValidator.ruleFor((product) => product.name, key: 'name').notEmpty();
    productValidator.ruleFor((product) => product.price, key: 'price').greaterThan(0);
    productValidator.ruleFor((product) => product.category, key: 'category').setValidator(categoryValidator);

    final product = ProductModel();

    test('nameValidator', () {
      final nameValidator = productValidator.byField(product, 'name');
      expect(nameValidator(), isNotNull);
    });

    test('priceValidator', () {
      final priceValidator = productValidator.byField(product, 'price');
      expect(priceValidator(), isNotNull);
    });

    test('categoryValidator', () {
      final categoryValidatorFn = productValidator.byField(product, 'category');
      expect(categoryValidatorFn(), isNotNull);
    });

    test('categoryNameValidator', () {
      final categoryNameValidatorFn = productValidator.byField(product, 'category.name');
      expect(categoryNameValidatorFn(), isNotNull);
    });

    test('flagValidator', () {
      final flagValidatorFn = productValidator.byField(product, 'category.flag');
      expect(flagValidatorFn(), isNotNull);
    });

    test('flagValueValidator', () {
      final flagValueValidatorFn = productValidator.byField(product, 'category.flag.value');
      expect(flagValueValidatorFn(), isNotNull);
    });

    test('must return null if not found key', () {
      final flagValueValidatorFn = productValidator.byField(product, 'category.flag.notExists');
      expect(flagValueValidatorFn(), null);
    });

    test('all validators', () {
      product.name = 'Product';
      product.price = 10;
      product.category.name = 'Category';
      product.category.flag.value = true;

      final nameValidator = productValidator.byField(product, 'name');
      final priceValidator = productValidator.byField(product, 'price');
      final categoryValidatorFn = productValidator.byField(product, 'category');
      final categoryNameValidatorFn = productValidator.byField(product, 'category.name');
      final flagValidatorFn = productValidator.byField(product, 'category.flag');
      final flagValueValidatorFn = productValidator.byField(product, 'category.flag.value');

      expect(nameValidator(), null);
      expect(priceValidator(), null);
      expect(categoryValidatorFn(), null);
      expect(categoryNameValidatorFn(), null);
      expect(flagValidatorFn(), null);
      expect(flagValueValidatorFn(), null);
    });
  });
}

class ProductModel {
  String name = '';
  double price = 0.0;
  CategoryModel category = CategoryModel();
}

class CategoryModel {
  String name = '';
  Flag flag = Flag();
}

class Flag {
  bool value = false;
}
