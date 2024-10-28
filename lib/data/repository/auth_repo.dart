import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timesheet/data/model/body/request/token_request.dart';
import 'package:timesheet/data/model/body/user.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class AuthRepo extends GetxService{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> signUp({required User objUser}) async {
    Map<String, String> header = {
      'Content-Type': 'application/json',
    };

    //Request chuẩn
    // Map<String, dynamic> body = {
    //   "active": true,
    //   "birthPlace": "longtest",
    //   "changePass": true,
    //   "confirmPassword": "123456",
    //   "displayName": "longtest",
    //   "email": "longtest@gmail.com",
    //   "firstName": "longtest",
    //   "gender": "M",
    //   "lastName": "longtest",
    //   "password": "123456",
    //   "university": "longtest",
    //   "username": "longtest",
    //   "year": 2,
    // };

    return await apiClient.postDataLogin(
      AppConstants.SIGN_UP,
      jsonEncode(objUser.toJson()),
      header,
    );
  }

  Future<Response> login(
      {required String username, required String password}) async {
    //header login
    var token = "Basic Y29yZV9jbGllbnQ6c2VjcmV0";
    var languageCode = sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
    Map<String, String> _header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      AppConstants.LOCALIZATION_KEY:
          languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': '$token'
    };
    //call api login
    return await apiClient.postDataLogin(
      AppConstants.LOGIN_URI,
      TokenRequest(
              username: username,
              password: password,
              clientId: "core_client",
              clientSecret: "secret",
              grantType: "password")
          .toJson(),
      _header,
    );
  }

  Future<Response> logOut() async {
    return await apiClient.deleteData(AppConstants.LOG_OUT, null);
  }

  Future<Response> getCurrentUser() async {
    return await apiClient.getData(AppConstants.GET_USER);
  }

  //Device Token

  Future<void> setDeviceToken() async {
    await _saveDeviceToken();

    FirebaseMessaging.instance.onTokenRefresh.listen(
      (String token) async {
        await sharedPreferences.setString(AppConstants.TOKEN_DEVICE, token);
        _sendTokenToSever(token);
      },
    );
  }

  Future<String?> _saveDeviceToken() async {
    String? _deviceToken;
    if (!GetPlatform.isWeb) {
      try {
        _deviceToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        if (kDebugMode) {
          print('Error getting device token: $e');
        }
      }
    }
    if (_deviceToken != null) {
      await sharedPreferences.setString(
          AppConstants.TOKEN_DEVICE, _deviceToken);
      _sendTokenToSever(_deviceToken);
      print('--------Device Token---------- ' + _deviceToken);
    }
    return _deviceToken;
  }

  Future<void> _sendTokenToSever(String token) async {
    await apiClient.getData(
      AppConstants.SEND_TOKEN_DEVICE,
      query: {'tokenDevice' : token}
    );
  }

  // for  user token
  Future<bool> saveUserToken(String token) async {
    apiClient.token = "Bearer $token";
    apiClient.updateHeader("Bearer $token", null,
        sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ?? "vi", 0);
    return await sharedPreferences.setString(
        AppConstants.TOKEN, "Bearer $token");
  }

  Future<bool> clearUserToken() async {
    return await sharedPreferences.remove(AppConstants.TOKEN);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  bool clearSharedAddress() {
    sharedPreferences.remove(AppConstants.USER_ADDRESS);
    return true;
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(
      String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
      await sharedPreferences.setString(
          AppConstants.USER_COUNTRY_CODE, countryCode);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveUserNumber(String number, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
      await sharedPreferences.setString(
          AppConstants.USER_COUNTRY_CODE, countryCode);
    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.USER_COUNTRY_CODE) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? true;
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    await sharedPreferences.remove(AppConstants.USER_COUNTRY_CODE);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }
}
