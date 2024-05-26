import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/view/auth/multiple_device_login_otp_page.dart';
import 'package:upgrader/upgrader.dart';

import '../../constants/colors.dart';
import '../../controller/auth/auth_controller.dart';

class MultipleDeviceLogin extends ConsumerStatefulWidget {
  const MultipleDeviceLogin({super.key, required this.email});
  final String email;

  @override
  ConsumerState<MultipleDeviceLogin> createState() =>
      _MultipleDeviceLoginState();
}

class _MultipleDeviceLoginState extends ConsumerState<MultipleDeviceLogin> {
  bool signOutDevices = false;
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);
    return UpgradeAlert(
      upgrader: Upgrader(
        showIgnore: false,
        durationUntilAlertAgain: const Duration(seconds: 5),
        debugLogging: true,
        // debugDisplayAlways:true,
        dialogStyle: UpgradeDialogStyle.cupertino,
        showLater: false,
        canDismissDialog: false,
        showReleaseNotes: true,
      ),
      child: Scaffold(
        backgroundColor: brandOne,
        body: Container(
          decoration: const BoxDecoration(
            color: brandOne,
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  right: -50,
                  child: Image.asset(
                    'assets/logo_transparent.png',
                    width: 205.47,
                    height: 292.51,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 55),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo_main.png',
                          width: 168,
                          height: 50.4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 30),
                          child: Text(
                            'your financial power...',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              color: colorWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height  / 4,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 24),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60),
                            Center(
                              child: Image.asset(
                                'assets/login_error.png',
                                width: 78,
                                height: 84,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Oops!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: colorBlack,
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              "It seems you are currently logged in on another device.\nClick 'Sign out of other devices' below to continue.",
                              style: GoogleFonts.lato(
                                color: const Color(0xff4B4B4B),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      // alignment: Alignment.centerLeft,
                                      child: Checkbox.adaptive(
                                        visualDensity: VisualDensity
                                            .adaptivePlatformDensity,
                                        value: signOutDevices,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            signOutDevices = value!;
                                          });
                                        },
                                        overlayColor:
                                            MaterialStateColor.resolveWith(
                                          (states) => brandTwo,
                                        ),
                                        fillColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return brandTwo;
                                          }
                                          return const Color(0xffF2F2F2);
                                        }),
                                        focusColor:
                                            MaterialStateColor.resolveWith(
                                          (states) => brandTwo,
                                        ),
                                        activeColor:
                                            MaterialStateColor.resolveWith(
                                          (states) => brandTwo,
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xffBDBDBD),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Sign out of other devices',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: colorDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Container(
                                // width: MediaQuery.of(context).size.width * 2,
                                alignment: Alignment.center,
                                // height: 110.h,
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width -
                                                50,
                                            50),
                                        backgroundColor:
                                            (signOutDevices == true)
                                                ? brandTwo
                                                : const Color(0xffD0D0D0),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: signOutDevices == true
                                          ? () {
                                              authState.singleDeviceLoginOtp(
                                                  context, widget.email);
                                            }
                                          : null,
                                      child: Text(
                                        'Continue With Sign in',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          color: (signOutDevices == true)
                                              ? colorWhite
                                              : colorBlack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                // width: MediaQuery.of(context).size.width * 2,
                                alignment: Alignment.center,
                                // height: 110.h,
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width -
                                                50,
                                            50),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        'Cancel',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
