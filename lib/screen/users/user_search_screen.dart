import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/screen/users/widgets/user_item.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_text_field.dart';
import 'package:timesheet/view/app_toast.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({super.key});

  void _search(String value) async {
    int statusCode = await Get.find<UserController>().searchUser(
        keyWord: value.trim(), pageIndex: 1, size: 100, status: null);
    if (statusCode != 200) {
      AppToast.showToast('Lỗi khi tìm kiếm');
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                AppImageAsset(imagePath: Images.icArrowBack, onTap: () => Get.back(), width: 20.w, height: 26.h,),
                SizedBox(width: 15.w),
                Expanded(
                  child: AppTextField(
                    hintText: 'Tên User',
                    onChanged: (value) => _search(value),
                  ),
                ),
              ],
            ),
          ),
        ),
        toolbarHeight: 60.h,
        automaticallyImplyLeading: false,
      ),
      body: GetBuilder<UserController>(
        builder: (controller) {
          if (controller.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (controller.hasSearchError) {
            return Center(
              child: AppText24(
                'error'.tr,
                color: theme.colorScheme.error,
              ),
            );
          }

          if (controller.userSearchs!.isEmpty) {
            return Center(
              child: AppText24('empty_list'.tr),
            );
          }

          return ListView.builder(
            itemCount: controller.userSearchs!.length,
            itemBuilder: (ctx, index) {
              return UserItem(objUser: controller.userSearchs![index]);
            },
          );
        },
      ),
    );
  }
}
