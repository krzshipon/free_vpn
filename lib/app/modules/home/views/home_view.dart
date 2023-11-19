import 'package:flutter/material.dart';
import 'package:free_vpn/app/data/app_constants.dart';
import 'package:free_vpn/app/data/models/vpn_status.dart';
import 'package:free_vpn/app/services/vpn_engine.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import '../../servers/views/server_card_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var powerButtonRadius = Get.height / 8 - 10;
    return CSHomeWidget(
      child: Column(
        children: [
          verticalSpaceRegular,
          CSHeader(
            headerType: HeaderType.home,
            title: "Free Vpn",
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                CSIconButton(
                  icon: Icons.brightness_medium_rounded,
                  onTap: () => controller.changeTheme(),
                ),
                CSIconButton(
                  icon: Icons.info_outlined,
                  onTap: () => controller.showIpDetails(),
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
          StreamBuilder<VpnStatus?>(
            initialData: VpnStatus(),
            stream: VpnEngine.vpnStatusSnapshot(),
            builder: ((context, snapshot) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CSCard(
                          margin: EdgeInsets.only(right: 5),
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CsIcon(Icons.download_sharp),
                                horizontalSpaceTiny,
                                CSText("Download")
                              ],
                            ),
                            verticalSpaceTiny,
                            CSText.label(snapshot.data?.byteIn != null &&
                                    !(snapshot.data?.byteIn.isBlank ?? true)
                                ? snapshot.data?.byteIn ?? '0 KB - 0 B/s'
                                : '0 KB - 0 B/s')
                          ],
                        ),
                      ),
                      Expanded(
                        child: CSCard(
                          margin: EdgeInsets.only(left: 5),
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CsIcon(Icons.download_sharp),
                                horizontalSpaceTiny,
                                CSText("Upload")
                              ],
                            ),
                            verticalSpaceTiny,
                            CSText.label(snapshot.data?.byteOut != null &&
                                    !(snapshot.data?.byteOut.isBlank ?? true)
                                ? snapshot.data?.byteOut ?? '0 KB - 0 B/s'
                                : '0 KB - 0 B/s')
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          verticalSpaceMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => CSText(
                  "Your IP : ${controller.ipDetails.value.query ?? 'fetching..'}",
                ),
              ),
            ],
          ),
          verticalSpaceMedium,
          Container(
            height: Get.height / 4,
            child: Obx(
              () => Center(
                child: CircleAvatar(
                  backgroundColor:
                      controller.getPowerButtonColor.withOpacity(.1),
                  radius: powerButtonRadius,
                  child: CircleAvatar(
                    backgroundColor:
                        controller.getPowerButtonColor.withOpacity(.7),
                    radius: powerButtonRadius - 15,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () => controller.connectVpn(),
                      child: CircleAvatar(
                        backgroundColor: controller.getPowerButtonColor,
                        radius: powerButtonRadius - 30,
                        child: Transform.scale(
                          scale: 2,
                          child: const CsIcon(
                            Icons.power_settings_new_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => CsIcon(
                    Icons.shield_moon_outlined,
                    color: controller.getVpnStateColor,
                  )),
              horizontalSpaceTiny,
              Obx(() => CSText(controller.vpnState.value)),
            ],
          ),
          verticalSpaceMedium,
          Obx(
            () => ServerCardView(
              controller.vpnServer.value,
              onTap: () => controller.selectLocation(),
            ),
          ),
          Expanded(
            child: Obx(
              () => LottieBuilder.asset(
                kHomeAnimation,
                animate: (controller.vpnState.value ==
                        VpnEngine.vpnConnecting ||
                    controller.vpnState.value == VpnEngine.vpnConnected ||
                    controller.vpnState.value == VpnEngine.vpnAuthenticating),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
