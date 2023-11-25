import 'package:flutter/material.dart';
import 'package:free_vpn/app/data/data_keys.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  setupLoaderUi();

  initTheme();

  runApp(
    GetMaterialApp(
      title: "Free Vpn",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: appLightTheme,
      darkTheme: appDarkTheme.copyWith(useMaterial3: true),
    ),
  );
}

void initTheme() {
  ThemeMode appThemeMode =
      GetStorage().read(kSelectedThemeMode) ?? ThemeMode.system;
  Get.changeThemeMode(appThemeMode);
}

void setupLoaderUi() {
  AppConfig.loaderScale = 0.8;
}
