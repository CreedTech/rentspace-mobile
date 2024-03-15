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
import 'package:rentspace/constants/firebase_auth_constants.dart';
import 'package:rentspace/controller/announcement_controller.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/controller/auth_controller.dart';
import 'package:rentspace/constants/theme.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentspace/view/dashboard/notifications.dart';
import 'package:rentspace/view/dashboard/settings.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'api/global_services.dart';
import 'constants/component_constannt.dart';
import 'core/helper/helper_route_path.dart';
import 'core/helper/helper_routes.dart';
import 'services/implementations/notification_service.dart';
import 'view/splash_screen.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling Background message ${message.messageId}');
// }

// const String logoUrl =
//     "https://firebasestorage.googleapis.com/v0/b/rentspace-351c8.appspot.com/o/assets%2Flogo.png?alt=media&token=333339fd-1183-4855-ad79-b8da6fad818b";
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

// class FCMService {
//   static Future<void> initializeFirebase() async =>
//       await Firebase.initializeApp();
// }

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
  });
  requestNotificationPermission();

// if application is in background
  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) async {
      print("onMessageOpened : $message");
      Navigator.pushNamed(
        _navigatorKey.currentState!.context,
        '/newNotification',
        arguments: {"message", json.encode(message.data)},
      );
    },
  );
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'Rentspace Notifications',
              channelDescription: 'Notifications for rentspace activities',
              // icon: android?.smallIcon,
              // other properties...
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
      print("received in background : $message");
      // Navigator.pushNamed(
      //   _navigatorKey.currentState!.context,
      //   '/newNotification',
      //   arguments: {"message", json.encode(message.data)},
      // );
    },
  );

// If app is closed or terminated
  FirebaseMessaging.instance.getInitialMessage().then(
    (RemoteMessage? message) async {
      RemoteNotification? notification = message?.notification;
      AndroidNotification? android = message?.notification!.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'Rentspace Notifications',
              channelDescription: 'Notifications for rentspace activities',
              // icon: android?.smallIcon,
              // other properties...
            ),
          ),
        );
      }
      // print("onMessageOpened : $message");
      // Navigator.pushNamed(
      //   _navigatorKey.currentState!.context,
      //   '/newNotification',
      //   arguments: {"message", json.encode(message!.data)},
      // );
    },
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print(fcmToken);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await FCMService.initializeFirebase();
  // await firebaseInitialization.then((value) async {
  //   // Get.put(AuthController());
  // });
  await initNotifications();
  // _showAnnouncementNotification('yo', 'test');

  // configLoading();
  runApp(const ProviderScope(child: MyApp()));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('_firebaseMessagingBackgroundHandler: $message');
  print('Handling Background message ${message.messageId}');
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

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        selectNotificationStream.add(notificationResponse.payload);
        // Get.to(const NotificationsPage());
        print("onMessageOpened : $notificationResponse.payload");
        Navigator.pushNamed(
          _navigatorKey.currentState!.context,
          '/newNotification',
          arguments: {"message", json.encode(notificationResponse.payload)},
        );
        break;
      case NotificationResponseType.selectedNotificationAction:
        if (notificationResponse.actionId == navigationActionId) {
          selectNotificationStream.add(notificationResponse.payload);
        }
        break;
    }
  });
}

// void onDidReceiveLocalNotification(
//     int id, String title, String? body, String? payload) async {
//   // display a dialog with the notification details, tap ok to go to another page
//   await Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => SettingsPage(),
//     ),
//   );
// }

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

  // @override
  // Widget build(BuildContext context) {
  //   setUpScreenUtils(context);
  //   setStatusBar();
  //   // ToastContext().init(context);
  //   return ChangeNotifierProvider(
  //     create: (_) => NotificationService(),
  //     child: ScreenUtilInit(
  //       designSize: const Size(390, 844),
  //       minTextAdapt: true,
  //       splitScreenMode: false,
  //       builder: (contex, child) {
  //         return GetMaterialApp(
  //           theme: Themes().lightTheme,
  //           darkTheme: Themes().darkTheme,
  //           themeMode: ThemeServices().getThemeMode(),
  //           debugShowCheckedModeBanner: false,
  //           title: 'RentSpace',
  //           home: const SplashScreen(),
  //           builder: EasyLoading.init(),

  //         );
  //       },
  //     ),
  //   );
  // }

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
