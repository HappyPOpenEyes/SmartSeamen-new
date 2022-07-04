import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title// description
      importance: Importance.high,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    var initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  color: Colors.blue,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: "@mipmap/ic_launcher",
                ),
                iOS: IOSNotificationDetails(
                  presentAlert: true,
                  presentSound: true,
                  threadIdentifier: 'thread_id'
                )));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // showDialog(
        //     context: (_),
        //     builder: (_) {
        //   return AlertDialog(
        //     title: Text(notification.title ?? 'Title'),
        //     content: SingleChildScrollView(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [Text(notification.body ?? 'Body')],
        //       ),
        //     ),
        //   );
        // });
      }
    });

    getToken();
  }

  getToken() async {
    String? token;
    token = await FirebaseMessaging.instance.getToken();
    print(token);
  }
}
