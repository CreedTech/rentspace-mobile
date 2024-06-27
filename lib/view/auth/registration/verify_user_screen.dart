import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/constants/colors.dart';

import '../../../constants/utils/obscureEmail.dart';
import '../../../constants/widgets/custom_dialog.dart';
import '../../../controller/auth/auth_controller.dart';

class VerifyUserPage extends ConsumerStatefulWidget {
  const VerifyUserPage({super.key, required this.email});
  final String email;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerifyUserPageState();
}

class _VerifyUserPageState extends ConsumerState<VerifyUserPage> {
  int _minutes = 0; // Initialize minutes to 3
  int _seconds = 30; // Initialize seconds to 0
  Timer? _timer;
  String currentTxt = '';
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
      _minutes = 0;
      _seconds = 30;
    });
    startCountDown();
  }

  setCompleted(String isSet) {}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> otpformKey = GlobalKey<FormState>();
  // StreamController<ErrorAnimationType>? errorController;

  @override
  Widget build(BuildContext context) {
    final authState = ref.read(authControllerProvider.notifier);
    String formattedTime = '$_minutes:${_seconds.toString().padLeft(2, '0')}';
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
    final otp = Pinput(
      // useNativeKeyboard: true,
      obscureText: false,
      defaultPinTheme: PinTheme(
        width: 67,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        textStyle: GoogleFonts.lato(
          fontSize: 25,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffBDBDBD), width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 67,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        textStyle: GoogleFonts.lato(
          fontSize: 25,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandOne, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      submittedPinTheme: PinTheme(
        width: 67,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        textStyle: GoogleFonts.lato(
          fontSize: 25,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandOne, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      followingPinTheme: PinTheme(
        width: 67,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        textStyle: GoogleFonts.lato(
          fontSize: 25,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffBDBDBD), width: 1.0),
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
        if (otpformKey.currentState!.validate() && isFilled == true) {
          // verifyBVN();
          authState.verifyOtp(
            context,
            widget.email,
            otpController.text,
          );
        } else {
          customErrorDialog(context, 'Invalid! :)',
              'Please fill the form properly to proceed');
        }
      },
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 27,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Email Verification',
          style: GoogleFonts.lato(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 23.w),
            child: Image.asset(
              'assets/icons/logo_icon.png',
              height: 35.7.h,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Form(
                      key: otpformKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 95,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/mail_send.png',
                                  width: 170,
                                  height: 170,
                                ),
                                SizedBox(
                                  height: 28.h,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Enter OTP',
                                    style: GoogleFonts.lato(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      // fontFamily: "DefaultFontFamily",
                                    ),
                                  ),
                                ),
                                Text(
                                  'One-Time Password sent to your email \n ${widget.email}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    color: Theme.of(context).primaryColorLight,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 32.h,
                                ),
                                otp,
                                SizedBox(
                                  height: 30.h,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              resetCountdown();
                              // resendVerification(context);
                              authState.resendOtp(context, widget.email);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Didn’t receive code? ",
                                      style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    (_seconds == 0)
                                        ? TextSpan(
                                            text: 'Resend OTP ',
                                            style: GoogleFonts.lato(
                                                color: const Color(0xff6E6E6E),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          )
                                        : TextSpan(
                                            text: ' ($formattedTime)',
                                            style: GoogleFonts.lato(
                                                color: const Color(0xff6E6E6E),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 120.h,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              // width: MediaQuery.of(context).size.width * 2,
                              alignment: Alignment.center,
                              // height: 110.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width - 50,
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
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (otpformKey.currentState!.validate() &&
                                      isFilled == true) {
                                    // verifyBVN();
                                    authState.verifyOtp(
                                      context,
                                      widget.email,
                                      otpController.text,
                                    );
                                  } else {
                                    customErrorDialog(context, 'Invalid! :)',
                                        'Please fill the form properly to proceed');
                                  }
                                },
                                child: Text(
                                  'Verify',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
