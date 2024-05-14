// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:local_auth/local_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../core/helper/helper_route_path.dart';
import '../FirstPage.dart';

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
String screenInfo = "";

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

  // registerControllers() async {
  //   Get.put(UserController());
  //   Get.put(WalletController());
  //   Get.put(ActivitiesController());
  // }

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
        Get.put(UserController());
        // Get.to(const FirstPage());
        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const FirstPage(),
            ),
            (route) => false);
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   // RouteList.pin_code,
        //   home,
        //   (route) => false,
        // );
        // await registerControllers().then(Get.to(const FirstPage()));
        //  Get.put(UserController());
        // Get.to(const FirstPage());
      } else {
        _canShowAuth = true;
        if (context.mounted) {
          customErrorDialog(context, "Error", "Biometrics failed");
        }
        // Get.snackbar(
        //   "Error",
        //   "Biometrics failed",
        //   animationDuration: const Duration(seconds: 2),
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      }
    } catch (e) {
      if (context.mounted) {
        customErrorDialog(context, "Error", "Biometrics failed");
      }
      // Get.snackbar(
      //   "Error",
      //   "Biometrics failed",
      //   animationDuration: const Duration(seconds: 2),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
    if (!mounted) return;
  }

  @override
  initState() {
    super.initState();
    setState(() {
      screenInfo = "";
      _canShowAuth = false;
    });

    Future.delayed(const Duration(seconds: 2), () {
      (hasBiometricStorage.read('hasBiometric') != null &&
              hasBiometricStorage.read('hasBiometric') == true)
          ? checkingForBioMetrics()
          : Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const FirstPage(),
              ),
              (route) => false);
      //  Get.to(const FirstPage()
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
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(
                'assets/slider3.png',
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), // Adjust the opacity here
                BlendMode.darken,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 150),
                child: Image.asset(
                  'assets/icons/RentSpaceWhite.png',
                  // width: 140,
                  height: 60,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Text(
                        screenInfo,
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const CustomLoader(),
                    const SizedBox(
                      height: 30,
                    ),
                    (_canShowAuth)
                        ?
                        //  GFButton(
                        //     onPressed: () {
                        //       checkingForBioMetrics();
                        //     },
                        //     text: "   Authenticate    ",
                        //     shape: GFButtonShape.pills,
                        //   )
                        Padding(
                            padding: const EdgeInsets.all(3),
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.of(context).pushNamed(getStarted);
                                checkingForBioMetrics();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff40AAD9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                textStyle: const TextStyle(
                                    color: brandFour, fontSize: 13),
                              ),
                              child: Text(
                                "Authenticate",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 0),
              //   child: Image.asset(
              //     'assets/icons/RentSpaceWhite.png',
              //     // width: 140,
              //     height: 53,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 300),
              //   child: Image.asset(
              //     'assets/icons/RentSpaceWhite.png',
              //     // width: 140,
              //     height: 53,
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(),
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     // const SizedBox(
              //     //   height: 50,
              //     // ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           screenInfo,
              //           style: TextStyle(
              //             fontSize: 20,
              //             fontWeight: FontWeight.bold,
              //             fontFamily: "DefaultFontFamily",
              //             color: Theme.of(context).primaryColor,
              //           ),
              //         ),
              //         const SizedBox(
              //           height: 30,
              //         ),
              //       ],
              //     ),
              //     // const SizedBox(
              //     //   height: 50,
              //     // ),
              //     const CircularProgressIndicator(
              //       color: brandOne,
              //     ),
              //     const SizedBox(
              //       height: 50,
              //     ),
              //     (_canShowAuth)
              //         ? GFButton(
              //             onPressed: () {
              //               checkingForBioMetrics();
              //             },
              //             text: "   Authenticate    ",
              //             shape: GFButtonShape.pills,
              //           )
              //         : const SizedBox(),
              //   ],
              // ),
            ],
          ),
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
