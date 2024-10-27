import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/localization_controller.dart';
import 'package:timesheet/screen/sign_in/sign_in_screen.dart';
import 'package:timesheet/theme/theme_controller.dart';
import 'package:timesheet/utils/app_constants.dart';

import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_toast.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  void _onToggleTheme() {
    Get.find<ThemeController>().toggleTheme();
  }

  void _onLanguageChange(bool isVN) {
    Locale locale;
    if (isVN) {
      locale = Locale(AppConstants.languages[0].languageCode,
          AppConstants.languages[0].countryCode);
    } else {
      locale = Locale(AppConstants.languages[1].languageCode,
          AppConstants.languages[1].countryCode);
    }
    Get.find<LocalizationController>().setLanguage(locale);
  }

  void _onExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppConfirm(
        title: '${'exit'.tr} app?',
        // SystemNavigator.pop();
        onConfirm: () => exit(0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'settings'.tr,
          style:
              TextStyle(fontSize: 24.sp),
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
                  AppText18('dark_theme'.tr),
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
              GetBuilder<LocalizationController>(
                builder: (controller) {
                  bool isVN = controller.locale.languageCode ==
                      AppConstants.languages[0].languageCode;
                  return Row(
                    children: [
                      AppText18('select_language'.tr),
                      SizedBox(width: 20.w),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AppImageAsset(
                            onTap: () {
                              _onLanguageChange(true);
                            },
                            imagePath: controller.languages[0].imageUrl,
                            width: 40,
                            height: 40,
                          ),
                          if (isVN)
                            Positioned(
                              top: -6.h,
                              right: -6.w,
                              child: const AppImageAsset(
                                imagePath: Images.icCheckTick,
                                height: 20,
                                width: 20,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 20.w),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AppImageAsset(
                            onTap: () {
                              _onLanguageChange(false);
                            },
                            imagePath: controller.languages[1].imageUrl,
                            width: 50,
                            height: 50,
                            color: theme.colorScheme.primary,
                          ),
                          if (!isVN)
                            Positioned(
                              top: -6.h,
                              right: -6.w,
                              child: const AppImageAsset(
                                imagePath: Images.icCheckTick,
                                height: 20,
                                width: 20,
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  AppText18('logout'.tr),
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
                    width: 30,
                    height: 30,
                    color: theme.colorScheme.onSurface,
                  ),
                ],
              ),
              SizedBox(height: 50.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText24('exit'.tr),
                  SizedBox(width: 5.w),
                  AppImageAsset(
                    onTap: () {
                      _onExit(context);
                    },
                    imagePath: Images.icOut,
                    width: 50,
                    height: 50,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
