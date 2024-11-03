import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/view/app_text.dart';

class PostImagesWidget extends StatelessWidget {
  final int maxImages;
  final List<File> files;

  const PostImagesWidget({
    super.key,
    required this.maxImages,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWith = (constraints.maxWidth - 4) / 3;
        if(files.length == 1) {
          itemWith = constraints.maxWidth;
        } else if(files.length == 2) {
          (constraints.maxWidth - 2) / 2;
        }

        return GetBuilder<PostController>(
          builder: (controller) {
            int displayCount =
                files.length > maxImages ? maxImages : files.length;
            int? otherCount =
                files.length > maxImages ? files.length - maxImages : null;
            return Wrap(
              spacing: 2,
              runSpacing: 2,
              children: [
                ...List.generate(displayCount, (index) {
                  return _buildImage(files[index], itemWith,
                      isLast: index == displayCount - 1 &&
                          files.length > maxImages,
                      otherCount: otherCount);
                }),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildImage(File file, double itemWith,
      {bool isLast = false, int? otherCount}) {
    return Stack(
      children: [
        Image.file(
          file,
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
                    AppText20(
                      otherCount.toString(),
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
