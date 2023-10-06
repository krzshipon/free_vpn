import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import '../controllers/servers_controller.dart';

class ServersView extends GetView<ServersController> {
  const ServersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ServersView'),
        centerTitle: true,
      ),
      body: Center(
        child: CSButton.outline(
          title: 'Get Server',
          onTap: () => controller.getServer(),
        ),
      ),
    );
  }
}
