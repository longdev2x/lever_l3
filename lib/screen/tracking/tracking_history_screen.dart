import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/tracking_entity.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/tracking/widgets/tracking_history_item.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_toast.dart';

class TrackingHistoryScreen extends StatelessWidget {
  const TrackingHistoryScreen({super.key});

  Future<bool> _onDelete(int? id) async {
    if (id == null) {
      AppToast.showToast('Can\'t delete');
      return false;
    }

    int statusCode =
        await Get.find<TrackingController>().deleteTracking(id: id);

    if (statusCode == 200) {
      AppToast.showToast('delete_successful'.tr);
      return true;
    } else {
      AppToast.showToast('delete_not_successful'.tr);
      return false;
    }
  }

  void _onFilter(BuildContext context) async {
    final now = DateTime.now();
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: now.subtract(
        const Duration(days: 30),
      ),
      lastDate: now,
      initialDate: now,
    );
    if (date != null) {
      Get.find<TrackingController>().filterList(date);
    } else {
      Get.find<TrackingController>().filterList(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        Get.find<TrackingController>().filterList(null);
      },
      child: Scaffold(
        appBar: AppBar(
          title: GetBuilder<TrackingController>(
            builder: (controller) => controller.dateFilter == null
                ? Text('${'history'.tr} tracking')
                : Text(
                    'Tracking - ${DateConverter.getOnlyFomatDate(controller.dateFilter!)}'),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => _onFilter(context),
              label: Text('filter'.tr),
              icon: const Icon(Icons.filter_list),
            ),
          ],
        ),
        body: GetBuilder<TrackingController>(
          initState: (state) => Get.find<TrackingController>().getTracking(),
          builder: (controller) {
            List<TrackingEntity>? list = controller.trackings?.reversed.toList();
      
            if (controller.loading == true) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
      
            if (list == null) {
              return Center(
                child: AppText20('error'.tr),
              );
            }
      
            //Filter
            if (controller.dateFilter != null) {
              list = list
                  .where((e) => e.date?.day == controller.dateFilter?.day)
                  .toList();
            }
      
            if (list.isEmpty) {
              return Center(
                child: AppText20('empty_list'.tr),
              );
            }
      
            return Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(list![index].id),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AppConfirm(
                          title: 'are_you_sure_to_delete_this_schedule'.tr,
                          onConfirm: () async {
                            bool result = await _onDelete(list![index].id);
      
                            if (context.mounted) {
                              Navigator.pop(context, result);
                            }
                          },
                        ),
                      );
                    },
                    background: Container(
                      margin: EdgeInsets.only(bottom: 9.h),
                      decoration: BoxDecoration(
                          color: ColorResources.getRedColor(),
                          borderRadius: BorderRadius.circular(16)),
                      child: Align(
                        alignment: Alignment.center,
                        child: AppText20(
                          'delete'.tr,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    child: TrackingHistoryItem(
                      objTracking: list[index],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
