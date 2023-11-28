import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:local_auth/local_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentspace/view/home_page.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:async';
import 'dart:io';
import 'package:upgrader/upgrader.dart';

class BiometricsPage extends StatefulWidget {
  BiometricsPage({
    Key? key,
  }) : super(key: key);

  @override
  _BiometricsPageState createState() => _BiometricsPageState();
}

final LocalAuthentication _localAuthentication = LocalAuthentication();
String _message = "Not Authorized";
bool _hasBiometric = false;
bool _canShowAuth = false;
final hasBiometricStorage = GetStorage();
String screenInfo = "Loading awesomeness...";

class _BiometricsPageState extends State<BiometricsPage> {
  Timer? _inactivityTimer;
  Future<bool> checkingForBioMetrics() async {
    setState(() {
      screenInfo = "App locked, complete Biometrics to unlock";
    });
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    _authenticateMe();
    return canCheckBiometrics;
  }

  void _cancelTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }

  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Authentication required",
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });
      if (_message == "Authorized") {
        setState(() {
          screenInfo = "App unlocked";
        });
        Get.to(FirstPage());
      } else {
        _canShowAuth = true;
        Get.snackbar(
          "Error",
          "Biometrics failed",
          animationDuration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Biometrics failed",
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    if (!mounted) return;
  }

  @override
  initState() {
    super.initState();
    setState(() {
      screenInfo = "Loading awesomeness...";
      _canShowAuth = false;
    });

    Future.delayed(const Duration(seconds: 2), () {
      (hasBiometricStorage.read('hasBiometric') != null &&
              hasBiometricStorage.read('hasBiometric') == true)
          ? checkingForBioMetrics()
          : Get.to(FirstPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  screenInfo,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "DefaultFontFamily",
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            CircularProgressIndicator(
              color: brandOne,
            ),
            SizedBox(
              height: 50,
            ),
            (_canShowAuth)
                ? GFButton(
                    onPressed: () {
                      checkingForBioMetrics();
                    },
                    text: "   Authenticate    ",
                    shape: GFButtonShape.pills,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
