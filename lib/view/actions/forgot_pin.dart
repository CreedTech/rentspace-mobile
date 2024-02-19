import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'package:rentspace/constants/icons.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';

import '../../constants/widgets/custom_dialog.dart';
import '../dashboard/confirm_forgot_pin.dart';

class ForgotPin extends StatefulWidget {
  final String pin;
  const ForgotPin({super.key, required this.pin});

  @override
  _ForgotPinState createState() => _ForgotPinState();
}

class _ForgotPinState extends State<ForgotPin> {
  final TextEditingController _pinController = TextEditingController();
  // final TextEditingController _pinTwoController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  final changePinformKey = GlobalKey<FormState>();
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

  // Future updatePin() async {
  //   var userPinUpdate = FirebaseFirestore.instance.collection('accounts');
  //   await userPinUpdate.doc(userId).update({
  //     'transaction_pin': _pinController.text.trim(),
  //   }).then((value) {
  //     Get.back();
  //     Get.snackbar(
  //       "PIN updated!",
  //       'Your transaction PIN has been updated successfully',
  //       animationDuration: Duration(seconds: 1),
  //       backgroundColor: brandOne,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.TOP,
  //     );
  //   }).catchError((error) {
  //     Get.snackbar(
  //       "Oops",
  //       "something went wrong, please try again",
  //       animationDuration: Duration(seconds: 2),
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   });
  // }

  void _doSomething() async {

    if (_pinController.text.trim() == widget.pin) {
      customErrorDialog(context, "Invalid!", "PIN cannot be the same as existing one.");
      // showTopSnackBar(
      //   Overlay.of(context),
      //   CustomSnackBar.error(
      //     // backgroundColor: Colors.red,
      //     message: 'PIN cannot be the same as existing one.',
      //     textStyle: GoogleFonts.nunito(
      //       fontSize: 14,
      //       color: Colors.white,
      //       fontWeight: FontWeight.w700,
      //     ),
      //   ),
      // );
      // Get.snackbar(
      //   "Error!",
      //   'PIN cannot be the same as existing one.',
      //   animationDuration: Duration(seconds: 1),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
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
      Get.to(ConfirmForgotPin(
          // password: _passwordController.text.trim(),
          pin: _pinController.text.trim()));
    }
  }

  bool obscurity = true;
  Icon lockIcon = LockIcon().open;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle:  GoogleFonts.nunito(
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
      controller: _pinController,
      focusedPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle:  GoogleFonts.nunito(
          fontSize: 20,
          color: Theme.of(context).primaryColor,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandTwo, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      length: 4,
      validator: validatePinOne,
      onChanged: validatePinOne,
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
          'Change PIN',
          style: GoogleFonts.nunito(
              color: Theme.of(context).primaryColor, fontSize: 24, fontWeight: FontWeight.w700),
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
                      key: changePinformKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            child: Text(
                              'Change Transaction PIN',
                              style: GoogleFonts.nunito(
                                color: Theme.of(context).primaryColor,
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
                                      if (changePinformKey.currentState!
                                          .validate()) {
                                        _doSomething();
                                      } else {
                                        customErrorDialog(context, "Invalid!", "Please Input your pin to proceed");
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
                                      'Proceed',
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
