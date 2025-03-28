import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';

import '../../../constants/colors.dart';
import '../../../constants/utils/obscureEmail.dart';
import '../../../controller/auth/auth_controller.dart';

class ForgotPinOTPVerificationPage extends ConsumerStatefulWidget {
  const ForgotPinOTPVerificationPage({super.key, required this.email});
  final String email;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPinOTPVerificationPageState();
}

class _ForgotPinOTPVerificationPageState
    extends ConsumerState<ForgotPinOTPVerificationPage> {
  int _minutes = 3; // Initialize minutes to 3
  int _seconds = 0; // Initialize seconds to 0
  Timer? _timer;
  String currentText = "";
  bool isClicked = false;

  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> otprestpinFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    startCountDown();
    // errorController = StreamController<ErrorAnimationType>();
  }

  void startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_minutes == 0 && _seconds == 0) {
        _timer?.cancel();
        setState(() {
          isClicked = false;
        });
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
      _minutes = 3;
      _seconds = 0;
    });
    startCountDown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    // errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.read(authControllerProvider.notifier);
    String formattedTime = '$_minutes:${_seconds.toString().padLeft(2, '0')}';

    validatePinOne(pinOneValue) {
      if (pinOneValue.isEmpty) {
        return 'pin cannot be empty';
      }
      if (pinOneValue.length < 4) {
        return 'pin is incomplete';
      }
      if (int.tryParse(pinOneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    //Pin
    final pin = Pinput(
      useNativeKeyboard: false,
      obscureText: false,
      defaultPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: GoogleFonts.lato(
          fontSize: 25,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: GoogleFonts.lato(
          fontSize: 25,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandOne, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      submittedPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: GoogleFonts.lato(
          fontSize: 25,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandOne, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      followingPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: GoogleFonts.lato(
          fontSize: 25,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandTwo, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      controller: otpController,
      length: 4,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      validator: validatePinOne,
      onChanged: validatePinOne,
      onCompleted: (val) {
        FocusScope.of(context).unfocus();
        authState.verifyForgotPinOtp(
          context,
          widget.email,
          otpController.text.trim(),
        );
        otpController.clear();
      },
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        // backgroundColor: const Color(0xffE0E0E0),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(
            Icons.arrow_back,
            size: 25,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        title: Text(
          'OTP',
          style: GoogleFonts.lato(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "We've sent a verification code to ",
                              style: GoogleFonts.lato(color: brandOne),
                            ),
                            TextSpan(
                              text: obscureEmail(widget.email),
                              style: GoogleFonts.lato(
                                color: brandTwo,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: otprestpinFormKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 14,
                          ),
                          child: pin,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Didn\'t receive the mail?',
                                style: GoogleFonts.lato(
                                  color: brandOne,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              if (isClicked == false)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isClicked = true;
                                    });
                                    resetCountdown();
                                    authState.resendPinOtp(
                                        context, widget.email);
                                  },
                                  child: Text(
                                    ' Click here',
                                    style: GoogleFonts.lato(
                                      color: brandTwo,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (isClicked == true)
                            Text(
                              formattedTime,
                              style: GoogleFonts.lato(
                                color: brandTwo,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: NumericKeyboard(
                  onKeyboardTap: (String value) {
                    setState(() {
                      otpController.text = otpController.text + value;
                    });
                  },
                  textStyle: GoogleFonts.lato(
                    color: brandOne,
                    fontSize: 28,
                  ),
                  rightButtonFn: () {
                    if (otpController.text.isEmpty) return;
                    setState(() {
                      otpController.text = otpController.text
                          .substring(0, otpController.text.length - 1);
                    });
                  },
                  rightButtonLongPressFn: () {
                    if (otpController.text.isEmpty) return;
                    setState(() {
                      otpController.text = '';
                    });
                  },
                  rightIcon: const Icon(
                    Icons.backspace_outlined,
                    color: Colors.blueGrey,
                  ),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
