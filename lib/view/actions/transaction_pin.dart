import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/view/actions/confirm_transaction_pin.dart';

import '../../constants/colors.dart';
import '../../constants/icons.dart';
import '../../constants/widgets/custom_dialog.dart';

class TransactionPin extends ConsumerStatefulWidget {
  const TransactionPin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TransactionPinState();
}

class _TransactionPinState extends ConsumerState<TransactionPin> {
  final TextEditingController _pinController = TextEditingController();
  final setPinformKey = GlobalKey<FormState>();
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
  @override
  initState() {
    super.initState();
  }

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
        textStyle: TextStyle(
          fontSize: 25.sp,
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
          fontSize: 25.sp,
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
          fontSize: 25.sp,
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
          fontSize: 25.sp,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandTwo, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      controller: _pinController,
      length: 4,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      validator: validatePinOne,
      onChanged: validatePinOne,
      onCompleted: (val) {
        Get.to(ConfirmTransactionPinPage(pin: _pinController.text.trim()));
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
                        'Set Transaction PIN',
                        style: GoogleFonts.poppins(
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
                    onKeyboardTap: onKeyboardTap,
                    textStyle: GoogleFonts.poppins(
                      color: brandOne,
                      fontSize: 28.sp,
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
