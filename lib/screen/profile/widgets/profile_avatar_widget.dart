import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/controller/profile_controller.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_toast.dart';

class ProfileAvatarWidget extends StatelessWidget {
  const ProfileAvatarWidget({super.key});

  void _changeImage() async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    int statusCode = await Get.find<ProfileController>().uploadAvatar(xFile);

    if (statusCode == 200) {
      AppToast.showToast('Upload thành công');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      initState: (state) => Get.find<ProfileController>().getImage(),
      builder: (controller) {
        return SizedBox(
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
                onTap: _changeImage,
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
              Center(
                child: Visibility(
                  visible: controller.imgLoading ? true : false,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
