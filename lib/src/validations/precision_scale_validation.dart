part of 'validations.dart';

/// Holds the total number of significant [digits] and the number of decimal
/// places ([scale]) of a numeric value.
class _PrecisionScaleInfo {
  final int digits;
  final int scale;
  const _PrecisionScaleInfo(this.digits, this.scale);
}

_PrecisionScaleInfo _precisionScaleInfo(num value, bool ignoreTrailingZeros) {
  final str = value.abs().toString();

  String intPart;
  String fracPart;
  if (str.contains('.')) {
    final parts = str.split('.');
    intPart = parts[0];
    fracPart = parts[1];
  } else {
    intPart = str;
    fracPart = '';
  }

  if (ignoreTrailingZeros) {
    fracPart = fracPart.replaceFirst(RegExp(r'0+$'), '');
  }

  final intDigits = intPart == '0' ? 0 : intPart.length;
  final scale = fracPart.length;
  return _PrecisionScaleInfo(intDigits + scale, scale);
}

bool _isValidPrecisionScale(
    _PrecisionScaleInfo info, int precision, int scale) {
  return info.scale <= scale &&
      info.digits <= precision &&
      (info.digits - info.scale) <= (precision - scale);
}

/// Extension on [LucidValidationBuilder] for [num] properties to add a precision/scale validation.
extension PrecisionScaleValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] does not exceed the given
  /// [precision] (total number of digits) and [scale] (number of decimal places).
  ///
  /// [precision] is the maximum total number of digits.
  /// [scale] is the maximum number of digits after the decimal point.
  /// [ignoreTrailingZeros] when `true`, trailing zeros in the decimal part are ignored.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// // up to 5 digits in total, 2 of them decimals (e.g. 123.45)
  /// ruleFor((product) => product.price, key: 'price')
  ///   .precisionScale(5, 2);
  /// ```
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ExpectedPrecision}**: The maximum total number of digits.
  /// - **{ExpectedScale}**: The maximum number of decimals.
  /// - **{Digits}**: The total digits found.
  /// - **{ActualScale}**: The decimals found.
  SimpleValidationBuilder<num> precisionScale(
    int precision,
    int scale, {
    bool ignoreTrailingZeros = false,
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) => _isValidPrecisionScale(
          _precisionScaleInfo(value, ignoreTrailingZeros), precision, scale),
      code: code ?? Language.code.precisionScale,
      message: message,
      parameters: (value, entity) {
        final info = _precisionScaleInfo(value, ignoreTrailingZeros);
        return {
          'ExpectedPrecision': '$precision',
          'ExpectedScale': '$scale',
          'Digits': '${info.digits}',
          'ActualScale': '${info.scale}',
        };
      },
    );
  }
}

extension PrecisionScaleOrNullableValidation on SimpleValidationBuilder<num?> {
  /// Adds a validation rule that checks the [precision] and [scale] of a [num?],
  /// or passes if the value is `null`.
  ///
  /// [precision] is the maximum total number of digits.
  /// [scale] is the maximum number of digits after the decimal point.
  /// [ignoreTrailingZeros] when `true`, trailing zeros in the decimal part are ignored.
  /// [message] is the error message returned if the validation fails.
  /// [code] is an optional error code for translation purposes.
  ///
  /// String format args:
  /// - **{PropertyName}**: The name of the property.
  /// - **{ExpectedPrecision}**: The maximum total number of digits.
  /// - **{ExpectedScale}**: The maximum number of decimals.
  /// - **{Digits}**: The total digits found.
  /// - **{ActualScale}**: The decimals found.
  SimpleValidationBuilder<num?> precisionScaleOrNull(
    int precision,
    int scale, {
    bool ignoreTrailingZeros = false,
    String? message,
    String? code,
  }) {
    return useValidation(
      (value, entity) =>
          value == null ||
          _isValidPrecisionScale(
              _precisionScaleInfo(value, ignoreTrailingZeros),
              precision,
              scale),
      code: code ?? Language.code.precisionScale,
      message: message,
      parameters: (value, entity) {
        final info = _precisionScaleInfo(value!, ignoreTrailingZeros);
        return {
          'ExpectedPrecision': '$precision',
          'ExpectedScale': '$scale',
          'Digits': '${info.digits}',
          'ActualScale': '${info.scale}',
        };
      },
    );
  }
}
