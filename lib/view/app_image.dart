
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheet/utils/images.dart';

class AppImageAsset extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final double radius;
  final Function()? onTap;
  final BoxFit? boxFit;
  final Color? color;

  const AppImageAsset(
      {super.key,
      this.imagePath = Images.logo,
      this.width = 16,
      this.height = 16,
      this.radius = 0,
      this.onTap,
      this.color,
      this.boxFit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
        ),
        clipBehavior: Clip.hardEdge,
        child: Image.asset(
          imagePath ?? Images.imgAvatarDefault,
          width: width.w,
          height: height.h,
          fit: boxFit,
          color: color,
        ),
      ),
    );
  }
}