import 'package:flutter/material.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import '../controllers/servers_controller.dart';
import 'server_card_view.dart';

class ServersView extends GetView<ServersController> {
  const ServersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CSHomeWidget(
      floatingActionButton: CSIconButton(
        icon: Icons.refresh_sharp,
        onTap: () => controller.refreshVpnServersFromProvider(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpaceRegular,
          const CSHeader(
            title: "Vpn Servers",
          ),
          verticalSpaceRegular,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: CSText.label(
                    '* For better speed, select a server with higher bandwith but less connections.',
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Expanded(
              child: controller.servers.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.servers.length,
                      itemBuilder: (context, index) => ServerCardView(
                        controller.servers[index],
                        onTap: () => controller.selectVpnServer(index),
                      ),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                    )
                  : const Center(
                      child: CSText.label("No server found! Refresh Now..."),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
