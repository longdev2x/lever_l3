import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/screen/profile/edit_profile_screen.dart';
import 'package:timesheet/screen/users/user_detail_screen.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_toast.dart';

class UserItem extends StatelessWidget {
  final User objUser;
  const UserItem({super.key, required this.objUser});

  @override
  Widget build(BuildContext context) {
    User currentUser = Get.find<AuthController>().user;
    bool isAdmin = false;

    if (currentUser.roles != null && currentUser.roles!.isNotEmpty) {
      isAdmin = currentUser.roles?[0].name == 'ROLE_ADMIN';
    }

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

    return GestureDetector(
      onTap: () {
        Get.to(() => const UserDetailScreen(), arguments: objUser);
      },
      child: Card(
        margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          child: Row(
            children: [
              AppImageAsset(
                imagePath: objUser.image,
                boxFit: BoxFit.contain,
                height: 40,
                width: 40,
                radius: 40,
              ),
              SizedBox(width: 20.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppText14(
                    objUser.displayName ?? 'No name',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 3.h),
                  AppText14(objUser.username ?? ''),
                ],
              ),
              const Spacer(),
              if (isAdmin)
                Row(
                  children: [
                    AppImageAsset(
                      imagePath: Images.icUpdateUser,
                      onTap: () {
                        Get.to(() => const EditProfileScreen());
                      },
                      height: 22,
                      width: 22,
                    ),
                    SizedBox(width: 15.w),
                    AppImageAsset(
                      imagePath: Images.icBlock,
                      onTap: () {
                        blockUser(objUser, context);
                      },
                      height: 22,
                      width: 22,
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
