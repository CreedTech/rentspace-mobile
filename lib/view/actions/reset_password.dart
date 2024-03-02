import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';

import '../../constants/icons.dart';
import '../../controller/auth/auth_controller.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key, required this.email});
  final String email;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final resetPwdFormKey = GlobalKey<FormState>();
  bool obscureText = true;
  Icon lockIcon = LockIcon().open;

  void visibility() {
    if (obscureText == true) {
      setState(() {
        obscureText = false;
        lockIcon = LockIcon().close;
      });
    } else {
      setState(() {
        obscureText = true;
        lockIcon = LockIcon().open;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);
    validatePass(passValue) {
      RegExp uppercaseRegex = RegExp(r'[A-Z]');
      RegExp lowercaseRegex = RegExp(r'[a-z]');
      RegExp digitsRegex = RegExp(r'[0-9]');
      RegExp specialCharRegex = RegExp(r'[#\$%&*?@]');
      if (passValue == null || passValue.isEmpty) {
        return 'Input a valid password';
      } else if (passValue.length < 8) {
        return "Password must be at least 8 characters long.";
      } else if (!uppercaseRegex.hasMatch(passValue)) {
        return "Password must contain at least one uppercase letter.";
      } else if (!lowercaseRegex.hasMatch(passValue)) {
        return "Password must contain at least one lowercase letter.";
      } else if (!digitsRegex.hasMatch(passValue)) {
        return "Password must contain at least one number.";
      } else if (!specialCharRegex.hasMatch(passValue)) {
        return "Password must contain at least one special character (#\$%&*?@).";
      } else {
        return null;
      }
    }

    //password field
    final password = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: newPasswordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        label: Text(
          "New Password",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        hintText: '************',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffix: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText ? Iconsax.eye_slash5 : Iconsax.eye4,
            color: brandOne,
          ),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
      validator: validatePass,
    );
    final confirmPassword = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: repeatPasswordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        hintText: '************',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        label: Text(
          "Repeat Password",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        suffix: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText ? Iconsax.eye_slash5 : Iconsax.eye4,
            color: brandOne,
          ),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != newPasswordController.text) {
          return 'Passwords do not match';
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
        centerTitle: true,
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 35,
                  ),
             
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Kindly fill in your new password.',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          color: brandOne,
                          fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Form(
                    key: resetPwdFormKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: 3, horizontal: 3),
                            //   child: Text(
                            //     'Password',
                            //     style: GoogleFonts.nunito(
                            //       color: Theme.of(context).primaryColor,
                            //       fontWeight: FontWeight.w700,
                            //       fontSize: 16,
                            //       // fontFamily: "DefaultFontFamily",
                            //     ),
                            //   ),
                            // ),
                            password,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      size: 15,
                                      color: Color(0xff828282),
                                    ),
                                    SizedBox(
                                      width: 320,
                                      child: Text(
                                        'Password -8 Characters, One Uppercase, One Lowercase, One Special Characters (#%&*?@)',
                                        softWrap: true,
                                        style: GoogleFonts.nunito(
                                          color: const Color(0xff828282),
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        confirmPassword
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
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
                    if (resetPwdFormKey.currentState!.validate()) {
                      // Resend Email Verification Code
                      authState.resetPassword(
                        context,
                        widget.email,
                        newPasswordController.text.trim(),
                        repeatPasswordController.text.trim(),
                      );
                      // resetPasswordDialog(context);
                    }
                  },
                  child: const Text(
                    'Reset Password',
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
