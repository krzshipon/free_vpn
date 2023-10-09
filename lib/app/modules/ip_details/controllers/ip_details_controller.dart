import 'package:free_vpn/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class IpDetailsController extends GetxController {
  final homeController = Get.find<HomeController>();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
