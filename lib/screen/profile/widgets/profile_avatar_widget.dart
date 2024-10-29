import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/controller/profile_controller.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';

class ProfileAvatarWidget extends StatelessWidget {
  const ProfileAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      initState: (state) => Get.find<ProfileController>().getImage(),
      builder: (controller) => SizedBox(
        height: 150.w,
        width: 150.w,
        child: Stack(
          children: [
            Hero(
              tag: controller.user?.id.toString() ?? 'avatar',
              child: CircleAvatar(
                radius: 100.r,
                backgroundImage: controller.fileAvatar != null
                    ? FileImage(controller.fileAvatar!)
                    : const AssetImage(Images.imgAvatarDefault)
                        as ImageProvider,
              ),
            ),
            GestureDetector(
              onTap: () async {
                ImagePicker picker = ImagePicker();
                XFile? xFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (xFile == null) return;
                _changeIamge(xFile);
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 40.w,
                  width: 40.w,
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onError,
                      shape: BoxShape.circle),
                  child: const AppImageAsset(imagePath: Images.icCamera),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeIamge(XFile xFile) {
    Get.find<ProfileController>().changeAvatar(xFile);
  }
}
