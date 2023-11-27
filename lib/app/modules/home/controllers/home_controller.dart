import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:free_vpn/app/common/controllers/ad_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  final AdController adController = AdController();

  //Required Fields
  final vpnServer = VpnServer(countryLong: 'Please select a server...').obs;
  final vpnState = VpnEngine.vpnDisconnected.obs;
  final ipDetails = IpDetails().obs;
  var isSelection = false;

  //Listeners => Must dispose on close
  Function()? selectedServerListener;

  //Ads
  NativeAd? nativeAd;
  final nativeAdIsLoaded = false.obs;

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
    //Ads
    loadAds();
  }

  @override
  void onClose() {
    VpnEngine.stopVpn();
    //Dispose listeners
    selectedServerListener?.call();
    super.onClose();
  }

  /// Fetches the selected VPN server from storage or triggers a provider refresh.
  ///
  /// - Checks the last update time of VPN servers.
  /// - If within [ktVpnServersRefreshTime], attempts to get the server from storage.
  ///   - If successful, updates [vpnServer] and refreshes state.
  ///   - If parsing fails, logs the error and triggers a provider refresh.
  /// - If no server found in storage or the last update time elapsed, triggers a refresh from the provider.
  void getVpnServer() {
    try {
      printInfo(info: '>>> Start getVpnServer');

      String? lastUpdateTime = box.read<String>(kVpnServersUpdatedAt);

      if (lastUpdateTime != null) {
        if (DateTime.now().difference(DateTime.parse(lastUpdateTime)) <
            ktVpnServersRefreshTime) {
          var savedVpnServer = box.read(kSelectedVpnServer);
          if (savedVpnServer != null) {
            // In duration => get from storage
            printInfo(info: 'getVpnServer => [✔] VPN server found in storage.');
            vpnServer.value = VpnServer.fromJson(savedVpnServer);
          } else {
            // No server found in storage => Refresh now
            printInfo(
                info:
                    'getVpnServer => [✘] No saved VPN server found. Refreshing from provider.');
            _serverProvider.refreshVpnServers();
          }
        } else {
          // Time elapsed => refresh VPN servers
          printInfo(
              info:
                  'getVpnServer => Duration elapsed. Refreshing VPN servers from provider.');
          _serverProvider.refreshVpnServers();
        }
      } else {
        // VPN servers last update time not found => refresh VPN servers
        printInfo(
            info:
                'getVpnServer => Last update time not found. Refreshing VPN servers from provider.');
        _serverProvider.refreshVpnServers();
      }

      printInfo(info: '<<< End getVpnServer');
    } catch (error) {
      // Error during execution. Log error and refresh from provider.
      printError(info: 'getVpnServer => ⚠ $error');
      _serverProvider.refreshVpnServers();
    }
  }

  /// Retrieves IP details asynchronously and updates the [ipDetails] value.
  ///
  /// - Initializes [ipDetails] with an empty instance.
  /// - Delays execution by 3 seconds to simulate asynchronous operation.
  /// - Calls the [_ipDetailsProvider.getIPDetails()] method.
  ///   - If details are received, updates [ipDetails] with the result.
  void getIpDetails() {
    try {
      // Log start of the method
      printInfo(info: '>>> Start getIpDetails');

      // Initialize ipDetails with an empty instance
      ipDetails.value = IpDetails();

      // Simulate asynchronous operation with a delay
      Future.delayed(const Duration(seconds: 3)).then((value) {
        // Fetch IP details from the provider
        _ipDetailsProvider.getIPDetails().then((result) {
          // If details are received, update ipDetails
          if (result != null) {
            printInfo(
                info:
                    'getIpDetails => [✔] Ip details are received, updating ipDetails');
            ipDetails.value = result;
          } else {
            printInfo(info: 'getIpDetails => [✘] Ip details are received Null');
          }
        }).onError((error, stackTrace) {
          printError(info: 'getIpDetails => ⚠ $error');
        });
      });

      printInfo(info: '<<< End getIpDetails');
    } catch (error) {
      printError(info: 'getIpDetails => ⚠ $error');
    }
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

  void loadAds() {
    adController.loadNativeAd(); //load a native ad to show in bottom navbar
  }
}
