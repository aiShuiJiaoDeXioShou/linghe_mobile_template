import 'package:get/get.dart';

import '../models/home/bindings/home_binding.dart';
import '../models/home/views/home_view.dart';
import '../models/settings/bindings/settings_binding.dart';
import '../models/settings/views/settings_view.dart';
import '../models/splash/bindings/splash_binding.dart';
import '../models/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  const AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
