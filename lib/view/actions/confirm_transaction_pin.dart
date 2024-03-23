import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
          authState.createPin(context, _confirmPinController.text.trim());
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
                        'Confirm Transaction PIN',
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
                      FocusScope.of(context).unfocus();
                      if (confirmPinformKey.currentState!.validate()) {
                        if (_confirmPinController.text.trim() !=
                            widget.pin) {
                          customErrorDialog(context, 'Pin Mismatch',
                              'Pin does not match');
                                  
                          _confirmPinController.clear();
                        } else {
                          authState.createPin(
                              context, _confirmPinController.text.trim());
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

              // Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.fromLTRB(30, 20.h, 30, 10),
              //         child: Form(
              //           key: confirmPinformKey,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Padding(
              //                 padding:
              //                     const EdgeInsets.only(top: 10, bottom: 20),
              //                 child: Text(
              //                   'Confirm Transaction PIN',
              //                   style: GoogleFonts.nunito(
              //                     color: Theme.of(context).primaryColor,
              //                     fontWeight: FontWeight.w700,
              //                     fontSize: 20,
              //                     // fontFamily: "DefaultFontFamily",
              //                   ),
              //                 ),
              //               ),
              //               SizedBox(
              //                 height: 25.h,
              //               ),
              //               pin,
              //               SizedBox(
              //                 height: 100.h,
              //               ),
              //               Align(
              //                 alignment: Alignment.bottomCenter,
              //                 child: Container(
              //                   // width: MediaQuery.of(context).size.width * 2,
              //                   alignment: Alignment.center,
              //                   // height: 110.h,
              //                   child: Column(
              //                     children: [
              //                       ElevatedButton(
              //                         style: ElevatedButton.styleFrom(
              //                           minimumSize: const Size(250, 50),
              //                           backgroundColor: brandOne,
              //                           elevation: 0,
              //                           shape: RoundedRectangleBorder(
              //                             borderRadius: BorderRadius.circular(
              //                               10,
              //                             ),
              //                           ),
              //                         ),
              //                         onPressed: () {
              //                           if (confirmPinformKey.currentState!
              //                               .validate()) {
              //                             if (_confirmPinController.text
              //                                     .trim() !=
              //                                 widget.pin) {
              //                               customErrorDialog(
              //                                   context,
              //                                   'Pin Mismatch',
              //                                   'Pin does not match');

              //                               _confirmPinController.clear();
              //                             } else {
              //                               authState.createPin(
              //                                   context,
              //                                   _confirmPinController.text
              //                                       .trim());
              //                               // Navigator.pushNamed(
              //                               //     context, RouteList.enable_user_notification);
              //                             }
              //                             // _doSomething();
              //                           } else {
              //                             customErrorDialog(
              //                                 context,
              //                                 "Invalid!",
              //                                 "Please Input your pin to proceed");
              //                           }
              //                         },
              //                         child: const Text(
              //                           'Proceed',
              //                           textAlign: TextAlign.center,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
