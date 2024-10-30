import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/profile_controller.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';

class PostHeaderWidget extends StatelessWidget {
  final String? avatar;
  final Function() onTapRow;
  final Function() onTapImagePicker;
  const PostHeaderWidget({
    super.key,
    required this.avatar,
    required this.onTapImagePicker,
    required this.onTapRow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapRow,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h),
        child: Row(
          children: [
            GetBuilder<ProfileController>(
              initState: (state) =>  Get.find<ProfileController>().getImage(),
              builder: (controller) => CircleAvatar(
                  radius: 25.r,
                  backgroundImage: controller.fileAvatar != null
                      ? FileImage(controller.fileAvatar!)
                      : const AssetImage(Images.imgAvatarDefault)
                          as ImageProvider,
                ),
            ),
            SizedBox(width: 12.w),
            AppText16('what_are_you_thinking'.tr),
            const Spacer(),
            GestureDetector(
              onTap: onTapImagePicker,
              child: const AppImageAsset(
                imagePath: Images.icImagePicker,
                height: 35,
                width: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}