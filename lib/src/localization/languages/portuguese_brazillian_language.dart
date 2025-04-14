import '../language.dart';

class PortugueseBrasillianLanguage extends Language {
  PortugueseBrasillianLanguage()
      : super({
          Language.code.equalTo:
              "'{PropertyName}' deve ser igual a '{ComparisonValue}'.",
          Language.code.greaterThan:
              "'{PropertyName}' deve ser maior que '{ComparisonValue}'.",
          Language.code.isEmpty: "'{PropertyName}' deve estar vazio.",
          Language.code.isNotNull: "'{PropertyName}' não pode ser nulo.",
          Language.code.isNull: "'{PropertyName}' deve ser nulo.",
          Language.code.lessThan:
              "'{PropertyName}' deve ser menor que '{ComparisonValue}'.",
          Language.code.matchesPattern:
              "'{PropertyName}' não está no formato correto.",
          Language.code.max:
              "'{PropertyName}' deve ser menor ou igual a {MaxValue}. Você digitou {PropertyValue}.",
          Language.code.maxLength:
              "O tamanho de '{PropertyName}' deve ser de {MaxLength} caracteres ou menos. Você digitou {TotalLength} caracteres.",
          Language.code.min:
              "'{PropertyName}' deve ser maior ou igual a {MinValue}. Você digitou {PropertyValue}.",
          Language.code.minLength:
              "O tamanho de '{PropertyName}' deve ser de pelo menos {MinLength} caracteres. Você digitou {TotalLength} caracteres.",
          Language.code.mustHaveLowercase:
              "'{PropertyName}' deve ter pelo menos uma letra minúscula.",
          Language.code.mustHaveNumber:
              "'{PropertyName}' deve ter pelo menos um dígito ('0'-'9').",
          Language.code.mustHaveSpecialCharacter:
              "'{PropertyName}' deve ter pelo menos um caractere não alfanumérico.",
          Language.code.mustHaveUppercase:
              "'{PropertyName}' deve ter pelo menos uma letra maiúscula.",
          Language.code.notEmpty: "'{PropertyName}' não pode estar vazio.",
          Language.code.notEqualTo:
              "'{PropertyName}' não pode ser igual a '{ComparisonValue}'.",
          Language.code.range:
              "'{PropertyName}' deve estar entre {From} e {To}. Você digitou {PropertyValue}.",
          Language.code.validCEP: "'{PropertyName}' não é um CEP válido.",
          Language.code.validCPF: "'{PropertyName}' não é um CPF válido.",
          Language.code.validCNPJ: "'{PropertyName}' não é um CNPJ válido.",
          Language.code.validCreditCard:
              "'{PropertyName}' não é um número de cartão de crédito válido.",
          Language.code.validEmail:
              "'{PropertyName}' não é um endereço de e-mail válido.",
          Language.code.greaterThanOrEqualToDateTime:
              "'{PropertyName}' deve ser maior ou igual à data '{ComparisonValue}'.",
          Language.code.greaterThanDatetime:
              "'{PropertyName}' deve ser maior que a data '{ComparisonValue}'.",
          Language.code.lessThanOrEqualToDateTime:
              "'{PropertyName}' deve ser menor ou igual à data '{ComparisonValue}'.",
          Language.code.lessThanDateTime:
              "'{PropertyName}' deve ser menor que a data '{ComparisonValue}'.",
          Language.code.inclusiveBetweenDatetime:
              "'{PropertyName}' deve ser maior ou igual à data '{StartValue}' e menor ou igual à data '{EndValue}'.",
          Language.code.exclusiveBetweenDatetime:
              "'{PropertyName}' deve ser maior que a data '{StartValue}' e menor que a data '{EndValue}'.",
          Language.code.validPhoneBr: "'{PropertyName}' não é um telefone válido.",
          Language.code.validPhoneDdiBr: "'{PropertyName}' não é um telefone DDI válido."
        });
}
