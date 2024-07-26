import 'package:blood_donating/Auth%20Screen/MainPage.dart';
import 'package:blood_donating/Function/LocalNotification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'controller/Internet_controller.dart';

void main() async {
  DependencyInjection.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken().then((token) {
    print("token $token");
  });
  FirebaseMessaging.instance.subscribeToTopic("all");
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    LocalNotification(FlutterLocalNotificationsPlugin()).call(message);

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification?.title}');
    }
  });
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  ///U.K.548687

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainHomePage(),
    );
  }
}

