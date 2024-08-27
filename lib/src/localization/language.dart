abstract class Language {
  static const code = (
    equalTo: 'equalTo',
    greaterThan: 'greaterThan',
    isEmpty: 'isEmpty',
    isNotNull: 'isNotNull',
    isNull: 'isNull',
    lessThan: 'lessThan',
    matchesPattern: 'matchesPattern',
    max: 'max',
    maxLength: 'maxLength',
    min: 'min',
    minLength: 'minLength',
    mustHaveLowercase: 'mustHaveLowercase',
    mustHaveNumber: 'mustHaveNumber',
    mustHaveSpecialCharacter: 'mustHaveSpecialCharacter',
    mustHaveUppercase: 'mustHaveUppercase',
    notEmpty: 'notEmpty',
    notEqualTo: 'notEqualTo',
    range: 'range',
    validCEP: 'validCEP',
    validCPF: 'validCPF',
    validCNPJ: 'validCNPJ',
    validCreditCard: 'validCreditCard',
    validEmail: 'validEmail',
  );

  Language([Map<String, String> translations = const {}]) {
    _translations.addAll(translations);
  }

  final _translations = <String, String>{
    code.equalTo: "'{PropertyName}' must be equal to '{ComparisonValue}'.",
    code.greaterThan: "'{PropertyName}' must be greater than '{ComparisonValue}'.",
    code.isEmpty: "'{PropertyName}' must be empty.",
    code.isNotNull: "'{PropertyName}' must not be null.",
    code.isNull: "'{PropertyName}' must be null.",
    code.lessThan: "'{PropertyName}' must be less than '{ComparisonValue}'.",
    code.matchesPattern: "'{PropertyName}' is not in the correct format.",
    code.max: "'{PropertyName}' must be less than or equal to {MaxValue}. You entered {PropertyValue}.",
    code.maxLength: "The length of '{PropertyName}' must be {MaxLength} characters or fewer. You entered {TotalLength} characters.",
    code.min: "'{PropertyName}' must be greater than or equal to {MinValue}. You entered {PropertyValue}.",
    code.minLength: "The length of '{PropertyName}' must be at least {MinLength} characters. You entered {TotalLength} characters.",
    code.mustHaveLowercase: "'{PropertyName}' must have at least one lowercase letter.",
    code.mustHaveNumber: "'{PropertyName}' must have at least one digit ('0'-'9').",
    code.mustHaveSpecialCharacter: "'{PropertyName}' must have at least one non-alphanumeric character.",
    code.mustHaveUppercase: "'{PropertyName}' must have at least one uppercase letter.",
    code.notEmpty: "'{PropertyName}' must not be empty.",
    code.notEqualTo: "'{PropertyName}' must not be equal to '{ComparisonValue}'.",
    code.range: "'{PropertyName}' must be between {From} and {To}. You entered {PropertyValue}.",
    code.validCEP: "'{PropertyName}' is not a valid CEP.",
    code.validCPF: "'{PropertyName}' is not a valid CPF.",
    code.validCNPJ: "'{PropertyName}' is not a valid CNPJ.",
    code.validCreditCard: "'{PropertyName}' is not a valid credit card number.",
    code.validEmail: "'{PropertyName}' is not a valid email address.",
  };

  String? getTranslation(String key) => _translations[key];
}
