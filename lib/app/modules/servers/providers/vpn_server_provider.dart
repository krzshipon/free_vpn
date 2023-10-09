import 'package:csv/csv.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import '../vpn_server_model.dart';

class VpnServerProvider extends GetConnect {
  Future<List<VpnServer>> getVPNServers() async {
    final List<VpnServer> vpnList = [];

    try {
      final res = await get('http://www.vpngate.net/api/iphone');
      final csvString = res.body.split("#")[1].replaceAll('*', '');

      List<List<dynamic>> list = const CsvToListConverter().convert(csvString);

      final header = list[0];

      for (int i = 1; i < list.length - 1; ++i) {
        Map<String, dynamic> tempJson = {};

        for (int j = 0; j < header.length; ++j) {
          tempJson.addAll({header[j].toString(): list[i][j]});
        }
        vpnList.add(VpnServer.fromJson(tempJson));
        printInfo(info: 'Server Score: $i: ${vpnList[i - 1].score}');
      }
    } catch (e) {
      printError(info: '$e');
    }
    // vpnList.shuffle();

    // if (vpnList.isNotEmpty) Pref.vpnList = vpnList;

    return vpnList;
  }
}
