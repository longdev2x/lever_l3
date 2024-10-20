import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            CircleAvatar(
              backgroundImage: avatar != null
                  ? NetworkImage(avatar!)
                  : const AssetImage(Images.imgAvatarDefault) as ImageProvider,
              radius: 25,
            ),
            SizedBox(width: 12.w),
            const AppText16('bạn đang nghĩ gì'),
            const Spacer(),
            GestureDetector(
              onTap: onTapImagePicker,
              child: const AppImageAsset(
                imagePath: Images.icCamera,
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