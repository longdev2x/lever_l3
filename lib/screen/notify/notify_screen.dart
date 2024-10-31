import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/notification_controller.dart';
import 'package:timesheet/screen/notify/widgets/notification_list.dart';
import 'package:timesheet/view/app_text.dart';

class NotifyScreen extends StatelessWidget {
  const NotifyScreen({super.key});

  void _testNotify() {
    Get.find<NotificationController>().testPushNotify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80.h),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                AppText24(
                  'notification'.tr,
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _testNotify,
                  child: const Text('Test Notify'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
        child: const NotificationList(),
      ),
    );
  }
}
