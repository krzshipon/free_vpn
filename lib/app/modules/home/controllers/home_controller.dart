import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:free_vpn/app/modules/ip_details/ip_details_model.dart';
import 'package:free_vpn/app/modules/ip_details/providers/ip_details_provider.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import '../../../data/models/vpn_config.dart';
import '../../../routes/app_pages.dart';
import '../../../services/vpn_engine.dart';
import '../../servers/vpn_server_model.dart';

class HomeController extends GetxController {
  final box = GetStorage();
  final _ipDetailsProvider = IpDetailsProvider();

  final vpnServer = VpnServer(countryLong: 'Please select a server...').obs;
  final vpnState = VpnEngine.vpnDisconnected.obs;
  final ipDetails = IpDetails().obs;

  @override
  void onInit() {
    VpnEngine.vpnStageSnapshot().listen((event) {
      vpnState.value = event;
      if (event == VpnEngine.vpnConnected ||
          event == VpnEngine.vpnDisconnected) {
        getIpDetails();
      }
    });
    var savedServer = box.read('selectedServer');
    if (savedServer != null) {
      vpnServer.value = VpnServer.fromJson(savedServer);
    }
    super.onInit();
  }

  @override
  void onReady() {
    getIpDetails();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  selectLocation() {
    Get.toNamed(Routes.SERVERS);
  }

  Color get getPowerButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Get.theme.colorScheme.primary;

      case VpnEngine.vpnConnected:
        return Colors.green;

      default:
        return Colors.orangeAccent;
    }
  }

  Color get getVpnStateColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.redAccent;

      case VpnEngine.vpnConnected:
        return Colors.green;

      default:
        return Colors.orangeAccent;
    }
  }

  connectVpn() async {
    VpnEngine.isConnected().then((isConnected) async {
      if (isConnected) {
        await VpnEngine.stopVpn();
      } else {
        final data = const Base64Decoder()
            .convert(vpnServer.value.openVPNConfigDataBase64 ?? "");
        final config = const Utf8Decoder().convert(data);
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

  void getIpDetails() {
    ipDetails.value = IpDetails();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      _ipDetailsProvider.getIPDetails().then((result) {
        result?.printInfo();
        if (result != null) {
          ipDetails.value = result;
        }
      }).onError((error, stackTrace) {
        error.printError();
      });
    });
  }

  showIpDetails() {
    Get.toNamed(Routes.IP_DETAILS);
  }

  changeTheme() {}
}
