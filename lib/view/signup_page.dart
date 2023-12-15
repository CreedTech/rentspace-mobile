import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/terms_and_conditions.dart';
import 'dart:async';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:get/get.dart';
import 'package:rentspace/constants/firebase_auth_constants.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/view/login_page.dart';
import 'package:rentspace/constants/icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

String dropdownValue = 'User';
bool isChecked = false;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Timer? timer;

  bool obscurity = true;
  Icon lockIcon = LockIcon().open;
  String enteredPin = '';
  bool isPinVisible = false;
  // ignore: prefer_typing_uninitialized_variables
  var onButtonPressed;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinOneController = TextEditingController();
  final TextEditingController _pinTwoController = TextEditingController();
  final TextEditingController _referalController = TextEditingController();
  final registerFormKey = GlobalKey<FormState>();

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Validator
    validateMail(emailValue) {
      if (emailValue == null || emailValue.isEmpty) {
        return 'Please enter an email address.';
      }
      if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
          .hasMatch(emailValue)) {
        return 'Please enter a valid email address.';
      }

      return null;
    }

    validatePhone(phoneValue) {
      if (phoneValue.isEmpty) {
        return 'phone cannot be empty';
      }
      if (phoneValue.length < 11) {
        return 'phone is invalid';
      }
      if (int.tryParse(phoneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    validateFirst(firstValue) {
      if (firstValue.isEmpty) {
        return 'first name cannot be empty';
      }

      return null;
    }

    validatePinOne(pinOneValue) {
      if (pinOneValue.isEmpty) {
        return 'pin cannot be empty';
      }
      if (pinOneValue.length < 4) {
        return 'pin is incomplete';
      }
      if (int.tryParse(pinOneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    validatePinTwo(pinTwoValue) {
      if (pinTwoValue.isEmpty) {
        return 'pin cannot be empty';
      }
      if (pinTwoValue.length < 4) {
        return 'pin is incomplete';
      }
      if (int.tryParse(pinTwoValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    validateLast(lastValue) {
      if (lastValue.isEmpty) {
        return 'last name cannot be empty';
      }

      return null;
    }

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

    //Phone number
    final phoneNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _phoneController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validatePhone,
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "Enter your Phone number",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
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
        fillColor: brandThree,
        hintText: 'e.g 080 123 456 789 ',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 20,
        color: brandOne,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: brandTwo, width: 1.0),
        borderRadius: BorderRadius.circular(5),
      ),
    );
    //Pin
    final pin_one = Pinput(
      defaultPinTheme: defaultPinTheme,
      controller: _pinOneController,
      length: 4,
      validator: validatePinOne,
      onChanged: validatePinOne,
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );
    //Pin
    final pin_two = Pinput(
      defaultPinTheme: defaultPinTheme,
      controller: _pinTwoController,
      length: 4,
      validator: validatePinTwo,
      onChanged: validatePinTwo,
      // onCompleted: _doSomething,
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );
//Address
    final referal = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _referalController,
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        // label: Text(
        //   "Referal code (Optional)",
        //   style: GoogleFonts.nunito(
        //     color: Colors.grey,
        //     fontSize: 12,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
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
        hintText: 'You and your referrer earn 1 point each',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
    );

    //firstname
    final firstname = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _firstnameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: Text(
          "Enter your First name",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
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
        hintText: 'legal first name',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateFirst,
    );
    final lastname = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _lastnameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: Text(
          "Enter Last name",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
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
        hintText: 'legal last name',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateLast,
    );
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
        label: Text(
          "Enter your email",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
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
        hintText: 'e.g mymail@inbox.com',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateMail,
    );
    //password field
    final password = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscurity,
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
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
            color: Colors.red,
            width: 2.0,
          ),
        ),
        suffix: InkWell(
          onTap: visibility,
          child: lockIcon,
        ),
        suffixIconColor: Colors.black,
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
      validator: validatePass,
    );
    //Username

    final forgotLabel = InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: const Text(
        'I have an account',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          decoration: TextDecoration.underline,
        ),
      ),
    );

    void _doSomething() async {
      Timer(const Duration(seconds: 1), () {
        _btnController.stop();
      });
      if (registerFormKey.currentState!.validate() && isChecked == true) {
        // authController.register(
        //   _emailController.text.trim(),
        //   _passwordController.text.trim(),
        //   _firstnameController.text.trim(),
        //   _lastnameController.text.trim(),
        //   _phoneController.text.trim().substring(1),
        //   _pinOneController.text.trim(),
        //   _referalController.text.trim(),
        // );
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AlertDialog.adaptive(
                    contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                    elevation: 0,
                    alignment: Alignment.bottomCenter,
                    insetPadding: const EdgeInsets.all(0),
                    scrollable: true,
                    title: null,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    content: SizedBox(
                      child: SizedBox(
                        width: 400,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        'Setup Your Transaction Pin',
                                        style: GoogleFonts.nunito(
                                          color: brandTwo,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  pin_one,
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        AlertDialog.adaptive(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .fromLTRB(30,
                                                                  30, 30, 20),
                                                          elevation: 0,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          scrollable: true,
                                                          title: null,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              topRight: Radius
                                                                  .circular(30),
                                                            ),
                                                          ),
                                                          content: SizedBox(
                                                            child: SizedBox(
                                                              width: 400,
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            40),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 15),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.topCenter,
                                                                            child:
                                                                                Text(
                                                                              'Confirm Your Transaction Pin',
                                                                              style: GoogleFonts.nunito(
                                                                                color: brandTwo,
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.w800,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        pin_two,
                                                                        const SizedBox(
                                                                          height:
                                                                              30,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 10),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(3),
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    print(_pinOneController.text.trim());
                                                                                    print(_pinTwoController.text.trim());
                                                                                    if (_pinOneController.text.trim() != _pinTwoController.text.trim()) {
                                                                                      showTopSnackBar(
                                                                                        Overlay.of(context),
                                                                                        CustomSnackBar.error(
                                                                                          // backgroundColor: brandOne,
                                                                                          message: 'Pin does not match',
                                                                                          textStyle: GoogleFonts.nunito(
                                                                                            fontSize: 14,
                                                                                            color: Colors.white,
                                                                                            fontWeight: FontWeight.w700,
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                      // Get.snackbar(
                                                                                      //   "Pin Mismatch",
                                                                                      //   'Pin does not match',
                                                                                      //   animationDuration: Duration(seconds: 1),
                                                                                      //   backgroundColor: Colors.red,
                                                                                      //   colorText: Colors.white,
                                                                                      //   snackPosition: SnackPosition.TOP,
                                                                                      // );
                                                                                    } else {
                                                                                      authController.register(
                                                                                        _emailController.text.trim(),
                                                                                        _passwordController.text.trim(),
                                                                                        _firstnameController.text.trim(),
                                                                                        _lastnameController.text.trim(),
                                                                                        _phoneController.text.trim().substring(1),
                                                                                        _pinTwoController.text.trim(),
                                                                                        _referalController.text.trim(),
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: brandTwo,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                    ),
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                                                                    textStyle: const TextStyle(color: brandFour, fontSize: 13),
                                                                                  ),
                                                                                  child: const Text(
                                                                                    "Finish",
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: brandTwo,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 60,
                                                      vertical: 15),
                                              textStyle: const TextStyle(
                                                  color: brandFour,
                                                  fontSize: 13),
                                            ),
                                            child: const Text(
                                              "Next",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            });
      } else {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: 'Please fill the form properly to proceed',
            textStyle: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        // Get.snackbar(
        //   "Invalid",
        //   'Please fill the form properly to proceed',
        //   animationDuration: const Duration(seconds: 1),
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: const Color(0xffE0E0E0),
        backgroundColor: Colors.white,
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
          'Sign up',
          style: TextStyle(
            color: Color(0xff4E4B4B),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Form(
                key: registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            'First Name',
                            style: GoogleFonts.nunito(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                        ),
                        firstname,
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            'Last Name',
                            style: GoogleFonts.nunito(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                        ),
                        lastname,
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            'Email Address',
                            style: GoogleFonts.nunito(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                        ),
                        email,
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            'Phone Number',
                            style: GoogleFonts.nunito(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                        ),
                        phoneNumber,
                      ],
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            'Password',
                            style: GoogleFonts.nunito(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                        ),
                        password,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            'Referral Code(Optional)',
                            style: GoogleFonts.nunito(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                        ),
                        referal,
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       const Text(
                    //         'Create transaction pin',
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontFamily: "DefaultFontFamily",
                    //         ),
                    //       ),
                    //       pin_one,
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Container(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       const Text(
                    //         'Confirm transaction pin',
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontFamily: "DefaultFontFamily",
                    //         ),
                    //       ),
                    //       pin_two,
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 30.0,
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.height / 80,
                        MediaQuery.of(context).size.height / 600,
                        MediaQuery.of(context).size.height / 80,
                        MediaQuery.of(context).size.height / 500,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox.adaptive(
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            overlayColor: MaterialStateColor.resolveWith(
                              (states) => brandTwo,
                            ),
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return brandTwo;
                              }
                              return const Color(0xffF2F2F2);
                            }),
                            focusColor: MaterialStateColor.resolveWith(
                              (states) => brandTwo,
                            ),
                            activeColor: MaterialStateColor.resolveWith(
                              (states) => brandTwo,
                            ),
                            side: const BorderSide(
                              color: Color(0xffBDBDBD),
                            ),
                          ),
                          // const SizedBox(
                          //   width: 10.0,
                          // ),
                          Text(
                            'You agree to our ',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.black,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(const TermsAndConditions());
                            },
                            child: Text(
                              'Terms of service',
                              style: GoogleFonts.nunito(
                                color: brandFive,
                                // fontFamily: "DefaultFontFamily",
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RoundedLoadingButton(
                      elevation: 0.0,
                      borderRadius: 5.0,
                      successColor: brandTwo,
                      color: brandTwo,
                      controller: _btnController,
                      onPressed: _doSomething,
                      // () {
                      // if (validateFirst(_firstnameController.text.trim()) ==
                      //         "" &&
                      //     validateLast(_lastnameController.text.trim()) == "" &&
                      //     validatePhone(_phoneController.text.trim()) == "" &&
                      //     validatePass(_passwordController.text.trim()) == "" &&
                      //     validateMail(_emailController.text.trim()) == "" &&
                      //     validatePinOne(_pinOneController.text.trim()) == "" &&
                      //     validatePinTwo(_pinOneController.text.trim()) == "" &&
                      //     (_pinOneController.text.trim() ==
                      //         _pinTwoController.text.trim())) {
                      //   _doSomething();
                      // } else {
                      //   Timer(const Duration(seconds: 1), () {
                      //     _btnController.stop();
                      //   });
                      //   Get.snackbar(
                      //     "Invalid",
                      //     'Please fill the form properly to proceed',
                      //     animationDuration: const Duration(seconds: 1),
                      //     backgroundColor: Colors.red,
                      //     colorText: Colors.white,
                      //     snackPosition: SnackPosition.BOTTOM,
                      //   );
                      // }
                      // _doSomething();
                      // },
                      child: const Text(
                        'Create account',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "DefaultFontFamily",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
