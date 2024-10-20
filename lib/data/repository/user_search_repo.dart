import 'package:get/get.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/data/model/body/search_request.dart';
import 'package:timesheet/utils/app_constants.dart';

class UserSearchRepo {
  final ApiClient apiClient;
  const UserSearchRepo({required this.apiClient});

  Future<Response> searchUser(SearchRequest objUserSearchRequest) async {
    return await apiClient.postData(
      AppConstants.SEARCH_USER,
      objUserSearchRequest.toJson(),
      null,
    );
  }
}
