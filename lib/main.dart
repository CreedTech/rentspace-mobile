import 'package:flutter/material.dart';
import 'package:rentspace/constants/firebase_auth_constants.dart';
import 'package:rentspace/controller/auth_controller.dart';
import 'package:rentspace/constants/theme.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:upgrader/upgrader.dart';

const String logoUrl =
    "https://firebasestorage.googleapis.com/v0/b/rentspace-351c8.appspot.com/o/assets%2Flogo.png?alt=media&token=333339fd-1183-4855-ad79-b8da6fad818b";
//app entry point
Future<void> main() async {
//initialize GetStorage
  await GetStorage.init();
  //widgets initializing
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInitialization.then((value) {
    Get.put(AuthController());
  });
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
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
    return GetMaterialApp(
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      themeMode: ThemeServices().getThemeMode(),
      debugShowCheckedModeBanner: false,
      title: 'RentSpace',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
