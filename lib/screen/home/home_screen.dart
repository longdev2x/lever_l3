import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  offset: const Offset(0, 3),
                  //kích thước bóng
                  spreadRadius: 2,
                  //Độ mờ bóng
                  blurRadius: 5,
                  //kiểu mờ của bóng
                  blurStyle: BlurStyle.normal,
                ),
              ],
            ),
            child: Row(
              children: [
                const AppText18(
                  'Tracking',
                  color: Color(0xFF5f607f),
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                AppImageAsset(
                  imagePath: Images.profile,
                  width: 25.w,
                  height: 25.w,
                  onTap: () {
                    //Navigate to profile
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
                color: const Color(0xFF11a9f5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 3),
                    //kích thước bóng
                    spreadRadius: 2,
                    //Độ mờ bóng
                    blurRadius: 5,
                    //kiểu mờ của bóng
                    blurStyle: BlurStyle.normal,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText14(
                        'Hôm nay, ${DateConverter.getWeekDay(now)}',
                        color: Colors.white,
                      ),
                      SizedBox(height: 10.h),
                      AppText16(
                        DateConverter.getOnlyFomatDate(now),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText14(
                        'Giờ vào ...',
                        color: Colors.white,
                      ),
                      SizedBox(height: 10.h),
                      AppText16(
                        'Chưa tracking...',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ],
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
                  selectedTextColor: Colors.white,
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
                    ontap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
