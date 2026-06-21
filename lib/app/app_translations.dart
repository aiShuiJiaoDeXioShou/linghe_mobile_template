import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static const fallbackLocale = Locale('zh', 'CN');
  static const supportedLocales = [Locale('zh', 'CN'), Locale('en', 'US')];

  static Locale get locale {
    final deviceLocale = Get.deviceLocale;
    if (deviceLocale == null) {
      return fallbackLocale;
    }

    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == deviceLocale.languageCode) {
        return supportedLocale;
      }
    }

    return fallbackLocale;
  }

  @override
  Map<String, Map<String, String>> get keys => {
    'zh_CN': {
      'app_name': 'Linghe 移动端模板',
      'splash_status': '正在准备工作台',
      'home_title': '工作台',
      'home_greeting': '你好，Linghe',
      'home_summary': '今日概览',
      'metric_done': '已完成',
      'metric_pending': '待处理',
      'metric_messages': '消息',
      'counter_title': '计数',
      'counter_increment': '增加计数',
      'settings_title': '设置',
      'settings_theme': '深色模式',
      'settings_theme_desc': '跟随当前应用设置切换主题',
      'settings_storage': '清理本地缓存',
      'settings_storage_desc': '清空 GetStorage 中的模板数据',
      'settings_cache_cleared_title': '已清理',
      'settings_cache_cleared_message': '本地缓存已清空',
      'settings_about': '关于模板',
      'settings_about_desc': 'Flutter + GetX 项目骨架',
    },
    'en_US': {
      'app_name': 'Linghe Mobile Template',
      'splash_status': 'Preparing workspace',
      'home_title': 'Dashboard',
      'home_greeting': 'Hello, Linghe',
      'home_summary': 'Today',
      'metric_done': 'Done',
      'metric_pending': 'Pending',
      'metric_messages': 'Messages',
      'counter_title': 'Counter',
      'counter_increment': 'Increase counter',
      'settings_title': 'Settings',
      'settings_theme': 'Dark mode',
      'settings_theme_desc': 'Switch the current app theme',
      'settings_storage': 'Clear local cache',
      'settings_storage_desc': 'Remove template data from GetStorage',
      'settings_cache_cleared_title': 'Cleared',
      'settings_cache_cleared_message': 'Local cache has been cleared',
      'settings_about': 'About template',
      'settings_about_desc': 'Flutter + GetX project skeleton',
    },
  };
}
