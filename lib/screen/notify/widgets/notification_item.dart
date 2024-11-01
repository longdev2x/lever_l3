import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/model/body/notification_entity.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity objNotify;
  const NotificationItem({super.key, required this.objNotify});

  String _getDateFormat(DateTime? date) {
    if (date == null) return 'no_data_found'.tr;
    DateTime now = DateTime.now();

    int difference = now.difference(date).inMinutes;

    if (difference < 60) {
      return '$difference ${'minutes_ago'.tr}';
    }
    if (difference < 1440) {
      int hours = now.difference(date).inHours;
      return '$hours ${'hours_ago'.tr}';
    }
    if (difference < 10080) {
      int days = now.difference(date).inDays;
      return '$days ${'days_ago'.tr}';
    }
    return '${DateConverter.getWeekDay(objNotify.date!)} - ${'days'} ${DateConverter.getOnlyFomatDate(objNotify.date!)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
      ),
      // decoration: BoxDecoration(
      //   color: ColorResources.getBackgroundColor(),
      // ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: objNotify.user?.image != null
                ? NetworkImage(objNotify.user!.image!)
                : const AssetImage(Images.imgAvatarDefault) as ImageProvider,
            radius: 25,
          ),
          SizedBox(width: 12.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText16(
                objNotify.title,
                fontWeight: FontWeight.bold,
              ),
              AppText14(objNotify.body),
              AppText14(_getDateFormat(objNotify.date)),
            ],
          ),
          const Spacer(),
          AppImageAsset(
            onTap: () {},
            imagePath: Images.icThreeDotHori,
            width: 15,
            height: 3,
          ),
        ],
      ),
    );
  }
}
