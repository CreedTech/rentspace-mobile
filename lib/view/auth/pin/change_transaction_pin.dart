import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../constants/colors.dart';
import '../../../controller/auth/auth_controller.dart';

class ChangeTransactionPin extends ConsumerStatefulWidget {
  const ChangeTransactionPin({super.key, required this.email});
  final String email;

  @override
  ConsumerState<ChangeTransactionPin> createState() =>
      _ChangeTransactionPinState();
}

class _ChangeTransactionPinState extends ConsumerState<ChangeTransactionPin> {
  final TextEditingController _pinOneController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final changeTransactionPinFormKey = GlobalKey<FormState>();
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    isFilled = false;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
               Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: 4.h,
              ),
              Text(
                'Change Transaction Pin',
                style: GoogleFonts.lato(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 24.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Input your new Transaction Pin',
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 27),
                        child: Form(
                          key: changeTransactionPinFormKey,
                          child: Column(
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
                                        color: Theme.of(context).colorScheme.primary,
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
                                        color: brandOne,
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
                                        color: brandOne,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: brandOne, width: 1.0),
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
                                        color: brandOne,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: brandOne, width: 1.0),
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
                                        color: brandOne,
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
                                        color: Theme.of(context).colorScheme.primary,
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
                                        color: brandOne,
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
                                        color: brandOne,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: brandOne, width: 1.0),
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
                                        color: brandOne,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: brandOne, width: 1.0),
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
                                        color: brandOne,
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
                                      if (changeTransactionPinFormKey
                                          .currentState!
                                          .validate()) {
                                        authState.setNewPin(
                                            context,
                                            _pinOneController.text.trim(),
                                            _confirmPinController.text.trim());
                                      }
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
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width - 50, 50),
                    backgroundColor: (isFilled = true) ? brandTwo : Colors.grey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (changeTransactionPinFormKey.currentState != null &&
                        changeTransactionPinFormKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      authState.setNewPin(
                          context,
                          _pinOneController.text.trim(),
                          _confirmPinController.text.trim());
                    }
                  },
                  child: const Text(
                    'Proceed',
                    textAlign: TextAlign.center,
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
