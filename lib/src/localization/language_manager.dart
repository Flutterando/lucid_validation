import '../../lucid_validation.dart';
import 'languages/portuguese_brazillian_language.dart';

final _avaliableLanguages = <Culture, Language>{
  Culture('pt', 'BR'): PortugueseBrasillianLanguage(),
  Culture('pt'): PortugueseBrasillianLanguage(),
  Culture('en'): EnglishLanguage(),
  Culture('en', 'US'): EnglishLanguage(),
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
