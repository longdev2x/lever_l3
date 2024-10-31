import 'package:get/get.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/utils/app_constants.dart';

class NotificationRepo extends GetxService {
  final ApiClient apiClient;
  NotificationRepo({required this.apiClient});

  Future<Response> getNotification() async {
    return await apiClient.getData(
      AppConstants.GET_NOTIFICATION,
    ); 
  }

  Future<Response> testPushNotify() async {
    return await apiClient.getData(
      AppConstants.TEST_PUSH_NOTIFY,
    ); 
  }
}