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
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_text_field.dart';
import 'package:timesheet/view/app_toast.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final int postId;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    postId = Get.arguments['postId'] as int;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _onLike(PostEntity objPost) {
    Get.find<PostController>().likePost(DateTime.now(), objPost);
  }

  bool _checkLiked(int? currentId, List<LikeEntity> likes) {
    return likes.any((e) => e.user?.id == currentId);
  }

  String _getDateFormat(DateTime? date, PostEntity objPost) {
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

  void _onCommentSend(PostEntity objPost) async {
    String comment = _controller.text;
    if (comment.trim().isEmpty) return;
    int statusCode =
        await Get.find<PostController>().sendComment(comment, objPost);
    if (statusCode == 200) {
      _controller.clear();
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    }
  }

  void _onEditPost(PostEntity objPost) {
    _controller.text = objPost.content ?? '';
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppText20('Chỉnh sửa'),
                SizedBox(height: 10.h),
                AppTextAreaField(
                  lable: 'Nội dung',
                  controller: _controller,
                  maxLength: 1000,
                  maxLines: 5,
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        name: 'Submit',
                        ontap: () async {
                          if (_controller.text.isEmpty) {
                            AppToast.showToast('Chưa có nội dung');
                            return;
                          }
                          int statusCode =
                              await Get.find<PostController>().editPost(
                            objPost,
                            _controller.text,
                          );
                          if (statusCode == 200) {
                            AppToast.showToast('Update thành công');
                          }
                          Get.back();
                        },
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: AppButton(
                        name: 'Canclle',
                        ontap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _checkIsMe(PostEntity objPost) {
    int? currentId = Get.find<AuthController>().user.id;
    return currentId == objPost.user?.id;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    int? currentId = Get.find<AuthController>().user.id;

    return GetBuilder<PostController>(builder: (controller) {
      PostEntity objPost = controller.posts!.firstWhere(
        (objPost) => objPost.id == postId,
      );

      return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
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
                      color: theme.appBarTheme.foregroundColor,
                    ),
                    SizedBox(width: 20.w),
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage: controller
                                  .mapFileAvatar[objPost.user?.image] !=
                              null
                          ? FileImage(
                              controller.mapFileAvatar[objPost.user?.image]!)
                          : const AssetImage(Images.imgAvatarDefault)
                              as ImageProvider,
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
                        AppText14(_getDateFormat(objPost.date, objPost)),
                      ],
                    ),
                    const Spacer(),
                    _checkIsMe(objPost)
                        ? AppImageAsset(
                            onTap: () => _onEditPost(objPost),
                            imagePath: Images.icEditPost,
                            width: 30,
                            height: 30,
                          )
                        : AppImageAsset(
                            onTap: () {},
                            imagePath: Images.icThreeDotHori,
                            width: 20,
                            height: 4,
                          ),
                  ],
                ),
              ),
            )),
        body: SafeArea(
          child: GetBuilder<PostController>(
            builder: (controller) {
              return Stack(
                children: [
                  Container(
                    height: 1.sh,
                    padding: EdgeInsets.only(bottom: 60.h),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText20(
                              objPost.content,
                              maxLines: 20,
                            ),
                            SizedBox(height: 50.h),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: _reactButton(
                                onLikeTap: () => _onLike(objPost),
                                onCommentTap: () {},
                                theme: theme,
                                isLiked: _checkLiked(
                                  currentId,
                                  objPost.likes,
                                ),
                              ),
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
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16.w, 5.h, 16.w, 10.h),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            spreadRadius: 1,
                            color: theme.colorScheme.shadow.withOpacity(0.2),
                            offset: const Offset(0, -1),
                          ),
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
                            onTap: () => _onCommentSend(objPost),
                            width: 45,
                            height: 45,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    });
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
                    ? AppText14(
                        'Like by ${reactInfors[0].user?.displayName?.split(' ').last} and ${reactInfors.length - 1} others',
                      )
                    : AppText14(
                        'Like by ${reactInfors[0].user?.displayName}',
                      ),
              ],
            ),
          ),
        const Spacer(),
        if (commentCounts != 0)
          GestureDetector(
              onTap: onCommentTap, child: AppText14('$commentCounts comment')),
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
    required ThemeData theme,
  }) {
    return Row(
      children: [
        AppImageAsset(
          onTap: onLikeTap,
          imagePath: Images.icReacLike,
          height: 25,
          width: 25,
          color: isLiked ? Colors.blue : theme.colorScheme.secondary,
        ),
        SizedBox(width: 30.w),
        AppImageAsset(
          onTap: onCommentTap,
          imagePath: Images.icCmt,
          height: 25,
          width: 25,
          color: theme.colorScheme.secondary,
        ),
      ],
    );
  }
}
