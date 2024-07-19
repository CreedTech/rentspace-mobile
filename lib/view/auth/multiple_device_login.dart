import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    width: 205.47.w,
                    height: 292.51.h,
                  ),
                ),
                Positioned(
                  top: 40.h,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 55.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo_main.png',
                          width: 168,
                          height: 50.4.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h, left: 30),
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
                  top: MediaQuery.of(context).size.height / 4,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 40.h, horizontal: 24),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
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
                            SizedBox(height: 60.h),
                            Center(
                              child: Image.asset(
                                'assets/login_error.png',
                                width: 78,
                                height: 84.h,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            Text(
                              'Oops!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              "It seems you are currently logged in on another device.\nClick 'Sign out of other devices' below to continue.",
                              style: GoogleFonts.lato(
                                color: Theme.of(context).primaryColorLight,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 40.h,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Container(
                                alignment: Alignment.center,
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
                                        context.pop();
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
                              SizedBox(
                                height: 10.h,
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
