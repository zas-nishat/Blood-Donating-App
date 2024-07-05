import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        provisional: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("authorized");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("provisional");
    } else {
      openAppSettings();
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {

    });
  }

  //  isTokenRefresh(){
  //   messaging.onTokenRefresh.listen((event) {
  //     event.toString();
  //   });
  // }

}
