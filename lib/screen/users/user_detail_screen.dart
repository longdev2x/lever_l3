import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/users/widgets/user_parameter_widget.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_image.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User currentUser = Get.find<AuthController>().user;
    bool isAdmin = false;

    if (currentUser.roles != null && currentUser.roles!.isNotEmpty) {
      isAdmin = currentUser.roles?[0].name == 'ROLE_ADMIN';
    }

    User user = Get.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text(user.displayName ?? ''),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 30.h),
        child: Column(
          children: [
            AppImageAsset(
              imagePath: user.image,
              radius: 100,
              height: 100,
              width: 100,
            ),
            SizedBox(height: 25.h),
            if (isAdmin)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        ontap: () {},
                        name: 'Change',
                        height: 37,
                      ),
                    ),
                    SizedBox(width: 30.w),
                    Expanded(
                      child: AppButton(
                        ontap: () {},
                        name: 'Block',
                        height: 37,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 35.h),
            if (user.username != null)
              UserParameterWidget(
                name: 'Tên tài khoản',
                icon: Images.icSocial,
                prameter: user.username!,
                isFirst: true,
              ),
            if (user.email != null)
              UserParameterWidget(
                name: 'Email',
                icon: Images.icSocial,
                prameter: user.email!,
              ),
            if (user.lastName != null || user.firstName != null)
              UserParameterWidget(
                name: 'Họ & Tên',
                icon: Images.icSocial,
                prameter: '${user.lastName} ${user.firstName}',
              ),
            if (user.dob != null)
              UserParameterWidget(
                name: 'Ngày sinh',
                icon: Images.icSocial,
                prameter: user.dob != null
                    ? DateConverter.getOnlyFomatDate(user.dob!)
                    : 'No infor',
              ),
            if (user.gender != null)
              UserParameterWidget(
                name: 'Giới tính',
                icon: Images.icSocial,
                prameter: user.gender!,
              ),
            if (user.birthPlace != null)
              UserParameterWidget(
                name: 'Nơi sinh',
                icon: Images.icSocial,
                prameter: user.birthPlace!,
              ),
            if (user.university != null)
              UserParameterWidget(
                name: 'Trường đại học',
                icon: Images.icSocial,
                prameter: user.university!,
              ),
            if (user.year != null)
              UserParameterWidget(
                name: 'Năm học',
                icon: Images.icSocial,
                prameter: user.year.toString(),
              ),
            UserParameterWidget(
              name: 'Số ngày checkin',
              icon: Images.icSocial,
              prameter: user.countDayCheckin != null
                  ? user.countDayCheckin.toString()
                  : '0',
            ),
            UserParameterWidget(
              name: 'Số ngày tracking',
              icon: Images.icSocial,
              prameter: user.countDayTracking != null
                  ? user.countDayTracking.toString()
                  : '0',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}
