import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/model/body/tracking_entity.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/tracking/tracking_detail.dart';
import 'package:timesheet/view/app_text.dart';

class TrackingHistoryItem extends StatelessWidget {
  final TrackingEntity objTracking;
  const TrackingHistoryItem({super.key, required this.objTracking});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Get.to(() => TrackingDetail(objTracking: objTracking)),
      child: Container(
        width: double.infinity,
        height: 100.h,
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(
            color: theme.colorScheme.outlineVariant
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.2),
              offset: const Offset(0, 2),
              spreadRadius: 2,
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            if (objTracking.date != null)
              SizedBox(
                width: 150.w,
                child: Column(
                  children: [
                    AppText14('${DateConverter.getWeekDay(objTracking.date!)}, ${DateConverter.getOnlyFomatDate(objTracking.date!)}', fontWeight: FontWeight.bold,),
                    const Spacer(),
                    AppText28(DateConverter.getHoursMinutes(objTracking.date!)),
                    const Spacer(),
                  ],
                ),
              ),
            SizedBox(width: 10.w),
            Container(
              width: 2,
              height: double.infinity,
              color: theme.dividerColor,
            ),
            SizedBox(width: 10.w),
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
      ),
    );
  }
}
