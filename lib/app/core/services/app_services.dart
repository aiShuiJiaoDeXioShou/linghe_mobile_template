import 'package:get/get.dart';

import 'api_client.dart';
import 'storage_service.dart';

abstract final class AppServices {
  static Future<void> init({String? storagePath}) async {
    if (!Get.isRegistered<StorageService>()) {
      await StorageService.init(storagePath: storagePath);
    }

    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(ApiClient(), permanent: true);
    }
  }
}
