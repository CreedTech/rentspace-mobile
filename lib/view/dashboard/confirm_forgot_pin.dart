import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/colors.dart';
import '../../constants/db/firebase_db.dart';
import '../../constants/icons.dart';
import '../../constants/widgets/custom_dialog.dart';

class ConfirmForgotPin extends StatefulWidget {
  final String pin;
  const ConfirmForgotPin({super.key, required this.pin});

  @override
  State<ConfirmForgotPin> createState() => _ConfirmForgotPinState();
}

class _ConfirmForgotPinState extends State<ConfirmForgotPin> {
  final TextEditingController _pinConfirmController = TextEditingController();
  final confirmPinformKey = GlobalKey<FormState>();
  void visibility() {
    if (obscurity == true) {
      setState(() {
        obscurity = false;
        lockIcon = LockIcon().close;
      });
    } else {
      setState(() {
        obscurity = true;
        lockIcon = LockIcon().open;
      });
    }
  }

  bool obscurity = true;
  Icon lockIcon = LockIcon().open;

  Future updatePin() async {
    var userPinUpdate = FirebaseFirestore.instance.collection('accounts');
    await userPinUpdate.doc(userId).update({
      'transaction_pin': _pinConfirmController.text.trim(),
    }).then((value) {
      for (int i = 0; i < 3; i++) {
        Get.back();
      }
      // Get.to(SettingsPage());
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: brandOne,
          message: 'Your transaction PIN has been updated successfully!!',
          textStyle: GoogleFonts.nunito(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
      // Get.snackbar(
      //   "PIN updated!",
      //   'Your transaction PIN has been updated successfully',
      //   animationDuration: Duration(seconds: 1),
      //   backgroundColor: brandOne,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
    }).catchError((error) {
      if (context.mounted) {
        customErrorDialog(
            context, 'Oops (:', "Something went wrong, please try again");
      }
      // showTopSnackBar(
      //   Overlay.of(context),
      //   CustomSnackBar.error(
      //     backgroundColor: Colors.red,
      //     message: 'Oops (: Something went wrong, please try again',
      //     textStyle: GoogleFonts.nunito(
      //       fontSize: 14,
      //       color: Colors.white,
      //       fontWeight: FontWeight.w700,
      //     ),
      //   ),
      // );
      // Get.snackbar(
      //   "Oops",
      //   "something went wrong, please try again",
      //   animationDuration: Duration(seconds: 2),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    });
  }

  void _doSomething() async {
    // Timer(Duration(seconds: 1), () {
    //   _btnController.stop();
    // });
    if ((widget.pin != _pinConfirmController.text.trim())) {
      if (context.mounted) {
        customErrorDialog(context, 'Invalid', "Pin does not match!!");
      }
      // showTopSnackBar(
      //   Overlay.of(context),
      //   CustomSnackBar.error(
      //     backgroundColor: Colors.red,
      //     message: 'Pin does not match!!',
      //     textStyle: GoogleFonts.nunito(
      //       fontSize: 14,
      //       color: Colors.white,
      //       fontWeight: FontWeight.w700,
      //     ),
      //   ),
      // );
      // Get.snackbar(
      //   "Invalid",
      //   'PIN is unacceptable.',
      //   animationDuration: Duration(seconds: 1),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
    // if (_pinOneController.text.trim() == widget.pin ||
    //     _pinTwoController.text.trim() == widget.pin) {
    //   Get.snackbar(
    //     "Error!",
    //     'PIN cannot be the same as existing one.',
    //     animationDuration: Duration(seconds: 1),
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // }
    // else if (widget.password != _passwordController.text.trim() ||
    //     _passwordController.text.trim() == "") {
    //   Get.snackbar(
    //     "Invalid",
    //     'Password is incorrect',
    //     animationDuration: Duration(seconds: 1),
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //     snackPosition: SnackPosition.BOTTOM,
    //   );

    // }
    else {
      updatePin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 20,
        color: brandOne,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(5),
      ),
    );
    validatePin(pinValue) {
      if (pinValue.isEmpty) {
        return 'pin cannot be empty';
      }
      if (pinValue.length < 4) {
        return 'pin is incomplete';
      }
      if (int.tryParse(pinValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    final pin = Pinput(
      obscureText: true,
      defaultPinTheme: defaultPinTheme,
      controller: _pinConfirmController,
      focusedPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: const TextStyle(
          fontSize: 20,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandTwo, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      length: 4,
      validator: validatePin,
      onChanged: validatePin,
      // onCompleted: _doSomething,
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Confirm PIN',
          style: GoogleFonts.nunito(
              color: brandOne, fontSize: 24, fontWeight: FontWeight.w700),
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
                      key: confirmPinformKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            child: Text(
                              'Confirm Transaction PIN',
                              style: GoogleFonts.nunito(
                                color: brandOne,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          pin,
                          const SizedBox(
                            height: 70,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              // width: MediaQuery.of(context).size.width * 2,
                              alignment: Alignment.center,
                              // height: 110.h,
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(250, 50),
                                      backgroundColor: brandTwo,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (confirmPinformKey.currentState!
                                          .validate()) {
                                        _doSomething();
                                      } else {
                                        customErrorDialog(
                                          context,
                                          'Invalid',
                                          "Please fill the form properly to proceed",
                                        );
                                        // showTopSnackBar(
                                        //   Overlay.of(context),
                                        //   CustomSnackBar.error(
                                        //     // backgroundColor: Colors.red,
                                        //     message:
                                        //         'Please fill the form properly to proceed',
                                        //     textStyle: GoogleFonts.nunito(
                                        //       fontSize: 14,
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.w700,
                                        //     ),
                                        //   ),
                                        // );
                                      }
                                    },
                                    child: const Text(
                                      'Verify',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
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
