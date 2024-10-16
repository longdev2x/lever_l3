import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/tracking_entity.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/data/repository/tracking_repo.dart';

class TrackingController extends GetxController {
  final TrackingRepo repo;

  TrackingController({required this.repo});

  bool _loading = false;

  Future<List<TrackingEntity>> getTracking() async {
    _loading = true;
    update();

    Response response = await repo.getCurrentUserTracking();
    if (response.statusCode == 200) {
      return List.from(response.body)
          .map((json) => TrackingEntity.fromJson(json))
          .toList();
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return [];
  }

  Future<int> saveTracking({required String content}) async {
    User user = Get.find<AuthController>().user;
    DateTime now = DateTime.now();

    TrackingEntity objTracking = TrackingEntity(
      //test
      id: 10,
      content: content,
      date: now,
      user: user,
    );

    _loading = true;
    update();

    Response response = await repo.updateCurrentUserTracking(objTracking);
    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode!;
  }
}