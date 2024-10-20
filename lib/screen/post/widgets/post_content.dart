import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/post_list_controller.dart';
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
    return GetBuilder<PostListController>(
      builder: (controller) {
        final List<PostEntity>? posts = controller.posts;
        if (controller.isFirstLoad) {
          return const Center(child: CircularProgressIndicator());
        }
        if (posts == null) {
          return const Center(
            child: Text('Lỗi khi tải dữ liệu'),
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
