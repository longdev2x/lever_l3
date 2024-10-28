import 'package:flutter/material.dart';
import 'package:timesheet/data/model/body/comment_entity.dart';
import 'package:timesheet/screen/post/widgets/comment_item.dart';

class PostDetailComment extends StatelessWidget {
  final List<CommentEntity> comments;
  const PostDetailComment({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (ctx, index) => CommentItem(objComment: comments[index],),);
  }
}