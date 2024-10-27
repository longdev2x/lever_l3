import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/notification_controller.dart';
import 'package:timesheet/data/model/body/notification_entity.dart';
import 'package:timesheet/screen/notify/widgets/notification_item.dart';
import 'package:timesheet/view/app_text.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        List<NotificationEntity>? notifications = controller.notifications;

        if (controller.loading) {
          return _loadingWidget(controller);
        }
        if (controller.notifications == null) {
          return _errorWidget();
        }
        if (controller.notifications!.isEmpty) {
          return Center(
            child: AppText16('no_data_found'.tr),
          );
        }
        return ListView.builder(
          itemBuilder: (ctx, index) =>
              NotificationItem(objNotify: notifications![index]),
        );
      },
    );
  }

  Widget _errorWidget() => Center(
        child: AppText18('error'.tr),
      );

  Widget _loadingWidget(NotificationController controller) => Visibility(
        visible: controller.loading,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
}
