import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/tracking_entity.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/data/repository/tracking_repo.dart';

class TrackingController extends GetxController implements GetxService {
  final TrackingRepo repo;

  TrackingController({required this.repo});

  bool _loading = false;
  List<TrackingEntity>? _trackings;
  DateTime? _dateFilter;

  bool get loading => _loading;
  DateTime? get dateFilter => _dateFilter;
  List<TrackingEntity>? get trackings => _trackings;

  Future<int> getTracking() async {
    _loading = true;
    update();

    Response response = await repo.getCurrentUserTracking();

    if (response.statusCode == 200) {
      _trackings = List.from(response.body)
          .map((json) => TrackingEntity.fromJson(json))
          .toList();
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode!;
  }

  void filterList(DateTime? date) async {
    _dateFilter = date;
    update();
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
    if (response.statusCode == 200) {
      TrackingEntity objTracking = TrackingEntity.fromJson(response.body);
      _trackings = [...?_trackings, objTracking];
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode!;
  }

  Future<int> editTracking(TrackingEntity objTracking,
      {required String newContent}) async {
    objTracking = objTracking.copyWith(
      content: newContent,
    );

    _loading = true;
    update();

    Response response = await repo.editTracking(objTracking);

    if (response.statusCode == 200) {
      int index = _trackings!.indexWhere((e) => e.id == objTracking.id);
      _trackings![index] = objTracking;
    } else {
      ApiChecker.checkApi(response);
    }

    _loading = false;
    update();
    return response.statusCode!;
  }

  Future<int> deleteTracking({required int id}) async {
    Response response = await repo.deleteTracking(id);

    if (response.statusCode == 200) {
      _trackings!.removeWhere((e) => e.id == id);
    } else {
      ApiChecker.checkApi(response);
    }

    return response.statusCode!;
  }
}
