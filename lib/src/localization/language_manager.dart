import '../../lucid_validation.dart';

abstract class LanguageManager {
  final _globalTranslations = <String, Map<String, String>>{};

  Language get currentLanguage => LucidValidation.global.language;

  void addTranslation(String culture, String code, String value) {
    if (!_globalTranslations.containsKey(culture)) {
      _globalTranslations[culture] = {};
    }
    _globalTranslations[culture]![code] = value;
  }

  String translate(String key, {Map<String, String> parameters = const {}, String? defaultMessage}) {
    final culture = currentLanguage.culture;
    final translations = _globalTranslations[culture] ?? {};
    var message = defaultMessage ?? translations[key] ?? currentLanguage.getTranslation(key) ?? key;
    for (var key in parameters.keys) {
      final value = parameters[key]!;
      message = message.replaceAll('{$key}', value);
    }
    return message;
  }
}

class DefaultLanguageManager extends LanguageManager {}
