import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/tracking_entity.dart';
import 'package:timesheet/screen/home/widgets/tracking_history_item.dart';
import 'package:timesheet/view/app_text.dart';

class TrackingHistoryScreen extends StatelessWidget {
  const TrackingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử tracking'),
      ),
      body: FutureBuilder<List<TrackingEntity>>(
        future: Get.find<TrackingController>().getTracking(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<TrackingEntity> list = snapshot.data!;
            return Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return TrackingHistoryItem(objTracking: list[index]);
                },
              ),
            );
          } else {
            return const Center(
              child: AppText24('Hiện chưa ghi nhận lịch sử tracking'),
            );
          }
        },
      ),
    );
  }
}
