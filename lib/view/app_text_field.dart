import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? lable;
  final String? initValue;
  final bool readOnly;
  final bool? obscureText;
  final Function()? onObscureTextTap;
  final Function()? onTap;
  final Function(String value)? onChanged;
  const AppTextField(
      {super.key,
      this.controller,
      this.hintText,
      this.lable,
      this.readOnly = false,
      this.onTap,
      this.onChanged,
      this.initValue,
      this.obscureText,
      this.onObscureTextTap});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onChanged: onChanged,
      onTap: onTap,
      obscureText: obscureText ?? false,
      initialValue: initValue,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 28),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: theme.colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        suffixIcon: obscureText == null
            ? null
            : IconButton(
                onPressed: onObscureTextTap,
                icon: Icon(
                    obscureText! ? Icons.visibility : Icons.visibility_off),
              ),
        label: lable != null ? Text(lable!) : null,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
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
      {super.key,
      this.controller,
      this.hintText,
      this.lable,
      this.readOnly = false,
      this.onTap,
      this.initValue,
      this.maxLines = 8,
      this.maxLength = 500});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
          borderSide: BorderSide(
            width: 1,
            color: theme.colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        label: lable != null ? Text(lable!) : null,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
