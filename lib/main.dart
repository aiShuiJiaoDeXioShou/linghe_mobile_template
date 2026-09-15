import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'data/data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Data.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const LingheMobileTemplateApp());
}
