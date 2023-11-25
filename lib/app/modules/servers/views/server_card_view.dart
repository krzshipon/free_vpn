import 'package:flutter/material.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import '../../../util/app_util.dart';
import '../vpn_server_model.dart';

class ServerCardView extends GetView {
  final VpnServer vpnServer;
  final void Function()? onTap;
  const ServerCardView(this.vpnServer, {this.onTap, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var pingType =
        AppUtil.classifyPing(int.tryParse(vpnServer.ping ?? '0') ?? 0);
    var speedType = AppUtil.classifySpeed(vpnServer.speed ?? 0);
    var connectionType =
        AppUtil.classifyConnections(vpnServer.numVpnSessions ?? 0);
    return CSCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      children: [
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                verticalSpaceTiny,
                verticalSpaceTiny,
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0), //or 15.0
                  child: Container(
                    decoration: BoxDecoration(
                      color: (vpnServer.countryShort == null)
                          ? Colors.red.shade300
                          : null,
                      border:
                          Border.all(color: Get.theme.colorScheme.tertiary),
                    ),
                    height: 55.0,
                    width: 80.0,
                    child: (vpnServer.countryShort == null)
                        ? const CsIcon(
                            Icons.flag,
                            color: Colors.white,
                          )
                        : Image.asset(
                            'assets/flags/${vpnServer.countryShort!.toLowerCase()}.png'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: CsIcon(
                        Icons.wifi,
                        color: pingType == ConnectionType.good
                            ? Colors.green
                            : pingType == ConnectionType.avg
                                ? Colors.yellow
                                : Colors.red,
                      ),
                    ),
                    CSText.label("${vpnServer.ping ?? '-'} ms"),
                  ],
                ),
              ],
            ),
            horizontalSpaceRegular,
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CSText.title("${vpnServer.countryLong}"),
                  ),
                  verticalSpaceTiny,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 0.7,
                        child: CsIcon(
                          Icons.speed,
                          color: speedType == ConnectionType.good
                              ? Colors.green
                              : speedType == ConnectionType.avg
                                  ? Colors.yellow
                                  : Colors.red,
                        ),
                      ),
                      horizontalSpaceTiny,
                      CSText.label(AppUtil.formatBits(vpnServer.speed ?? 0, 2)),
                    ],
                  ),
                  // verticalSpaceTiny,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 0.7,
                        child: CsIcon(
                          Icons.group_outlined,
                          color: connectionType == ConnectionType.good
                              ? Colors.green
                              : connectionType == ConnectionType.avg
                                  ? Colors.yellow
                                  : Colors.red,
                        ),
                      ),
                      horizontalSpaceTiny,
                      CSText.label(
                          "${vpnServer.numVpnSessions ?? '-'} connections"),
                    ],
                  ),
                ],
              ),
            ),
            horizontalSpaceRegular,
            const CsIcon(Icons.arrow_forward_ios_sharp),
          ],
        )
      ],
    );
  }
}
