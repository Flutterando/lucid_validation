import 'package:example/presentation/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lucid_validation/lucid_validation.dart';

import 'domain/validations/language_manager.dart';

void main() {
  LucidValidation.global.languageManager = CustomLanguageManager();

  runApp(const MyApp());
}

final globalLocale = ValueNotifier(Locale('en'));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: globalLocale,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          locale: value,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('pt', 'BR'),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            LucidLocalizationDelegate.delegate,
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const LoginPage(),
        );
      },
    );
  }
}

class LucidLocalizationDelegate extends LocalizationsDelegate<Culture> {
  const LucidLocalizationDelegate();

  static final delegate = LucidLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return LucidValidation.global.languageManager.isSupported(
      locale.languageCode,
      locale.countryCode,
    );
  }

  @override
  Future<Culture> load(Locale locale) async {
    print(locale);
    final culture = Culture(locale.languageCode, locale.countryCode ?? '');
    LucidValidation.global.culture = culture;
    return culture;
  }

  @override
  bool shouldReload(LocalizationsDelegate<Culture> old) {
    return true;
  }
}
