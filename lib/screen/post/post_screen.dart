import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/screen/post/create_post_screen.dart';
import 'package:timesheet/screen/post/widgets/post_content.dart';
import 'package:timesheet/screen/post/widgets/post_divider_widget.dart';
import 'package:timesheet/screen/post/widgets/post_header_widget.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels == 0;
      if (!isTop) {
        Get.find<PostController>().getPosts(
          pageIndex: Get.find<PostController>().posts!.length ~/ 5 + 1,
          size: 5,
          status: null,
        );
      }
    }
  }

  void _addImage(BuildContext context, User objUser) async {
    if (!context.mounted) return;

    Get.to(() => const CreatePostScreen(), transition: Transition.downToUp);

    final ImagePicker picker = ImagePicker();
    final List<XFile> xFiles = await picker.pickMultiImage();

    if (xFiles.isNotEmpty) {
      Get.find<PostController>().uploadImages(xFiles);
      await Get.find<PostController>().uploadImages(xFiles);
    }
    if (kDebugMode) {
      print(xFiles);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User objUser = Get.find<AuthController>().user;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              GetBuilder<PostController>(
                builder: (controller) {
                  return PostHeaderWidget(
                    avatar: objUser.image,
                    onTapRow: () {
                      Get.to(() => const CreatePostScreen(),
                          transition: Transition.downToUp);
                    },
                    onTapImagePicker: () {
                      _addImage(context, objUser);
                    },
                  );
                },
              ),
              const PostDividerWidget(),
              const PostContent(),
            ],
          ),
        ),
      ),
    );
  }
}
