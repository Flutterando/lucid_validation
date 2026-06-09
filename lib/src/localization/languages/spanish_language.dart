import '../language.dart';

class SpanishLanguage extends Language {
  SpanishLanguage()
      : super({
          Language.code.equalTo:
              "'{PropertyName}' debe ser igual a '{ComparisonValue}'.",
          Language.code.greaterThan:
              "'{PropertyName}' debe ser mayor que '{ComparisonValue}'.",
          Language.code.isEmpty: "'{PropertyName}' debe estar vacío.",
          Language.code.isNotNull: "'{PropertyName}' no puede ser nulo.",
          Language.code.isNull: "'{PropertyName}' debe ser nulo.",
          Language.code.lessThan:
              "'{PropertyName}' debe ser menor que '{ComparisonValue}'.",
          Language.code.matchesPattern:
              "'{PropertyName}' no tiene el formato correcto.",
          Language.code.max:
              "'{PropertyName}' debe ser menor o igual a {MaxValue}. Has ingresado {PropertyValue}.",
          Language.code.maxLength:
              "El tamaño de '{PropertyName}' debe ser de {MaxLength} caracteres o menos. Has ingresado {TotalLength} caracteres.",
          Language.code.min:
              "'{PropertyName}' debe ser mayor o igual a {MinValue}. Has ingresado {PropertyValue}.",
          Language.code.minLength:
              "El tamaño de '{PropertyName}' debe ser de al menos {MinLength} caracteres. Has ingresado {TotalLength} caracteres.",
          Language.code.mustHaveLowercase:
              "'{PropertyName}' debe tener al menos una letra minúscula.",
          Language.code.mustHaveNumber:
              "'{PropertyName}' debe tener al menos un dígito ('0'-'9').",
          Language.code.mustHaveSpecialCharacter:
              "'{PropertyName}' debe tener al menos un carácter no alfanumérico.",
          Language.code.mustHaveUppercase:
              "'{PropertyName}' debe tener al menos una letra mayúscula.",
          Language.code.notEmpty: "'{PropertyName}' no puede estar vacío.",
          Language.code.notEqualTo:
              "'{PropertyName}' no puede ser igual a '{ComparisonValue}'.",
          Language.code.range:
              "'{PropertyName}' debe estar entre {From} y {To}. Has ingresado {PropertyValue}.",
          Language.code.validCEP: "'{PropertyName}' no es un CEP válido.",
          Language.code.validCPF: "'{PropertyName}' no es un CPF válido.",
          Language.code.validCNPJ: "'{PropertyName}' no es un CNPJ válido.",
          Language.code.validCreditCard:
              "'{PropertyName}' no es un número de tarjeta de crédito válido.",
          Language.code.validEmail:
              "'{PropertyName}' no es una dirección de correo electrónico válida.",
          Language.code.greaterThanOrEqualToDateTime:
              "'{PropertyName}' debe ser mayor o igual a la fecha '{ComparisonValue}'.",
          Language.code.greaterThanDatetime:
              "'{PropertyName}' debe ser mayor que la fecha '{ComparisonValue}'.",
          Language.code.lessThanOrEqualToDateTime:
              "'{PropertyName}' debe ser menor o igual a la fecha '{ComparisonValue}'.",
          Language.code.lessThanDateTime:
              "'{PropertyName}' debe ser menor que la fecha '{ComparisonValue}'.",
          Language.code.inclusiveBetweenDatetime:
              "'{PropertyName}' debe ser mayor o igual a la fecha '{StartValue}' y menor o igual a la fecha '{EndValue}'.",
          Language.code.exclusiveBetweenDatetime:
              "'{PropertyName}' debe ser mayor que la fecha '{StartValue}' y menor que la fecha '{EndValue}'.",
          Language.code.validPhoneBr:
              "'{PropertyName}' no es un teléfono válido.",
          Language.code.validPhoneDdiBr:
              "'{PropertyName}' no es un teléfono DDI válido.",
          Language.code.sequentialRepeatedCharacters:
              "'{PropertyName}' no puede tener caracteres repetidos en secuencia.",
          Language.code.sequentialCharactersNotAllowed:
              "'{PropertyName}' no puede tener secuencias como '123' o 'abc'.",
          Language.code.inclusiveBetween:
              "'{PropertyName}' debe estar entre {From} y {To} (inclusive). Has ingresado {PropertyValue}.",
          Language.code.exclusiveBetween:
              "'{PropertyName}' debe estar entre {From} y {To} (exclusive). Has ingresado {PropertyValue}.",
          Language.code.validUrl: "'{PropertyName}' no es una URL válida.",
          Language.code.length:
              "'{PropertyName}' debe tener entre {MinLength} y {MaxLength} caracteres. Has ingresado {TotalLength} caracteres.",
          Language.code.isInEnum:
              "'{PropertyName}' tiene un rango de valores que no incluye '{PropertyValue}'.",
          Language.code.precisionScale:
              "'{PropertyName}' no puede tener más de {ExpectedPrecision} dígitos en total, con un máximo de {ExpectedScale} decimales. Se encontraron {Digits} dígitos y {ActualScale} decimales.",
          Language.code.alphanumeric:
              "'{PropertyName}' debe contener solo letras y dígitos.",
          Language.code.isNumeric:
              "'{PropertyName}' debe contener solo dígitos.",
          Language.code.isUppercase:
              "'{PropertyName}' debe estar en mayúsculas.",
          Language.code.isLowercase:
              "'{PropertyName}' debe estar en minúsculas.",
          Language.code.contains:
              "'{PropertyName}' debe contener '{RequiredSubstring}'.",
          Language.code.startsWith:
              "'{PropertyName}' debe comenzar con '{Prefix}'.",
          Language.code.endsWith:
              "'{PropertyName}' debe terminar con '{Suffix}'.",
          Language.code.validUuid:
              "'{PropertyName}' no es un UUID válido.",
          Language.code.validIpv4:
              "'{PropertyName}' no es una dirección IPv4 válida.",
          Language.code.validIpv6:
              "'{PropertyName}' no es una dirección IPv6 válida.",
          Language.code.httpUrl:
              "'{PropertyName}' no es una URL HTTP o HTTPS válida.",
          Language.code.isPositive:
              "'{PropertyName}' debe ser un número positivo.",
          Language.code.isNegative:
              "'{PropertyName}' debe ser un número negativo.",
          Language.code.isNonNegative:
              "'{PropertyName}' debe ser mayor o igual a cero.",
          Language.code.isNonZero:
              "'{PropertyName}' no puede ser cero.",
          Language.code.multipleOf:
              "'{PropertyName}' debe ser múltiplo de {Divisor}.",
          Language.code.isEven:
              "'{PropertyName}' debe ser un número par.",
          Language.code.isOdd:
              "'{PropertyName}' debe ser un número impar.",
          Language.code.isTrue: "'{PropertyName}' debe ser verdadero.",
          Language.code.isFalse: "'{PropertyName}' debe ser falso.",
          Language.code.minItems:
              "'{PropertyName}' debe tener al menos {MinItems} elementos. Has ingresado {TotalItems} elementos.",
          Language.code.maxItems:
              "'{PropertyName}' debe tener como máximo {MaxItems} elementos. Has ingresado {TotalItems} elementos.",
          Language.code.listContains:
              "'{PropertyName}' debe contener '{RequiredItem}'.",
          Language.code.inPast:
              "'{PropertyName}' debe ser una fecha en el pasado.",
          Language.code.inFuture:
              "'{PropertyName}' debe ser una fecha en el futuro.",
          Language.code.afterField:
              "'{PropertyName}' debe ser posterior a '{ComparisonValue}'.",
          Language.code.beforeField:
              "'{PropertyName}' debe ser anterior a '{ComparisonValue}'.",
        });
}
