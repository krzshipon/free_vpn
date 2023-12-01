import 'package:super_ui_kit/super_ui_kit.dart';

import '../../../common/controllers/ad_controller.dart';
import '../../home/controllers/home_controller.dart';

class IpDetailsController extends GetxController {
  final homeController = Get.find<HomeController>();
  final AdController adController = AdController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  void loadData() {
    //Ads
    loadAds();
  }

  @override
  void onClose() {
    //Dispose ads
    adController.nativeAd?.dispose();
    super.onClose();
  }

  void loadAds() {
    adController.loadNativeAd(); //load a native ad to show in bottom navbar
  }
}
