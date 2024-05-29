// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/view/actions/change_password.dart';
// import 'package:rentspace/view/actions/change_pin_intro.dart';
import 'package:rentspace/view/actions/change_transaction_pin_otp_page.dart';
// import 'package:rentspace/view/actions/forgot_pin_intro.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/colors.dart';
// import '../../controller/user_controller.dart';
import '../../controller/auth/auth_controller.dart';
import '../../controller/auth/user_controller.dart';
// import '../actions/forgot_password.dart';

class Security extends ConsumerStatefulWidget {
  const Security({super.key});

  @override
  ConsumerState<Security> createState() => _SecurityState();
}

final LocalAuthentication _localAuthentication = LocalAuthentication();
String _message = "Not Authorized";
bool _hasBiometric = false;
final hasBiometricStorage = GetStorage();

class _SecurityState extends ConsumerState<Security> {
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
          textStyle: GoogleFonts.lato(
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
            textStyle: GoogleFonts.lato(
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
      if (kDebugMode) {
        print(hasBiometricStorage.read('hasBiometric').toString());
      }
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
          textStyle: GoogleFonts.lato(
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
            textStyle: GoogleFonts.lato(
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
    final authState = ref.watch(authControllerProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffF6F6F8),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: colorBlack,
              ),
            ),
            SizedBox(
              width: 4.h,
            ),
            Text(
              'Security',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 24.w,
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 17, top: 17, right: 17, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1), // Shadow color
                          spreadRadius: 0.5, // Spread radius
                          blurRadius: 2, // Blur radius
                          offset: const Offset(0, 3), // Offset
                        ),
                      ],
                      color: colorWhite,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          // horizontalTitleGap: 0,
                          minLeadingWidth: 0,
                          onTap: () {
                            Get.to(const ChangePassword());
                          },
                          title: Text(
                            "Change Password",
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colorBlack,
                            ),
                          ),

                          trailing: const Icon(
                            Icons.keyboard_arrow_right,
                            color: colorBlack,
                            size: 20,
                          ),
                        ),
                        const Divider(
                          color: Color(0xffC9C9C9),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          // horizontalTitleGap: 0,
                          minLeadingWidth: 0,
                          onTap: () {
                            authState.forgotPin(context, userController.userModel!.userDetails![0].email);
                          },
                          title: Text(
                            'Change Transaction Pin',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colorBlack,
                            ),
                          ),

                          trailing: const Icon(
                            Icons.keyboard_arrow_right,
                            color: colorBlack,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 0),
                  //   child: ListTile(
                  //     leading: Container(
                  //       padding: const EdgeInsets.all(9),
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Theme.of(context).cardColor,
                  //       ),
                  //       child: const Icon(
                  //         Iconsax.password_check,
                  //         color: brandOne,
                  //       ),
                  //     ),
                  //     title: Text(
                  //       'Reset Password',
                  //       style: GoogleFonts.lato(
                  //         color: Theme.of(context).primaryColor,
                  //         fontSize: 13,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     onTap: () {
                  //       Get.to(const ForgotPassword());
                  //     },
                  //     trailing: Icon(
                  //       Iconsax.arrow_right_3,
                  //       color: Theme.of(context).primaryColor,
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 0),
                  //   child: ListTile(
                  //     leading: Container(
                  //       padding: const EdgeInsets.all(9),
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Theme.of(context).cardColor,
                  //       ),
                  //       child: const Icon(
                  //         Iconsax.password_check,
                  //         color: brandOne,
                  //       ),
                  //     ),
                  //     onTap: () {
                  //       Get.to(const ChangePinIntro());
                  //       // Get.to(ForgotPin(
                  //       //   password: userController.user[0].userPassword,
                  //       //   pin: userController.user[0].transactionPIN,
                  //       // ));
                  //     },
                  //     title: Text(
                  //       'Change Payment PIN',
                  //       style: GoogleFonts.lato(
                  //         color: Theme.of(context).primaryColor,
                  //         fontSize: 13,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     trailing: Icon(
                  //       Iconsax.arrow_right_3,
                  //       color: Theme.of(context).primaryColor,
                  //     ),
                  //   ),
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 0),
                  //   child: ListTile(
                  //     leading: Container(
                  //       padding: const EdgeInsets.all(9),
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Theme.of(context).cardColor,
                  //       ),
                  //       child: const Icon(
                  //         Iconsax.password_check,
                  //         color: brandOne,
                  //       ),
                  //     ),
                  //     onTap: () {
                  //       Get.to(const ForgotPinIntro());
                  //       // Get.to(ForgotPin(
                  //       //   password: userController.user[0].userPassword,
                  //       //   pin: userController.user[0].transactionPIN,
                  //       // ));
                  //     },
                  //     title: Text(
                  //       'Forgot Payment PIN',
                  //       style: GoogleFonts.lato(
                  //         color: Theme.of(context).primaryColor,
                  //         fontSize: 13,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     trailing: Icon(
                  //       Iconsax.arrow_right_3,
                  //       color: Theme.of(context).primaryColor,
                  //     ),
                  //   ),
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 0),
                  //   child: ListTile(
                  //     leading: Container(
                  //       padding: const EdgeInsets.all(9),
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Theme.of(context).cardColor,
                  //       ),
                  //       child: const Icon(
                  //         Iconsax.finger_scan,
                  //         color: brandOne,
                  //       ),
                  //     ),
                  //     // onTap: () {
                  //     //   Get.to(ForgotPin(
                  //     //     password: userController.user[0].userPassword,
                  //     //     pin: userController.user[0].transactionPIN,
                  //     //   ));
                  //     // },
                  //     title: Text(
                  //       'Biometrics Login',
                  //       style: GoogleFonts.lato(
                  //         color: Theme.of(context).primaryColor,
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //     subtitle: Text(
                  //         (hasBiometricStorage.read('hasBiometric') != null &&
                  //                 hasBiometricStorage.read('hasBiometric') ==
                  //                     true)
                  //             ? 'Disable Biometrics'
                  //             : 'Enable Biometrics',
                  //         style: GoogleFonts.lato(
                  //           color: Theme.of(context).primaryColor,
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.w400,
                  //         )),
                  //     trailing: Switch(
                  //       activeColor: Theme.of(context).primaryColor,
                  //       inactiveTrackColor: brandTwo,
                  //       value:
                  //           hasBiometricStorage.read('hasBiometric') ?? false,
                  //       onChanged: (_hasBiometric) {
                  //         print(_hasBiometric);
                  //         print('hasBiometricStorage');
                  //         print(hasBiometricStorage.read('hasBiometric'));
                  //         if ((hasBiometricStorage.read('hasBiometric') !=
                  //                 null &&
                  //             hasBiometricStorage.read('hasBiometric') ==
                  //                 true)) {
                  //           _NotAuthenticateMe();
                  //         } else {
                  //           _authenticateMe();
                  //         }
                  //       },
                  //     ),
                  //     // const Icon(
                  //     //   Iconsax.arrow_right_3,
                  //     //   color: brandOne,
                  //     // ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
