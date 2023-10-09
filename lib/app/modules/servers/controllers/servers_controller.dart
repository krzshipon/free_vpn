import 'package:super_ui_kit/super_ui_kit.dart';

import '../../home/controllers/home_controller.dart';
import '../providers/vpn_server_provider.dart';
import '../vpn_server_model.dart';

class ServersController extends GetxController {
  final VpnServerProvider _serverProvider = VpnServerProvider();
  final HomeController _homeController = Get.find();
  final servers = <VpnServer>[].obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getServer();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getServer() {
    Get.showLoader();
    _serverProvider.getVPNServers().then(
      (vpnServers) {
        printInfo(info: 'Got Total: ${vpnServers.length}');
        if (vpnServers.isNotEmpty) {
          _homeController.vpnServer.value = vpnServers[1];
          servers.value = vpnServers;
          servers.refresh();
        }
        Get.hideLoader();
      },
    ).onError((error, stackTrace) {
      printError(info: error.toString());
      Get.hideLoader();
    });
  }

  selectVpnServer(int index) {
    _homeController.vpnServer.value = servers[index];
    _homeController.box.write('selectedServer', servers[index].toJson());
    Get.back();
  }
}
