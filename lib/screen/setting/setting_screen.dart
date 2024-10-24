import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/screen/sign_in/sign_in_screen.dart';
import 'package:timesheet/theme/theme_controller.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  void _onToggleTheme() {
    Get.find<ThemeController>().toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style:
              TextStyle(color: ColorResources.getBlackColor(), fontSize: 24.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const AppText18('Theme Mode'),
                  SizedBox(width: 20.w),
                  GetBuilder<ThemeController>(
                    builder: (controller) => Switch(
                      value: controller.darkTheme ?? false,
                      onChanged: (value) {
                        _onToggleTheme();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  const AppText18('Ngôn ngữ'),
                  SizedBox(width: 20.w),
                  Switch(value: true, onChanged: (value) {}),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  const AppText18('Đăng xuất'),
                  SizedBox(width: 20.w),
                  AppImageAsset(
                    onTap: () {
                      Get.find<AuthController>().logOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    imagePath: Images.icLogout,
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
              SizedBox(height: 50.h),
              AppImageAsset(
                onTap: () {
                  // SystemNavigator.pop();
                  exit(0);
                },
                imagePath: Images.icOut,
                width: 50,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
