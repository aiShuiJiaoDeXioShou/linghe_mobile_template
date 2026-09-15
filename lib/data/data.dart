import 'package:get_storage/get_storage.dart';

class Data {
  Data._();

  static const _container = 'user_data';
  static const _settingsDarkModeKey = 'settings_dark_mode';

  static late GetStorage _box;

  static Future<void> init({String? storagePath}) async {
    _box = GetStorage(_container, storagePath);
    await _box.initStorage;
  }

  /// 设置黑暗模式
  static String get settingsDarkMode =>
      _box.read<String>(_settingsDarkModeKey) ?? 'system';

  static Future<void> setSettingsDarkMode(String value) =>
      _box.write(_settingsDarkModeKey, value);

  static Future<void> clear() => _box.erase();
}
