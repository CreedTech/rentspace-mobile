// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/view/actions/forgot_pin_intro.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/colors.dart';
import '../../controller/user_controller.dart';
import '../actions/forgot_password.dart';
import '../actions/forgot_pin.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

final LocalAuthentication _localAuthentication = LocalAuthentication();
String _message = "Not Authorized";
bool _hasBiometric = false;
final hasBiometricStorage = GetStorage();

class _SecurityState extends State<Security> {
  final UserController userController = Get.find();

  enableBiometrics() {
    if (hasBiometricStorage.read('hasBiometric') == null ||
        hasBiometricStorage.read('hasBiometric') == false) {
      hasBiometricStorage.write('hasBiometric', true);
      Get.back();

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: brandOne,
          message: 'Biometrics enabled',
          textStyle: GoogleFonts.nunito(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
      
      if (hasBiometricStorage.read('hasBiometric') == false) {
        setState(
          () {
            _hasBiometric = true;
            hasBiometricStorage.write('hasBiometric', _hasBiometric);
          },
        );
        Get.back();
         showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: brandOne,
          message: 'Biometrics enabled',
          textStyle: GoogleFonts.nunito(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
       
      } else {
        return;
      }
    } else {
      print(hasBiometricStorage.read('hasBiometric').toString());
    }
    //print()
  }

  disableBiometrics() {
    if (hasBiometricStorage.read('hasBiometric') == null ||
        hasBiometricStorage.read('hasBiometric') == true) {
      hasBiometricStorage.write('hasBiometric', false);
      Get.back();
       showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: brandOne,
          message: 'Biometrics disabled',
          textStyle: GoogleFonts.nunito(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
      // Get.snackbar(
      //   "Disabled",
      //   "Biometrics disabled",
      //   animationDuration: const Duration(seconds: 1),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      if (hasBiometricStorage.read('hasBiometric') == true) {
        setState(
          () {
            _hasBiometric = false;
            hasBiometricStorage.write('hasBiometric', _hasBiometric);
          },
        );
        Get.back();
         showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: brandOne,
          message: 'Biometrics disabled',
          textStyle: GoogleFonts.nunito(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
        // Get.snackbar(
        //   "Disabled",
        //   "Biometrics disabled",
        //   animationDuration: const Duration(seconds: 1),
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      } else {
        return;
      }
    } else {
      print(hasBiometricStorage.read('hasBiometric').toString());
    }
    //print()
  }

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    return canCheckBiometrics;
  }

  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Touch fingerprint scanner to enable Biometrics",
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });
      if (authenticated) {
        enableBiometrics();
      } else {
        customErrorDialog(context, 'Error', "Could not authenticate");
        // Get.snackbar(
        //   "Error",
        //   "could not authenticate",
        //   animationDuration: const Duration(seconds: 1),
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      }

      print("Authenticated");
    } catch (e) {
      print("Not authenticated");
    }
    if (!mounted) return;
  }

  Future<void> _NotAuthenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Touch fingerprint scanner to disable Biometrics",
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });

      if (authenticated) {
        disableBiometrics();
      } else {
        customErrorDialog(context, 'Error', "Could not authenticate");
        // Get.snackbar(
        //   "Error",
        //   "could not authenticate",
        //   animationDuration: const Duration(seconds: 1),
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      }

      print("Authenticated");
    } catch (e) {
      print("Not authenticated");
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Security',
          style: GoogleFonts.nunito(
              color: brandOne, fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: brandTwo.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Iconsax.password_check,
                            color: brandOne,
                          ),
                        ),
                        title: Text(
                          'Reset Password',
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          Get.to(const ForgotPassword());
                        },
                        trailing: const Icon(
                          Iconsax.arrow_right_3,
                          color: brandOne,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: brandTwo.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Iconsax.password_check,
                            color: brandOne,
                          ),
                        ),
                        onTap: () {
                          Get.to(ForgotPinIntro());
                          // Get.to(ForgotPin(
                          //   password: userController.user[0].userPassword,
                          //   pin: userController.user[0].transactionPIN,
                          // ));
                        },
                        title: Text(
                          'Change PIN',
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(
                          Iconsax.arrow_right_3,
                          color: brandOne,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: brandTwo.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Iconsax.finger_scan,
                            color: brandOne,
                          ),
                        ),
                        // onTap: () {
                        //   Get.to(ForgotPin(
                        //     password: userController.user[0].userPassword,
                        //     pin: userController.user[0].transactionPIN,
                        //   ));
                        // },
                        title: Text(
                          'Biometrics Login',
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                            (hasBiometricStorage.read('hasBiometric') != null &&
                                    hasBiometricStorage.read('hasBiometric') ==
                                        true)
                                ? 'Disable Biometrics'
                                : 'Enable Biometrics',
                            style: GoogleFonts.nunito(
                              color: brandOne,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                        trailing: Switch(
                          value:
                              hasBiometricStorage.read('hasBiometric') ?? false,
                          onChanged: (_hasBiometric) {
                            print(_hasBiometric);
                            print('hasBiometricStorage');
                            print(hasBiometricStorage.read('hasBiometric'));
                            if ((hasBiometricStorage.read('hasBiometric') !=
                                    null &&
                                hasBiometricStorage.read('hasBiometric') ==
                                    true)) {
                              _NotAuthenticateMe();
                            } else {
                              _authenticateMe();
                            }
                          },
                        ),
                        // const Icon(
                        //   Iconsax.arrow_right_3,
                        //   color: brandOne,
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
