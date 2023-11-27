import 'package:flutter/material.dart';
import 'package:free_vpn/app/data/data_keys.dart';
import 'package:free_vpn/app/util/app_util.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize(); //Google Ads
  await GetStorage.init(); //Mini Storage like shared pref

  setupLoaderUi(); //Customize app loader
  initTheme(); //Initial app theme setup

  runApp(
    GetMaterialApp(
      title: "Free Vpn",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: appLightTheme,
      darkTheme: appDarkTheme.copyWith(useMaterial3: true),
      debugShowCheckedModeBanner: false,
    ),
  );
}

void initTheme() {
  String appThemeMode =
      GetStorage().read(kSelectedThemeMode) ?? ThemeMode.system.name;
  Get.changeThemeMode(AppUtil.getThemeModeFromName(appThemeMode));
}

void setupLoaderUi() {
  AppConfig.loaderScale = 0.8;
}
