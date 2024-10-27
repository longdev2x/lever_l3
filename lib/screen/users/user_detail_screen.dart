import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/users/edit_member_user_screen.dart';
import 'package:timesheet/screen/users/widgets/user_parameter_widget.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_toast.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  void blockUser(User objUser, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppConfirm(
        title: 'Bạn thực sự muốn block ${objUser.displayName}',
        onConfirm: () {
          // User không lưu thông tin block
          // Get.find<AuthController>()
          AppToast.showToast('Không có thông tin block để triển khai');
          Navigator.pop(context);
        },
      ),
    );
  }

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
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: AppButton(
                        ontap: () {
                          Get.to(() => EditMemberUserScreen(objUser: user));
                        },
                        name: 'edit_profile'.tr,
                        height: 37,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: AppButton(
                        ontap: () {
                          blockUser(user, context);
                        },
                        name: 'block_user'.tr,
                        height: 37,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 35.h),
            if (user.username != null)
              UserParameterWidget(
                name: 'username'.tr,
                icon: Images.icSocial,
                prameter: user.username!,
                isFirst: true,
              ),
            if (user.email != null)
              UserParameterWidget(
                name: 'email'.tr,
                icon: Images.icSocial,
                prameter: user.email!,
              ),
            if (user.lastName != null || user.firstName != null)
              UserParameterWidget(
                name: 'full_name'.tr,
                icon: Images.icSocial,
                prameter: '${user.lastName} ${user.firstName}',
              ),
            if (user.dob != null)
              UserParameterWidget(
                name: 'date_of_birth'.tr,
                icon: Images.icSocial,
                prameter: user.dob != null
                    ? DateConverter.getOnlyFomatDate(user.dob!)
                    : 'unavailable'.tr,
              ),
            if (user.gender != null)
              UserParameterWidget(
                name: 'gender'.tr,
                icon: Images.icSocial,
                prameter: user.gender!,
              ),
            if (user.birthPlace != null)
              UserParameterWidget(
                name: 'birth_place'.tr,
                icon: Images.icSocial,
                prameter: user.birthPlace!,
              ),
            if (user.university != null)
              UserParameterWidget(
                name: 'university'.tr,
                icon: Images.icSocial,
                prameter: user.university!,
              ),
            if (user.year != null)
              UserParameterWidget(
                name: 'year_student'.tr,
                icon: Images.icSocial,
                prameter: user.year.toString(),
              ),
            UserParameterWidget(
              name: 'count_day_check_in'.tr,
              icon: Images.icSocial,
              prameter: user.countDayCheckin != null
                  ? user.countDayCheckin.toString()
                  : '0',
            ),
            UserParameterWidget(
              name: 'count_day_tracking'.tr,
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
