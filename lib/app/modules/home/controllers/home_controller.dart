import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final counter = 0.obs;

  void incrementCounter() {
    counter.value++;
  }

  void openSettings() {
    Get.toNamed(Routes.settings);
  }
}
