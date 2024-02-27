import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../constants/colors.dart';
import '../../constants/utils/obscureEmail.dart';
import '../../controller/auth/auth_controller.dart';

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

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: GoogleFonts.nunito(
        fontSize: 20,
        color: Theme.of(context).primaryColor,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(5),
      ),
    );
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
      obscureText: true,
      defaultPinTheme: defaultPinTheme,
      controller: otpController,
      focusedPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: GoogleFonts.nunito(
          fontSize: 20,
          color: Theme.of(context).primaryColor,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandTwo, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      length: 4,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      validator: validatePinOne,
      onChanged: validatePinOne,
      onCompleted: (val) {
        authState.verifyForgotPasswordOtp(
          context,
          widget.email,
          otpController.text.trim(),
        );
        otpController.clear();
        // Get.to(ConfirmTransactionPinPage(pin: _pinController.text.trim()));
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
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'OTP',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
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
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "We've sent a verification code to ",
                              style: GoogleFonts.nunito(color: brandOne),
                            ),
                            TextSpan(
                              text: obscureEmail(widget.email),
                              style: GoogleFonts.nunito(
                                color: brandTwo,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            // TextSpan(
                            //   text: '. Please check your mail.',
                            //   style: GoogleFonts.nunito(
                            //     color: brandTwo,
                            //   ),
                            // ),
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
                                style: GoogleFonts.nunito(
                                  color: brandOne,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isClicked = true;
                                  });
                                  resetCountdown();
                                  authState.resendPasswordOtp(
                                      context, widget.email);
                                },
                                child: Text(
                                  ' Click here',
                                  style: GoogleFonts.nunito(
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
                              style: GoogleFonts.nunito(
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 50),
                    backgroundColor: brandOne,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (otprestpinFormKey.currentState!.validate()) {
                      authState.verifyForgotPasswordOtp(
                        context,
                        widget.email,
                        otpController.text.trim(),
                      );
                      otpController.clear();
                    }
                  },
                  child: const Text(
                    'Proceed',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
