import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/sign_up_controller.dart';
import 'package:timesheet/screen/sign_up/sign_up_screen2.dart';
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
  late final TextEditingController _lastnameController =
      TextEditingController();
  late final TextEditingController _firstnameController =
      TextEditingController();
  late final TextEditingController _dobController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _universityNameController =
      TextEditingController();
  late final TextEditingController _yearController = TextEditingController();
  late final TextEditingController _birthPlaceController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _lastnameController.dispose();
    _firstnameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _universityNameController.dispose();
    _yearController.dispose();
    _birthPlaceController.dispose();
  }

  void _onContinue() {
    Get.find<SignUpController>().updateInfor(
      firstName: _firstnameController.text,
      lastName: _lastnameController.text,
      email: _emailController.text,
      university: _universityNameController.text,
      year: int.tryParse(_yearController.text),
      birthPlace: _birthPlaceController.text,
    );
    String? error = Get.find<SignUpController>().firstValidate();
    if (error != null) {
      AppToast.showToast(error);
      return;
    }
    Get.to(
      () => const SignUpScreen2(),
    );
  }

  void _showDatePicker() async {
    DateTime? dob = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(const Duration(days: 10000)),
        lastDate: DateTime.now(),
        initialDate: Get.find<SignUpController>().user.dob ??
            DateTime.now().subtract(const Duration(days: 7260)));
    if (dob != null) {
      Get.find<SignUpController>().updateInfor(dob: dob);
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GetBuilder<SignUpController>(
            builder: (controller) {
              _dobController.text =
                  'ngày ${controller.user.dob?.day} tháng ${controller.user.dob?.month}, ${controller.user.dob?.year}';
              return SafeArea(
                child: SizedBox(
                  height: 1.sh - 70.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText24('sign_up'.tr),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                              child: AppTextField(
                            lable: 'last_name'.tr,
                            controller: _lastnameController,
                          )),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                              child: AppTextField(
                            lable: 'first_name'.tr,
                            controller: _firstnameController,
                          )),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          AppText16(
                            'gender'.tr,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          AppText16('male'.tr),
                          Radio<String>(
                            value: 'M',
                            groupValue: controller.user.gender ?? 'M',
                            onChanged: (value) =>
                                controller.updateInfor(gender: value),
                          ),
                          SizedBox(width: 10.w),
                          AppText16('female'.tr),
                          Radio<String>(
                            value: 'F',
                            groupValue: controller.user.gender ?? 'M',
                            onChanged: (value) =>
                                controller.updateInfor(gender: value),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      AppTextField(
                        onTap: _showDatePicker,
                        lable: 'date_of_birth_with_old'.trParams({
                          'old': _getBirthDay(controller.user.dob ??
                                  DateTime.now()
                                      .subtract(const Duration(days: 7260)))
                              .toString(),
                        }),
                        controller: _dobController,
                        readOnly: true,
                      ),
                      SizedBox(height: 20.h),
                      AppTextField(
                        lable: 'birth_place'.tr,
                        controller: _birthPlaceController,
                      ),
                      SizedBox(height: 20.h),
                      AppTextField(
                        lable: 'email'.tr,
                        controller: _emailController,
                      ),
                      SizedBox(height: 20.h),
                      AppTextField(
                        lable: 'university'.tr,
                        controller: _universityNameController,
                      ),
                      SizedBox(height: 20.h),
                      AppTextField(
                        lable: 'year_student'.tr,
                        controller: _yearController,
                      ),
                      SizedBox(height: 50.h),
                      AppButton(
                        name: 'next'.tr,
                        ontap: _onContinue,
                      ),
                      SizedBox(height: 15.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                              text: '${'you_already_have_an_account'.tr}  ',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: theme.colorScheme.onSurfaceVariant
                              ),
                              children: [
                                TextSpan(
                                  text: 'login'.tr,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Get.back(),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
