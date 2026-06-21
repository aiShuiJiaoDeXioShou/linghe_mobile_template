part of 'app_pages.dart';

abstract final class Routes {
  static const splash = _Paths.splash;
  static const home = _Paths.home;
  static const settings = _Paths.settings;
}

abstract final class _Paths {
  static const splash = '/';
  static const home = '/home';
  static const settings = '/settings';
}
