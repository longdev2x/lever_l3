import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';

class UserParameterWidget extends StatelessWidget {
  final String name;
  final String icon;
  final String prameter;
  final bool? isFirst;
  final bool? isLast;
  const UserParameterWidget(
      {super.key,
      required this.name,
      required this.icon,
      required this.prameter,
      this.isFirst = false,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        margin: EdgeInsets.only(bottom: 5.h),
        decoration: BoxDecoration(
          color: ColorResources.getOthersCardColor(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isFirst! ? 12 : 0),
            topRight: Radius.circular(isFirst! ? 12 : 0),
            bottomLeft: Radius.circular(isLast! ? 12 : 0),
            bottomRight: Radius.circular(isLast! ? 12 : 0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImageAsset(imagePath: icon, width: 28, height: 28,),
            SizedBox(width: 5.w),
            AppText16(name, color: ColorResources.getTextColor()),
            const Spacer(),
            AppText16(
              prameter,
              fontWeight: FontWeight.bold,
              color: ColorResources.getTextColor(),
            ),
          ],
        ),
      ),
    );
  }
}