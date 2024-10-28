import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    this.bgColor,
    this.textColor,
    this.fontSize = 19,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
            colors: bgColor == null
                ? [
                    theme.colorScheme.primary.withOpacity(0.6),
                    theme.colorScheme.primary.withOpacity(0.9),
                  ]
                : [
                    bgColor!.withOpacity(0.6),
                    bgColor!.withOpacity(0.9),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(radius!),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow,
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          name!,
          style: TextStyle(
            color: textColor ?? theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: fontSize!.sp,
          ),
        ),
      ),
    );
  }
}
