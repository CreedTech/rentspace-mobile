// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/theme.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentspace/view/FirstPage.dart';
import 'package:rentspace/view/actions/idle_page.dart';
import 'api/global_services.dart';
import 'constants/component_constannt.dart';
import 'core/helper/helper_routes.dart';
import 'view/splash_screen.dart';
import 'package:path_provider/path_provider.dart';

int id = 0;
final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.input?.isNotEmpty ?? false) {}
}

// final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
//app entry point
Future<void> main() async {
  await GlobalService.init();
//initialize GetStorage
  await GetStorage.init();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await Hive.initFlutter('rentspace');
  } else {
    await Hive.initFlutter();
    // // // // // // // // print('Hive Intialized');
  }
  await openHiveBox('userInfo');
  await openHiveBox('dataBundles');
  // Get.put(UserController());
  //widgets initializing
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  final deviceInfoPlugin = DeviceInfoPlugin();
  // final deviceInfo = await deviceInfoPlugin.androidInfo;
  // final allInfo = deviceInfo.type +  deviceInfo.product + deviceInfo.id  + deviceInfo.device;
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    GlobalService.sharedPreferencesManager
        .setDevieInfo('Android', androidInfo.model);
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    GlobalService.sharedPreferencesManager
        .setDevieInfo('IOS', iosInfo.utsname.machine);
  }
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
      await GlobalService.sharedPreferencesManager
          .userAllowedNotifications(value: true);
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      await GlobalService.sharedPreferencesManager
          .userAllowedNotifications(value: true);
    } else {
      await GlobalService.sharedPreferencesManager
          .userAllowedNotifications(value: false);
    }
  }

  FirebaseMessaging.instance.getToken().then((value) {
    // // // // // // // // print("fcmtoken here $value");
    GlobalService.sharedPreferencesManager.setFCMToken(value: value!);
  });
  requestNotificationPermission();

// if application is in background
  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) async {
      // Navigate to appropriate screen based on notification type
      // String notificationType = message.data['notificationType'];
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
      // }
    },
  );

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification!.android;
      // String notificationType = message.data['notificationType'];
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
    },
  );

// If app is closed or terminated
  FirebaseMessaging.instance.getInitialMessage().then(
    (RemoteMessage? message) async {
      // RemoteNotification? notification = message?.notification;
      // AndroidNotification? android = message?.notification!.android;
      if (message != null) {
        displayNotification(message.notification, message.data);
      }
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

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  await Hive.openBox(boxName).onError((error, stackTrace) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    // // // // // // // // print(dirPath);
    File dbFile = File('$dirPath/$boxName.hive');
    // // // // // // // // print(dbFile);
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/rentspace/$boxName.hive');
      lockFile = File('$dirPath/rentspace/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
}

Future<void> initNotifications() async {
  // final sessionStateStream = StreamController<SessionState>();
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
        // // // // // // // // print("onMessageOpened here: ${notificationResponse.payload}");
        // // // // // // // // print('payload before routing');
        // // // // // // // // // print(notificationResponse.payload);
        Get.to(const FirstPage());
        // Get.to(NewNotificationPage(
        //     message: notificationResponse.payload));
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

void configLoading() {
  EasyLoading.instance
    // ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.chasingDots
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = brandOne
    ..backgroundColor = brandThree
    ..indicatorColor = brandOne
    ..textColor = brandTwo
    ..maskColor = Colors.transparent
    ..userInteractions = false
    ..dismissOnTap = false;

  // ..customAnimation = CustomAnimation();
}

class _MyAppState extends State<MyApp> {
// Be sure to cancel subscription after you are done
  final _sessionNavigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _sessionNavigator => _sessionNavigatorKey.currentState!;

  /// Make this stream available throughout the widget tree with with any state management library
  /// like bloc, provider, GetX, ..
  final sessionStateStream = StreamController<SessionState>();

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
    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 3),
      invalidateSessionForUserInactivity: const Duration(minutes: 5),
    );
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      // stop listening, as user will already be in auth page
      sessionStateStream.add(SessionState.stopListening);
      // sessionCheckout.onResume()
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        _sessionNavigator.push(MaterialPageRoute(
          builder: (_) => IdlePage(
              sessionStateStream: sessionStateStream,
              loggedOutReason: "Logged out because of user inactivity"),
        ));
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        // handle user  app lost focus timeout
        _sessionNavigator.push(MaterialPageRoute(
          builder: (_) => IdlePage(
              sessionStateStream: sessionStateStream,
              loggedOutReason: "Logged out because app lost focus"),
        ));
      }
    });
    setUpScreenUtils(context);
    setStatusBar();
    // ToastContext().init(context);
    return SessionTimeoutManager(
      userActivityDebounceDuration: const Duration(seconds: 1),
      sessionConfig: sessionConfig,
      sessionStateStream: sessionStateStream.stream,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
        child: GetMaterialApp(
          theme: Themes().lightTheme,
          // darkTheme: Themes().darkTheme,
          themeMode: ThemeServices().getThemeMode(),
          debugShowCheckedModeBanner: false,
          navigatorKey: _sessionNavigatorKey,
          title: 'RentSpace',
          // initialRoute: root,
          home: SplashScreen(
            sessionStateStream: sessionStateStream,
          ),
          onGenerateRoute: RouterGenerator().generate,
          onUnknownRoute: RouterGenerator.onUnknownRoute,
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}
