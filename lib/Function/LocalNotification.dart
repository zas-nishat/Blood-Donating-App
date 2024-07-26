import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LocalNotification {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  LocalNotification(this._flutterLocalNotificationsPlugin);

  void call(RemoteMessage message) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('notification_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title ?? "Notification",
      message.notification?.body ?? "Descritpion",
      NotificationDetails(
        android: AndroidNotificationDetails(
          'all',
          'All notification',
          importance: Importance.max,
          priority: Priority.high,
          channelShowBadge: false,
        ),
      ),
    );
  }
}