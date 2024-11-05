import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/check_in_controller.dart';
import 'package:timesheet/controller/home_controller.dart';
import 'package:timesheet/controller/notification_controller.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/controller/profile_controller.dart';
import 'package:timesheet/controller/sign_up_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/repository/check_in_repo.dart';
import 'package:timesheet/data/repository/notification_repo.dart';
import 'package:timesheet/data/repository/post_repo.dart';
import 'package:timesheet/data/repository/profile_repo.dart';
import 'package:timesheet/data/repository/splash_repo.dart';
import 'package:timesheet/data/repository/tracking_repo.dart';
import 'package:timesheet/data/repository/user_search_repo.dart';
import 'package:timesheet/helper/notification_helper.dart';
import '../controller/localization_controller.dart';
import '../controller/splash_controller.dart';
import '../data/api/api_client.dart';
import '../data/model/language_model.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/language_repo.dart';
import '../theme/theme_controller.dart';
import '../utils/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  final firstCamera = await availableCameras();

  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => firstCamera);
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashRepo(apiClient: Get.find()));
  Get.lazyPut(() => CheckInRepo(apiClient: Get.find()));
  Get.lazyPut(() => TrackingRepo(apiClient: Get.find()));
  Get.lazyPut(() => UserSearchRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProfileRepo(apiClient: Get.find()));
  Get.lazyPut(() => PostRepo(apiClient: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find()));

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(repo: Get.find()));
  Get.lazyPut(() => AuthController(repo: Get.find()));
  Get.lazyPut(() => SignUpController());
  Get.lazyPut(() => CheckInController(repo: Get.find()));
  Get.lazyPut(() => TrackingController(repo: Get.find()));
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => UserController(repo: Get.find()));
  Get.lazyPut(() => ProfileController(repo: Get.find()));
  Get.lazyPut(() => PostController(repo: Get.find()));
  Get.lazyPut(() => NotificationController(repo: Get.find()));

  //Init Notification
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  NotificationHelper.listenNetworkConnect(flutterLocalNotificationsPlugin);

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};

  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();

    mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });

    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        _json;
  }
  // Sẽ có dạng thế này
  // [{'vi_VN': {'All Map from Asset VN'}},
  //   {'en_US': {'All Map from Asset US'}},];
  return languages;
}
