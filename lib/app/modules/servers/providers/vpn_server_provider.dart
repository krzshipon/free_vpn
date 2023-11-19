import 'package:csv/csv.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import '../../../data/data_keys.dart';
import '../vpn_server_model.dart';

class VpnServerProvider extends GetConnect {
  final box = GetStorage();

  /// Fetch vpn servers from VpnGate public api
  Future<void> refreshVpnServers() async {
    final List<VpnServer> vpnList = [];

    try {
      Get.showLoader();
      printInfo(
          info:
              'refreshVpnServers => Trying to fetch servers from vpngate api >>>> ');
      final res = await get('http://www.vpngate.net/api/iphone');
      printInfo(
          info:
              'refreshVpnServers => Success <<<< Get response of vpn servers');
      final csvString = res.body.split("#")[1].replaceAll('*', '');
      List<List<dynamic>> list = const CsvToListConverter().convert(csvString);

      final header = list[0];

      for (int i = 1; i < list.length - 1; ++i) {
        Map<String, dynamic> tempJson = {};
        for (int j = 0; j < header.length; ++j) {
          tempJson.addAll({header[j].toString(): list[i][j]});
        }
        vpnList.add(VpnServer.fromJson(tempJson));
        printInfo(
            info:
                'refreshVpnServers => Server Score: $i: ${vpnList[i - 1].score}');
      }

      if (vpnList.isNotEmpty) {
        box.write(kVpnServers, vpnList);
        box.write(kSelectedVpnServer, vpnList[1]);
      }
      box.write(kVpnServersUpdatedAt, DateTime.now().toIso8601String());
      printInfo(info: 'refreshVpnServers => Total Server: ${vpnList.length}');
      Get.hideLoader();
    } catch (e) {
      Get.hideLoader();
      printError(info: 'refreshVpnServers => $e');
    }
  }
}
