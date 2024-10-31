import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/controller/profile_controller.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/screen/post/widgets/create_post_image.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_text_field.dart';
import 'package:timesheet/view/app_toast.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({
    super.key,
  });

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void _onPost() async {
    String content = _controller.text;
    if (content.trim().isEmpty) {
      AppToast.showToast('Chưa có nội dung');
      return;
    }
    int statusCode =
        await Get.find<PostController>().createPost(content: content);

    if (statusCode == 200 && mounted) {
      Navigator.pop(context);
    }
  }

  void _onPop() {
    showDialog(
      context: context,
      builder: (ctx) => AppConfirm(
          title: 'Dữ liệu sẽ không được lưu, bạn chắc chứ?',
          onConfirm: () {
            Get.find<PostController>().removeMedia();
            Navigator.pop(context);
            Navigator.pop(context);
          }),
    );
  }

  void _addImage({bool isCamera = false}) async {
    final ImagePicker picker = ImagePicker();
    if (isCamera) {
      final XFile? xFile = await picker.pickImage(source: ImageSource.camera);
      if (xFile != null) {
        Get.find<PostController>().uploadImages([xFile]);
      }
      return;
    }

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
    User objUser = Get.find<AuthController>().user;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: _onPop,
          icon: const Icon(Icons.close),
        ),
        title: const AppText20('Tạo bài viết', fontWeight: FontWeight.bold),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onPost,
            child: const AppText20('Đăng'),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GetBuilder<ProfileController>(
                            initState: (state) =>
                                Get.find<ProfileController>().getImage(),
                            builder: (controller) => CircleAvatar(
                              radius: 25.r,
                              backgroundImage: controller.fileAvatar != null
                                  ? FileImage(controller.fileAvatar!)
                                  : const AssetImage(Images.imgAvatarDefault)
                                      as ImageProvider,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          AppText16(objUser.displayName,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      AppTextAreaField(
                        controller: _controller,
                        hintText: 'Hãy nói gì đó về nội dung này...',
                        maxLength: 1000,
                        maxLines: 10,
                      ),
                      SizedBox(height: 20.h),
                      //Hàng ảnh
                      const CreatePostImageWidget(maxImages: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(child: GetBuilder<PostController>(
            builder: (controller) {
              return Visibility(
                visible: controller.loading,
                child: const CircularProgressIndicator(),
              );
            },
          )),
        ],
      ),
      bottomNavigationBar: Card(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 30.w,
              right: 30.w,
              top: 10.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppImageAsset(
                onTap: () {
                  _addImage(isCamera: true);
                },
                imagePath: Images.icCamera,
                height: 30,
                width: 30,
              ),
              SizedBox(width: 20.w),
              AppImageAsset(
                onTap: () {
                  _addImage();
                },
                imagePath: Images.icImagePicker,
                height: 30,
                width: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
