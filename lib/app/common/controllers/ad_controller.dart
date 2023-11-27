import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdController extends GetxController {
  NativeAd? nativeAd;
  final nativeAdIsLoaded = false.obs;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  /// Loads a native ad using the provided ad unit ID and handles ad-related events.
  ///
  /// - Initializes a [NativeAd] with the specified ad unit ID.
  /// - Sets up a [NativeAdListener] to respond to ad loading, failure, closure, and click events.
  /// - Loads the native ad.
  void loadNativeAd() {
    // Log the start of the method
    printInfo(info: '>>> Start loadNativeAd');
    // Initialize a NativeAd with the given ad unit ID
    nativeAd = NativeAd(
      adUnitId: _adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          // Log when the native ad is loaded successfully
          printInfo(info: 'loadNativeAd => [✔] NativeAd loaded.');
          nativeAdIsLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          // Dispose the ad to free resources and log the failure
          printError(
              info: 'loadNativeAd => [✘] NativeAd failed to load: $error');
          ad.dispose();
        },
        onAdClosed: (ad) {
          printInfo(info: 'loadNativeAd => [c] NativeAd is closed');
          nativeAdIsLoaded.value = false;
        },
        onAdClicked: (ad) {
          printInfo(info: 'loadNativeAd => NativeAd clicked.');
          // Dispose the ad and load a new native ad on click
          ad.dispose();
          loadNativeAd();
        },
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        // Customization options for the ad's style (optional)
        templateType: TemplateType.small,
        cornerRadius: 10.0,
        // Additional styling options can be uncommented and customized as needed
        // mainBackgroundColor: Colors.purple,
        // callToActionTextStyle: NativeTemplateTextStyle(
        //   textColor: Colors.cyan,
        //   backgroundColor: Colors.red,
        //   style: NativeTemplateFontStyle.monospace,
        //   size: 16.0,
        // ),
        // primaryTextStyle: NativeTemplateTextStyle(
        //   textColor: Colors.red,
        //   backgroundColor: Colors.cyan,
        //   style: NativeTemplateFontStyle.italic,
        //   size: 16.0,
        // ),
        // secondaryTextStyle: NativeTemplateTextStyle(
        //   textColor: Colors.green,
        //   backgroundColor: Colors.black,
        //   style: NativeTemplateFontStyle.bold,
        //   size: 16.0,
        // ),
        // tertiaryTextStyle: NativeTemplateTextStyle(
        //   textColor: Colors.brown,
        //   backgroundColor: Colors.amber,
        //   style: NativeTemplateFontStyle.normal,
        //   size: 16.0,
        // ),
      ),
    )..load();
    // Log the end of the method
    printInfo(info: '<<< End loadNativeAd');
  }
}
