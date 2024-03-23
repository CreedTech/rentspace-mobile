import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../controller/auth/auth_controller.dart';

class ConfirmResetPinPage extends ConsumerStatefulWidget {
  const ConfirmResetPinPage({super.key, required this.pin});
  final String pin;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmResetPinPageState();
}

class _ConfirmResetPinPageState extends ConsumerState<ConfirmResetPinPage> {
  final TextEditingController _confirmPinController = TextEditingController();
  final confirmNewPinformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);
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
      controller: _confirmPinController,
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
      validator: validatePinOne,
      onChanged: validatePinOne,
      onCompleted: (val) {
        FocusScope.of(context).unfocus();
        if (val != widget.pin) {
          customErrorDialog(context, 'Pin Mismatch', 'Pin does not match');

          val = '';
          _confirmPinController.clear();
        } else {
          authState.setNewPin(
              context, widget.pin, _confirmPinController.text.trim());
          // Navigator.pushNamed(
          //     context, RouteList.enable_user_notification);
        }

        // Get.to(ConfirmTransactionPinPage(pin:_confirmPinController.text.trim()));
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
                        'Confirm New Transaction PIN',
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
                          key: confirmNewPinformKey,
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
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (confirmNewPinformKey.currentState!.validate()) {
                        if (_confirmPinController.text.trim() != widget.pin) {
                          customErrorDialog(
                              context, 'Pin Mismatch', 'Pin does not match');

                          _confirmPinController.clear();
                        } else {
                          authState.setNewPin(
                            context,
                            widget.pin,
                            _confirmPinController.text.trim(),
                          );
                          // Navigator.pushNamed(
                          //     context, RouteList.enable_user_notification);
                        }
                        // _doSomething();
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
