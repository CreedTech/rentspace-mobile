import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/view/actions/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/icons.dart';
import 'package:rentspace/view/signup_page.dart';
import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import '../api/global_services.dart';
import '../controller/auth/auth_controller.dart';
import '../internet_connection_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  LoginPage(
      {super.key, required this.sessionStateStream, this.loggedOutReason = ""});

  final StreamController<SessionState> sessionStateStream;
  late String loggedOutReason;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageConsumerState();
}

class _LoginPageConsumerState extends ConsumerState<LoginPage> {
  //Multiple attempts prevention section
  late StreamSubscription subscription;
  final loginAttempts = GetStorage();
  final lockAttempts = GetStorage();
  int loginCount = 0;
  final d1 = "".obs();
  int currentCount = 0;
  bool isLockedOut = false;
  bool isChecked = false;
  bool isLoading = false;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  bool obscurity = true;
  Icon lockIcon = LockIcon().open;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  String deviceType = "";
  String deviceModel = "";
  String token = "";
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

  @override
  initState() {
    // setHasSeenOnboardingPreference(true);
    super.initState();
    // getConnectivity();
    _getSavedLoginInfo();
    _getDeviceInfo();
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

  Future<void> _getDeviceInfo() async {
    final fcmToken = await GlobalService.sharedPreferencesManager.getFCMToken();
    final prefs = await SharedPreferences.getInstance();
    final savedDeviceType = prefs.getString('device_type');
    final savedDeviceModel = prefs.getString('device_model');
    print('device info');
    print(savedDeviceType);
    print(savedDeviceModel);
    print(fcmToken);
    if (savedDeviceType != null && savedDeviceModel != null && fcmToken != '') {
      setState(() {
        deviceType = savedDeviceType;
        deviceModel = savedDeviceModel;
        token = fcmToken;
      });
      print(savedDeviceType);
      print(savedDeviceModel);
      print(fcmToken);
    }
  }

  void getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && !isAlertSet) {
          noInternetConnectionScreen(context);
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);
    // final isConnected = ref.watch(internetConnectionProvider).isConnected;
    //email field
    final email = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: colorBlack,
      style: GoogleFonts.lato(color: colorBlack, fontSize: 14),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
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
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        // hintText: 'Enter your email',
        // hintStyle: GoogleFonts.lato(
        //   color: Colors.grey,
        //   fontSize: 12,
        //   fontWeight: FontWeight.w400,
        // ),
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
      cursorColor: colorBlack,
      controller: _passwordController,
      obscureText: obscurity,
      style: GoogleFonts.lato(color: colorBlack, fontSize: 14),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        suffix: InkWell(
          onTap: visibility,
          child: lockIcon,
        ),
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
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        // hintText: 'Enter your password',
        // hintStyle: GoogleFonts.lato(
        //   color: Colors.grey,
        //   fontSize: 12,
        //   fontWeight: FontWeight.w400,
        // ),
      ),
      maxLines: 1,
      validator: (value) {
        // RegExp uppercaseRegex = RegExp(r'[A-Z]');
        // RegExp lowercaseRegex = RegExp(r'[a-z]');
        // RegExp digitsRegex = RegExp(r'[0-9]');
        // RegExp specialCharRegex = RegExp(r'[#\$%&*?@]');
        if (value == null || value.isEmpty) {
          return 'Input a valid password';
        } else {
          return null;
        }
      },
    );

    //     \t"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!\%*?&])[A-Za-z@\t$\d!\t%*?&]{8,10}$\t

    return UpgradeAlert(
      upgrader: Upgrader(
        showIgnore: false,
        durationUntilAlertAgain: const Duration(seconds: 5),
        debugLogging: true,
        // debugDisplayAlways:true,
        dialogStyle: UpgradeDialogStyle.cupertino,
        showLater: false,
        canDismissDialog: false,
        showReleaseNotes: true,
      ),
      child: Scaffold(
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 24),
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
                              'Welcome Back👋',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: colorBlack,
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Keep your rent journey seamless. \nLog in to manage payments effortlessly.',
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
                              key: loginFormKey,
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3.h, horizontal: 3.w),
                                        child: Text(
                                          'Email',
                                          style: GoogleFonts.lato(
                                            color: colorBlack,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      email,
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 36,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    height: 21,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                              overlayColor: MaterialStateColor
                                                  .resolveWith(
                                                (states) => brandTwo,
                                              ),
                                              fillColor: MaterialStateProperty
                                                  .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                if (states.contains(
                                                    MaterialState.selected)) {
                                                  return brandTwo;
                                                }
                                                return const Color(0xffF2F2F2);
                                              }),
                                              focusColor: MaterialStateColor
                                                  .resolveWith(
                                                (states) => brandTwo,
                                              ),
                                              activeColor: MaterialStateColor
                                                  .resolveWith(
                                                (states) => brandTwo,
                                              ),
                                              side: const BorderSide(
                                                color: Color(0xffBDBDBD),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Remember me',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: colorDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // : const Row(
                                      //     children: [],
                                      //   ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(const ForgotPassword());
                                          // Navigator.of(context).pushNamed(forgotPass);
                                        },
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'Forgot Password?',
                                            style: GoogleFonts.lato(
                                              color: brandFive,
                                              fontSize: 14,
                                              // leadingDistribution:
                                              //     TextLeadingDistribution.even,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width - 50,
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
                                    if (loginFormKey.currentState!.validate()) {
                                      authState.signIn(
                                        context,
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                        token,
                                        deviceType,
                                        deviceModel,
                                        widget.loggedOutReason,
                                        widget.sessionStateStream,
                                        rememberMe: _rememberMe,
                                        // usernameController.text.trim(),
                                      );
                                      // emailController.clear();
                                      // passwordController.clear();
                                    }
                                  },
                                  child: Text(
                                    'Sign in',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.lato(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Didn’t get the code? ',
                                            style: GoogleFonts.lato(
                                              color: colorBlack,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            )),
                                        TextSpan(
                                          text: 'Sign up',
                                          style: GoogleFonts.lato(
                                            color: brandFive,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.to(const SignupPage());
                                              // authState.sendOTP(
                                              //   context,
                                              //   widget.email,
                                              // );
                                            },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                (currentCount != 0)
                                    ? Text(
                                        "Remaining attempts: ${5 - currentCount}",
                                        style: GoogleFonts.lato(
                                          color: Colors.red,
                                        ),
                                      )
                                    : Text(
                                        d1,
                                      ),
                              ],
                            ),
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

  noInternetConnectionScreen(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
            elevation: 0.0,
            alignment: Alignment.bottomCenter,
            insetPadding: const EdgeInsets.all(0),
            title: null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            content: SizedBox(
              height: 170.h,
              child: Container(
                width: 400.w,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Text(
                      'No internet Connection',
                      style: GoogleFonts.lato(
                          color: brandOne,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: brandOne,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 50),
                          maximumSize: const Size(400, 50),
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          // EasyLoading.dismiss();
                          setState(() => isAlertSet = false);
                          isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!isDeviceConnected && isAlertSet == false) {
                            // showDialogBox();
                            noInternetConnectionScreen(context);
                            setState(() => isAlertSet = true);
                          }
                        },
                        child: Text(
                          "Try Again",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // @override
  // void dispose() {
  //   _passwordController.dispose();
  //   _emailController.dispose();
  //   super.dispose();
  // }
}
