import 'package:flutter/material.dart';

import 'package:super_ui_kit/super_ui_kit.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  setupLoaderUi();

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: appLightTheme.copyWith(useMaterial3: false),
    ),
  );
}

void setupLoaderUi() {
  AppConfig.loaderScale = 0.8;
}
