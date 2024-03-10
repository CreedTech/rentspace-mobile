import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/view/FirstPage.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../controller/auth/auth_controller.dart';

class ChangePIN extends ConsumerStatefulWidget {
  const ChangePIN({super.key, required this.pin});
  final String pin;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangePINState();
}

class _ChangePINState extends ConsumerState<ChangePIN> {
  final TextEditingController _changePinController = TextEditingController();
  final changePinformKey = GlobalKey<FormState>();

  // void _doSomething() async {
  //   if (BCrypt.checkpw(_oldPinController.text.trim().toString(),
  //       userController.userModel!.userDetails![0].wallet.pin)) {
  //     customErrorDialog(
  //         context, "Invalid!", "PIN cannot be the same as existing one.");
  //   } else {
  //     // Get.to(ConfirmForgotPin(
  //     //     // password: _passwordController.text.trim(),
  //     //     pin: _pinController.text.trim()));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authState = ref.read(authControllerProvider.notifier);
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

    final pin = Pinput(
      obscureText: true,
      defaultPinTheme: defaultPinTheme,
      controller: _changePinController,
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
      onCompleted: (val) async {
        if (BCrypt.checkpw(_changePinController.text.trim().toString(),
            userController.userModel!.userDetails![0].wallet.pin)) {
          customErrorDialog(
              context, "Invalid!", "PIN cannot be the same as existing one.");
          _changePinController.clear();
        } else {
          authState.changePin(
              context, _changePinController.text.trim(), widget.pin);
        }
        _changePinController.clear();
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
                        'Change Transaction PIN',
                        style: GoogleFonts.nunito(
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
                          key: changePinformKey,
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
                    onPressed: () async {
                      if (changePinformKey.currentState!.validate()) {
                        if (BCrypt.checkpw(
                            _changePinController.text.trim().toString(),
                            widget.pin)) {
                          customErrorDialog(context, "Invalid!",
                              "PIN cannot be the same as existing one.");
                          _changePinController.clear();
                        } else {
                          authState.changePin(
                              context,
                              _changePinController.text.trim(),
                              userController
                                  .userModel!.userDetails![0].wallet.pin);
                        }
                        _changePinController.clear();
                      } else {
                        EasyLoading.dismiss();
                        customErrorDialog(context, "Incomplete",
                            "Fill the field correctly to proceed");
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
