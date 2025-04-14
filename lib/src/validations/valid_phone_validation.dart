part of 'validations.dart';

/// A validation extension for `SimpleValidationBuilder<String>` that provides
/// methods to validate Brazilian phone numbers, both with and without country code.
///
/// This extension adds two validation methods:
/// 1. `validPhoneBR`: Validates Brazilian phone numbers without a country code.
/// 2. `validPhoneWithCountryCodeBR`: Validates Brazilian phone numbers with the country code `+55`.
///
/// Both methods use regular expressions to ensure the phone number follows the standard Brazilian format.
///
/// ## Usage
/// To use these validations, import the extension and apply it to a `SimpleValidationBuilder<String>` instance.
///
/// ### Example 1: Validating a Brazilian phone number without country code
/// ```dart
/// final validation = SimpleValidationBuilder<String>()
///   ..validPhoneBR(message: 'Invalid Brazilian phone number');
///
/// final result = validation.validate('(75) 9 9261-9575');
/// print(result); // null (valid)
///
/// final invalidResult = validation.validate('75 99261-9575');
/// print(invalidResult); // ValidationException (invalid)
/// ```
///
/// ### Example 2: Validating a Brazilian phone number with country code
/// ```dart
/// final validation = SimpleValidationBuilder<String>()
///   ..validPhoneWithCountryCodeBR(message: 'Invalid Brazilian phone number with country code');
///
/// final result = validation.validate('+55 (75) 9 9261-9575');
/// print(result); // null (valid)
///
/// final invalidResult = validation.validate('+55 75 99261-9575');
/// print(invalidResult); // ValidationException (invalid)
/// ```
///
/// ## Regular Expressions Used
/// - For `validPhoneBR`: `^(\(?[1-9]{2}\)?[\s]?)(9[\s]?)?(\d{4})[\s-]?(\d{4})$`
///   - Matches formats like `(75) 9 9261-9575`, `75 99261-9575`, or `75992619575`.
/// - For `validPhoneWithCountryCodeBR`: `^\+55 ?\(?[1-9]{2}\)? ?9?[0-9]{4}-?[0-9]{4}$`
///   - Matches formats like `+55 (75) 9 9261-9575` or `+55 75 99261-9575`.
///
/// ## Customization
/// - You can provide a custom error message using the `message` parameter.
/// - You can also provide a custom error code using the `code` parameter.
///
/// ## Throws
/// - Returns a `ValidationException` if the phone number is invalid.
extension ValidPhoneValidation on SimpleValidationBuilder<String> {
  /// Validates a Brazilian phone number without a country code.
  ///
  /// This method checks if the phone number follows the standard Brazilian format:
  /// - Optional parentheses around the area code.
  /// - Optional spaces or hyphens as separators.
  /// - A 9th digit (optional for landlines, mandatory for mobile numbers).
  ///
  /// ### Parameters
  /// - `message`: A custom error message to display if the validation fails.
  /// - `code`: A custom error code to use if the validation fails.
  ///
  /// ### Returns
  /// - `null` if the phone number is valid.
  /// - A `ValidationException` if the phone number is invalid.
  ///
  /// ### Example
  /// ```dart
  /// final validation = SimpleValidationBuilder<String>()
  ///   ..validPhoneBR(message: 'Invalid Brazilian phone number');
  ///
  /// final result = validation.validate('(75) 9 9261-9575');
  /// print(result); // null (valid)
  /// ```
  SimpleValidationBuilder<String> validPhoneBR({String? message, String? code}) {
    return use((value, entity) {
      final regex = RegExp(
        r'''^(\(?[1-9]{2}\)?[\s]?)(9[\s]?)?(\d{4})[\s-]?(\d{4})$''',
        multiLine: false,
        caseSensitive: false,
        dotAll: false,
        unicode: false,
      );

      if (regex.hasMatch(value)) {
        return null;
      }

      final currentCode = code ?? Language.code.validPhoneBr;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
        },
        defaultMessage: message,
      );

      return ValidationException(
        message: currentMessage,
        code: currentCode,
        key: key,
      );
    });
  }

  /// Validates a Brazilian phone number with the country code `+55`.
  ///
  /// This method checks if the phone number follows the standard Brazilian format
  /// with the country code `+55`:
  /// - The country code `+55` must be present.
  /// - Optional parentheses around the area code.
  /// - Optional spaces or hyphens as separators.
  /// - A 9th digit (optional for landlines, mandatory for mobile numbers).
  ///
  /// ### Parameters
  /// - `message`: A custom error message to display if the validation fails.
  /// - `code`: A custom error code to use if the validation fails.
  ///
  /// ### Returns
  /// - `null` if the phone number is valid.
  /// - A `ValidationException` if the phone number is invalid.
  ///
  /// ### Example
  /// ```dart
  /// final validation = SimpleValidationBuilder<String>()
  ///   ..validPhoneWithCountryCodeBR(message: 'Invalid Brazilian phone number with country code');
  ///
  /// final result = validation.validate('+55 (75) 9 9261-9575');
  /// print(result); // null (valid)
  /// ```
  SimpleValidationBuilder<String> validPhoneWithCountryCodeBR({String? message, String? code}) {
    return use((value, entity) {
      final regex = RegExp(r'^\+55 ?\(?[1-9]{2}\)? ?9?[0-9]{4}-?[0-9]{4}$');

      if (regex.hasMatch(value)) {
        return null;
      }

      final currentCode = code ?? Language.code.validPhoneDdiBr;
      final currentMessage = LucidValidation.global.languageManager.translate(
        currentCode,
        parameters: {
          'PropertyName': label.isNotEmpty ? label : key,
        },
        defaultMessage: message,
      );

      return ValidationException(
        message: currentMessage,
        code: currentCode,
        key: key,
      );
    });
  }
}
