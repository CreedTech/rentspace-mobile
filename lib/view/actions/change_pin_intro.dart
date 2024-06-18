import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/view/FirstPage.dart';
import 'package:rentspace/view/actions/change_pin.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';

class ChangePinIntro extends StatefulWidget {
  const ChangePinIntro({super.key});

  @override
  State<ChangePinIntro> createState() => _ChangePinIntroState();
}

class _ChangePinIntroState extends State<ChangePinIntro> {
  final TextEditingController _pinController = TextEditingController();
  final setPinformKey = GlobalKey<FormState>();

  onKeyboardTap(String value) {
    setState(() {
      _pinController.text = _pinController.text + value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      obscureText: true,
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
      // defaultPinTheme: defaultPinTheme,
      controller: _pinController,
      length: 4,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      validator: validatePinOne,
      onChanged: validatePinOne,
      onCompleted: (val) async {
        FocusScope.of(context).unfocus();
        if (BCrypt.checkpw(_pinController.text.trim().toString(),
            userController.userModel!.userDetails![0].wallet.pin)) {
          _pinController.clear();

          Get.to(ChangePIN(pin: val));
        } else {
          EasyLoading.dismiss();
          _pinController.clear();
          if (context.mounted) {
            customErrorDialog(
                context, "Invalid PIN", 'Enter correct PIN to proceed');
          }
        }
      },
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Enter PIN to Proceed',
                        style: GoogleFonts.lato(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          // fontFamily: "DefaultFontFamily",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: setPinformKey,
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
                        _pinController.text = _pinController.text + value;
                      });
                    },
                    textStyle: GoogleFonts.lato(
                      color: brandOne,
                      fontSize: 28,
                    ),
                    rightButtonFn: () {
                      if (_pinController.text.isEmpty) return;
                      setState(() {
                        _pinController.text = _pinController.text
                            .substring(0, _pinController.text.length - 1);
                      });
                    },
                    rightButtonLongPressFn: () {
                      if (_pinController.text.isEmpty) return;
                      setState(() {
                        _pinController.text = '';
                      });
                    },
                    rightIcon: const Icon(
                      Icons.backspace_outlined,
                      color: Colors.red,
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
