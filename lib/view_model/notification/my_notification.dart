import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

import '../../model/utils/color_resource.dart';
import 'notifiction_redirection.dart';

class MyNotification {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    await requestPermissions(flutterLocalNotificationsPlugin);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// local notification
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'Plant Spotify',
      'Plant Spotify',
      importance: Importance.max,
      playSound: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var androidInitialize =
    const AndroidInitializationSettings('ic_notification');
    var iOSInitialize = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initializationsSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );

    // v21: removed deprecated `settings` named parameter
    flutterLocalNotificationsPlugin.initialize(
      settings: initializationsSettings,
      onDidReceiveBackgroundNotificationResponse: onBackgroundMessageTopLevel,
      onDidReceiveNotificationResponse:
          (NotificationResponse notification) async {
        try {
          if (notification.payload != null &&
              notification.payload!.isNotEmpty) {
            ("payload => ${notification.payload}").logPrint();
            NotificationRedirection.notificationRedirectionFromPayload(
                notificationPayload: notification.payload ?? "");
          }
        } catch (e) {
          (e.toString()).logPrint();
        }
        return;
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      try {
        notificationDataLog(message, "onMessage");
      } catch (e) {
        ("notification onMessage error=>$e").logPrint();
      }
      MyNotification.showBigTextNotification(
          message, flutterLocalNotificationsPlugin);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      try {
        notificationDataLog(message, "onMessageApp");
        if (message.data.isNotEmpty) {
          ("payload => ${message.data}").logPrint();
          NotificationRedirection.notificationRedirectionFromPayload(
              notificationPayload: jsonEncode(message.data));
        }
      } catch (e) {
        ("notification onMessageApp error=>$e").logPrint();
      }
      try {
        if (message.data.isNotEmpty) {
          (message).logPrint();
        }
      } catch (e) {
        (e.toString()).logPrint();
      }
    });
  }

  static Future<void> showBigTextNotification(
      RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
    try {
      NotificationRedirection.forLogoutNotification(
          notificationPayload: jsonEncode(message.data));
    } catch (e) {
      ("notification error=>$e").logPrint();
    }
    try {
      String title = message.notification?.title ?? message.data['title'] as String? ?? "";
      String body = message.notification?.body ?? message.data['body'] as String? ?? "";

      if (title.isEmpty && body.isEmpty) return;

      String? imageUrl;
      if (Platform.isAndroid) {
        imageUrl = message.notification?.android?.imageUrl;
        imageUrl ??= message.data['image'] as String?;
      }

      StyleInformation styleInformation = const BigTextStyleInformation('');
      String? downloadedImagePath;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          final tempDir = await getTemporaryDirectory();
          final filePath = '${tempDir.path}/notif_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
          await Dio().download(imageUrl, filePath);
          downloadedImagePath = filePath;
        } catch (e) {
          ("notification image download error: $e").logPrint();
        }
      }

      if (downloadedImagePath != null) {
        final FilePathAndroidBitmap bigPicture =
            FilePathAndroidBitmap(downloadedImagePath);
        styleInformation = BigPictureStyleInformation(
          bigPicture,
          contentTitle: title,
          summaryText: body,
          hideExpandedLargeIcon: true,
        );
      }

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'Plant Spotify',
        'Plant Spotify',
        importance: Importance.max,
        playSound: true,
        icon: 'ic_notification',
        color: ColorResource.instance.mainColor,
        priority: Priority.high,
        styleInformation: styleInformation,
        largeIcon: downloadedImagePath != null
            ? FilePathAndroidBitmap(downloadedImagePath)
            : null,
      );
      var iOSInitialize = const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSInitialize,
      );
      await fln.show(
        id: 0,
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      ("notification error : $e").logPrint();
    }
  }

  static Future<void> requestPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final bool? granted =
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("token refreshed");
    });
  }
}

@pragma('vm:entry-point')
void onBackgroundMessageTopLevel(NotificationResponse response) {
  ("onDidReceiveBackgroundNotificationResponse: ${response.payload}")
      .logPrint();
}

@pragma('vm:entry-point')
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  try {
    notificationDataLog(message, "background");
    // For data-only messages on Android, FCM does not show a notification
    // automatically — show it manually so images are included.
    // Notification messages (message.notification != null) are already shown
    // by the FCM SDK natively, so skip those to avoid duplicates.
    if (Platform.isAndroid && message.notification == null) {
      final FlutterLocalNotificationsPlugin fln =
          FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('ic_notification');
      await fln.initialize(
          settings: const InitializationSettings(android: androidSettings));
      await MyNotification.showBigTextNotification(message, fln);
    }
  } catch (e) {
    ("notification background error=>$e").logPrint();
  }
}

void notificationDataLog(RemoteMessage message, String notificationType) {
  ("Notification type: $notificationType").logPrint();
  ("Title: ${message.notification?.title}").logPrint();
  ("Body: ${message.notification?.body}").logPrint();
  ("Data: ${message.data}").logPrint();
}

