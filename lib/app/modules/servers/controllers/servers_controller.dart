import 'package:free_vpn/app/modules/home/controllers/home_controller.dart';
import 'package:free_vpn/app/modules/servers/providers/vpn_server_provider.dart';
import 'package:free_vpn/app/modules/servers/vpn_server_model.dart';
import 'package:get/get.dart';

class ServersController extends GetxController {
  VpnServerProvider _serverProvider = VpnServerProvider();
  HomeController _homeController = Get.find();
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

  getServer() {
    _serverProvider.getVPNServers().then(
      (vpnServers) {
        printInfo(info: 'Got Total: ${vpnServers.length}');
        if (vpnServers.isNotEmpty) {
          _homeController.vpnServer.value = vpnServers[1];
        }
      },
    );
  }
}
