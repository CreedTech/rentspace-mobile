import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/view/FirstPage.dart';
import 'package:rentspace/view/actions/change_pin.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';

class ChangePinIntro extends StatefulWidget {
  const ChangePinIntro({super.key});

  @override
  State<ChangePinIntro> createState() => _ChangePinIntroState();
}

class _ChangePinIntroState extends State<ChangePinIntro> {
  final TextEditingController _pinController = TextEditingController();
  final setPinformKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
      controller: _pinController,
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
        FocusScope.of(context).unfocus();
        if (BCrypt.checkpw(_pinController.text.trim().toString(),
            userController.userModel!.userDetails![0].wallet.pin)) {
          _pinController.clear();
          // EasyLoading.show(
          //   indicator: const CustomLoader(),
          //   maskType: EasyLoadingMaskType.black,
          //   dismissOnTap: false,
          // );
          print(val);
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
                      FocusScope.of(context).unfocus();
                      if (setPinformKey.currentState!.validate()) {
                        if (BCrypt.checkpw(
                            _pinController.text.trim().toString(),
                            userController
                                .userModel!.userDetails![0].wallet.pin)) {
                          _pinController.clear();

                          // EasyLoading.show(
                          //   indicator: const CustomLoader(),
                          //   maskType: EasyLoadingMaskType.black,
                          //   dismissOnTap: false,
                          // );
                          Get.to(ChangePIN(pin: _pinController.text.trim()));
                        } else {
                          EasyLoading.dismiss();
                          _pinController.clear();
                          if (context.mounted) {
                            customErrorDialog(context, "Invalid PIN",
                                'Enter correct PIN to proceed');
                          }
                        }
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
