import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/home_controller.dart';
import 'package:timesheet/screen/notify/notify_screen.dart';
import 'package:timesheet/screen/setting/setting_screen.dart';
import 'package:timesheet/screen/social/social_screen.dart';
import 'package:timesheet/screen/tracking/tracking_screen.dart';
import 'package:timesheet/screen/users/users_screen.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';

List<Widget> screens = [
  const TrackingScreen(),
  const UsersScreen(),
  const SocialScreen(),
  const NotifyScreen(),
  const SettingScreen(),
];

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return Obx(
      () => BottomNavigationBar(
        currentIndex: homeController.bottomIndexSelected.value,
        onTap: (value) {
          homeController.onSelected(value);
        },
        items: listBottoms
            .map((objBottom) => _bottomItem(objBottom: objBottom))
            .toList(),
        backgroundColor: ColorResources.getBackgroundColor(),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  BottomNavigationBarItem _bottomItem({
    required BottomItemEntity objBottom,
  }) =>
      BottomNavigationBarItem(
        icon: AppImageAsset(
          imagePath: objBottom.icon,
          color: ColorResources.getGreyBaseGray1(),
          height: 25,
          width: 25,
        ),
        label: objBottom.name,
        activeIcon: AppImageAsset(
          imagePath: objBottom.icon,
          color: ColorResources.getBalanceTextColor(),
          height: 25,
          width: 25,
        ),
      );
}


List<BottomItemEntity> listBottoms = [
  const BottomItemEntity(name: 'Home', icon: Images.icHome),
  const BottomItemEntity(name: 'Users', icon: Images.icUsers),
  const BottomItemEntity(name: 'Social', icon: Images.icSocial),
  const BottomItemEntity(name: 'Notify', icon: Images.icNotify),
  const BottomItemEntity(name: 'Settings', icon: Images.icSetting),
];

class BottomItemEntity {
  final String name;
  final String icon;
  const BottomItemEntity({
    required this.name,
    required this.icon,
  });
}
