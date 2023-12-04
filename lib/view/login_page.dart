import 'package:rentspace/constants/firebase_auth_constants.dart';
import 'package:rentspace/view/actions/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/icons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Multiple attempts prevention section
  final loginAttempts = GetStorage();
  final lockAttempts = GetStorage();
  int loginCount = 0;
  final d1 = "".obs();
  int currentCount = 0;
  bool isLockedOut = false;

  bool obscurity = true;
  Icon lockIcon = LockIcon().open;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
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

  void _doSomething() async {
    Timer(const Duration(seconds: 1), () {
      _btnController.stop();
    });

    authController.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //email field
    final email = TextFormField(
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
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: brandOne, width: 2.0), // Change color to yellow
        ),
        filled: true,
        fillColor: brandThree,
        hintText: 'Enter your email...',
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
//Textform field
    final password = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _passwordController,
      obscureText: obscurity,
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        suffix: InkWell(
          onTap: visibility,
          child: lockIcon,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide:BorderSide(color: brandOne, width: 2.0),
        ),
        filled: true,
        fillColor: brandThree,
        hintText: 'Enter your password...',
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/icons/RentSpace-icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login to your account',
                    style: TextStyle(
                      color: brandFour,
                      fontSize: 30,
                      fontFamily: "DefaultFontFamily",
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'Enter Email',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "DefaultFontFamily",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  email,
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Enter Password',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "DefaultFontFamily",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  password,
                  const SizedBox(
                    height: 50,
                  ),
                  RoundedLoadingButton(
                    borderRadius: 5.0,
                    elevation: 0.0,
                    successColor: brandOne,
                    color: brandOne,
                    controller: _btnController,
                    onPressed: _doSomething,
                    child: const Text(
                      'Proceed',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "DefaultFontFamily",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const ForgotPassword());
                    },
                    child: const Text(
                      "Forgot password? click here to reset",
                      style: TextStyle(
                        fontFamily: "DefaultFontFamily",
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  (currentCount != 0)
                      ? Text(
                          "Remaining attempts: ${5 - currentCount}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontFamily: "DefaultFontFamily",
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
