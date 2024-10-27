import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/data/model/body/like_entity.dart';
import 'package:timesheet/data/model/body/post_entity.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/post/widgets/post_detail_comment.dart';

import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_text_field.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final PostEntity objPost;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    objPost = Get.arguments['objPost'] as PostEntity;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _onLike() {
    Get.find<PostController>().likePost(DateTime.now(), objPost);
  }

  bool _checkLiked(int? currentId, List<LikeEntity> likes) {
    return likes.any((e) => e.user?.id == currentId);
  }

  String _getDateFormat(DateTime? date) {
    if (date == null) return 'no_data_found'.tr;
    DateTime now = DateTime.now();

    int difference = now.difference(date).inMinutes;

    if (difference < 60) {
      return '$difference ${'minutes_ago'.tr}';
    }
    if (difference < 1440) {
      int hours = now.difference(date).inHours;
      return '$hours ${'hours_ago'.tr}';
    }
    if (difference < 10080) {
      int days = now.difference(date).inDays;
      return '$days ${'days_ago'.tr}';
    }
    return '${DateConverter.getWeekDay(objPost.date!)} - ${'days'} ${DateConverter.getOnlyFomatDate(objPost.date!)}';
  }

  void _onPop() {
    Navigator.of(context).pop();
  }

  void _onCommentSend() async {
    String comment = _controller.text;
    if (comment.trim().isEmpty) return;
    int statusCode = await Get.find<PostController>().sendComment(comment, objPost);
    if(statusCode == 200) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    int? currentId = Get.find<AuthController>().user.id;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppImageAsset(
                    imagePath: Images.icArrowBack,
                    width: 12.w,
                    height: 20.565.w,
                    onTap: _onPop,
                  ),
                  SizedBox(width: 20.w),
                  CircleAvatar(
                    backgroundImage: objPost.user?.image != null
                        ? NetworkImage(objPost.user!.image!)
                        : const AssetImage(Images.imgAvatarDefault)
                            as ImageProvider,
                    radius: 25,
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText16(
                        objPost.user?.displayName,
                        fontWeight: FontWeight.bold,
                      ),
                      AppText14(_getDateFormat(objPost.date)),
                    ],
                  ),
                  const Spacer(),
                  AppImageAsset(
                    imagePath: Images.icThreeDotHori,
                    width: 17.w,
                    height: 3.86.w,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          )),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
        child: SafeArea(
          child: GetBuilder<PostController>(
            builder: (controller) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText20(
                      objPost.content,
                      maxLines: null,
                    ),
                    SizedBox(height: 50.h),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: _reactButton(
                          onLikeTap: _onLike,
                          onCommentTap: () {},
                          isLiked: _checkLiked(currentId, objPost.likes)),
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
                    SizedBox(height: 20.h),
                    PostDetailComment(comments: objPost.comments),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 5.h, 16.w, 10.h),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, -1),
                  blurRadius: 0,
                  spreadRadius: 0),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _controller,
                  hintText: 'Viết bình luận...',
                ),
              ),
              SizedBox(width: 20.w),
              AppImageAsset(
                imagePath: Images.icSend,
                onTap: _onCommentSend,
                width: 30,
                height: 30,
              ),
            ],
          ),
        ),
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
          onTap: onLikeTap,
          imagePath: Images.icLike,
          height: 18,
          width: 21,
          color: isLiked ? Colors.blue : null,
        ),
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
