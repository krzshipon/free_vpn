import 'package:super_ui_kit/super_ui_kit.dart';

import '../../../data/app_constants.dart';
import '../../../data/data_keys.dart';
import '../../home/controllers/home_controller.dart';
import '../providers/vpn_server_provider.dart';
import '../vpn_server_model.dart';

class ServersController extends GetxController {
  //Required libs, controllers & services
  final box = GetStorage();
  final VpnServerProvider _serverProvider = VpnServerProvider();
  final HomeController _homeController = Get.find();

  //Required Fields
  final servers = <VpnServer>[].obs;

  //Listeners => Must dispose on close
  Function()? serversListener;

  @override
  void onInit() {
    super.onInit();
    registerListeners();
  }

  void registerListeners() {
    //Vpn Servers
    box.listenKey(kVpnServers, (vpnServers) {
      if (vpnServers != null) {
        List<VpnServer> vpnServerList = vpnServers;
        if (vpnServerList.isNotEmpty) {
          servers.value = vpnServers;
          servers.refresh();
        }
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  void loadData() {
    //Vpn Server
    getVpnServers();
  }

  @override
  void onClose() {
    //Dispose listeners
    serversListener?.call();
    super.onClose();
  }

  getVpnServers() {
    String? vpnServerLastUpdatedTimeStamp =
        box.read<String>(kVpnServersUpdatedAt);
    if (vpnServerLastUpdatedTimeStamp != null) {
      if (DateTime.now()
              .difference(DateTime.parse(vpnServerLastUpdatedTimeStamp)) <
          ktVpnServersRefreshTime) {
        //In duration => get from storage
        var vpnServers = box.read(kVpnServers);
        if (vpnServers != null) {
          List<VpnServer> vpnServerList = vpnServers;
          if (vpnServerList.isNotEmpty) {
            servers.value = vpnServers;
            servers.refresh();
          }
        }
      } else {
        //Time elapsed => refresh vpn servers
        refreshVpnServersFromProvider();
      }
    } else {
      //Vpn servers last update time not found => refresh vpn servers
      refreshVpnServersFromProvider();
    }
  }

  refreshVpnServersFromProvider() {
    //Calling provider to refresh vpn server data...
    _serverProvider.refreshVpnServers();
  }

  selectVpnServer(int index) {
    _homeController.vpnServer.value = servers[index];
    _homeController.box.write(kSelectedVpnServer, servers[index].toJson());
    Get.back();
  }
}
