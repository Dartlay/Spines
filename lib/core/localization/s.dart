import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../generated/localization/app_localizations.dart';

class S {
  S._();

  static const Locale en = Locale('en');
  static const Locale ru = Locale('ru');

  static bool isEn(Locale locale) => locale == en;

  static const List<Locale> supportedLocales = [en, ru];

  static final Map<String, Locale> _languageMap = {
    'English': en,
    'Русский': ru,
  };

  static List<String> get availableLanguageNames => _languageMap.keys.toList();

  static Locale getLocaleByName(String name) {
    return _languageMap[name] ?? en;
  }

  static String getNameByLocale(Locale locale) {
    final entry = _languageMap.entries.firstWhere(
      (element) => element.value.languageCode == locale.languageCode,
      orElse: () => _languageMap.entries.first,
    );
    return entry.key;
  }

  static const List<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? resolveLocale(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    if (locale == null) return supportedLocales.first;

    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }

    return supportedLocales.first;
  }

  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context);
}

extension ContextExt on BuildContext {
  AppLocalizations get tr => S.of(this);
}
