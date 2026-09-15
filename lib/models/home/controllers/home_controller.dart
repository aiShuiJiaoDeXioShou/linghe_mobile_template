import 'package:get/get.dart';
import 'package:linghe_mobile_template/routes/app_pages.dart';

class HomeController extends GetxController {
  final counter = 0.obs;

  void incrementCounter() {
    counter.value++;
  }

  void openSettings() {
    Get.toNamed(AppPages.settings);
  }
}
