import 'package:get/get.dart';

class HomeController extends GetxController implements GetxService  {
  final RxInt bottomIndexSelected = 0.obs;

  void onSelected(int index) {
    bottomIndexSelected.value = index;
  }
}