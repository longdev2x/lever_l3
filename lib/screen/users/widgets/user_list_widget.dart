import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/screen/users/widgets/user_item.dart';
import 'package:timesheet/view/app_text.dart';

class UserListWidget extends StatefulWidget {
  const UserListWidget({super.key});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      Get.find<UserController>().searchUser(
        pageIndex: Get.find<UserController>().users!.length ~/ 15 + 1,
        size: 15,
        status: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Get.find<UserController>();
    return GetBuilder<UserController>(
      builder: (controller) {
        if (controller.isFirstLoad) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.users != null) {
          if (controller.users!.isEmpty) {
            return Center(
              child: AppText24('empty_list'.tr),
            );
          }
          return ListView.builder(
              itemCount: controller.users!.length + 1,
              controller: scrollController,
              itemBuilder: (ctx, index) {
                if (index == controller.users!.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return UserItem(objUser: controller.users![index]);
                }
              });
        } else {
          return Center(
            child: AppText24(
              'error'.tr,
              color: theme.colorScheme.error,
            ),
          );
        }
      },
    );
  }
}
