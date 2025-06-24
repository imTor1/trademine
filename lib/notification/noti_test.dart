import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void showNotification() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channel_id',
    'Channel Name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'สวัสดี!',
    'นี่คือการแจ้งเตือน',
    platformDetails,
  );
}
