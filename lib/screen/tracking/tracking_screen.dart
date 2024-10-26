import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  void dispose() {
    super.dispose();
    _contentTrackingController.dispose();
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
                  //kích thước bóng
                  spreadRadius: 2,
                  //Độ mờ bóng
                  blurRadius: 2,
                  //kiểu mờ của bóng
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
                    //kích thước bóng
                    spreadRadius: 2,
                    //Độ mờ bóng
                    blurRadius: 2,
                    //kiểu mờ của bóng
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
                        'Hôm nay, ${DateConverter.getWeekDay(now)}',
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
                  FutureBuilder<CheckInEntity?>(
                    future: Get.find<TrackingController>().getCheckin(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data == null) {
                        return const SizedBox.shrink();
                      } else {
                        CheckInEntity objCheckIn = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText14(
                              'Giờ vào ${objCheckIn.dateAttendance?.hour}h',
                              color: ColorResources.getWhiteColor(),
                            ),
                            SizedBox(height: 10.h),
                            AppText16(
                              objCheckIn.message != null
                                  ? 'Đã CheckIn'
                                  : 'Chưa CheckIn',
                              fontWeight: FontWeight.bold,
                              color: ColorResources.getWhiteColor(),
                            ),
                          ],
                        );
                      }
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
                    'Nội dung tracking',
                    color: ColorResources.getTextColor(),
                  ),
                  SizedBox(height: 30.h),
                  AppTextAreaField(
                    hintText: 'Hôm nay tôi ...',
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
                        'Lịch sử tracking',
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
}
