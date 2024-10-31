import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/view/app_text.dart';

class CreatePostImageWidget extends StatelessWidget {
  final int maxImages;
  const CreatePostImageWidget({super.key, required this.maxImages});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWith = (constraints.maxWidth - 4)/3;
        return GetBuilder<PostController>(
          builder: (controller) {
            List<XFile>? xFiles = controller.xFiles;
            
            if (xFiles == null || xFiles.isEmpty) {
              return const SizedBox();
            }
            int displayCount =
                xFiles.length > maxImages ? maxImages : xFiles.length;
            int? otherCount =
                xFiles.length > maxImages ? xFiles.length - maxImages : null;
            return Wrap(
              spacing: 2,
              runSpacing: 2,
              children: [
                ...List.generate(displayCount, (index) {
                  return _buildImage(xFiles[index], itemWith,
                      isLast: index == displayCount - 1 && xFiles.length > maxImages,
                      otherCount: otherCount);
                }),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildImage(XFile xFile, double itemWith,
      {bool isLast = false, int? otherCount}) {
    return Stack(
      children: [
        Image.file(
          File(xFile.path),
          width: itemWith,
          height: itemWith,
          fit: BoxFit.cover,
          //Màu phủ lên
          color: isLast ? Colors.black.withOpacity(0.5) : null,
          //Cách phủ
          colorBlendMode: isLast ? BlendMode.darken : null,
        ),
        if (isLast)
          Positioned.fill(
            child: Center(
              child: SizedBox(
                width: itemWith / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white),
                    AppText20(otherCount.toString(), color: Colors.white,)
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
