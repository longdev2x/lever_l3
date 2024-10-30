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
import 'package:timesheet/view/app_toast.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late final TextEditingController _contentTrackingController;
  final DatePickerController _datePickerController = DatePickerController();

  DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
    _contentTrackingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _datePickerController.animateToDate(DateTime.now());
      },
    );
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

  void _checkIn() async {
    int statusCode = await Get.find<CheckInController>().checkIn();
    if (statusCode == 200) {
      AppToast.showToast('CheckIn thành công');
    }
  }

  void onTracking() async {
    String content = _contentTrackingController.text;
    if (content.trim().isNotEmpty) {
      int statusCode =
          await Get.find<TrackingController>().saveTracking(content: content);
      if (statusCode == 200) {
        _contentTrackingController.clear();
        AppToast.showToast('Tracking thành công');
        Get.to(() => const TrackingHistoryScreen());
      }
    }
  }

  void _onHistory(BuildContext context, DateTime? date) async {
    if (date != null) {
      Get.find<TrackingController>().filterList(date);
    } else {
      Get.find<TrackingController>().filterList(null);
    }
    Get.to(() => const TrackingHistoryScreen());
  }

  String _checkDelay(DateTime dateCheckIn) {
    //Ví dụ 7 giờ phải checkIn
    DateTime ruleTime =
        DateTime(dateCheckIn.year, dateCheckIn.month, dateCheckIn.day, 7, 0);
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
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80.h),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.7),
                  offset: const Offset(0, 3),
                  spreadRadius: 2,
                  blurRadius: 2,
                  blurStyle: BlurStyle.normal,
                ),
              ],
            ),
            child: Row(
              children: [
                AppText24(
                  'Tracking',
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                AppImageAsset(
                  imagePath: Images.profile,
                  width: 25.w,
                  height: 25.w,
                  color: theme.colorScheme.onPrimary,
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
                color: theme.colorScheme.secondary,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.4),
                    offset: const Offset(0, 3),
                    spreadRadius: 2,
                    blurRadius: 2,
                    blurStyle: BlurStyle.normal,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText14(
                        '${'today'.tr}, ${DateConverter.getWeekDay(now)}',
                        color: theme.colorScheme.onPrimary,
                      ),
                      SizedBox(height: 10.h),
                      AppText16(
                        DateConverter.getOnlyFomatDate(now),
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
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
                          listCheckIn.last.dateAttendance?.toLocal().day !=
                              nowDay) {
                        return ElevatedButton(
                          onPressed: _checkIn,
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(
                              theme.colorScheme.onSecondary,
                            ),
                            foregroundColor: WidgetStatePropertyAll<Color>(
                              theme.colorScheme.secondary,
                            ),
                          ),
                          child: AppText16('check_in'.tr),
                        );
                      }
                      CheckInEntity todayCheckIn = listCheckIn.last;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText14(
                            '${'date_attendance'.tr} ${todayCheckIn.dateAttendance?.hour}h',
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 10.h),
                          AppText16(
                            _checkDelay(todayCheckIn.dateAttendance!),
                            color: theme.colorScheme.onPrimary,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Align(
                alignment: Alignment.center,
                child: DatePicker(
                  now.subtract(const Duration(days: 27)),
                  height: 90.h,
                  controller: _datePickerController,
                  initialSelectedDate: now,
                  daysCount: 30,
                  selectionColor: theme.colorScheme.primary,
                  selectedTextColor: theme.colorScheme.onPrimary,
                  dateTextStyle: TextStyle(color: ColorResources.getBlackColor(), fontWeight: FontWeight.w500, fontSize: 21.sp),
                  dayTextStyle: TextStyle(color: ColorResources.getBlackColor(), fontSize: 10.sp),
                  monthTextStyle: TextStyle(color: ColorResources.getBlackColor(), fontSize: 12.sp),
                  onDateChange: (selectedDate) {
                    _onHistory(context, selectedDate);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 25.h),
                  AppText28(
                    '${'content'.tr} tracking',
                    color: theme.colorScheme.onSurface,
                  ),
                  SizedBox(height: 25.h),
                  AppTextAreaField(
                    hintText: '${'today'.tr} ${('i'.tr).toLowerCase()} ...',
                    controller: _contentTrackingController,
                  ),
                  SizedBox(height: 25.h),
                  AppButton(
                    name: 'Tracking',
                    ontap: onTracking,
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                      onTap: () {
                        _onHistory(context, null);
                      },
                      child: AppText16(
                        '${'history'.tr} tracking',
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
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
