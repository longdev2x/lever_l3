import 'package:get/get.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/data/model/body/tracking_entity.dart';
import 'package:timesheet/utils/app_constants.dart';

class TrackingRepo extends GetxService {
  final ApiClient apiClient;

  TrackingRepo({required this.apiClient});

  Future<Response> getCurrentUserTracking() async {
    return await apiClient.getData(AppConstants.TRACKING);
  }

  Future<Response> updateCurrentUserTracking(TrackingEntity objTracking) async {
    return await apiClient.postData(
        AppConstants.TRACKING, objTracking.toJson(), null);
  }
}
