// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rentspace/constants/colors.dart';
// import 'package:rentspace/constants/firebase_auth_constants.dart';
// import 'package:rentspace/controller/announcement_controller.dart';
// import 'package:rentspace/controller/auth_controller.dart';
// import 'package:rentspace/constants/theme.dart';
// import 'package:rentspace/constants/theme_services.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:rentspace/view/dashboard/notifications.dart';
// import 'package:rentspace/view/dashboard/settings.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
// import 'api/global_services.dart';
// import 'constants/component_constannt.dart';
// import 'services/implementations/notification_service.dart';
// import 'view/splash_screen.dart';

// const String logoUrl =
//     "https://firebasestorage.googleapis.com/v0/b/rentspace-351c8.appspot.com/o/assets%2Flogo.png?alt=media&token=333339fd-1183-4855-ad79-b8da6fad818b";
// int id = 0;
// final StreamController<String?> selectNotificationStream =
//     StreamController<String?>.broadcast();

// /// A notification action which triggers a App navigation event
// const String navigationActionId = 'id_3';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   // ignore: avoid_print
//   print('notification(${notificationResponse.id}) action tapped: '
//       '${notificationResponse.actionId} with'
//       ' payload: ${notificationResponse.payload}');
//   if (notificationResponse.input?.isNotEmpty ?? false) {
//     // ignore: avoid_print
//     print(
//         'notification action tapped with input: ${notificationResponse.input}');
//   }
// }

// //app entry point
// Future<void> main() async {
//     await GlobalService.init();
// //initialize GetStorage
//   await GetStorage.init();

//   //widgets initializing
//   // WidgetsFlutterBinding.ensureInitialized();
//   await firebaseInitialization.then((value) async {
//     Get.put(AuthController());
//     // Get.put(UserController());
//   });
//   await initNotifications();
//   // _showAnnouncementNotification('yo', 'test');

//   // configLoading();
//   // runApp(const ProviderScope(child: MyApp()));
//   runApp(MyApp());
// }

// Future<void> initNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//   const DarwinInitializationSettings initializationSettingsIOS =
//       DarwinInitializationSettings(
//     requestAlertPermission: false,
//     requestBadgePermission: false,
//     requestSoundPermission: false,
//   );
//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) {
//     switch (notificationResponse.notificationResponseType) {
//       case NotificationResponseType.selectedNotification:
//         selectNotificationStream.add(notificationResponse.payload);
//         Get.to(const NotificationsPage());
//         break;
//       case NotificationResponseType.selectedNotificationAction:
//         if (notificationResponse.actionId == navigationActionId) {
//           selectNotificationStream.add(notificationResponse.payload);
//         }
//         break;
//     }
//   });
// }

// // void onDidReceiveLocalNotification(
// //     int id, String title, String? body, String? payload) async {
// //   // display a dialog with the notification details, tap ok to go to another page
// //   await Navigator.push(
// //     context,
// //     MaterialPageRoute(
// //       builder: (context) => SettingsPage(),
// //     ),
// //   );
// // }

// // Show transaction notification
// Future<void> _showTransactionNotification(String title, String body) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'transaction_channel_id',
//     'Transaction Notifications',
//     channelDescription: 'Notifications for completed transactions',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);

//   await flutterLocalNotificationsPlugin.show(
//     id++,
//     title,
//     body,
//     platformChannelSpecifics,
//     payload: 'item x',
//   );
// }

// // Show announcement notification
// Future<void> _showAnnouncementNotification(String title, String body) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'announcement_channel_id',
//     'Announcement Notifications',
//     channelDescription: 'Notifications for announcements',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);

//   await flutterLocalNotificationsPlugin.show(
//     id++,
//     title,
//     body,
//     platformChannelSpecifics,
//     payload: 'item x',
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// void configLoading() {
//   EasyLoading.instance
//     ..displayDuration = const Duration(milliseconds: 2000)
//     ..indicatorType = EasyLoadingIndicatorType.chasingDots
//     ..loadingStyle = EasyLoadingStyle.custom
//     ..indicatorSize = 45.0
//     ..radius = 10.0
//     ..progressColor = brandOne
//     ..backgroundColor = brandThree
//     ..indicatorColor = brandOne
//     ..textColor = brandTwo
//     ..maskColor = Colors.transparent
//     ..userInteractions = true
//     ..dismissOnTap = false;

//   // ..customAnimation = CustomAnimation();
// }

// class _MyAppState extends State<MyApp> {
// // Be sure to cancel subscription after you are done
//   @override
//   initState() {
//     super.initState();
//   }

//   @override
//   dispose() {
//     super.dispose();
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   setUpScreenUtils(context);
//   //   setStatusBar();
//   //   // ToastContext().init(context);
//   //   return ChangeNotifierProvider(
//   //     create: (_) => NotificationService(),
//   //     child: ScreenUtilInit(
//   //       designSize: const Size(390, 844),
//   //       minTextAdapt: true,
//   //       splitScreenMode: false,
//   //       builder: (contex, child) {
//   //         return GetMaterialApp(
//   //           theme: Themes().lightTheme,
//   //           darkTheme: Themes().darkTheme,
//   //           themeMode: ThemeServices().getThemeMode(),
//   //           debugShowCheckedModeBanner: false,
//   //           title: 'RentSpace',
//   //           home: const SplashScreen(),
//   //           builder: EasyLoading.init(),

//   //         );
//   //       },
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     setUpScreenUtils(context);
//     setStatusBar();
//     // ToastContext().init(context);
//      return ChangeNotifierProvider(
//       create: (_) => NotificationService(),
//       child: ScreenUtilInit(
//         designSize: const Size(390, 844),
//         minTextAdapt: true,
//         splitScreenMode: false,
//         builder: (contex, child) {
//           return GetMaterialApp(
//             theme: Themes().lightTheme,
//             darkTheme: Themes().darkTheme,
//             themeMode: ThemeServices().getThemeMode(),
//             debugShowCheckedModeBanner: false,
//             title: 'RentSpace',
//             home: const SplashScreen(),
//             builder: EasyLoading.init(),

//             // const Scaffold(
//             //   backgroundColor: Colors.white,
//             //   body: Column(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     crossAxisAlignment: CrossAxisAlignment.center,
//             //     // ignore: prefer_const_literals_to_create_immutables
//             //     children: [
//             //       Center(
//             //         child: CircularProgressIndicator(
//             //           backgroundColor: Colors.white,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//           );
//         },
//       ),
//     );
//   }

// }

import 'dart:async';

import 'package:flutter/cupertino.dart';
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
import 'services/implementations/notification_service.dart';
import 'view/splash_screen.dart';

const String logoUrl =
    "https://firebasestorage.googleapis.com/v0/b/rentspace-351c8.appspot.com/o/assets%2Flogo.png?alt=media&token=333339fd-1183-4855-ad79-b8da6fad818b";
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

//app entry point
Future<void> main() async {
  await GlobalService.init();
//initialize GetStorage
  await GetStorage.init();
  // Get.put(UserController());
  //widgets initializing
  // WidgetsFlutterBinding.ensureInitialized();
  await firebaseInitialization.then((value) async {
    // Get.put(AuthController());
  
  });
  await initNotifications();
  // _showAnnouncementNotification('yo', 'test');

  // configLoading();
  runApp(const ProviderScope(child: MyApp()));
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
        Get.to(const NotificationsPage());
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
    'transaction_channel_id',
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
    'announcement_channel_id',
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
          darkTheme: Themes().darkTheme,
          themeMode: ThemeServices().getThemeMode(),
          debugShowCheckedModeBanner: false,
          title: 'RentSpace',
          home: const SplashScreen(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
