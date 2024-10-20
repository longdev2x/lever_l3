import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheet/data/model/body/post_entity.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_text.dart';

class PostItem extends StatelessWidget {
  final PostEntity objPost;
  const PostItem({super.key, required this.objPost});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: objPost.user?.image != null
                    ? NetworkImage(objPost.user!.image!)
                    : const AssetImage(Images.imgAvatarDefault) as ImageProvider,
                radius: 25,
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText16(
                    objPost.user?.displayName,
                    fontWeight: FontWeight.bold,
                  ),
                  AppText14(objPost.date.toString()),
                ],
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 10.h),
          AppText20(
            objPost.content,
            maxLines: null,
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
