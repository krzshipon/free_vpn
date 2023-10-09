import 'package:flutter/material.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import '../controllers/servers_controller.dart';
import 'server_card_view.dart';

class ServersView extends GetView<ServersController> {
  const ServersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CSHomeWidget(
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
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.servers.length,
                itemBuilder: (context, index) => ServerCardView(
                  controller.servers[index],
                  onTap: () => controller.selectVpnServer(index),
                ),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
