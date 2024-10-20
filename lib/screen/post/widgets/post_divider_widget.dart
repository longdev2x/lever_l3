import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostDividerWidget extends StatelessWidget {
  const PostDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 4.h,
      color: const Color.fromRGBO(211, 185, 193, 1),
    );
  }
}
