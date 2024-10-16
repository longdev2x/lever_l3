import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt bottomIndexSelected = 0.obs;

  void onSelected(int index) {
    bottomIndexSelected.value = index;
  }
}