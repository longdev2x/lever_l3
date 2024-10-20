import 'package:get/get_connect/http/src/response/response.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/data/model/body/search_request.dart';
import 'package:timesheet/utils/app_constants.dart';

class PostRepo {
  final ApiClient apiClient;

  const PostRepo({required this.apiClient});

    Future<Response> searchUser(SearchRequest objUserSearchRequest) async {
    return await apiClient.postData(
      AppConstants.GET_NEWS,
      objUserSearchRequest.toJson(),
      null,
    );
  }
}