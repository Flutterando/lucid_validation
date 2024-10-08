import 'package:lucid_validation/lucid_validation.dart';

class CustomLanguageManager extends LanguageManager {
  CustomLanguageManager() {
    addTranslation(Culture('pt', 'BR'), 'passwordEqualTo',
        "'{PropertyName}' deve ser igual.");
    addTranslation(
        Culture('pt'), 'passwordEqualTo', "'{PropertyName}' deve ser igual.");
    addTranslation(Culture('en', 'US'), 'passwordEqualTo',
        "'{PropertyName}' must be equal.");
    addTranslation(
        Culture('en'), 'passwordEqualTo', "'{PropertyName}' must be equal.");
  }
}
