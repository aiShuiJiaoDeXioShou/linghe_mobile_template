import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/storage_keys.dart';
import '../../../generated/locales.g.dart';
import '../../../services/storage_service.dart';

class SettingsController extends GetxController {
  final isDarkMode = false.obs;

  StorageService get _storage => Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.readBool(
      StorageKeys.settingsDarkMode,
      defaultValue: Get.isDarkMode,
    );
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    await _storage.write(StorageKeys.settingsDarkMode, value);
  }

  Future<void> clearLocalCache() async {
    await _storage.clear();
    isDarkMode.value = Get.isDarkMode;

    Get.snackbar(
      LocaleKeys.settings_cache_cleared_title.tr,
      LocaleKeys.settings_cache_cleared_message.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
