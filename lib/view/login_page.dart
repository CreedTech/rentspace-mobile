import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/view/actions/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/icons.dart';
import 'package:rentspace/view/signup_page.dart';
import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/auth/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageConsumerState();
}

class _LoginPageConsumerState extends ConsumerState<LoginPage> {
  //Multiple attempts prevention section
  final loginAttempts = GetStorage();
  final lockAttempts = GetStorage();
  int loginCount = 0;
  final d1 = "".obs();
  int currentCount = 0;
  bool isLockedOut = false;
  bool isChecked = false;
  bool isLoading = false;

  bool obscurity = true;
  Icon lockIcon = LockIcon().open;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  // final RoundedLoadingButtonController _btnController =
  //     RoundedLoadingButtonController();
  final loginFormKey = GlobalKey<FormState>();
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

  // Future<void> setHasSeenOnboardingPreference(bool value) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('hasSeenOnboarding', value);
  //   print("====================");
  //   print("Checking for new users.....");
  //   print(prefs.get('hasSeenOnboarding'));
  //   print("====================");
  // }

  // void _doSomething() async {
  //   Timer(const Duration(seconds: 1), () {
  //     _btnController.stop();
  //   });

  //   if (loginFormKey.currentState!.validate()) {
  //     authController.login(_emailController.text.trim(),
  //         _passwordController.text.trim(), context);
  //   }
  // }

  @override
  initState() {
    // setHasSeenOnboardingPreference(true);
    super.initState();
    _getSavedLoginInfo();
  }

  // Function to retrieve saved login credentials and remember me status
  Future<void> _getSavedLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        _rememberMe = rememberMe;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);
    //email field
    final email = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: TextStyle(
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
//Textform field
    final password = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _passwordController,
      obscureText: obscurity,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        suffix: InkWell(
          onTap: visibility,
          child: lockIcon,
        ),
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
        hintText: 'Enter your password',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: (value) {
        RegExp uppercaseRegex = RegExp(r'[A-Z]');
        RegExp lowercaseRegex = RegExp(r'[a-z]');
        RegExp digitsRegex = RegExp(r'[0-9]');
        RegExp specialCharRegex = RegExp(r'[#\$%&*?@]');
        if (value == null || value.isEmpty) {
          return 'Input a valid password';
        }
        // if (value.length < 8) {
        //   return "Password must be at least 8 characters long.";
        // } else if (!uppercaseRegex.hasMatch(value)) {
        //   return "Password must contain at least one uppercase letter.";
        // } else if (!lowercaseRegex.hasMatch(value)) {
        //   return "Password must contain at least one lowercase letter.";
        // } else if (!digitsRegex.hasMatch(value)) {
        //   return "Password must contain at least one number.";
        // } else if (!specialCharRegex.hasMatch(value)) {
        //   return "Password must contain at least one special character (#\$%&*?@).";
        // }
        else {
          return null;
        }
      },
    );

    //     \t"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!\%*?&])[A-Za-z@\t$\d!\t%*?&]{8,10}$\t

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        // backgroundColor: const Color(0xffE0E0E0),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        // leading: GestureDetector(
        //   onTap: () {
        //     Get.back();
        //   },
        //   child: Icon(
        //     Icons.arrow_back,
        //     size: 25,
        //     color: Theme.of(context).primaryColor,
        //   ),
        // ),
        centerTitle: true,
        // title: Text(
        //   'Login',
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login to your account',
                        style: GoogleFonts.nunito(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          // fontFamily: "DefaultFontFamily",
                        ),
                      ),
                      Text(
                        'Reconnect with your dreams and aspirations as we embrace the next chapter of your journey together.',
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
                    key: loginFormKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 3),
                              child: Text(
                                'Enter Email',
                                style: GoogleFonts.nunito(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            email,
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 3),
                              child: Text(
                                'Enter Password',
                                style: GoogleFonts.nunito(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  // fontFamily: "DefaultFontFamily",
                                ),
                              ),
                            ),
                            password,
                          ],
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (_rememberMe == false)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.zero,
                                        // alignment: Alignment.centerLeft,
                                        child: Checkbox.adaptive(
                                            visualDensity: VisualDensity
                                                .adaptivePlatformDensity,
                                            value: _rememberMe,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _rememberMe = value!;
                                              });
                                            },
                                            overlayColor:
                                                MaterialStateColor.resolveWith(
                                              (states) => brandFour,
                                            ),
                                            fillColor: MaterialStateProperty
                                                .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                              if (states.contains(
                                                  MaterialState.selected)) {
                                                return brandFour;
                                              }
                                              return const Color(0xffF2F2F2);
                                            }),
                                            focusColor:
                                                MaterialStateColor.resolveWith(
                                              (states) => brandFour,
                                            ),
                                            activeColor:
                                                MaterialStateColor.resolveWith(
                                              (states) => brandFour,
                                            ),
                                            side: const BorderSide(
                                              color: Color(0xffBDBDBD),
                                            )),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Remember me',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff828282),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(
                                    children: [],
                                  ),
                            GestureDetector(
                              onTap: () {
                                Get.to(const ForgotPassword());
                                // Navigator.of(context).pushNamed(forgotPass);
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.nunito(
                                    color: brandFive,
                                    fontSize: 12,
                                    // leadingDistribution:
                                    //     TextLeadingDistribution.even,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // width: MediaQuery.of(context).size.width * 2,
                      alignment: Alignment.center,
                      // height: 110.h,
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 50),
                              backgroundColor: brandOne,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (loginFormKey.currentState!.validate()) {
                                authState.signIn(
                                  context,
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  rememberMe: _rememberMe,
                                  // usernameController.text.trim(),
                                );
                                // emailController.clear();
                                // passwordController.clear();
                              }
                            },
                            child: Text(
                              'Proceed',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // RoundedLoadingButton(
                  //   borderRadius: 5.0,
                  //   elevation: 0.0,
                  //   successColor: brandOne,
                  //   color: brandFive,
                  //   controller: _btnController,
                  //   onPressed: _doSomething,
                  //   child: Text(
                  //     'Proceed',
                  //     style: GoogleFonts.nunito(
                  //         color: Colors.white,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w700),
                  //   ),
                  // ),

                  // const SizedBox(
                  //   height: 15,
                  // ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const SignupPage());
                          },
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.nunito(
                              color: brandFive,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  (currentCount != 0)
                      ? Text(
                          "Remaining attempts: ${5 - currentCount}",
                          style: GoogleFonts.nunito(
                            color: Colors.red,
                          ),
                        )
                      : Text(
                          d1,
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
