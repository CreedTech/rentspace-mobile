import 'package:connectivity_plus/connectivity_plus.dart';
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
    if (savedDeviceType != null && savedDeviceModel != null && fcmToken != '') {
      setState(() {
        deviceType = savedDeviceType;
        deviceModel = savedDeviceModel;
        token = fcmToken;
      });
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
    final isConnected = ref.watch(internetConnectionProvider).isConnected;
    //email field
    final email = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: GoogleFonts.poppins(
          color: Theme.of(context).primaryColor, fontSize: 14.sp),
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
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12.sp,
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
      style: GoogleFonts.poppins(
          color: Theme.of(context).primaryColor, fontSize: 14.sp),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        suffix: InkWell(
          onTap: visibility,
          child: lockIcon,
        ),
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
        hintText: 'Enter your password',
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12.sp,
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
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          // backgroundColor: const Color(0xffE0E0E0),
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,

          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.loggedOutReason != "")
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              widget.loggedOutReason,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Welcome Back👋!!!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            // fontFamily: "DefaultFontFamily",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: Text(
                            'Reconnect with your dreams and aspirations as we embrace the next chapter of your journey together.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: const Color(0xff828282),
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 51.h,
                    ),
                    Form(
                      key: loginFormKey,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Enter Email',
                                  style: GoogleFonts.poppins(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              email,
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Enter Password',
                                  style: GoogleFonts.poppins(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    // fontFamily: "DefaultFontFamily",
                                  ),
                                ),
                              ),
                              password,
                            ],
                          ),
                          SizedBox(
                            height: 28.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // (_rememberMe == false)
                              //     ?
                              Row(
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
                                                (Set<MaterialState> states) {
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
                                      style: GoogleFonts.poppins(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xff828282),
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
                                    style: GoogleFonts.poppins(
                                      color: brandFive,
                                      fontSize: 10.sp,
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
                    SizedBox(
                      height: 50.h,
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
                                minimumSize: Size(300.w, 50.h),
                                backgroundColor: brandOne,
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
                                'Proceed',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(const SignupPage());
                            },
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.poppins(
                                color: brandFive,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (currentCount != 0)
                        ? Text(
                            "Remaining attempts: ${5 - currentCount}",
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                            ),
                          )
                        : Text(
                            d1,
                          ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
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
            contentPadding: EdgeInsets.fromLTRB(30.sp, 30.sp, 30.sp, 20.sp),
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
                      style: GoogleFonts.poppins(
                          color: brandOne,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: brandOne,
                          fontSize: 12.sp,
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
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12.sp,
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
