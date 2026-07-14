import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../config/app_config.dart';

class StorageService extends GetxService {
  StorageService._(this._box);

  final GetStorage _box;

  static Future<StorageService> init({String? storagePath}) async {
    final box = GetStorage(AppConfig.storageContainerName, storagePath);
    await box.initStorage;

    return Get.put<StorageService>(StorageService._(box), permanent: true);
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  bool readBool(String key, {bool defaultValue = false}) {
    return _box.read<bool>(key) ?? defaultValue;
  }

  Future<void> write(String key, Object? value) {
    return _box.write(key, value);
  }

  Future<void> remove(String key) {
    return _box.remove(key);
  }

  Future<void> clear() {
    return _box.erase();
  }
}
