import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:free_vpn/app/modules/servers/vpn_server_model.dart';
import 'package:free_vpn/app/routes/app_pages.dart';
import 'package:free_vpn/app/services/vpn_engine.dart';
import 'package:get/get.dart';
import 'package:openvpn_sf_flutter/openvpn_flutter.dart';

class HomeController extends GetxController {
  final vpnServer = VpnServer().obs;

  final vpnList = <VpnServer>[].obs;

  late OpenVPN openVPN;

  @override
  void onInit() {
    openVPN = OpenVPN(
        onVpnStatusChanged: _onVpnStatusChanged,
        onVpnStageChanged: _onVpnStageChanged);
    openVPN.initialize(
        groupIdentifier: "group.com.cyclicsoft.freevpn",

        ///Example 'group.com.laskarmedia.vpn'
        providerBundleIdentifier: "com.cyclicsoft.freevpn.vpnextension",

        ///Example 'id.laskarmedia.openvpnFlutterExample.VPNExtension'
        localizedDescription: "Free Vpn"

        ///Example 'Laskarmedia VPN'
        );
    super.onInit();
  }

  void _onVpnStatusChanged(VpnStatus? vpnStatus) {
    print(vpnStatus);
  }

  void _onVpnStageChanged(VPNStage? stage, String raw) {
    print(stage);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  selectLocation() {
    Get.toNamed(Routes.SERVERS);
  }

  connectVpn() async {
    openVPN.isConnected().then((value) async {
      if (value) {
        openVPN.disconnect();
      } else {
        // var vpn = vpnList[Random().nextInt(vpnList.length)];
        // final data = Base64Decoder().convert(vpn.openVPNConfigDataBase64 ?? "");
        // final config = Utf8Decoder().convert(data);
        openVPN.connect(
          await rootBundle.loadString('assets/configs/japan.ovpn'),
          "japan",
          username: 'vpn',
          password: 'vpn',
          bypassPackages: [],
          // In iOS connection can stuck in "connecting" if this flag is "false".
          // Solution is to switch it to "true".
          certIsRequired: true,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    VpnEngine.stopVpn();
  }
}
