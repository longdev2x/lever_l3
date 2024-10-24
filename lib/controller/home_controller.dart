import 'package:get/get.dart';
import 'package:timesheet/data/repository/auth_repo.dart';

class HomeController extends GetxController implements GetxService  {
  final RxInt bottomIndexSelected = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Get.find<AuthRepo>().setDeviceToken();
  }

  void onSelected(int index) {
    bottomIndexSelected.value = index;
  }
}