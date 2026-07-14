import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'config/app_config.dart';
import 'config/storage_keys.dart';
import 'generated/locales.g.dart';
import 'routes/app_pages.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

class LingheMobileTemplateApp extends StatefulWidget {
  const LingheMobileTemplateApp({super.key});

  @override
  State<LingheMobileTemplateApp> createState() =>
      _LingheMobileTemplateAppState();
}

class _LingheMobileTemplateAppState extends State<LingheMobileTemplateApp>
    with WidgetsBindingObserver {
  static const _fallbackLocale = Locale('zh', 'CN');
  static const _supportedLocales = [Locale('zh', 'CN'), Locale('en', 'US')];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
      translationsKeys: AppTranslation.translations,
      locale: _initialLocale(),
      fallbackLocale: _fallbackLocale,
      supportedLocales: _supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }

  Locale _initialLocale() {
    final deviceLocale = Get.deviceLocale;
    if (deviceLocale == null) {
      return _fallbackLocale;
    }

    for (final supportedLocale in _supportedLocales) {
      if (supportedLocale.languageCode == deviceLocale.languageCode) {
        return supportedLocale;
      }
    }

    return _fallbackLocale;
  }

  ThemeMode _initialThemeMode() {
    if (!Get.isRegistered<StorageService>()) {
      return ThemeMode.system;
    }

    final isDarkMode = Get.find<StorageService>().read<bool>(
      StorageKeys.settingsDarkMode,
    );

    if (isDarkMode == null) {
      return ThemeMode.system;
    }

    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
