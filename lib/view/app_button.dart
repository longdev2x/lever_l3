
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheet/utils/color_resources.dart';

class AppButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String? name;
  final double? radius;
  final Color? bgColor;
  final Color? textColor;
  final double? fontSize;
  final Function()? ontap;

  const AppButton({
    super.key,
    this.ontap,
    this.radius = 26,
    this.height = 45,
    this.width = double.infinity,
    this.name = "",
    this.bgColor =  ColorResources.blueColor,
    this.textColor = Colors.white,
    this.fontSize = 19,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        alignment: Alignment.center,
        height: height!.h,
        width: width!.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bgColor!,
              bgColor!.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(radius!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          name!,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: fontSize!.sp,
          ),
        ),
      ),
    );
  }
}