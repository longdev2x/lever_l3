import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/data/model/body/post_entity.dart';
import 'package:timesheet/screen/post/widgets/post_divider_widget.dart';
import 'package:timesheet/screen/post/widgets/post_item.dart';

class PostContent extends StatefulWidget {
  const PostContent({super.key});

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostController>(
      builder: (controller) {
        final List<PostEntity>? posts = controller.posts;
        if (controller.isFirstLoad) {
          return SizedBox(
            height: 1.sh - 200.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (posts == null) {
          return Center(
            child: Text('error'.tr),
          );
        }
        return ListView.separated(
          itemBuilder: (context, index) {
            if (index == posts.length) {
              return const Center(child: CircularProgressIndicator());
            }
            return PostItem(
              objPost: posts[index],
            );
          },
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          separatorBuilder: (context, index) => const PostDividerWidget(),
          itemCount: posts.length + 1,
        );
      },
    );
  }
}
