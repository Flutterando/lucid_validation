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
          Language.code.validPhoneBr: "'{PropertyName}' no es un teléfono válido.",
          Language.code.validPhoneDdiBr: "'{PropertyName}' no es un teléfono DDI válido."
        });
}
