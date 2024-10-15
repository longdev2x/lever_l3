import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/sign_up_controller.dart';
import 'package:timesheet/screen/sign_in/sign_in_screen.dart';
import 'package:timesheet/screen/sign_up/sign_up_screen2.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_text_field.dart';
import 'package:timesheet/view/app_toast.dart';

class SignUpScreen1 extends StatefulWidget {
  const SignUpScreen1({super.key});

  @override
  State<SignUpScreen1> createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  late final TextEditingController _lastnameController;
  late final TextEditingController _firstnameController;
  late final TextEditingController _dobController;
  late final TextEditingController _emailController;
  late final TextEditingController _universityNameController;
  late final TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _lastnameController = TextEditingController();
    _firstnameController = TextEditingController();
    _dobController = TextEditingController();
    _emailController = TextEditingController();
    _universityNameController = TextEditingController();
    _yearController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _lastnameController.dispose();
    _firstnameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _universityNameController.dispose();
    _yearController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GetBuilder<SignUpController>(
            builder: (controller) {
              _dobController.text =
                  'ngày ${controller.user.dob?.day} tháng ${controller.user.dob?.month}, ${controller.user.dob?.year}';
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(80, 56, 80, 60),
                    color: Colors.white,
                    child: Image.asset(Images.logo),
                  ),
                  const AppText24('Đăng ký'),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                          child: AppTextField(
                        hintText: 'Họ',
                        controller: _lastnameController,
                      )),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                          child: AppTextField(
                        hintText: 'Tên',
                        controller: _firstnameController,
                      )),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      const AppText16(
                        'Giới tính',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      const AppText16('Nam'),
                      Radio<String>(
                        value: 'Nam',
                        groupValue: controller.user.gender ?? 'Nam',
                        onChanged: (value) =>
                            controller.updateInfor(gender: value),
                      ),
                      SizedBox(width: 10.w),
                      const AppText16('Nữ'),
                      Radio<String>(
                        value: 'Nữ',
                        groupValue: controller.user.gender ?? 'Nam',
                        onChanged: (value) =>
                            controller.updateInfor(gender: value),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  AppTextField(
                    onTap: () {
                      _showDatePicker(controller);
                    },
                    lable:
                        'Ngày sinh (${_getBirthDay(controller.user.dob ?? DateTime.now().subtract(const Duration(days: 7260)))} tuổi)',
                    controller: _dobController,
                    readOnly: true,
                  ),
                  SizedBox(height: 20.h),
                  AppTextField(
                    hintText: 'Email',
                    controller: _emailController,
                  ),
                  SizedBox(height: 20.h),
                  AppTextField(
                    hintText: 'Tên trường',
                    controller: _universityNameController,
                  ),
                  SizedBox(height: 20.h),
                  AppTextField(
                    hintText: 'Sinh viên năm',
                    controller: _yearController,
                  ),
                  SizedBox(height: 50.h),
                  AppButton(
                    name: 'Tiếp',
                    ontap: () {
                      _onContinue(controller);
                    },
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                          text: 'Đã có tài khoản ? ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                          children: [
                            TextSpan(
                              text: 'Đăng nhập',
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              onEnter: (event) => Get.to(const SignInScreen()),
                            ),
                          ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onContinue(SignUpController controller) {
    controller.updateInfor(
      firstName: _firstnameController.text,
      lastName: _lastnameController.text,
      email: _emailController.text,
      university: _universityNameController.text,
      year: int.tryParse(_yearController.text),
    );
    String? error = controller.firstValidate();
    if (error != null) {
      AppToast.showToast(error);
      return;
    }
    Get.to(const SignUpScreen2());
  }

  void _showDatePicker(SignUpController controller) async {
    DateTime? dob = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(const Duration(days: 10000)),
        lastDate: DateTime.now(),
        initialDate: controller.user.dob ??
            DateTime.now().subtract(const Duration(days: 7260)));
    if (dob != null) {
      controller.updateInfor(dob: dob);
    }
  }

  int _getBirthDay(DateTime date) {
    DateTime now = DateTime.now();
    int birth = now.year - date.year;
    if (now.month > date.month ||
        now.month == date.month && now.day > date.day) {
      birth--;
    }
    return birth;
  }
}
