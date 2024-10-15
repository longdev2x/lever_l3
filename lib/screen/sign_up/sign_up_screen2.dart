import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/sign_up_controller.dart';
import 'package:timesheet/screen/home/home_screen.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_text_field.dart';
import 'package:timesheet/view/app_toast.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _rePasswordController;
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.BACKGROUND_BAR_LIGHT_GRAY,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(80, 80, 80, 60),
                    color: Colors.white,
                    child: Image.asset(Images.logo),
                  ),
                  SizedBox(height: 20.h),
                  AppTextField(
                    hintText: 'username',
                    controller: _usernameController,
                  ),
                  SizedBox(height: 20.h),
                  AppTextField(
                    hintText: 'password',
                    controller: _passwordController,
                  ),
                  SizedBox(height: 20.h),
                  AppTextField(
                    hintText: 'confirm password',
                    controller: _rePasswordController,
                  ),
                  SizedBox(height: 50.h),
                  GetBuilder<SignUpController>(
                    builder: (controller) => AppButton(
                      name: 'Register',
                      ontap: () {
                        _register(controller);
                      },
                    ),
                  ),
                ],
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

  void _register(SignUpController controller) async {
    controller.updateInfor(
      username: _usernameController.text,
      password: _passwordController.text,
      confirmPassword: _rePasswordController.text,
    );
    String? error = controller.secondValidate();
    if (error != null) {
      AppToast.showToast(error);
      return;
    }
    int statusCode = await Get.find<AuthController>().signUp(controller.user);
    if(statusCode == 200) {
      Get.to(const HomeScreen());
    }
  }
}
