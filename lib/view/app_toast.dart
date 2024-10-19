import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}


class AppConfirm extends StatelessWidget {
  final String title;
  final Function()? onNoConfirm;
  final Function() onConfirm;
  const AppConfirm({super.key, required this.title,required this.onConfirm, this.onNoConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        ElevatedButton(
            onPressed: onNoConfirm ?? () {
              Navigator.pop(context);
            },
            child: const Text("Huỷ")),
        ElevatedButton(onPressed: onConfirm, child: const Text("Okay"))
      ],
    );
  }
}
