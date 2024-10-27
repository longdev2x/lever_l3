import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/check_in_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/check_in_entity.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/profile/profile_screen.dart';
import 'package:timesheet/screen/tracking/tracking_history_screen.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_text_field.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late final TextEditingController _contentTrackingController;
  DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
    _contentTrackingController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Get.find<CheckInController>().getCheckIn();
  }

  @override
  void dispose() {
    super.dispose();
    _contentTrackingController.dispose();
  }

  void _checkIn() {
    Get.find<CheckInController>().checkIn();
  }

  void onTracking() async {
    String content = _contentTrackingController.text;
    if (content.trim().isNotEmpty) {
      int statusCode =
          await Get.find<TrackingController>().saveTracking(content: content);
      if (statusCode == 200) {
        _contentTrackingController.clear();
        Get.to(() => const TrackingHistoryScreen());
      }
    }
  }

  String _checkDelay(DateTime dateCheckIn) {
    //Ví dụ 7 giờ phải checkIn
    DateTime ruleTime =
        DateTime(dateCheckIn.year, dateCheckIn.month, dateCheckIn.day, 7, 0).toLocal();
    var difference = dateCheckIn.difference(ruleTime);
    //Tới sớm
    if (difference.inMinutes < 0) {
      difference = -difference;
      if (difference.inMinutes == 60) {
        return '${'check_in'.tr} ${'early'.tr} 1h';
      } else if (difference.inMinutes > 60) {
        return '${'check_in'.tr} ${'early'.tr} ${difference.inMinutes ~/ 60}h - ${difference.inMinutes % 60}p';
      } else {
        return '${'check_in'.tr} ${'early'.tr} ${difference.inMinutes}p';
      }
    }
    // Tới muộn
    if (difference.inMinutes > 0) {
      if (difference.inMinutes == 60) {
        return '${'check_in'.tr} ${'late'.tr} 1h';
      } else if (difference.inMinutes > 60) {
        return '${'check_in'.tr} ${'late'.tr} ${difference.inMinutes ~/ 60}h - ${difference.inMinutes % 60}p';
      } else {
        return '${'check_in'.tr} ${'late'.tr} ${difference.inMinutes}p';
      }
    }
    //Đúng giờ
    return '${'check_in'.tr} ${'on_time'.tr}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80.h),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: ColorResources.getWhiteColor(),
              boxShadow: [
                BoxShadow(
                  color: ColorResources.getShadowColor(),
                  offset: const Offset(0, 3),
                  spreadRadius: 2,
                  blurRadius: 2,
                  blurStyle: BlurStyle.normal,
                ),
              ],
            ),
            child: Row(
              children: [
                AppText18(
                  'Tracking',
                  color: ColorResources.getTextColor(),
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                AppImageAsset(
                  imagePath: Images.profile,
                  width: 25.w,
                  height: 25.w,
                  color: ColorResources.getTextColor(),
                  onTap: () {
                    Get.to(() => const ProfileScreen());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: ColorResources.getWebsiteTextColor(),
                boxShadow: [
                  BoxShadow(
                    color: ColorResources.getShadowColor(),
                    offset: const Offset(0, 3),
                    spreadRadius: 2,
                    blurRadius: 2,
                    blurStyle: BlurStyle.normal,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText14(
                        '${'today'.tr}, ${DateConverter.getWeekDay(now)}',
                        color: ColorResources.getWhiteColor(),
                      ),
                      SizedBox(height: 10.h),
                      AppText16(
                        DateConverter.getOnlyFomatDate(now),
                        fontWeight: FontWeight.bold,
                        color: ColorResources.getWhiteColor(),
                      ),
                    ],
                  ),
                  GetBuilder<CheckInController>(
                    builder: (controller) {
                      if (controller.loading == true) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      List<CheckInEntity> listCheckIn = controller.listCheckIn;
                      int nowDay = DateTime.now().toLocal().day;

                      if (listCheckIn.isEmpty ||
                          listCheckIn.last.dateAttendance?.toLocal().day != nowDay) {
                        return ElevatedButton(
                          onPressed: _checkIn,
                          child: AppText16('check_in'.tr),
                        );
                      }
                      CheckInEntity todayCheckIn = listCheckIn.last;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText14(
                            '${'date_attendance'.tr} ${todayCheckIn.dateAttendance?.toLocal().hour}h',
                            color: ColorResources.getWhiteColor(),
                          ),
                          SizedBox(height: 10.h),
                          AppText16(
                            _checkDelay(todayCheckIn.dateAttendance!.toLocal()),
                            fontWeight: FontWeight.bold,
                            color: ColorResources.getWhiteColor(),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Align(
                alignment: Alignment.center,
                child: DatePicker(
                  now.subtract(const Duration(days: 2)),
                  initialSelectedDate: now,
                  daysCount: 5,
                  selectionColor: Colors.black,
                  selectedTextColor: ColorResources.getWhiteColor(),
                  activeDates: [now],
                  onDateChange: (selectedDate) {},
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  AppText28(
                    '${'content'.tr} tracking',
                    color: ColorResources.getTextColor(),
                  ),
                  SizedBox(height: 30.h),
                  AppTextAreaField(
                    hintText: '${'today'.tr} ${('i'.tr).toLowerCase()} ...',
                    controller: _contentTrackingController,
                  ),
                  SizedBox(height: 30.h),
                  AppButton(
                    name: 'Tracking',
                    ontap: onTracking,
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                      onTap: () {
                        Get.to(() => const TrackingHistoryScreen());
                      },
                      child: AppText16(
                        '${'history'.tr} tracking',
                        color: ColorResources.getWebsiteTextColor(),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
