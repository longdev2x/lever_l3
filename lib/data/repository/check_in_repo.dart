import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class CheckInRepo {
  final ApiClient apiClient;

  CheckInRepo({required this.apiClient});

  Future<Response> getCheckIn() async {
    return await apiClient.getData(
      AppConstants.GET_CHECK_IN,
    );
  }
  Future<Response> checkIn(String ip) async {
    return await apiClient.getData(
      AppConstants.CHECK_IN,
      query: {'ip': ip},
    );
  }

  Future<String?> getIp() async {
    String ip = '';
    final ipResponse =
        await http.get(Uri.parse('https://api.ipify.org?format=json'));
    if (ipResponse.statusCode == 200) {
      ip = jsonDecode(ipResponse.body)['ip'];
    } else {
      return null;
    }
    return ip;
  }
}
