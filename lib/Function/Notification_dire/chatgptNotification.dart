// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// Future<void> saveTokenToDatabase(String token) async {
//   String? userId = FirebaseAuth.instance.currentUser?.uid;
//   if (userId != null) {
//     await FirebaseFirestore.instance.collection('users').doc(userId).update({
//       'fcmToken': token,
//     }).catchError((error) {
//       print("Failed to update token: $error");
//     });
//   }
// }
//
// void registerNotification() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   // Request permission
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );
//
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     // Get the token
//     String? token = await messaging.getToken();
//     if (token != null) {
//       saveTokenToDatabase(token);
//     }
//
//     // Listen to token updates
//     FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
//       saveTokenToDatabase(token);
//     });
//   }
// }
//
// Future<void> sendGroupNotification(List<String> userIds, String messageTitle, String messageBody) async {
//   List<String> tokens = [];
//
//   for (String userId in userIds) {
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     if (userDoc.exists) {
//       String? token = userDoc.data()?['fcmToken']; // Safe null check
//       if (token != null) {
//         tokens.add(token);
//       }
//     }
//   }
//
//   if (tokens.isEmpty) {
//     print('No valid FCM tokens found');
//     return;
//   }
//
//   final data = {
//     "registration_ids": tokens,
//     "notification": {
//       "title": messageTitle,
//       "body": messageBody,
//     },
//   };
//
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'key=YOUR_SERVER_KEY', // Replace with your FCM server key
//   };
//
//   final response = await http.post(
//     Uri.parse('https://fcm.googleapis.com/fcm/send'),
//     headers: headers,
//     body: json.encode(data),
//   );
//
//   if (response.statusCode == 200) {
//     print('Notification sent successfully');
//   } else {
//     print('Failed to send notification: ${response.body}');
//   }
// }
//
// void notifyUsers() async {
//   List<String> userIds = ['user1', 'user2', 'user3']; // Replace with your target user IDs
//   String title = 'New Update';
//   String body = 'Check out the latest update!';
//
//   await sendGroupNotification(userIds, title, body);
// }
