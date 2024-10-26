import 'package:get/get.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/check_in_entity.dart';
import 'package:timesheet/data/repository/check_in_repo.dart';

class CheckInController extends GetxController implements GetxService {
  final CheckInRepo repo;
  CheckInController({required this.repo});

  bool _loading = false;
  List<CheckInEntity> _listCheckIn = [];

  bool get loading => _loading;
  List<CheckInEntity> get listCheckIn => _listCheckIn;

  Future<int> checkIn() async {
    _loading = true;
    update();

    String? ip = await repo.getIp();
    if (ip == null) {
      return 400;
    }

    Response response = await repo.checkIn(ip);

    if (response.statusCode == 200) {
      CheckInEntity objCheckIn = CheckInEntity.fromJson(response.body);
      _listCheckIn.add(objCheckIn);
    } else {
      ApiChecker.checkApi(response);
    }

    _loading = false;
    update();

    return response.statusCode!;
  }

  Future<int> getCheckIn() async {
    _loading = true;
    update();

    Response response = await repo.getCheckIn();

    if (response.statusCode == 200) {
      _listCheckIn = (response.body as List).isEmpty
          ? []
          : (response.body as List)
              .map((json) => CheckInEntity.fromJson(json))
              .toList();
    } else {
      ApiChecker.checkApi(response);
    }

    _loading = false;
    update();

    return response.statusCode!;
  }
}
