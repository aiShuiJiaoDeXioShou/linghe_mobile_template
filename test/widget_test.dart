import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:linghe_mobile_template/app/app.dart';
import 'package:linghe_mobile_template/app/core/services/app_services.dart';

void main() {
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

  late Directory storageDirectory;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    storageDirectory = await Directory.systemTemp.createTemp(
      'linghe_mobile_template_test_',
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
          return storageDirectory.path;
        });
  });

  setUp(() async {
    await AppServices.init(storagePath: storageDirectory.path);
  });

  tearDown(() {
    Get.reset();
  });

  tearDownAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);

    if (storageDirectory.existsSync()) {
      await storageDirectory.delete(recursive: true);
    }
  });

  testWidgets('shows home after splash bootstrap', (tester) async {
    await tester.pumpWidget(const LingheMobileTemplateApp());
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('increments counter with GetX state', (tester) async {
    await tester.pumpWidget(const LingheMobileTemplateApp());
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
