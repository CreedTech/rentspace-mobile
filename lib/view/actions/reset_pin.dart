import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/view/actions/confirm_reset_pin_page.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';

class ResetPIN extends ConsumerStatefulWidget {
  const ResetPIN({super.key, required this.email});
  final String email;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetPINState();
}

class _ResetPINState extends ConsumerState<ResetPIN> {
    final TextEditingController _pinController = TextEditingController();
  final resetPinFormKey = GlobalKey<FormState>();
  
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
        width: 50.w,
        height: 50.w,
        textStyle: GoogleFonts.nunito(
          fontSize: 20.sp,
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
        Get.to(ConfirmResetPinPage(pin: _pinController.text.trim()));
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
                        'Set New Transaction PIN',
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
                          key: resetPinFormKey,
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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                      if (resetPinFormKey.currentState!.validate()) {
                        // _doSomething();
                        Get.to(ConfirmResetPinPage(
                            pin: _pinController.text.trim()));
                      } else {
                        customErrorDialog(context, "Invalid!",
                            "Please Input your pin to proceed");
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
