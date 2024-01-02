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

//String status = "Reset Password";

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final forgotPassFormKey = GlobalKey<FormState>();
  void _doSomething() async {
    Timer(const Duration(seconds: 1), () {
      _btnController.stop();
    });

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
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
      ),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
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
          child: const Icon(
            Icons.arrow_back,
            size: 25,
            color: Color(0xff4E4B4B),
          ),
        ),
        title: const Text(
          'Back',
          style: TextStyle(
            color: Color(0xff4E4B4B),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
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
                            color: brandFour,
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
                      height: 34,
                    ),
                    RoundedLoadingButton(
                      elevation: 0.0,
                      borderRadius: 8.0,
                      successColor: brandOne,
                      color: brandFive,
                      controller: _btnController,
                      onPressed: _doSomething,
                      child: Text(
                        'Send link',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
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
