import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/post_list_controller.dart';
import 'package:timesheet/data/model/body/like_entity.dart';
import 'package:timesheet/data/model/body/post_entity.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';

class PostItem extends StatelessWidget {
  final PostEntity objPost;
  const PostItem({super.key, required this.objPost});

  bool _checkLiked(int? currentId, List<LikeEntity> likes) {
    return likes.any((e) => e.user?.id == currentId);
  }

  void _onLike() {
    Get.find<PostListController>().likePost(DateTime.now(), objPost);
  }

  @override
  Widget build(BuildContext context) {
    int? currentId = Get.find<AuthController>().user.id;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: objPost.user?.image != null
                    ? NetworkImage(objPost.user!.image!)
                    : const AssetImage(Images.imgAvatarDefault)
                        as ImageProvider,
                radius: 25,
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText16(
                    objPost.user?.displayName,
                    fontWeight: FontWeight.bold,
                  ),
                  AppText14(objPost.date.toString()),
                ],
              ),
              const Spacer(),
              AppImageAsset(
                onTap: () {},
                imagePath: Images.icThreeDotVeti,
                width: 3,
                height: 15,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          AppText20(
            objPost.content,
            maxLines: null,
          ),
          SizedBox(height: 50.h),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: _reactButton(
                onLikeTap: _onLike, onCommentTap: () {}, isLiked: _checkLiked(currentId, objPost.likes)),
          ),
          SizedBox(width: 14.w),
          Padding(
            padding: EdgeInsets.only(top: 14.h, bottom: 20.h),
            child: _reactInfor(
                onLikeTap: () {},
                onCommentTap: () {},
                reactInfors: objPost.likes,
                commentCounts: objPost.comments.length),
          ),
        ],
      ),
    );
  }

  Widget _reactInfor(
      {required Function() onLikeTap,
      required Function() onCommentTap,
      required List<LikeEntity> reactInfors,
      required int commentCounts}) {
    return Row(
      children: [
        if (reactInfors.isNotEmpty)
          GestureDetector(
            onTap: onLikeTap,
            child: Row(
              children: [
                _reactIcon(Images.icReacLike, [
                  const Color(0xFF6B79F2),
                  const Color(0xFF0019FE),
                ]),
                SizedBox(width: 6.w),
                reactInfors.length > 1
                    ? AppText10(
                        'Like by ${reactInfors[0].user?.displayName} and ${reactInfors.length - 1} others',
                      )
                    : AppText10(
                        'Like by ${reactInfors[0].user?.displayName}',
                      ),
              ],
            ),
          ),
        const Spacer(),
        if (commentCounts != 0)
          GestureDetector(
              onTap: onCommentTap, child: AppText10('$commentCounts comment')),
      ],
    );
  }

  Widget _reactIcon(String icon, List<Color> colors) => Container(
        width: 14.w,
        height: 14.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          gradient: LinearGradient(colors: colors),
        ),
        child: AppImageAsset(
          width: 8.w,
          height: 7.w,
          imagePath: icon,
          color: Colors.white,
        ),
      );

  Widget _reactButton({
    required Function() onLikeTap,
    required Function() onCommentTap,
    bool isLiked = false,
  }) {
    return Row(
      children: [
        AppImageAsset(
            onTap: onLikeTap, imagePath: Images.icLike, height: 18, width: 21, color: isLiked ? Colors.blue : null,),
        SizedBox(width: 30.w),
        AppImageAsset(
            onTap: onCommentTap,
            imagePath: Images.icCmt,
            height: 18,
            width: 21),
        SizedBox(width: 30.w),
      ],
    );
  }
}
