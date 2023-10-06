import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:super_ui_kit/super_ui_kit.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      floatingActionButton: CSIconButton(
        icon: Icons.location_on_rounded,
        onTap: () => controller.selectLocation(),
      ),
      body:  Center(
        child: CSButton.outline(title: 'Connect', onTap: () => controller.connectVpn(),),
      ),
    );
  }
}
