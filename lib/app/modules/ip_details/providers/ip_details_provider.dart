import 'dart:convert';

import 'package:super_ui_kit/super_ui_kit.dart';

import '../ip_details_model.dart';

class IpDetailsProvider extends GetConnect {
  Future<IpDetails?> getIPDetails() async {
    var result = IpDetails();
    try {
      final res = await get('http://ip-api.com/json');
      final data = jsonDecode(res.bodyString!);
      result = IpDetails.fromJson(data);
    } catch (e) {
      printError(info: e.toString());
    }

    return result;
  }
}
