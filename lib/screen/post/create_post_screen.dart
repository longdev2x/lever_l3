
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_text_field.dart';
import 'package:timesheet/view/app_toast.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({
    super.key,
  });

  @override
  State<CreatePostScreen> createState() =>
      _CreatePostScreenState();
}

class _CreatePostScreenState
    extends State<CreatePostScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    User objUser = Get.find<AuthController>().user;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 120.h,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AppConfirm(
                  title: 'Dữ liệu sẽ không được lưu, bạn chắc chứ?',
                  onConfirm: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
            );
          },
          icon: const Icon(Icons.close),
        ),
        title: const AppText20(
          'Tạo bài viết',
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
            },
            child: const AppText20('Đăng'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: objUser.image != null
                            ? NetworkImage(objUser.image!)
                            : const AssetImage(Images.imgAvatarDefault)
                                as ImageProvider,
                        radius: 35,
                      ),
                      SizedBox(width: 16.w),
                      
                      const Spacer(),
                      
                    ],
                  ),
                  SizedBox(height: 20.h),
                  AppTextAreaField(
                    controller: _controller,
                    hintText: 'Hãy nói gì đó về nội dung này...',
                  ),
                  SizedBox(height: 20.h),
                  //Hàng ảnh
                  
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          left: 10.w,
          right: 10.w,
        ),
        child: const Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            ],
          ),
        ),
      ),
    );
  }

}
