import 'package:get/get.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/notification_entity.dart';
import 'package:timesheet/data/repository/notification_repo.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo repo;
  NotificationController({required this.repo});

  bool _loading = false;
  List<NotificationEntity>? _notifications;

  bool get loading => _loading;
  List<NotificationEntity>? get notifications => _notifications;

  @override
  void onInit() {
    super.onInit();
    getNotification();
  }

  Future<int> getNotification() async {
    _loading = true;
    update();

    Response response = await repo.getNotification();

    if (response.statusCode == 200) {
      _notifications = (response.body as List<dynamic>).isNotEmpty
          ? (response.body as List<dynamic>)
              .map((json) => NotificationEntity.fromJson(json))
              .toList().reversed.toList()
          : [];
    } else {
      ApiChecker.checkApi(response);
    }
    
    _loading = false;
    update();

    return response.statusCode!;
  }


  Future<int> testPushNotify() async {

    Response response = await repo.testPushNotify();

    if (response.statusCode == 200) {
      // trả về bool
    } else {
      ApiChecker.checkApi(response);
    }
    
    update();
    return response.statusCode!;
  }
}
