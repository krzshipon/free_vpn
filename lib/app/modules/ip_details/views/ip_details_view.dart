import 'package:flutter/material.dart';

import 'package:super_ui_kit/super_ui_kit.dart';

import '../controllers/ip_details_controller.dart';

class IpDetailsView extends GetView<IpDetailsController> {
  const IpDetailsView({Key? key}) : super(key: key);
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
            title: "IP Info",
          ),
          verticalSpaceLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0), //or 15.0
                child: Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color: (controller
                                  .homeController.ipDetails.value.countryCode ==
                              null)
                          ? Colors.red.shade300
                          : null,
                      border: Border.all(color: Get.theme.colorScheme.tertiary),
                    ),
                    height: 55.0,
                    width: 80.0,
                    child: (controller
                                .homeController.ipDetails.value.countryCode ==
                            null)
                        ? const CsIcon(
                            Icons.flag,
                            color: Colors.white,
                          )
                        : Image.asset(
                            'assets/flags/${controller.homeController.ipDetails.value.countryCode!.toLowerCase()}.png'),
                  ),
                ),
              ),
            ],
          ),
          verticalSpaceRegular,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => CSText(
                    'Your IP: ${controller.homeController.ipDetails.value.query ?? 'fetching...'}'),
              ),
            ],
          ),
          verticalSpaceRegular,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: CSCard(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      color: Get.theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CsIcon(
                              Icons.home,
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            horizontalSpaceTiny,
                            CSText.title(
                              'ISP',
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            horizontalSpaceTiny
                          ],
                        ),
                      ),
                    ),
                    verticalSpaceRegular,
                    CSText(controller.homeController.ipDetails.value.isp ??
                        'fetching...'),
                    verticalSpaceRegular
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: CSCard(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      color: Get.theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CsIcon(
                              Icons.location_on_outlined,
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            horizontalSpaceTiny,
                            CSText.title(
                              'Location',
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            horizontalSpaceTiny
                          ],
                        ),
                      ),
                    ),
                    verticalSpaceRegular,
                    Obx(() => CSText(_getLocation())),
                    verticalSpaceRegular
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: CSCard(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      color: Get.theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CsIcon(
                              Icons.access_time,
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            horizontalSpaceTiny,
                            CSText.title(
                              'Time Zone',
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            horizontalSpaceTiny
                          ],
                        ),
                      ),
                    ),
                    verticalSpaceRegular,
                    CSText(controller.homeController.ipDetails.value.timezone ??
                        'fetching...'),
                    verticalSpaceRegular
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: CSCard(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      color: Get.theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CsIcon(
                              Icons.local_post_office,
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            horizontalSpaceTiny,
                            CSText.title(
                              'Zip Code',
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            horizontalSpaceTiny
                          ],
                        ),
                      ),
                    ),
                    verticalSpaceRegular,
                    CSText(controller.homeController.ipDetails.value.zip ??
                        'fetching...'),
                    verticalSpaceRegular
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLocation() {
    var location = '';
    var areaName = controller.homeController.ipDetails.value.regionName ?? '';
    var city = controller.homeController.ipDetails.value.city ?? '';
    var country = controller.homeController.ipDetails.value.country ?? '';

    if (!(areaName.isBlank ?? true)) {
      location += areaName;
    }
    if (!(city.isBlank ?? true)) {
      if (!(location.isBlank ?? true)) location += ', ';
      location += city;
    }
    if (!(country.isBlank ?? true)) {
      if (!(location.isBlank ?? true)) location += ', ';
      location += country;
    }
    if (location.isBlank ?? true) location = 'loading...';

    return location;
  }
}
