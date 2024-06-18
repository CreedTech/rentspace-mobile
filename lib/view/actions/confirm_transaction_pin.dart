import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';

import '../../constants/colors.dart';
import '../../constants/icons.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../controller/auth/auth_controller.dart';

class ConfirmTransactionPinPage extends ConsumerStatefulWidget {
  const ConfirmTransactionPinPage({super.key, required this.pin});
  final String pin;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmTransactionPinPageState();
}

class _ConfirmTransactionPinPageState
    extends ConsumerState<ConfirmTransactionPinPage> {
  final TextEditingController _confirmPinController = TextEditingController();
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
  @override
  initState() {
    super.initState();
  }

  onKeyboardTap(String value) {
    setState(() {
      _confirmPinController.text = _confirmPinController.text + value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);

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
      controller: _confirmPinController,
      length: 4,
      validator: validatePinOne,
      onChanged: validatePinOne,
      onCompleted: (val) {
        FocusScope.of(context).unfocus();
        if (val != widget.pin) {
          customErrorDialog(context, 'Pin Mismatch', 'Pin does not match');

          val = '';
          _confirmPinController.clear();
        } else {
          authState.createPin(context, _confirmPinController.text.trim());
          // Navigator.pushNamed(
          //     context, RouteList.enable_user_notification);
        }
      },
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Confirm Transaction PIN',
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
                          key: confirmPinformKey,
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
                    textStyle: GoogleFonts.lato(
                      color: brandOne,
                      fontSize: 28,
                    ),
                    rightButtonFn: () {
                      if (_confirmPinController.text.isEmpty) return;
                      setState(() {
                        _confirmPinController.text = _confirmPinController.text
                            .substring(
                                0, _confirmPinController.text.length - 1);
                      });
                    },
                    rightButtonLongPressFn: () {
                      if (_confirmPinController.text.isEmpty) return;
                      setState(() {
                        _confirmPinController.text = '';
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
