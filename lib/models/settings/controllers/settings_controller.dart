import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linghe_mobile_template/data/data.dart';

import '../../../generated/locales.g.dart';

class SettingsController extends GetxController {
  final isDarkMode = (Data.settingsDarkMode == 'dark').obs;

  Future<void> toggleDarkMode(bool value) async {
    final themeMode = value ? ThemeMode.dark : ThemeMode.light;
    await Data.setSettingsDarkMode(themeMode.name);
    Get.changeThemeMode(themeMode);
  }

  Future<void> clearLocalCache() async {
    await Data.clear();

    Get.snackbar(
      LocaleKeys.settings_cache_cleared_title.tr,
      LocaleKeys.settings_cache_cleared_message.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
