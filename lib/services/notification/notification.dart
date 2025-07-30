import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trademine/firebase_options.dart';
import 'package:flutter/material.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> setupFirebaseMessaging() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 📦 Background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🔧 Android notification channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // 🔔 Local notification init
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ), // เปลี่ยน icon ได้หากไม่มี
      iOS: DarwinInitializationSettings(),
    ),
  );

  // ✅ ขอสิทธิ์การแจ้งเตือน (Android 13+, iOS)
  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission(alert: true, badge: true, sound: true);
  print('🔔 Permission status: ${settings.authorizationStatus}');

  // ✅ Foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('🔥 Foreground message received');
    print('🔔 Title: ${message.notification?.title}');
    print('📦 Data: ${message.data}');

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
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    }
  });

  // ✅ เมื่อคลิก notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('🟡 Notification clicked: ${message.notification?.title}');
  });
}

// ✅ Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('🔙 Background message: ${message.messageId}');
}
