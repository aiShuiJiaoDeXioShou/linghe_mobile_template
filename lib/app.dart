import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linghe_mobile_template/data/data.dart';

import 'config/app_config.dart';
import 'locale/app_locale.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';

class LingheMobileTemplateApp extends StatelessWidget {
  const LingheMobileTemplateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _initialThemeMode(),
      translations: AppLocale(),
      locale: AppLocale.locale,
      fallbackLocale: AppLocale.fallbackLocale,
      supportedLocales: AppLocale.supportedLocales,
      localizationsDelegates: AppLocale.localizationsDelegates,
    );
  }

  ThemeMode _initialThemeMode() {
    return switch (Data.settingsDarkMode) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }
}
