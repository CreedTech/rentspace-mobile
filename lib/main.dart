import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
// import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/theme.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentspace/view/FirstPage.dart';
import 'package:rentspace/view/dashboard/settings.dart';
import 'api/global_services.dart';
import 'constants/component_constannt.dart';
import 'constants/widgets/notification_dialog.dart';
import 'core/helper/helper_route_path.dart';
import 'core/helper/helper_routes.dart';
import 'view/actions/new_notification_page.dart';

// final notificationProvider =
//     StateNotifierProvider<NotificationNotifier, List<String>>((ref) {
//   return NotificationNotifier();
// });

// class NotificationNotifier extends StateNotifier<List<String>> {
//   NotificationNotifier() : super([]);

//   void addNotification(String notification) {
//     state = [...state, notification];
//   }
// }

int id = 0;
final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
//app entry point
Future<void> main() async {
  await GlobalService.init();
//initialize GetStorage
  await GetStorage.init();
  // Get.put(UserController());
  //widgets initializing
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  // Inside a function or during app initialization
  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  FirebaseMessaging.instance.getToken().then((value) {
    print('get token : $value');
    GlobalService.sharedPreferencesManager.setFCMToken(value: value!);
  });
  requestNotificationPermission();

// if application is in background
  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) async {
      print("App opened from background or terminated state");

      // Print notification information
      print(
          "Notification: ${message.notification?.title}/${message.notification?.body}/${message.data['notificationType']}");

      // Display notification dialog
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return NotificationDialog(notificationData: message.data);
      //   },
      // );

      // Navigate to appropriate screen based on notification type
      String notificationType = message.data['notificationType'];
      // switch (notificationType) {
      //   case 'news':

      //     // Navigate to NewsScreen
      //     Navigator.push(
      //       _navigatorKey.currentState!.context,
      //       MaterialPageRoute(
      //         builder: (context) => NewNotificationPage(
      //           message: message.data,
      //         ),
      //       ),
      //     );
      //     break;
      //   case 'payment':

      //     // Navigate to EventScreen
      //     Navigator.push(
      //       _navigatorKey.currentState!.context,
      //       MaterialPageRoute(
      //         builder: (context) => NewNotificationPage(
      //           message: message.data,
      //         ),
      //       ),
      //     );
      //     break;
      //   case 'fail':

      //     // Navigate to EventScreen
      //     Navigator.push(
      //       _navigatorKey.currentState!.context,
      //       MaterialPageRoute(
      //         builder: (context) => NewNotificationPage(
      //           message: message.data,
      //         ),
      //       ),
      //     );
      //     break;
      //   // Add more cases for other notification types as needed
      //   default:
      //     // Handle unknown notification types
      //     Get.to(FirstPage());
      //     break;
      // }

      // try {
      //   if (message.notification?.titleLocKey != null &&
      //       message.notification?.titleLocKey != null) {
      //     // Navigate to NewNotificationPage
      //     Get.to(NewNotificationPage(message: message.notification!.title!));
      //   } else {
      //     // Navigate to FirstPage
      //     Navigator.push(
      //       _navigatorKey.currentState!.context,
      //       MaterialPageRoute(
      //         builder: (context) => FirstPage(),
      //       ),
      //     );
      //   }
      // } catch (e) {
      //   print("Error navigating to screen: $e");
      // }
    },
  );

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) async {
      print("............onMessage..............");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}/${message.data['notificationType']}");
      print('message.data');
      print(message.notification!.body);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      String notificationType = message.data['notificationType'];
      // switch (notificationType) {
      //   case 'news':

      //     // Navigate to NewsScreen
      //     Navigator.push(
      //       _navigatorKey.currentState!.context,
      //       MaterialPageRoute(
      //         builder: (context) => NewNotificationPage(
      //           message: message.data,
      //         ),
      //       ),
      //     );
      //     break;
      //   case 'payment':

      //     // Navigate to EventScreen
      //     Navigator.push(
      //       _navigatorKey.currentState!.context,
      //       MaterialPageRoute(
      //         builder: (context) => NewNotificationPage(
      //           message: message.data,
      //         ),
      //       ),
      //     );
      //     break;
      //   case 'fail':

      //     // Navigate to EventScreen
      //     Navigator.push(
      //       _navigatorKey.currentState!.context,
      //       MaterialPageRoute(
      //         builder: (context) => NewNotificationPage(
      //           message: message.data,
      //         ),
      //       ),
      //     );
      //     break;
      //   // Add more cases for other notification types as needed
      //   default:
      //     // Handle unknown notification types
      //     Get.to(FirstPage());
      //     break;
      // }

      displayNotification(notification, message.data);
      // showDialog(
      //   context: _navigatorKey.currentState!.context,
      //   builder: (BuildContext context) {
      //     return NotificationDialog(notificationData: message.data);
      //   },
      // );
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      // if (notification != null && android != null) {
      //   flutterLocalNotificationsPlugin.show(
      //     notification.hashCode,
      //     notification.title,
      //     notification.body,
      //     payload: message.notification!.body,
      //     const NotificationDetails(
      //       android: AndroidNotificationDetails(
      //         'high_importance_channel',
      //         'Rentspace Notifications',
      //         priority: Priority.max,
      //         importance: Importance.max,
      //         channelDescription: 'Notifications for rentspace activities',
      //         // icon: android?.smallIcon,
      //         // other properties...
      //       ),
      //       iOS: DarwinNotificationDetails(
      //           presentAlert: true,
      //           presentBanner: true,
      //           presentSound: true,
      //           presentBadge: true,
      //           interruptionLevel: InterruptionLevel.critical),
      //     ),
      //   );
      // }
      print(
          "received in background : ${json.encode(message.notification!.body)}");
    },
  );

// If app is closed or terminated
  FirebaseMessaging.instance.getInitialMessage().then(
    (RemoteMessage? message) async {
      RemoteNotification? notification = message?.notification;
      AndroidNotification? android = message?.notification!.android;
      displayNotification(notification, message!.data);
      // if (notification != null && android != null) {
      //   flutterLocalNotificationsPlugin.show(
      //     notification.hashCode,
      //     notification.title,
      //     notification.body,
      //     payload: message!.notification!.body,
      //     const NotificationDetails(
      //       android: AndroidNotificationDetails(
      //         'high_importance_channel',
      //         'Rentspace Notifications',
      //         priority: Priority.max,
      //         importance: Importance.max,
      //         channelDescription: 'Notifications for rentspace activities',

      //         // icon: android?.smallIcon,
      //         // other properties...
      //       ),
      //       iOS: DarwinNotificationDetails(
      //           presentAlert: true,
      //           presentBanner: true,
      //           presentSound: true,
      //           presentBadge: true,
      //           interruptionLevel: InterruptionLevel.critical),
      //     ),
      //     // payload: message!.data['body'],
      //   );
      // }
    },
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await initNotifications();

  // configLoading();
  runApp(const ProviderScope(child: MyApp()));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();

  print('_firebaseMessagingBackgroundHandler: ${message.notification!.body}');
  print('Handling Background message ${message.notification!.body}');
}

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        selectNotificationStream.add(notificationResponse.payload);
        // Get.to(const NotificationsPage());
        print("onMessageOpened here: ${notificationResponse.payload}");
        print('payload before routing');
        print(notificationResponse.payload);
        Get.to(NewNotificationPage(
            message: notificationResponse.payload));
        // Get.to(SettingsPage());
        // Navigator.push(
        //     _navigatorKey.currentState!.context,
        //     MaterialPageRoute(
        //       builder: (context) => FirstPage(),
        //       //  NewNotificationPage(
        //       //   message: notificationResponse.payload!,
        //       // ),
        //       // settings: const RouteSettings(name: newNotification),
        //     ));

        break;
      case NotificationResponseType.selectedNotificationAction:
        if (notificationResponse.actionId == navigationActionId) {
          selectNotificationStream.add(notificationResponse.payload);
        }
        break;
    }
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
}

void displayNotification(
    RemoteNotification? notification, Map<String, dynamic> data) {
  if (notification != null) {
    // Construct local notification
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'Rentspace Notifications',
      priority: Priority.max,
      importance: Importance.max,
      channelDescription: 'Notifications for rentspace activities',

      // icon: android?.smallIcon,
      // other properties...
    );
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true,
            presentBanner: true,
            presentSound: true,
            presentBadge: true,
            interruptionLevel: InterruptionLevel.critical);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: darwinNotificationDetails);
    // Display the notification
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        // notification.
        platformChannelSpecifics,
        payload: data.toString());
  }
}

// Show transaction notification
Future<void> _showTransactionNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'Transaction Notifications',
    channelDescription: 'Notifications for completed transactions',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    id++,
    title,
    body,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

// Show announcement notification
Future<void> _showAnnouncementNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'Announcement Notifications',
    channelDescription: 'Notifications for announcements',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    id++,
    title,
    body,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.chasingDots
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = brandOne
    ..backgroundColor = brandThree
    ..indicatorColor = brandOne
    ..textColor = brandTwo
    ..maskColor = Colors.transparent
    ..userInteractions = true
    ..dismissOnTap = false;

  // ..customAnimation = CustomAnimation();
}

class _MyAppState extends State<MyApp> {
// Be sure to cancel subscription after you are done
  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setUpScreenUtils(context);
    setStatusBar();
    // ToastContext().init(context);
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (contex, child) {
        return GetMaterialApp(
          theme: Themes().lightTheme,
          // darkTheme: Themes().darkTheme,
          themeMode: ThemeServices().getThemeMode(),
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          title: 'RentSpace',
          initialRoute: root,
          // home: const SplashScreen(),
          onGenerateRoute: RouterGenerator().generate,
          onUnknownRoute: RouterGenerator.onUnknownRoute,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
