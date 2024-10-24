import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../utils/app_constants.dart';

class NotificationHelper {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    _requestNotificationPermission();
    
    var androidInitialize =
        const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      try {} catch (e) {}
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
      NotificationHelper.showNotification(
          message, flutterLocalNotificationsPlugin, false);
      // if (Get.find<AuthController>().isLoggedIn()) {
      //   Get.find<OrderController>().getRunningOrders(1);
      //   Get.find<OrderController>().getHistoryOrders(1);
      //   Get.find<NotificationController>().getNotificationList(true);
      // }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "onOpenApp: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
      try {} catch (e) {}
    });
  }

  static Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);
    if (kDebugMode) {
      print('Quyền thông báo - ${settings.authorizationStatus}');
    }
  }

  static Future<void> showNotification(RemoteMessage message,
      FlutterLocalNotificationsPlugin fln, bool data) async {
    print('Nework -3 -');
    if (!GetPlatform.isIOS) {
      String? title;
      String? body;
      String? orderID;
      String? image;
      if (data) {
        title = message.data['title'];
        body = message.data['body'];
        orderID = message.data['order_id'];
        image = (message.data['image'] != null &&
                message.data['image'].isNotEmpty)
            ? message.data['image'].startsWith('http')
                ? message.data['image']
                : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.data['image']}'
            : null;
      } else {
        print('Nework -4');
        print('Nework -4 - ${message.notification?.title}');
        title = message.notification?.title;
        body = message.notification?.body;
        orderID = message.notification?.titleLocKey;
        if (GetPlatform.isAndroid) {
          image = (message.notification?.android?.imageUrl != null &&
                  message.notification!.android!.imageUrl!.isNotEmpty)
              ? message.notification!.android!.imageUrl!.startsWith('http')
                  ? message.notification!.android!.imageUrl
                  : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification!.android!.imageUrl}'
              : null;
        } else if (GetPlatform.isIOS) {
          image = (message.notification!.apple!.imageUrl != null &&
                  message.notification!.apple!.imageUrl!.isNotEmpty)
              ? message.notification!.apple!.imageUrl!.startsWith('http')
                  ? message.notification!.apple!.imageUrl
                  : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification!.apple!.imageUrl}'
              : null;
        }
      }

      if (image != null && image.isNotEmpty) {
        try {
          await showBigPictureNotificationHiddenLargeIcon(
              title!, body!, orderID!, image, fln);
        } catch (e) {
          await showBigTextNotification(title!, body!, orderID!, fln);
        }
      } else {
        print('Nework -5');
        print('Nework -5 - $title, $body, $orderID, $fln');
        await showBigTextNotification(title!, body!, orderID!, fln);
      }
    }
  }

  static Future<void> listenNetworkConnect(
      FlutterLocalNotificationsPlugin fln) async {
    print('Listen network Connect');
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        print('Nework -2');
        print('Nework - $result');
        if (result == ConnectivityResult.none) {
          await showNotification(
            const RemoteMessage(
              notification: RemoteNotification(
                title: 'Mất mạng',
                body: 'Hãy bật lại mạng',
              ),
            ),
            fln,
            false,
          );
        } else {
          await showNotification(
            const RemoteMessage(
              notification: RemoteNotification(
                title: 'Đã có mạng',
              ),
            ),
            fln,
            false,
          );
        }
      },
    );
  }

  static Future<void> showTextNotification(String title, String body,
      String orderID, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '6ammart',
      '6ammart',
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigTextNotification(String title, String body,
      String orderID, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '6ammart',
      '6ammart',
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      String title,
      String body,
      String orderID,
      String image,
      FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath =
        await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: body,
      htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '6ammart',
      '6ammart',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      priority: Priority.max,
      playSound: true,
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print(
      "onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
  var androidInitialize =
      const AndroidInitializationSettings('notification_icon');
  var iOSInitialize = const DarwinInitializationSettings();
  var initializationsSettings =
      InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  NotificationHelper.showNotification(
      message, flutterLocalNotificationsPlugin, true);
}
