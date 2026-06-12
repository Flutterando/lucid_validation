## 1.4.0

* Added `ValidationResult` helpers: `errorsByKey` (errors grouped by field) and `firstErrorFor(key)`.
* Added `validateAndThrow` / `validateAndThrowAsync`, throwing a `LucidValidationException` with all failures.
* Added numeric `inclusiveBetween` / `exclusiveBetween` validators (previously only available for `DateTime`).
* Added `validUrl`, `length(min, max)`, `isInEnum` and `precisionScale` validators (each with an `OrNull` variant).
* Added `withMessage`, `withErrorCode` and `withName` for fluent, chained customization of the previous rule.
* Added asynchronous validation: `mustAsync`, `mustWithAsync`, `useAsync` and `LucidValidator.validateAsync`.
* Added `ruleForEach` to validate each item of a collection inline (without a dedicated validator class).
* Added rule sets via `ruleSet(name, () {...})` and `validate(entity, ruleSets: [...])`.
* Added `include` to compose/reuse validators of the same entity type.
* Added `unless` (the inverse of `when`); `when` and `unless` now compose.
* Added `normalize` to sanitize a value before validation (e.g. trim/lowercase) without mutating the entity.
* Added `switchOn` for polymorphic/branching validations based on discriminator values (e.g. enums, Strings, ints).
* Added `LucidValidator.inline` factory constructor to build validators on the fly without subclassing.
* Added `rulesForField` and `rulesForFieldAsync` to evaluate and inspect the status of all rules on a specific field (e.g. for password checklist widgets).
* Added `getExceptions` and `getExceptionsByKey` to directly retrieve raw lists of validation exceptions.
* Added `use` and `useAsync` builders to manually construct custom rules with full control over the created `ValidationException`.

## 1.3.1

*  Added nullable support for phone number validation

## 1.3.0

*  Added support for list validation using `setEach`, allowing nested validators with index-aware error reporting.

## 1.2.7

* Aded hasNoSequentialRepeatedCharacters and hasNoSequentialCharacters

## 1.2.6

* Aded validPhoneWithCountryCodeBR and validPhoneBR

## 1.2.5

* Aded Exception serialization

## 1.2.4

* Fix overrideCallback in byField

## 1.2.3

* Added overrideCallback in byField

## 1.2.2

* Added validCPFOrCNPJ

## 1.2.1

* Added getExceptions and getExceptionsByKey

## 1.2.0

* Added support nullable

## 1.1.0

* Added Label

## 1.0.1

* Added valid greaterThanOrEqualTo, greaterThan, lessThanOrEqualTo, lessThan, inclusiveBetween and exclusiveBetween

## 1.0.0

* Production release

## 0.0.7

* Added `when` and `setValidator`

## 0.0.5

* Added must and mustWith

## 0.0.3

* Added Cascade Mode

## 0.0.2

* Added valid CEP, CNPJ and CreditCard

## 0.0.1+1

* Initial Release
