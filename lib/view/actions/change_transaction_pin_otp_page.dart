import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../controller/auth/auth_controller.dart';

class ChangetransactionPinOtpPage extends ConsumerStatefulWidget {
  const ChangetransactionPinOtpPage({super.key, required this.email});
  final String email;

  @override
  ConsumerState<ChangetransactionPinOtpPage> createState() =>
      _ChangetransactionPinOtpPageState();
}

class _ChangetransactionPinOtpPageState
    extends ConsumerState<ChangetransactionPinOtpPage> {
  final changePinOtpformKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();

  int _minutes = 2; // Initialize minutes to 3
  int _seconds = 0; // Initialize seconds to 0
  Timer? _timer;
  String currentText = "";
  bool isClicked = false;

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
      _minutes = 2;
      _seconds = 0;
    });
    startCountDown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    // errorController!.close();
    super.dispose();
    otpController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.read(authControllerProvider.notifier);
    String formattedTime = '$_minutes:${_seconds.toString().padLeft(2, '0')}';
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
              'Change Transaction Pin',
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      'Verify OTP sent to your mail to change your Transaction Pin. Click ‘Send OTP’ to get the code',
                      style: GoogleFonts.lato(
                        color: colorBlack,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: changePinOtpformKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.h, horizontal: 3.w),
                              child: Text(
                                'Enter OTP',
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            TextFormField(
                              enableSuggestions: true,
                              cursorColor: colorBlack,
                              style: GoogleFonts.lato(
                                  color: colorBlack, fontSize: 14),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: otpController,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                // hintText: 'Amount',
                                errorStyle: GoogleFonts.lato(
                                    fontSize: 12, fontWeight: FontWeight.w500),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: brandOne,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xffBDBDBD),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xffBDBDBD),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.0), // Change color to yellow
                                ),

                                filled: false,
                                contentPadding: const EdgeInsets.all(14),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Otp';
                                }

                                if (!value.isNum) {
                                  return 'Please enter valid digits';
                                }
                                // if (value.length > 4) {
                                //   return 'Otp cannot be more than 4 digits';
                                // }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Didn\'t receive the OTP? ',
                                  style: GoogleFonts.lato(
                                    color: colorBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
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
                                      'Resend OTP',
                                      style: GoogleFonts.lato(
                                        color: const Color(0xff6E6E6E),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                if (isClicked == true)
                                  Text(
                                    '($formattedTime)',
                                    style: GoogleFonts.lato(
                                      color: const Color(0xff6E6E6E),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 50, 50),
                      backgroundColor: brandTwo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (changePinOtpformKey.currentState != null &&
                          changePinOtpformKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        authState.verifyForgotPinOtp(
                            context, widget.email, otpController.text.trim());
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
      ),
    );
  }
}
