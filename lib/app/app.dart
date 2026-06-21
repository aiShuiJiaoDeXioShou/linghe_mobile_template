import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app_translations.dart';
import 'bindings/initial_binding.dart';
import 'core/config/app_config.dart';
import 'core/config/storage_keys.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';

class LingheMobileTemplateApp extends StatefulWidget {
  const LingheMobileTemplateApp({super.key});

  @override
  State<LingheMobileTemplateApp> createState() =>
      _LingheMobileTemplateAppState();
}

class _LingheMobileTemplateAppState extends State<LingheMobileTemplateApp>
    with WidgetsBindingObserver {
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
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _initialThemeMode(),
      translations: AppTranslations(),
      locale: AppTranslations.locale,
      fallbackLocale: AppTranslations.fallbackLocale,
      supportedLocales: AppTranslations.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
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
