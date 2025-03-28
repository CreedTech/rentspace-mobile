import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'dart:io';

import '../../constants/colors.dart';
import '../../controller/auth/user_controller.dart';
import '../../widgets/custom_dialogs/index.dart';

class IdlePage extends StatefulWidget {
  IdlePage(
      {super.key, required this.sessionStateStream, this.loggedOutReason = ""});

  final StreamController<SessionState> sessionStateStream;
  late String loggedOutReason;

  @override
  _IdlePageState createState() => _IdlePageState();
}

final TextEditingController _pinController = TextEditingController();
final idlePinformKey = GlobalKey<FormState>();

class _IdlePageState extends State<IdlePage> {
  final UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    if (widget.loggedOutReason != "") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            backgroundColor: brandOne,
            message: widget.loggedOutReason,
          ),
        );
      });
    }
    _pinController.clear();
  }

  onKeyboardTap(String value) {
    setState(() {
      _pinController.text = _pinController.text + value;
    });
  }

  @override
  Widget build(BuildContext context) {
    //validation function

    //pin theme

    //Pin

    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            child: Stack(
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const SizedBox(
                    //   height: 50,
                    // ),

                    SizedBox(
                      height: 100.h,
                      width: 90.w,
                      child: Container(
                        height: 30,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/idle.gif"),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Enter Your Rentspace Pin to Return to Rentspace',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: idlePinformKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 14,
                            ),
                            child: Pinput(
                              useNativeKeyboard: false,
                              obscureText: true,
                              defaultPinTheme: PinTheme(
                                width: 50,
                                height: 50,
                                textStyle: GoogleFonts.lato(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 28,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffBDBDBD),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              focusedPinTheme: PinTheme(
                                width: 50,
                                height: 50,
                                textStyle: GoogleFonts.lato(
                                  fontSize: 25,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffBDBDBD),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              submittedPinTheme: PinTheme(
                                width: 50,
                                height: 50,
                                textStyle: GoogleFonts.lato(
                                  fontSize: 25,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffBDBDBD),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              followingPinTheme: PinTheme(
                                width: 50,
                                height: 50,
                                textStyle: GoogleFonts.lato(
                                  fontSize: 25,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffBDBDBD),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onCompleted: (String val) {
                                if (BCrypt.checkpw(
                                  _pinController.text.trim().toString(),
                                  userController
                                      .userModel!.userDetails![0].wallet.pin,
                                )) {
                                  widget.sessionStateStream
                                      .add(SessionState.startListening);
                                  context.pop();
                                } else {
                                  _pinController.clear();
                                  if (context.mounted) {
                                    customErrorDialog(context, "Invalid PIN",
                                        'Enter correct PIN to proceed');
                                  }
                                }
                              },
                              controller: _pinController,
                              length: 4,
                              closeKeyboardWhenCompleted: true,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ],
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
                        color: Theme.of(context).colorScheme.primary,
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
      ),
    );
  }
}
