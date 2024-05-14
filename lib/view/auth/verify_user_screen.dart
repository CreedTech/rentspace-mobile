import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/constants/colors.dart';

import '../../controller/auth/auth_controller.dart';

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
      useNativeKeyboard: true,
      obscureText: false,
      defaultPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: TextStyle(
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
        textStyle: TextStyle(
          fontSize: 25,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandOne, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      submittedPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: TextStyle(
          fontSize: 25,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandOne, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      followingPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: TextStyle(
          fontSize: 25,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandTwo, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      controller: otpController,
      length: 4,
      validator: validateOTP,
      onChanged: validateOTP,
      onCompleted: (String isSet) {
        setState(() {
          isFilled = true;
        });
      },
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );

    final authState = ref.read(authControllerProvider.notifier);
    String formattedTime = '$_minutes:${_seconds.toString().padLeft(2, '0')}';
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
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
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/verify_mail.png',
                                  width: 105.w,
                                ),
                                SizedBox(
                                  height: 65.h,
                                ),
                                Text(
                                  'Verify your email',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                    // fontFamily: "DefaultFontFamily",
                                  ),
                                ),
                                Text(
                                  'Enter a four-digit OTP sent to ${widget.email}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    // fontFamily: "DefaultFontFamily",
                                  ),
                                ),
                                SizedBox(
                                  height: 32.h,
                                ),
                              ],
                            ),
                          ),
                          otp,
                          SizedBox(
                            height: 32.h,
                          ),
                          (_seconds == 0)
                              ? GestureDetector(
                                  onTap: () {
                                    resetCountdown();
                                    // resendVerification(context);
                                    authState.resendOtp(context, widget.email);
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: "Didn’t receive code? ",
                                          style: GoogleFonts.lato(
                                              color: brandOne,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        TextSpan(
                                          text: 'Resend OTP',
                                          style: GoogleFonts.lato(
                                              color: brandOne,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12),
                                        ),
                                      ]),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Text(
                            formattedTime,
                            style: GoogleFonts.lato(
                                color: brandOne,
                                fontWeight: FontWeight.w700,
                                fontSize: 12),
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                          // Text(
                          //   'If you did not get the OTP please go back to re-confirm you entered the correct email address',
                          //   textAlign: TextAlign.center,
                          //   style: GoogleFonts.lato(
                          //     color: const Color(0xff828282),
                          //     fontWeight: FontWeight.w400,
                          //     fontSize: 10,
                          //     // fontFamily: "DefaultFontFamily",
                          //   ),
                          // ),
                          SizedBox(
                            height: 32.h,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              // width: MediaQuery.of(context).size.width * 2,
                              alignment: Alignment.center,
                              // height: 110.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(350, 50),
                                  backgroundColor: (isFilled == true)
                                      ? brandOne
                                      : const Color.fromARGB(
                                          255, 150, 156, 172),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (isFilled == true) {
                                    authState.verifyOtp(
                                      context,
                                      widget.email,
                                      otpController.text,
                                    );
                                  }
                                },
                                child: Text(
                                  'Proceed',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(color: Colors.white),
                                ),
                              ),
                            ),
                          )
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
