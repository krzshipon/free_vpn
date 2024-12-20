import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/ip_details/bindings/ip_details_binding.dart';
import '../modules/ip_details/views/ip_details_view.dart';
import '../modules/servers/bindings/servers_binding.dart';
import '../modules/servers/views/servers_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SERVERS,
      page: () => const ServersView(),
      binding: ServersBinding(),
    ),
    GetPage(
      name: _Paths.IP_DETAILS,
      page: () => const IpDetailsView(),
      binding: IpDetailsBinding(),
    ),
  ];
}
