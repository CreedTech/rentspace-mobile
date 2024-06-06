import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/colors.dart';
import '../../constants/icons.dart';
import '../../controller/auth/user_controller.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final UserController userController = Get.find();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final changePwdFormKey = GlobalKey<FormState>();
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
    final oldPassword = TextFormField(
      enableSuggestions: true,
      cursorColor: colorBlack,
      controller: oldPasswordController,
      autovalidateMode: AutovalidateMode.disabled,
      obscureText: obscureText,
      style: GoogleFonts.lato(
        color: colorBlack,
        fontSize: 14,
        fontWeight: FontWeight.w500,
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
          borderSide: const BorderSide(color: brandOne, width: 1.0),
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
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w500,
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
          ),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
      // onEditingComplete: () {
      //   changePwdFormKey.currentState?.validate();
      //   // if (changePwdFormKey.currentState?.validate() ?? false) {
      //   //   // Perform the action you want after successful validation
      //   // }
      // },
      // onTapOutside: (String) {
      //   changePwdFormKey.currentState?.validate();
      // },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your old Password';
        }
        if (!BCrypt.checkpw(
          oldPasswordController.text.trim(),
          userController.userModel!.userDetails![0].password,
        )) {
          return 'Incorrect Password. Please check and try again';
        }

        return null;
      },
    );

    final password = TextFormField(
      enableSuggestions: true,
      cursorColor: colorBlack,
      controller: newPasswordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      style: GoogleFonts.lato(
        color: colorBlack,
        fontSize: 14,
        fontWeight: FontWeight.w500,
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
          borderSide: const BorderSide(color: brandOne, width: 1.0),
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
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w500,
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
      style: GoogleFonts.lato(
        color: colorBlack,
        fontSize: 14,
        fontWeight: FontWeight.w500,
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
          borderSide: const BorderSide(color: brandOne, width: 1.0),
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
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w500,
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
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffF6F6F8),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: colorBlack,
              ),
              SizedBox(
                width: 4.h,
              ),
              Text(
                'Change Password',
                style: GoogleFonts.lato(
                  color: colorBlack,
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
                    children: [
                      Form(
                        key: changePwdFormKey,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.h, horizontal: 3.w),
                                  child: Text(
                                    'Old Password',
                                    style: GoogleFonts.lato(
                                      color: colorBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                oldPassword,
                              ],
                            ),
                            SizedBox(
                              height: 13.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.h, horizontal: 3.w),
                                  child: Text(
                                    'New Password',
                                    style: GoogleFonts.lato(
                                      color: colorBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                password,
                              ],
                            ),
                            SizedBox(
                              height: 13.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.h, horizontal: 3.w),
                                  child: Text(
                                    'Re-enter New Password',
                                    style: GoogleFonts.lato(
                                      color: colorBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                confirmPassword,
                              ],
                            ),
                            SizedBox(
                              height: 13.h,
                            ),
                          ],
                        ),
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
                    backgroundColor: brandTwo,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (changePwdFormKey.currentState != null &&
                        changePwdFormKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      userController.changePassword(
                          context,
                          oldPasswordController.text.trim(),
                          newPasswordController.text.trim(),
                          repeatPasswordController.text.trim());
                      //  storedData['data'];
                    }
                  },
                  child: const Text(
                    'Change',
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
