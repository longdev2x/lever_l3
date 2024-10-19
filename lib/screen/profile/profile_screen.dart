import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/profile_controller.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/profile/edit_profile_screen.dart';
import 'package:timesheet/screen/profile/widgets/profile_avatar_widget.dart';
import 'package:timesheet/screen/sign_in/sign_in_screen.dart';
import 'package:timesheet/screen/users/widgets/user_parameter_widget.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                _logout();
              },
              icon: const Icon(Icons.logout)),
          SizedBox(width: 10.w),
        ],
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          User objUser = controller.user!;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileAvatarWidget(avatar: objUser.image),
                    SizedBox(height: 15.h),
                    AppText20(
                        '${objUser.username} (${objUser.roles?.name == 'ROLE_USER' ? 'USER' : 'ADMIN'})',
                        fontWeight: FontWeight.bold),
                    SizedBox(height: 5.h),
                    AppText16(objUser.email),
                    SizedBox(height: 15.h),
                    AppButton(
                        ontap: () {
                          Get.to(() => const EditProfileScreen());
                        },
                        name: 'Cập nhật hồ sơ',
                        width: 250),
                    SizedBox(height: 20.h),
                    if (objUser.username != null)
                      UserParameterWidget(
                        name: 'Tên tài khoản',
                        icon: Images.icSocial,
                        prameter: objUser.username!,
                        isFirst: true,
                      ),
                    if (objUser.email != null)
                      UserParameterWidget(
                        name: 'Email',
                        icon: Images.icSocial,
                        prameter: objUser.email!,
                      ),
                    if (objUser.lastName != null || objUser.firstName != null)
                      UserParameterWidget(
                        name: 'Họ & Tên',
                        icon: Images.icSocial,
                        prameter: '${objUser.lastName} ${objUser.firstName}',
                      ),
                    if (objUser.dob != null)
                      UserParameterWidget(
                        name: 'Ngày sinh',
                        icon: Images.icSocial,
                        prameter: objUser.dob != null
                            ? DateConverter.getOnlyFomatDate(objUser.dob!)
                            : 'No infor',
                      ),
                    if (objUser.gender != null)
                      UserParameterWidget(
                        name: 'Giới tính',
                        icon: Images.icSocial,
                        prameter: objUser.gender!,
                      ),
                    if (objUser.birthPlace != null)
                      UserParameterWidget(
                        name: 'Nơi sinh',
                        icon: Images.icSocial,
                        prameter: objUser.birthPlace!,
                      ),
                    if (objUser.university != null)
                      UserParameterWidget(
                        name: 'Trường đại học',
                        icon: Images.icSocial,
                        prameter: objUser.university!,
                      ),
                    if (objUser.year != null)
                      UserParameterWidget(
                        name: 'Năm học',
                        icon: Images.icSocial,
                        prameter: objUser.year.toString(),
                      ),
                    UserParameterWidget(
                      name: 'Số ngày checkin',
                      icon: Images.icSocial,
                      prameter: objUser.countDayCheckin != null
                          ? objUser.countDayCheckin.toString()
                          : '0',
                    ),
                    UserParameterWidget(
                      name: 'Số ngày tracking',
                      icon: Images.icSocial,
                      prameter: objUser.countDayTracking != null
                          ? objUser.countDayTracking.toString()
                          : '0',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _logout() async {
    if (await Get.find<AuthController>().logOut() == 200) {
      Get.to(() => const SignInScreen());
    }
  }
}
