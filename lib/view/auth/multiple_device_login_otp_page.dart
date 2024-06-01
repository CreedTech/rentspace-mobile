import 'dart:async';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:upgrader/upgrader.dart';

import '../../constants/colors.dart';
import '../../constants/utils/obscureEmail.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../controller/auth/auth_controller.dart';

class MultipleDeviceLoginOtpPage extends ConsumerStatefulWidget {
  const MultipleDeviceLoginOtpPage({super.key, required this.email});
  final String email;

  @override
  ConsumerState<MultipleDeviceLoginOtpPage> createState() =>
      _MultipleDeviceLoginOtpPageState();
}

class _MultipleDeviceLoginOtpPageState
    extends ConsumerState<MultipleDeviceLoginOtpPage> {
  int _minutes = 1; // Initialize minutes to 3
  int _seconds = 0; // Initialize seconds to 0
  Timer? _timer;
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    startCountDown();
  }

  void startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_minutes == 0 && _seconds == 0) {
        _timer?.cancel();
      } else if (_seconds == 0) {
        setState(() {
          _minutes--;
          _seconds = 59;
        });
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  void resetCountdown() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    setState(() {
      _minutes = 1;
      _seconds = 0;
    });
    startCountDown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> otpformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    validateOTP(pinOneValue) {
      if (pinOneValue.isEmpty) {
        return 'otp cannot be empty';
      }
      if (pinOneValue.length < 4) {
        return 'otp is incomplete';
      }
      if (int.tryParse(pinOneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    //Pin

    final authState = ref.watch(authControllerProvider.notifier);
    String formattedTime = '$_minutes:${_seconds.toString().padLeft(2, '0')}';
    print(MediaQuery.of(context).size.height);
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                    top: MediaQuery.of(context).size.height / 4,
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
                          Form(
                            key: otpformKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/mail_send.png',
                                        width: 84,
                                        height: 84,
                                      ),
                                      const SizedBox(
                                        height: 31,
                                      ),
                                      Text(
                                        'Enter OTP',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            style: GoogleFonts.lato(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    "Email Verification! Enter One-Time Password ",
                                                style: GoogleFonts.lato(
                                                  color: const Color(0xff4E4B4B),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '\n sent to ${obscureEmail(widget.email)}',
                                                style: GoogleFonts.lato(
                                                  color: const Color(0xff4E4B4B),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 32,
                                      ),
                                    ],
                                  ),
                                ),
                                Pinput(
                                  useNativeKeyboard: true,
                                  obscureText: false,
                                  defaultPinTheme: PinTheme(
                                    width: 67,
                                    height: 60,
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    textStyle: GoogleFonts.lato(
                                      fontSize: 25,
                                      color: brandOne,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xffBDBDBD),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  focusedPinTheme: PinTheme(
                                    width: 67,
                                    height: 60,
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    textStyle: GoogleFonts.lato(
                                      fontSize: 25,
                                      color: brandOne,
                                    ),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: brandOne, width: 1.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  submittedPinTheme: PinTheme(
                                    width: 67,
                                    height: 60,
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    textStyle: GoogleFonts.lato(
                                      fontSize: 25,
                                      color: brandOne,
                                    ),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: brandOne, width: 1.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  followingPinTheme: PinTheme(
                                    width: 67,
                                    height: 60,
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    textStyle: GoogleFonts.lato(
                                      fontSize: 25,
                                      color: brandOne,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xffBDBDBD),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  controller: otpController,
                                  length: 4,
                                  validator: validateOTP,
                                  onChanged: validateOTP,
                                  onCompleted: (String val) async {
                                    setState(() {
                                      isFilled = true;
                                    });
                                    print(otpController.text);
                                    await authState.verifySingleDeviceLoginOtp(
                                        context,
                                        widget.email,
                                        otpController.text);
                                  },
                                  closeKeyboardWhenCompleted: true,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    resetCountdown();
                                    // resendVerification(context);
                                    authState.singleDeviceLoginOtp(
                                        context, widget.email);
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: "Didn’t receive code? ",
                                          style: GoogleFonts.lato(
                                              color: colorBlack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        (_minutes == 0)
                                            ? TextSpan(
                                                text: 'Resend OTP ',
                                                style: GoogleFonts.lato(
                                                    color:
                                                        const Color(0xff6E6E6E),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14),
                                              )
                                            : TextSpan(
                                                text: ' ($formattedTime)',
                                                style: GoogleFonts.lato(
                                                    color:
                                                        const Color(0xff6E6E6E),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14),
                                              ),
                                      ]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                          backgroundColor: (isFilled == true)
                                              ? brandTwo
                                              : const Color(0xffD0D0D0),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: isFilled == true
                                            ? () {
                                                authState
                                                    .verifySingleDeviceLoginOtp(
                                                        context,
                                                        widget.email,
                                                        otpController.text);
                                              }
                                            : null,
                                        child: Text(
                                          'Verify',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            color: (isFilled == true)
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
      ),
    );
  }
}
