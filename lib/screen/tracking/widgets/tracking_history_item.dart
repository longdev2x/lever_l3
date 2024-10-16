import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheet/data/model/body/tracking_entity.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/view/app_text.dart';

class TrackingHistoryItem extends StatelessWidget {
  final TrackingEntity objTracking;
  const TrackingHistoryItem({super.key, required this.objTracking});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.h,
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              spreadRadius: 5,
              blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          if (objTracking.date != null)
            Column(
              children: [
                AppText14(
                    '${DateConverter.getWeekDay(objTracking.date!)}, ${DateConverter.getOnlyFomatDate(objTracking.date!)}'),
                const Spacer(),
                AppText28(DateConverter.getHoursMinutes(objTracking.date!)),
                const Spacer(),
              ],
            ),
          SizedBox(width: 5.w),
          Container(
            width: 1,
            height: double.infinity,
            color: Colors.grey,
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: AppText16(
                objTracking.content,
                maxLines: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
