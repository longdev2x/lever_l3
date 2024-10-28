import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/sign_up_controller.dart';
import 'package:timesheet/screen/sign_in/sign_in_screen.dart';

import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_text_field.dart';
import 'package:timesheet/view/app_toast.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final RxBool _showPass = false.obs;
  final RxBool _showConfirmPass = false.obs;
  late final TextEditingController _usernameController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _rePasswordController =
      TextEditingController();
  late final TextEditingController _displayNameController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _displayNameController.dispose();
  }

  void _register() async {
    Get.find<SignUpController>().updateInfor(
      username: _usernameController.text,
      displayName: _displayNameController.text,
      password: _passwordController.text,
      confirmPassword: _rePasswordController.text,
    );
    String? error = Get.find<SignUpController>().secondValidate();
    if (error != null) {
      AppToast.showToast(error);
      return;
    }
    int statusCode = await Get.find<AuthController>()
        .signUp(Get.find<SignUpController>().user);

    if (statusCode == 200) {
      AppToast.showToast('Đăng ký thành công, vui lòng đăng nhập');
      Get.to(() => const SignInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: 1.sh - 100.h,
                child: GetBuilder<AuthController>(
                  builder: (controller) => Opacity(
                    opacity: controller.loading ? 0.3 : 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppTextField(
                          lable: 'display_name'.tr,
                          controller: _displayNameController,
                        ),
                        SizedBox(height: 20.h),
                        AppTextField(
                          lable: 'username'.tr,
                          controller: _usernameController,
                        ),
                        SizedBox(height: 20.h),
                        Obx(
                          () => AppTextField(
                            lable: 'password'.tr,
                            controller: _passwordController,
                            obscureText: _showPass.value,
                            onObscureTextTap: () {
                              _showPass.value = !_showPass.value;
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Obx(
                          () => AppTextField(
                            lable: 'confirm_password'.tr,
                            controller: _rePasswordController,
                            obscureText: _showConfirmPass.value,
                            onObscureTextTap: () {
                              _showConfirmPass.value = !_showConfirmPass.value;
                            },
                          ),
                        ),
                        SizedBox(height: 50.h),
                        GetBuilder<SignUpController>(
                          builder: (controller) => AppButton(
                            name: 'register'.tr,
                            ontap: _register,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: GetBuilder<AuthController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.loading,
                    child: const CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
