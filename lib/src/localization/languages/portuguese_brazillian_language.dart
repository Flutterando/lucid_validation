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
          Language.code.validPhoneBr:
              "'{PropertyName}' não é um telefone válido.",
          Language.code.validPhoneDdiBr:
              "'{PropertyName}' não é um telefone DDI válido.",
          Language.code.sequentialRepeatedCharacters:
              "'{PropertyName}' não pode ter caracteres repetidos em sequência.",
          Language.code.sequentialCharactersNotAllowed:
              "'{PropertyName}' não pode ter sequências como '123' ou 'abc'.",
          Language.code.inclusiveBetween:
              "'{PropertyName}' deve estar entre {From} e {To} (inclusive). Você digitou {PropertyValue}.",
          Language.code.exclusiveBetween:
              "'{PropertyName}' deve estar entre {From} e {To} (exclusive). Você digitou {PropertyValue}.",
          Language.code.validUrl: "'{PropertyName}' não é uma URL válida.",
          Language.code.length:
              "'{PropertyName}' deve ter entre {MinLength} e {MaxLength} caracteres. Você digitou {TotalLength} caracteres.",
          Language.code.isInEnum:
              "'{PropertyName}' possui um conjunto de valores que não inclui '{PropertyValue}'.",
          Language.code.precisionScale:
              "'{PropertyName}' não pode ter mais que {ExpectedPrecision} dígitos no total, com no máximo {ExpectedScale} casas decimais. Foram encontrados {Digits} dígitos e {ActualScale} casas decimais.",
          Language.code.alphanumeric:
              "'{PropertyName}' deve conter apenas letras e dígitos.",
          Language.code.isNumeric:
              "'{PropertyName}' deve conter apenas dígitos.",
          Language.code.isUppercase:
              "'{PropertyName}' deve estar em maiúsculas.",
          Language.code.isLowercase:
              "'{PropertyName}' deve estar em minúsculas.",
          Language.code.contains:
              "'{PropertyName}' deve conter '{RequiredSubstring}'.",
          Language.code.startsWith:
              "'{PropertyName}' deve começar com '{Prefix}'.",
          Language.code.endsWith:
              "'{PropertyName}' deve terminar com '{Suffix}'.",
          Language.code.validUuid:
              "'{PropertyName}' não é um UUID válido.",
          Language.code.validIpv4:
              "'{PropertyName}' não é um endereço IPv4 válido.",
          Language.code.validIpv6:
              "'{PropertyName}' não é um endereço IPv6 válido.",
          Language.code.httpUrl:
              "'{PropertyName}' não é uma URL HTTP ou HTTPS válida.",
          Language.code.isPositive:
              "'{PropertyName}' deve ser um número positivo.",
          Language.code.isNegative:
              "'{PropertyName}' deve ser um número negativo.",
          Language.code.isNonNegative:
              "'{PropertyName}' deve ser maior ou igual a zero.",
          Language.code.isNonZero:
              "'{PropertyName}' não pode ser zero.",
          Language.code.multipleOf:
              "'{PropertyName}' deve ser múltiplo de {Divisor}.",
          Language.code.isEven:
              "'{PropertyName}' deve ser um número par.",
          Language.code.isOdd:
              "'{PropertyName}' deve ser um número ímpar.",
          Language.code.isTrue: "'{PropertyName}' deve ser verdadeiro.",
          Language.code.isFalse: "'{PropertyName}' deve ser falso.",
          Language.code.minItems:
              "'{PropertyName}' deve ter pelo menos {MinItems} itens. Você informou {TotalItems} itens.",
          Language.code.maxItems:
              "'{PropertyName}' deve ter no máximo {MaxItems} itens. Você informou {TotalItems} itens.",
          Language.code.listContains:
              "'{PropertyName}' deve conter '{RequiredItem}'.",
          Language.code.inPast:
              "'{PropertyName}' deve ser uma data no passado.",
          Language.code.inFuture:
              "'{PropertyName}' deve ser uma data no futuro.",
          Language.code.afterField:
              "'{PropertyName}' deve ser posterior a '{ComparisonValue}'.",
          Language.code.beforeField:
              "'{PropertyName}' deve ser anterior a '{ComparisonValue}'.",
        });
}
