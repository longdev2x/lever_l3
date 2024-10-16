import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? lable;
  final String? initValue;
  final bool readOnly;
  final Function()? onTap;
  const AppTextField(
      {super.key, this.controller, this.hintText, this.lable, this.readOnly = false, this.onTap, this.initValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      initialValue: initValue,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 28),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color.fromRGBO(244, 244, 244, 1)),
              borderRadius: BorderRadius.circular(15)),
          hintText: hintText,
          label: lable != null ? Text(lable!) : null,
          hintStyle: const TextStyle(color: Colors.grey)),
    );
  }
}

class AppTextAreaField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? lable;
  final String? initValue;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final Function()? onTap;
  const AppTextAreaField(
      {super.key, this.controller, this.hintText, this.lable, this.readOnly = false, this.onTap, this.initValue, this.maxLines = 10, this.maxLength = 500});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      textAlignVertical: TextAlignVertical.center,
      onTap: onTap,
      initialValue: initValue,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color.fromRGBO(244, 244, 244, 1)),
              borderRadius: BorderRadius.circular(15)),
          hintText: hintText,
          label: lable != null ? Text(lable!) : null,
          hintStyle: const TextStyle(color: Colors.grey)),
    );
  }
}
