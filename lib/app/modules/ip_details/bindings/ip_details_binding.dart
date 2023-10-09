import 'package:get/get.dart';

import '../controllers/ip_details_controller.dart';

class IpDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IpDetailsController>(
      () => IpDetailsController(),
    );
  }
}
