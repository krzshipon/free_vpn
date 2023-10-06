import 'dart:convert';

import 'package:free_vpn/app/data/models/vpn_config.dart';
import 'package:free_vpn/app/modules/servers/vpn_server_model.dart';
import 'package:free_vpn/app/routes/app_pages.dart';
import 'package:free_vpn/app/services/vpn_engine.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final vpnServer = VpnServer().obs;

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

  selectLocation() {
    Get.toNamed(Routes.SERVERS);
  }

  connectVpn() async {
    VpnEngine.isConnected().then((isConnected) async {
      if (isConnected) {
        await VpnEngine.stopVpn();
      } else {
        final data = Base64Decoder()
            .convert(vpnServer.value.openVPNConfigDataBase64 ?? "");
        final config = Utf8Decoder().convert(data);
        VpnEngine.startVpn(
          VpnConfig(
              country: vpnServer.value.countryLong ?? "",
              username: 'vpn',
              password: 'vpn',
              config: config),
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
