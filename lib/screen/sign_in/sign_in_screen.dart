import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/screen/sign_up/sign_up_screen1.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text_field.dart';

import '../home/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _showPass = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            Scrollbar(
                child: SingleChildScrollView(
              child: SafeArea(
                child: GetBuilder<AuthController>(
                  builder: (controller) => Opacity(
                    opacity: controller.loading ? 0.3 : 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
                      height: 1.sh - 50.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppImageAsset(
                            imagePath: Images.logo,
                            radius: 30,
                          ),
                          SizedBox(height: 50.h),
                          Text(
                            'login_to_your_account'.tr,
                            style: TextStyle(
                                fontSize: 20,
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: AppTextField(
                              hintText: 'email'.tr,
                              controller: _usernameController,
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Obx(
                                () => TextFormField(
                                  textInputAction: TextInputAction.done,
                                  obscureText: _showPass.value,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(left: 28),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _showPass.value = !_showPass.value;
                                        },
                                        icon: Icon(_showPass.value
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromRGBO(244, 244, 244, 1)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      hintText: 'password'.tr,
                                      hintStyle:
                                          const TextStyle(color: Colors.grey)),
                                ),
                              )),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.to(const SignUpScreen1(),
                                    transition: Transition.size,
                                    curve: Curves.bounceIn);
                              },
                              child: Text(
                                'you_have_not_an_account'.tr,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(100, 18, 100, 18),
                            child: AppButton(
                              name: 'login'.tr,
                              ontap: _login,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
            Center(child: GetBuilder<AuthController>(
              builder: (controller) {
                return Visibility(
                  visible: controller.loading,
                  child: const CircularProgressIndicator(),
                );
              },
            ))
          ],
        ));
  }

  _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      const snackBar = SnackBar(
        content: Text('Bạn cần điền đầy đủ tài khoản mật khẩu.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Get.find<AuthController>().login(username, password).then((value) => {
            if (value == 200)
              {
                Get.to(const HomeScreen(),
                    transition: Transition.size,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn)
              }
            else if (value == 400)
              {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Tài khoản mật khẩu không chính xác")))
              }
            else
              {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Đã xảy ra lỗi xin vui lòng thử lại")))
              },
          });
    }
  }
}
