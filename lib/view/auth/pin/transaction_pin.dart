import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/view/auth/pin/confirm_transaction_pin.dart';

import '../../../constants/colors.dart';
import '../../../constants/icons.dart';
import '../../../constants/widgets/custom_dialog.dart';
import '../../../controller/auth/auth_controller.dart';

class TransactionPin extends ConsumerStatefulWidget {
  const TransactionPin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TransactionPinState();
}

class _TransactionPinState extends ConsumerState<TransactionPin> {
  // final TextEditingController _pinController = TextEditingController();
  final TextEditingController _pinOneController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool isFilled = false;
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

  // onKeyboardTap(String value) {
  //   setState(() {
  //     _pinController.text = _pinController.text + value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 27,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Transaction Pin',
          style: GoogleFonts.lato(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 23.w),
            child: Image.asset(
              'assets/icons/logo_icon.png',
              height: 35.7.h,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     'Set Transaction PIN',
                  //     style: GoogleFonts.lato(
                  //       color: Theme.of(context).primaryColor,
                  //       fontWeight: FontWeight.w700,
                  //       fontSize: 20,
                  //       // fontFamily: "DefaultFontFamily",
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 40.h,
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Form(
                      key: setPinformKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/transaction_pin.png',
                            width: 138.w,
                          ),
                          SizedBox(
                            height: 54.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Set Transaction Pin',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            'Set up your personalized 4-digit PIN for transaction authorization.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Theme.of(context).primaryColorLight,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                          Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.h, horizontal: 3.w),
                                    child: Text(
                                      'Pin',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Pinput(
                                    obscuringCharacter: '*',
                                    // useNativeKeyboard: false,
                                    obscureText: true,
                                    defaultPinTheme: PinTheme(
                                      width: 67,
                                      height: 60,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      textStyle: GoogleFonts.lato(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffBDBDBD),
                                            width: 1.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    focusedPinTheme: PinTheme(
                                      width: 67,
                                      height: 60,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      textStyle: GoogleFonts.lato(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      decoration: BoxDecoration(
                                       border: Border.all(
                                                  color:
                                                      const Color(0xffBDBDBD),
                                                  width: 1.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    submittedPinTheme: PinTheme(
                                      width: 67,
                                      height: 60,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      textStyle: GoogleFonts.lato(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      decoration: BoxDecoration(
                                       border: Border.all(
                                                  color:
                                                      const Color(0xffBDBDBD),
                                                  width: 1.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    followingPinTheme: PinTheme(
                                      width: 67,
                                      height: 60,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      textStyle: GoogleFonts.lato(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffBDBDBD),
                                            width: 1.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    // onCompleted: (String val) async {
                                    //   setState(() {
                                    //     isFilled = true;
                                    //   });
                                    // },
                                    // validator: validatePinOne,
                                    // onChanged: validatePinOne,
                                    errorTextStyle: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red),
                                    controller: _pinOneController,
                                    length: 4,
                                    closeKeyboardWhenCompleted: true,
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.h, horizontal: 3.w),
                                    child: Text(
                                      'Confirm Pin',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Pinput(
                                    obscuringCharacter: '*',
                                    // useNativeKeyboard: false,
                                    obscureText: true,
                                    defaultPinTheme: PinTheme(
                                      width: 67,
                                      height: 60,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      textStyle: GoogleFonts.lato(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffBDBDBD),
                                            width: 1.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    focusedPinTheme: PinTheme(
                                      width: 67,
                                      height: 60,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      textStyle: GoogleFonts.lato(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      decoration: BoxDecoration(
                                       border: Border.all(
                                                  color:
                                                      const Color(0xffBDBDBD),
                                                  width: 1.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    submittedPinTheme: PinTheme(
                                      width: 67,
                                      height: 60,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      textStyle: GoogleFonts.lato(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffBDBDBD),
                                            width: 1.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    followingPinTheme: PinTheme(
                                      width: 67,
                                      height: 60,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      textStyle: GoogleFonts.lato(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffBDBDBD),
                                            width: 1.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onCompleted: (String val) async {
                                      setState(() {
                                        isFilled = true;
                                      });
                                      if (setPinformKey.currentState!
                                          .validate()) {
                                        authState.createPin(context,
                                            _confirmPinController.text.trim());
                                      }

                                      // authState.setNewPin(context, _pinOneController.text.trim(), _confirmPinController.text.trim());
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != _pinOneController.text) {
                                        return 'Pin does not match. Please check and try again';
                                      }

                                      return null;
                                    },
                                    errorTextStyle: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red),

                                    // validator: validatePinOne,
                                    // onChanged: validatePinOne,
                                    controller: _confirmPinController,
                                    length: 4,
                                    closeKeyboardWhenCompleted: true,
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 120.h,
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
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width -
                                              50,
                                          50),
                                      backgroundColor: brandTwo,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (setPinformKey.currentState!
                                          .validate()) {
                                        // verifyBVN();
                                        authState.createPin(context,
                                            _confirmPinController.text.trim());
                                      } else {
                                        customErrorDialog(
                                            context,
                                            'Invalid! :)',
                                            'Please fill the form properly to proceed');
                                      }
                                    },
                                    child: Text(
                                      'Proceed',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(
            //   bottom: 20,
            //   left: 0,
            //   right: 0,
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: NumericKeyboard(
            //       onKeyboardTap: onKeyboardTap,
            //       textStyle: GoogleFonts.lato(
            //         color: brandOne,
            //         fontSize: 28,
            //       ),
            //       rightButtonFn: () {
            //         if (_pinController.text.isEmpty) return;
            //         setState(() {
            //           _pinController.text = _pinController.text
            //               .substring(0, _pinController.text.length - 1);
            //         });
            //       },
            //       rightButtonLongPressFn: () {
            //         if (_pinController.text.isEmpty) return;
            //         setState(() {
            //           _pinController.text = '';
            //         });
            //       },
            //       rightIcon: const Icon(
            //         Icons.backspace_outlined,
            //         color: Colors.red,
            //       ),
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
