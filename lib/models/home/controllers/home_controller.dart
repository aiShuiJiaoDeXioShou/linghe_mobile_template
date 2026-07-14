import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final counter = 0.obs;

  void incrementCounter() {
    counter.value++;
  }

  void openSettings() {
    Get.toNamed(Routes.settings);
  }
}
