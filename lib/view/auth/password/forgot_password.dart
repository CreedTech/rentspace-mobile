import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';

import '../../../controller/auth/auth_controller.dart';
import '../../../widgets/custom_text_field_widget.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordConsumerState();
}

class _ForgotPasswordConsumerState extends ConsumerState<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  final forgotPassFormKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);
    return Scaffold(
      backgroundColor: brandOne,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: brandOne,
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  right: -50,
                  child: Image.asset(
                    'assets/logo_transparent.png',
                    width: 205.47.w,
                    height: 292.51.h,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 55),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo_main.png',
                          width: 168,
                          height: 50.4.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h, left: 30),
                          child: Text(
                            'your financial power...',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              color: colorWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 4,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 24),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Forgot Password',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'No worries, we’ll get you back on track.\nInput your email address below to receive an OTP. ',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).primaryColorLight,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 79,
                            ),
                            Form(
                              key: forgotPassFormKey,
                              child: Column(
                                children: [
                                  CustomTextFieldWidget(
                                    controller: _emailController,
                                    obscureText: false,
                                    filled: false,
                                    readOnly: false,
                                    labelText: 'Email',
                                    autoValidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    maxLines: 1,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter an email address.';
                                      }

                                      // Regular expression for a valid email address
                                      final emailRegex = RegExp(
                                          r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');

                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Please enter a valid email address.';
                                      }

                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Container(
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
                                        if (forgotPassFormKey.currentState!
                                            .validate()) {
                                          authState.forgotPassword(
                                            context,
                                            _emailController.text.trim(),
                                          );
                                          // _emailController.clear();
                                        }
                                      },
                                      child: Text(
                                        'Continue',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          color: colorWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
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
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.back();
                                        // Get.back();
                                      },
                                      child: Text(
                                        'Cancel',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ],
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
