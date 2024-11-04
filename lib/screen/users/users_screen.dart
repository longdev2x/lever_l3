import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_search_controller.dart';
import 'package:timesheet/screen/users/widgets/user_list_widget.dart';

import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_toast.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        int statusCode = await Get.find<UserSearchController>().refreshData();
        if (statusCode == 200) {
          AppToast.showToast('Refresh thành công');
        } else {
          AppToast.showToast('Refresh thất bại');
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 80.h),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  const AppText24(
                    'Tracking',
                    fontWeight: FontWeight.bold,
                  ),
                  const Spacer(),
                  AppImageAsset(
                    imagePath: Images.icSearchUser,
                    width: 25.w,
                    height: 25.w,
                    onTap: () {
                      //Search Icon Tap
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: const UserListWidget(),
        ),
      ),
    );
  }
}
