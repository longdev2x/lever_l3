import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/post_list_controller.dart';
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
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {

        bool isTop = _scrollController.position.pixels == 0;
        if (!isTop) {
          Get.find<PostListController>().getPosts(
            pageIndex: Get.find<PostListController>().posts!.length ~/ 15,
            size: 15,
            status: null,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {}

  @override
  Widget build(BuildContext context) {
    final User objUser = Get.find<AuthController>().user;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              GetBuilder<PostListController>(
                builder: (controller) {
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
                },
              ),
              const PostDividerWidget(),
              PostContent(),
            ],
          ),
        ),
      ),
    );
  }

  void _addImage(BuildContext context, User objUser) async {
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
