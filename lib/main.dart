import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'bootstrap/app_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppServices.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const LingheMobileTemplateApp());
}
