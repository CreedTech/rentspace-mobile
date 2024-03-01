import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/firebase_auth_constants.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/view/actions/confirm_reset_page.dart';
import 'package:rentspace/view/login_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'package:get/get.dart';

import '../../controller/auth/auth_controller.dart';

//String status = "Reset Password";

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  // _ForgotPasswordState createState() => _ForgotPasswordState();
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordConsumerState();
}

class _ForgotPasswordConsumerState extends ConsumerState<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  // final RoundedLoadingButtonController _btnController =
  //     RoundedLoadingButtonController();
  final forgotPassFormKey = GlobalKey<FormState>();
  void _doSomething() async {
    // Timer(const Duration(seconds: 1), () {
    //   _btnController.stop();
    // });

    if (forgotPassFormKey.currentState!.validate()) {
      authController.reset(context, _emailController.text.trim());
      setState(() {
        _emailController.clear();
      });
    }
  }

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
    //Validator
    validateMail(emailValue) {
      if (emailValue.isEmpty) {
        return 'email cannot be empty';
      }
      if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
          .hasMatch(emailValue)) {
        return 'Please enter a valid email';
      }

      return '';
    }

    //email field
    final email = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: const Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Enter your email',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email address.';
        }

        // Regular expression for a valid email address
        final emailRegex =
            RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');

        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address.';
        }

        return null;
      },
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        // backgroundColor: const Color(0xffE0E0E0),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
        // centerTitle: false,
        // title: Text(
        //   'Back',
        //   style: TextStyle(
        //     color: Theme.of(context).primaryColor,
        //     fontWeight: FontWeight.w700,
        //     fontSize: 16,
        //   ),
        // ),
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.3,
          //     child: Image.asset(
          //       'assets/icons/RentSpace-icon.png',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          ListView(
            children: [
              // SizedBox(
              //   height: 80,
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: 40,
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot Password',
                          style: GoogleFonts.nunito(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            // fontFamily: "DefaultFontFamily",
                          ),
                        ),
                        Text(
                          'Regain access with password recovery.',
                          style: GoogleFonts.nunito(
                            color: const Color(0xff828282),
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            // fontFamily: "DefaultFontFamily",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 51,
                    ),
                    Form(
                      key: forgotPassFormKey,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Enter Email',
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    // fontFamily: "DefaultFontFamily",
                                  ),
                                ),
                              ),
                              email,
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 50),
                          maximumSize: const Size(300, 50),
                          backgroundColor: brandOne,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (forgotPassFormKey.currentState!.validate()) {
                            authState.forgotPassword(
                              context,
                              _emailController.text.trim(),
                            );
                            // _emailController.clear();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Send OTP',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
