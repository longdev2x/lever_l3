import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/check_in_entity.dart';
import 'package:timesheet/data/model/body/tracking_entity.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/data/repository/tracking_repo.dart';

class TrackingController extends GetxController implements GetxService {
  final TrackingRepo repo;

  TrackingController({required this.repo});

  bool _loading = false;
  CheckInEntity? _objCheckIn;

  bool get loading => _loading;
  CheckInEntity? get objCheckIn => _objCheckIn;

  Future<CheckInEntity?> getCheckin() async {
    String ip = '';
    final ipResponse =
        await http.get(Uri.parse('https://api.ipify.org?format=json'));
    if (ipResponse.statusCode == 200) {
      ip = jsonDecode(ipResponse.body)['ip'];
    } else {
      return null;
    }

    Response response = await repo.getInfoCheckIn(ip);

    if (response.statusCode == 200) {
      _objCheckIn = CheckInEntity.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
      return null;
    }

    update();
    return _objCheckIn;
  }

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
