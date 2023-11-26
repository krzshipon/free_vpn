import 'package:free_vpn/app/modules/home/controllers/home_controller.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import '../../../data/app_constants.dart';
import '../../../data/data_keys.dart';
import '../providers/vpn_server_provider.dart';
import '../vpn_server_model.dart';

class ServersController extends GetxController {
  //Required libs, controllers & services
  final box = GetStorage();
  final VpnServerProvider _serverProvider = VpnServerProvider();
  final HomeController _homeController = Get.find<HomeController>();

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
    box.listenKey(kVpnServers, (dynamic data) {
      printInfo(info: 'listenKey => Value updated for $kVpnServers');
      if (data != null) {
        // Convert the dynamic data back to a List of VpnServer
        final List<VpnServer> updatedList = (data as List<dynamic>)
            .map((json) => VpnServer.fromJson(json))
            .toList();
        printInfo(info: 'listenKey => [✔] Updated List: ${updatedList.length}');
        if (updatedList.isNotEmpty) {
          servers.value = updatedList;
          servers.refresh();
        }
      } else {
        printInfo(info: 'Key $kVpnServers was deleted');
        printInfo(info: 'listenKey => [✘] Key: $kVpnServers , Value: Null');
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

  /// Fetches VPN servers from storage or triggers a provider refresh based on the last update time.
  ///
  /// - If last update within [ktVpnServersRefreshTime], uses stored data.
  /// - If last update time not found or duration elapsed, triggers a refresh from the provider.
  getVpnServers() {
    try {
      printInfo(info: '>>> Start getVpnServers');

      String? vpnServerLastUpdatedTimeStamp =
          box.read<String>(kVpnServersUpdatedAt);

      if (vpnServerLastUpdatedTimeStamp != null) {
        var lastUpdatedAt = DateTime.parse(vpnServerLastUpdatedTimeStamp);

        if (DateTime.now().difference(lastUpdatedAt) <
            ktVpnServersRefreshTime) {
          // In duration => get from storage
          final List<VpnServer> storedVpnList =
              (box.read<List<dynamic>>(kVpnServers) ?? [])
                  .map((json) => VpnServer.fromJson(json))
                  .toList();

          if (storedVpnList.isNotEmpty) {
            printInfo(
                info:
                    'getVpnServers => [✔] Using stored VPN servers.');
            servers.value = storedVpnList;
            servers.refresh();
          } else {
            printInfo(
                info:
                    'getVpnServers => [✘] Stored VPN servers list is empty. Refreshing from provider.');
            refreshVpnServersFromProvider();
          }
        } else {
          // Time elapsed => refresh VPN servers
          printInfo(
              info:
                  'getVpnServers => Duration elapsed. Refreshing VPN servers from provider.');
          refreshVpnServersFromProvider();
        }
      } else {
        // VPN servers last update time not found => refresh VPN servers
        printInfo(
            info:
                'getVpnServers => VPN servers last update time not found. Refreshing from provider.');
        refreshVpnServersFromProvider();
      }
      printInfo(info: '<<< End getVpnServers');
    } catch (e) {
      printError(info: 'getVpnServers => ⚠ $e');
      refreshVpnServersFromProvider();
    }
  }

  selectVpnServer(int index) {
    _homeController.isSelection = true;
    box.write(kSelectedVpnServer, servers[index].toJson());
    Get.back();
  }

  refreshVpnServersFromProvider() {
    _serverProvider.refreshVpnServers();
  }
}
