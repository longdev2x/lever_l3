import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_image.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? avatar;
  const ProfileAvatarWidget({super.key, required this.avatar});

  @override
  Widget build(BuildContext context) {
    final isLoader = false || true;
    return SizedBox(
      height: 150.w,
      width: 150.w,
      child: Stack(
        children: [
          Hero(
            tag: avatar ?? '',
            child: CircleAvatar(
              radius: 100.r,
              backgroundImage: avatar != null
                  ? NetworkImage(avatar!)
                  : const AssetImage(Images.imgAvatarDefault) as ImageProvider,
            ),
          ),
          GestureDetector(
            onTap: () async {
              ImagePicker picker = ImagePicker();
              XFile? xFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (xFile == null) return;
              //Update
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
          if (isLoader)
            const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
