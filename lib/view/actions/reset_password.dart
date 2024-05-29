import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      cursorColor: colorBlack,
      controller: newPasswordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      style: TextStyle(
        color: colorBlack,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        suffix: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText ? Iconsax.eye_slash : Iconsax.eye,
            color: colorBlack,
            size: 24,
          ),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
      validator: validatePass,
    );
    final confirmPassword = TextFormField(
      enableSuggestions: true,
      cursorColor: colorBlack,
      controller: repeatPasswordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      style: TextStyle(
        color: colorBlack,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        
        suffix: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText ? Iconsax.eye_slash : Iconsax.eye,
            color: colorBlack,
            size: 24,
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
      backgroundColor: brandOne,
      body: Container(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.only(
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
                            'Create New Password',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: colorBlack,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            'Email verified successfully!\nCreate new password to gain access to your account.',
                            style: GoogleFonts.lato(
                              color: const Color(0xff4B4B4B),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                          const SizedBox(
                            height: 49,
                          ),
                          Form(
                            key: resetPwdFormKey,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        'Password',
                                        style: GoogleFonts.lato(
                                          color: colorBlack,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    password,
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        'Confirm Password',
                                        style: GoogleFonts.lato(
                                          color: colorBlack,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    confirmPassword,
                                  ],
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
                                      if (resetPwdFormKey.currentState!
                                          .validate()) {
                                        authState.resetPassword(
                                            context,
                                            widget.email,
                                            newPasswordController.text.trim(),
                                            repeatPasswordController.text
                                                .trim());
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
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Column(
              //   children: [
              //     const SizedBox(
              //       height: 35,
              //     ),
              //     Align(
              //       alignment: Alignment.topLeft,
              //       child: Text(
              //         'Kindly fill in your new password.',
              //         style: GoogleFonts.lato(
              //             fontWeight: FontWeight.w700,
              //             color: brandOne,
              //             fontSize: 18),
              //       ),
              //     ),
              //     const SizedBox(
              //       height: 25,
              //     ),
              //     Form(
              //       key: resetPwdFormKey,
              //       child: Column(
              //         children: [
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               password,
              //               Padding(
              //                 padding: const EdgeInsets.symmetric(vertical: 8),
              //                 child: SizedBox(
              //                   width: MediaQuery.of(context).size.width,
              //                   child: Row(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       const Icon(
              //                         Icons.info_outline,
              //                         size: 15,
              //                         color: Color(0xff828282),
              //                       ),
              //                       SizedBox(
              //                         width: 320,
              //                         child: Text(
              //                           'Password -8 Characters, One Uppercase, One Lowercase, One Special Characters (#%&*?@)',
              //                           softWrap: true,
              //                           style: GoogleFonts.lato(
              //                             color: const Color(0xff828282),
              //                             fontSize: 12,
              //                             fontStyle: FontStyle.italic,
              //                             fontWeight: FontWeight.w400,
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           const SizedBox(
              //             height: 15,
              //           ),
              //           confirmPassword
              //         ],
              //       ),
              //     ),
              //   ],
              // ),

              // const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
