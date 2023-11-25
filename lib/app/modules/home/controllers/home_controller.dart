import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import '../../../data/app_constants.dart';
import '../../../data/data_keys.dart';
import '../../../data/models/vpn_config.dart';
import '../../../routes/app_pages.dart';
import '../../../services/vpn_engine.dart';
import '../../ip_details/ip_details_model.dart';
import '../../ip_details/providers/ip_details_provider.dart';
import '../../servers/providers/vpn_server_provider.dart';
import '../../servers/vpn_server_model.dart';

class HomeController extends GetxController {
  //Required libs, controllers & services
  final box = GetStorage();
  final _ipDetailsProvider = IpDetailsProvider();
  final VpnServerProvider _serverProvider = VpnServerProvider();

  //Required Fields
  final vpnServer = VpnServer(countryLong: 'Please select a server...').obs;
  final vpnState = VpnEngine.vpnDisconnected.obs;
  final ipDetails = IpDetails().obs;
  var isSelection = false;

  //Listeners => Must dispose on close
  Function()? selectedServerListener;

  @override
  void onInit() {
    super.onInit();
    registerListeners();
  }

  void registerListeners() {
    //Engine status...
    VpnEngine.vpnStageSnapshot().listen((event) {
      vpnState.value = event;
      if (event == VpnEngine.vpnConnected ||
          event == VpnEngine.vpnDisconnected) {
        getIpDetails();
      }
    });
    //Selected Server...
    selectedServerListener =
        box.listenKey(kSelectedVpnServer, (selectedVpnServer) {
      if (selectedVpnServer != null) {
        vpnServer.value = VpnServer.fromJson(selectedVpnServer);
        if (isSelection) {
          isSelection = !isSelection;
          connectVpn();
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
    getVpnServer();
    //Ip Detail
    getIpDetails();
  }

  @override
  void onClose() {
    VpnEngine.stopVpn();
    //Dispose listeners
    selectedServerListener?.call();
    super.onClose();
  }

  void getVpnServer() {
    String? vpnServerLastUpdatedTimeStamp =
        box.read<String>(kVpnServersUpdatedAt);
    if (vpnServerLastUpdatedTimeStamp != null) {
      var lastUpdatedAt = DateTime.parse(vpnServerLastUpdatedTimeStamp);
      if (DateTime.now().difference(lastUpdatedAt) < ktVpnServersRefreshTime) {
        // In duration => get from storage
        var savedVpnServer = box.read(kSelectedVpnServer);
        if (savedVpnServer != null) {
          try {
            vpnServer.value = VpnServer.fromJson(savedVpnServer);
          } catch (e) {
            printError(info: 'getVpnServer => $e');
            _serverProvider.refreshVpnServers();
          }
        } else {
          //No server found in storage => Refresh now
          _serverProvider.refreshVpnServers();
        }
      } else {
        //Time elapsed => refresh vpn servers
        _serverProvider.refreshVpnServers();
      }
    } else {
      //Vpn servers last update time not found => refresh vpn servers
      _serverProvider.refreshVpnServers();
    }
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

  selectLocation() {
    if (vpnState.value != VpnEngine.vpnDisconnected) {
      VpnEngine.stopVpn();
    }
    Get.toNamed(Routes.SERVERS);
  }

  bool get isVpnIsTryingToConnect {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return false;

      case VpnEngine.vpnConnected:
        return false;

      default:
        return true;
    }
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
    if (vpnState.value != VpnEngine.vpnAuthenticating &&
        vpnState.value != VpnEngine.vpnConnecting &&
        vpnState.value != VpnEngine.vpnPrepare &&
        vpnState.value != VpnEngine.vpnWaitConnection) {
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
  }

  @override
  void dispose() {
    super.dispose();
    VpnEngine.stopVpn();
  }

  showIpDetails() {
    Get.toNamed(Routes.IP_DETAILS);
  }

  changeTheme() {
    ThemeMode themeMode = Get.theme.brightness == Brightness.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    Get.changeThemeMode(themeMode);
    box.write(kSelectedThemeMode, themeMode.name);
  }
}
