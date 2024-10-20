import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/create_post_controller.dart';
import 'package:timesheet/controller/post_list_controller.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/screen/post/create_post_screen.dart';
import 'package:timesheet/screen/post/widgets/post_content.dart';
import 'package:timesheet/screen/post/widgets/post_divider_widget.dart';
import 'package:timesheet/screen/post/widgets/post_header_widget.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User objUser = Get.find<AuthController>().user;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<PostListController>(builder: (controller) {
                return PostHeaderWidget(
                avatar: objUser.image,
                onTapRow: () {
                  showModalBottomSheet(
                    context: context,
                    useSafeArea: false,
                    enableDrag: false,
                    isScrollControlled: true,
                    builder: (ctx) => const CreatePostScreen(),
                  );
                },
                onTapImagePicker: () {
                  _addImage(context, objUser);
                },
              );
              },),
              
              const PostDividerWidget(),
              const PostContent(),
            ],
          ),
        ),
      ),
    );
  }

  void _addImage(
      BuildContext context, User objUser) async {
    // final ImagePicker picker = ImagePicker();
    // final List<XFile> xFiles = await picker.pickMultiImage();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: false,
      isScrollControlled: true,
      builder: (ctx) => const CreatePostScreen(),
    );
  }
}
