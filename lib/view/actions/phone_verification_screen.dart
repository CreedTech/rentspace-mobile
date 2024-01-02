import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';

class PhoneVerificationScreen extends StatefulWidget {
  PhoneVerificationScreen({
    Key? key,
  }) : super(key: key);
  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  Timer? timer;
  final _auth = FirebaseAuth.instance;
  late String _verificationId;
  late TextEditingController _otpController;
  late bool _isLoading;
  late bool _otpSent;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    _verificationId = "";
    _otpController = TextEditingController();
    _isLoading = false;
    _otpSent = false;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    setState(() {
      _isLoading = true;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: userController.user[0].userPhone,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) async {
        //await _auth.signInWithCredential(credential);
        setState(() {
          _isLoading = false;
        });
        Get.back();
        Navigator.of(context).pop();
      },
      verificationFailed: (FirebaseAuthException e) {
        print('====================');
        print('Verification Failed: ${e.message}');
        print('====================');
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          "Error",
          "Try again later",
          animationDuration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _otpSent = true;
          _isLoading = false;
        });
        Get.snackbar(
          "Waiting for OTP",
          "An OTP has been sent to ${userController.user[0].userPhone}",
          animationDuration: const Duration(seconds: 1),
          backgroundColor: brandOne,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future updateVerification() async {
    var userUpdate = FirebaseFirestore.instance.collection('accounts');

    await userUpdate.doc(userId).update({
      'has_verified_phone': 'true',
    }).catchError((error) {
      print(error);
    });
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _otpController.text.trim(),
    );

    try {
      await _auth.signInWithCredential(credential);
      updateVerification();
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
      Get.snackbar(
        "Verified!",
        "Your phone number has been verified",
        animationDuration: const Duration(seconds: 1),
        backgroundColor: brandOne,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        "Error",
        "The OTP could not be verified, try again later",
        animationDuration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
            setState(() {
              _otpSent = false;
            });
          },
          child: Icon(
            Icons.close,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (!_otpSent)
                      ? Text(
                          "OTP will be sent to ${userController.user[0].userPhone}",
                          style: GoogleFonts.nunito(
                            fontSize: 15.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          "OTP has been sent to ${userController.user[0].userPhone}",
                          style: GoogleFonts.nunito(
                            fontSize: 18.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  (!_otpSent)
                      ? RoundedLoadingButton(
                          child: Text(
                            'Send OTP',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                            ),
                          ),
                          elevation: 0.0,
                          successColor: brandOne,
                          color: brandOne,
                          controller: _btnController,
                          onPressed: () {
                            Timer(const Duration(seconds: 2), () {
                              _btnController.stop();
                            });
                            _sendOTP();
                          },
                        )
                      : const Text(""),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_otpSent)
                    TextFormField(
                      enableSuggestions: true,
                      cursorColor: Colors.black,
                      controller: _otpController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: GoogleFonts.nunito(
                        color: brandOne,
                      ),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        label: Text(
                          "OTP",
                          style: GoogleFonts.nunito(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: brandOne, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0), // Change color to yellow
                        ),
                        filled: false,
                        contentPadding: const EdgeInsets.all(14),
                        hintText: 'enter your OTP ',
                        hintStyle: GoogleFonts.nunito(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  if (_otpSent)
                    const SizedBox(
                      height: 30,
                    ),
                  if (_otpSent)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 50),
                        backgroundColor: brandTwo,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_otpController.text.trim() == "") {
                          Get.snackbar(
                            "Empty",
                            "OTP cannot be empty",
                            animationDuration: const Duration(seconds: 1),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          _verifyOTP();
                        }
                      },
                      child: Text(
                        'Verify OTP',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  // GFButton(
                  //   onPressed: () {
                  //     if (_otpController.text.trim() == "") {
                  //       Get.snackbar(
                  //         "Empty",
                  //         "OTP cannot be empty",
                  //         animationDuration: const Duration(seconds: 1),
                  //         backgroundColor: Colors.red,
                  //         colorText: Colors.white,
                  //         snackPosition: SnackPosition.BOTTOM,
                  //       );
                  //     } else {
                  //       _verifyOTP();
                  //     }
                  //   },
                  //   color: brandOne,
                  //   fullWidthButton: true,
                  //   shape: GFButtonShape.pills,
                  //   child: Text(
                  //     'Verify OTP',
                  //     style: GoogleFonts.nunito(
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }
}
