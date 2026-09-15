import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import '../generated/locales.g.dart';

class AppLocale extends Translations {
  static const fallbackLocale = Locale('zh', 'CN');

  static const supportedLocales = [Locale('zh', 'CN'), Locale('en', 'US')];

  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? get locale => Get.deviceLocale;

  @override
  Map<String, Map<String, String>> get keys => AppTranslation.translations;
}
