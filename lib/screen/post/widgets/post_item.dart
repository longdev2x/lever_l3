import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/data/model/body/like_entity.dart';
import 'package:timesheet/data/model/body/post_entity.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/post/post_detail_screen.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_text_field.dart';
import 'package:timesheet/view/app_toast.dart';

class PostItem extends StatefulWidget {
  final PostEntity objPost;
  const PostItem({super.key, required this.objPost});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _checkLiked(int? currentId, List<LikeEntity> likes) {
    return likes.any((e) => e.user?.id == currentId);
  }

  void _onLike() {
    Get.find<PostController>().likePost(DateTime.now(), widget.objPost);
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
    return '${DateConverter.getWeekDay(widget.objPost.date!)} - ${'days'} ${DateConverter.getOnlyFomatDate(widget.objPost.date!)}';
  }

  void _navigateToDetail() {
    Get.to(() => const PostDetailScreen(),
        arguments: {'postId': widget.objPost.id});
  }

  void _onEditPost() {
    _controller.text = widget.objPost.content ?? '';
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
                            widget.objPost,
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

  bool _checkIsMe() {
    int? currentId = Get.find<AuthController>().user.id;
    return currentId == widget.objPost.user?.id;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    int? currentId = Get.find<AuthController>().user.id;

    return GestureDetector(
      onTap: () {
        _navigateToDetail();
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
        child: GetBuilder<PostController>(
          builder: (controller) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundImage:
                        controller.mapFileAvatar[widget.objPost.user?.image] !=
                                null
                            ? FileImage(controller
                                .mapFileAvatar[widget.objPost.user?.image]!)
                            : const AssetImage(Images.imgAvatarDefault)
                                as ImageProvider,
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText16(
                        widget.objPost.user?.displayName,
                        fontWeight: FontWeight.bold,
                      ),
                      AppText14(_getDateFormat(widget.objPost.date)),
                    ],
                  ),
                  const Spacer(),
                  _checkIsMe()
                      ? AppImageAsset(
                          onTap: _onEditPost,
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
              SizedBox(height: 10.h),
              AppText20(
                widget.objPost.content,
                maxLines: 5,
              ),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: _reactButton(
                    onLikeTap: _onLike,
                    onCommentTap: () {
                      _navigateToDetail();
                    },
                    isLiked: _checkLiked(currentId, widget.objPost.likes),
                    theme: theme),
              ),
              SizedBox(width: 14.w),
              Padding(
                padding: EdgeInsets.only(top: 14.h, bottom: 20.h),
                child: _reactInfor(
                    onLikeTap: () {},
                    onCommentTap: () {
                      _navigateToDetail();
                    },
                    reactInfors: widget.objPost.likes,
                    commentCounts: widget.objPost.comments.length),
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
        width: 16.w,
        height: 16.w,
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
          color: isLiked
              ? const Color.fromARGB(255, 39, 27, 207)
              : theme.colorScheme.onSurface,
        ),
        SizedBox(width: 30.w),
        AppImageAsset(
          onTap: onCommentTap,
          imagePath: Images.icCmt,
          height: 25,
          width: 25,
          color: theme.colorScheme.onSurface,
        ),
      ],
    );
  }
}
