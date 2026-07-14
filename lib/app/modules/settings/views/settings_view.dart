import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.settings_title.tr)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Obx(
              () => SwitchListTile.adaptive(
                value: controller.isDarkMode.value,
                onChanged: controller.toggleDarkMode,
                secondary: const Icon(Icons.dark_mode_outlined),
                title: Text(LocaleKeys.settings_theme.tr),
                subtitle: Text(LocaleKeys.settings_theme_desc.tr),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(LocaleKeys.settings_storage.tr),
              subtitle: Text(LocaleKeys.settings_storage_desc.tr),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: controller.clearLocalCache,
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(LocaleKeys.settings_about.tr),
              subtitle: Text(LocaleKeys.settings_about_desc.tr),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
