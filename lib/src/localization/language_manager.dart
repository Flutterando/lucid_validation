import '../../lucid_validation.dart';
import 'languages/portuguese_brazillian_language.dart';
import 'languages/spanish_language.dart';

final _avaliableLanguages = <Culture, Language>{
  Culture('pt'): PortugueseBrasillianLanguage(),
  Culture('pt', 'BR'): PortugueseBrasillianLanguage(),
  Culture('en'): EnglishLanguage(),
  Culture('en', 'US'): EnglishLanguage(),
  Culture('en', 'UA'): EnglishLanguage(),
  Culture('en', 'NZ'): EnglishLanguage(),
  Culture('en', 'ZA'): EnglishLanguage(),
  Culture('en', 'GB'): EnglishLanguage(),
  Culture('en', 'CA'): EnglishLanguage(),
  Culture('en', 'AU'): EnglishLanguage(),
  Culture('en', 'IE'): EnglishLanguage(),
  Culture('en', 'IN'): EnglishLanguage(),
  Culture('en', 'SG'): EnglishLanguage(),
  Culture('en', 'PH'): EnglishLanguage(),
  Culture('en', 'MY'): EnglishLanguage(),
  Culture('en', 'PK'): EnglishLanguage(),
  Culture('en', 'NG'): EnglishLanguage(),
  Culture('en', 'KE'): EnglishLanguage(),
  Culture('en', 'GH'): EnglishLanguage(),
  Culture('en', 'UG'): EnglishLanguage(),
  Culture('en', 'TT'): EnglishLanguage(),
  Culture('es'): SpanishLanguage(),
  Culture('es', 'ES'): SpanishLanguage(),
  Culture('es', 'MX'): SpanishLanguage(),
  Culture('es', 'AR'): SpanishLanguage(),
  Culture('es', 'CR'): SpanishLanguage(),
  Culture('es', 'DO'): SpanishLanguage(),
  Culture('es', 'CO'): SpanishLanguage(),
  Culture('es', 'CL'): SpanishLanguage(),
  Culture('es', 'PY'): SpanishLanguage(),
  Culture('es', 'SV'): SpanishLanguage(),
  Culture('es', 'NI'): SpanishLanguage(),
  Culture('es', 'GT'): SpanishLanguage(),
  Culture('es', 'PA'): SpanishLanguage(),
  Culture('es', 'VE'): SpanishLanguage(),
  Culture('es', 'PE'): SpanishLanguage(),
  Culture('es', 'EC'): SpanishLanguage(),
  Culture('es', 'UY'): SpanishLanguage(),
  Culture('es', 'PO'): SpanishLanguage(),
  Culture('es', 'HN'): SpanishLanguage(),
  Culture('es', 'PR'): SpanishLanguage(),
};

abstract class LanguageManager {
  final _globalTranslations = <Culture, Map<String, String>>{};

  void addTranslation(Culture culture, String code, String value) {
    if (!_globalTranslations.containsKey(culture)) {
      _globalTranslations[culture] = {};
    }
    _globalTranslations[culture]![code] = value;
  }

  List<Culture> avaliableCultures() {
    return _avaliableLanguages.keys.toList();
  }

  bool isSupported(String languageCode, String? countryCode) {
    return _avaliableLanguages.containsKey(Culture(languageCode, countryCode ?? ''));
  }

  String translate(String key, {Map<String, String> parameters = const {}, String? defaultMessage}) {
    final culture = LucidValidation.global.culture;
    final currentLanguage = getLanguage(culture);
    final translations = _globalTranslations[culture] ?? {};
    var message = defaultMessage ?? translations[key] ?? currentLanguage.getTranslation(key) ?? key;
    for (var key in parameters.keys) {
      final value = parameters[key]!;
      message = message.replaceAll('{$key}', value);
    }
    return message;
  }

  Language getLanguage(Culture culture) {
    return _avaliableLanguages[culture] ?? _avaliableLanguages[Culture('en')]!;
  }
}

class DefaultLanguageManager extends LanguageManager {}
