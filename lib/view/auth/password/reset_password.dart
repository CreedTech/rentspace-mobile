import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';

import '../../../constants/icons.dart';
import '../../../controller/auth/auth_controller.dart';
import '../../../widgets/custom_text_field_widget.dart';

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
  // late Icon lockIcon;

  // void visibility() {
  //   if (obscureText == true) {
  //     setState(() {
  //       obscureText = false;
  //       lockIcon = LockIcon().close(context);
  //     });
  //   } else {
  //     setState(() {
  //       obscureText = true;
  //       lockIcon = LockIcon().open(context);
  //     });
  //   }
  // }

  @override
  void initState() {
    // lockIcon = LockIcon().open(context);
    super.initState();
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
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
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
                            'Create New Password',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            'Email verified successfully!\nCreate new password to gain access to your account.',
                            style: GoogleFonts.lato(
                              color: Theme.of(context).primaryColorLight,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 49,
                          ),
                          Form(
                            key: resetPwdFormKey,
                            child: Column(
                              children: [
                                CustomTextFieldWidget(
                                  controller: newPasswordController,
                                  obscureText: obscureText,
                                  filled: false,
                                  readOnly: false,
                                  labelText: 'Password',
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLines: 1,
                                  validator: validatePass,
                                  keyboardType: TextInputType.text,
                                  suffix: InkWell(
                                    onTap: () {
                                      setState(() {
                                        obscureText =
                                            !obscureText; // Toggle the obscureText state
                                      });
                                    },
                                    child: (obscureText == true)
                                        ? Icon(
                                            Iconsax.eye_slash,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )
                                        : Icon(
                                            Iconsax.eye,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomTextFieldWidget(
                                  controller: repeatPasswordController,
                                  obscureText: obscureText,
                                  filled: false,
                                  readOnly: false,
                                  labelText: 'Confirm Password',
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != newPasswordController.text) {
                                      return 'Passwords do not match';
                                    }

                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  suffix: InkWell(
                                    onTap: () {
                                      setState(() {
                                        obscureText =
                                            !obscureText; // Toggle the obscureText state
                                      });
                                    },
                                    child: (obscureText == true)
                                        ? Icon(
                                            Iconsax.eye_slash,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )
                                        : Icon(
                                            Iconsax.eye,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                  ),
                                  suffixIconColor: Colors.black,
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
                              alignment: Alignment.center,
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
            ],
          ),
        ),
      ),
    );
  }
}
