import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheet/utils/images.dart';

class AppImageAsset extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final double radius;
  final Function()? onTap;
  final BoxFit? boxFit;
  final Color? color;

  const AppImageAsset(
      {super.key,
      this.imagePath = Images.logo,
      this.width,
      this.height,
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
          width: width?.w,
          height: height?.h,
          fit: boxFit,
          color: color,
        ),
      ),
    );
  }
}

class AppImageFile extends StatelessWidget {
  final File? imageFile;
  final double width;
  final double height;
  final double radius;
  final Function()? onTap;
  final BoxFit? boxFit;
  final Color? color;

  const AppImageFile(
      {super.key,
      this.imageFile,
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
        child: imageFile != null
            ? Image.file(
                imageFile!,
                width: width.w,
                height: height.h,
                fit: boxFit,
                color: color,
              )
            : Image.asset(
                Images.imgAvatarDefault,
                width: width.w,
                height: height.h,
                fit: boxFit,
                color: color,
              ),
      ),
    );
  }
}

class AppCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final void Function()? onTap;
  const AppCachedNetworkImage({super.key, this.imageUrl, this.width, this.height, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        height: height?.h,
        width: width?.w,
        fit: BoxFit.cover,
        imageUrl: imageUrl ?? '',
        placeholder: (context, url) => SizedBox(
            height: 20.h,
            width: 20.h,
            child: const Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) =>
            Image.asset(Images.imgAvatarDefault),
      ),
    );
  }
}
