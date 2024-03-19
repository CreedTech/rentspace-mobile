// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:rentspace/api/global_services.dart';
// import 'package:rentspace/view/actions/new_notification_page.dart';

// class HelperNotification {
//   static Future<void> initialize(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitialize = const DarwinInitializationSettings();
//     var initializationSettings =
//         InitializationSettings(android: androidInitialize, iOS: iosInitialize);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {
//       try {
//         if (notificationResponse.payload != null &&
//             notificationResponse.payload!.isNotEmpty) {
//           print('.... I am going to a new route on Select Notification');
//           Get.to(NewNotificationPage(message: notificationResponse.payload!));
//         } else {}
//       } catch (e) {
//         print(e);
//       }
//       return;
//     });
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//             alert: true, badge: true, sound: true);

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       print("............onMessage..............");
//       print(
//           "onMessage: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
//       // String authToken =
//       // await GlobalService.sharedPreferencesManager.getAuthToken();
//       print('message.data');
//       print(message.notification!.body);
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification!.android;
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           payload: message.notification!.body,
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'high_importance_channel',
//               'Rentspace Notifications',
//               priority: Priority.max,
//               importance: Importance.max,
//               channelDescription: 'Notifications for rentspace activities',
//               // icon: android?.smallIcon,
//               // other properties...
//             ),
//             iOS: DarwinNotificationDetails(
//                 presentAlert: true,
//                 presentBanner: true,
//                 presentSound: true,
//                 presentBadge: true,
//                 interruptionLevel: InterruptionLevel.critical),
//           ),
//         );
//       }
//       // HelperNotification.showNotification(
//       //     message, flutterLocalNotificationsPlugin, false);
//       String authToken =
//           await GlobalService.sharedPreferencesManager.getAuthToken();
//       if (authToken == '' || authToken.isEmpty) {}
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         print("......opened....");
//         print(
//             "onOpenApp: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
//         try {
//           if (message.notification?.titleLocKey != null &&
//               message.notification?.titleLocKey != null) {
//             Get.to(NewNotificationPage(
//                 message: message.notification!.titleLocKey!));
//           } else {}
//         } catch (e) {
//           print("....we have an error....");
//           print(e.toString());
//         }
//       });
//     });
//   }
// }
