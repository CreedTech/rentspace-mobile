import 'package:flutter/services.dart';
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

String dropdownValue = 'User';
bool isChecked = false;

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Timer? timer;

  bool obscurity = true;
  Icon lockIcon = LockIcon().open;
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

  void _doSomething() async {
    Timer(Duration(seconds: 1), () {
      _btnController.stop();
    });
    if ((_emailController.text.trim() != "") &&
        (_passwordController.text.trim() != "") &&
        (_firstnameController.text.trim() != "") &&
        (_lastnameController.text.trim() != "") &&
        (_phoneController.text.trim() != "") &&
        (_pinOneController.text.trim() != "") &&
        (_pinTwoController.text.trim() != "") &&
        (_pinOneController.text.trim() == _pinTwoController.text.trim()) &&
        (isChecked != false)) {
      authController.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _firstnameController.text.trim(),
        _lastnameController.text.trim(),
        _phoneController.text.trim().substring(1),
        _pinOneController.text.trim(),
        _referalController.text.trim(),
      );
    } else {
      Get.snackbar(
        "Invalid",
        'Please fill the form properly to proceed',
        animationDuration: Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

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
      if (emailValue.isEmpty) {
        return 'email cannot be empty';
      }
      if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
          .hasMatch(emailValue)) {
        return 'Please enter a valid email';
      }

      return '';
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
      return '';
    }

    validateFirst(firstValue) {
      if (firstValue.isEmpty) {
        return 'first name cannot be empty';
      }

      return '';
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
      return '';
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
      return '';
    }

    validateLast(lastValue) {
      if (lastValue.isEmpty) {
        return 'last name cannot be empty';
      }

      return '';
    }

    validatePass(passValue) {
      bool hasUpper = passValue.contains(RegExp(r'[A-Z]'));
      bool hasLower = passValue.contains(RegExp(r'[a-z]'));
      bool hasDigits = passValue.contains(RegExp(r'[0-9]'));
      bool hasSpecial = passValue.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      if (passValue.isEmpty) {
        return 'password cannot be empty';
      }

      if (passValue.length < 8) {
        return 'password too short, min 8 characters';
      }
      if (!hasUpper) {
        return 'password must include uppercase';
      }
      if (!hasSpecial) {
        return 'password must include special character';
      }
      if (!hasDigits) {
        return 'password must include number';
      }
      if (!hasLower) {
        return 'password must include lowercase';
      }

      return '';
    }

    //Phone number
    final phoneNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _phoneController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validatePhone,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "Phone number",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        filled: true,
        fillColor: brandThree,
        hintText: 'e.g 080 123 456 789 ',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
    final defaultPinTheme = PinTheme(
      width: 30,
      height: 30,
      textStyle: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: brandOne, width: 2.0),
        borderRadius: BorderRadius.circular(10),
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
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );
//Address
    final referal = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _referalController,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: Text(
          "Referal code (Optional)",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        filled: true,
        fillColor: brandThree,
        hintText: 'you and your referrer earn 1 point each',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );

    //firstname
    final firstname = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _firstnameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateFirst,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: Text(
          "First name",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: brandOne, width: 2.0), // Change color to yellow
        ),
        filled: true,
        fillColor: brandThree,
        hintText: 'legal first name',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
    final lastname = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _lastnameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateLast,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: Text(
          "Last name",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        filled: true,
        fillColor: brandThree,
        hintText: 'legal last name',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
    //email field
    final email = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      style: TextStyle(
        color: Colors.black,
      ),
      controller: _emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateMail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        label: Text(
          "E-mail",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        filled: true,
        fillColor: brandThree,
        hintText: 'e.g mymail@inbox.com',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
    //password field
    final password = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validatePass,
      obscureText: obscurity,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: Text(
          "Password",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        suffix: InkWell(
          onTap: visibility,
          child: lockIcon,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        suffixIconColor: Colors.black,
        filled: true,
        fillColor: brandThree,
      ),
    );
    //Username

    final forgotLabel = InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Text(
        'I have an account',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          decoration: TextDecoration.underline,
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
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Sign Up',
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
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'First name',
                    style: TextStyle(
                      fontFamily: "DefaultFontFamily",
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  firstname,
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Last name',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "DefaultFontFamily",
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  lastname,
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Email address',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "DefaultFontFamily",
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  email,
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Phone number',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "DefaultFontFamily",
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  phoneNumber,
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "DefaultFontFamily",
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  password,
                  Text(
                    'Password -8 Characters, One Uppercase, One Lowercase, One Special Characters (#%&*?@)',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "DefaultFontFamily",
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Referal code (optional)',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "DefaultFontFamily",
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  referal,
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create transaction pin',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "DefaultFontFamily",
                          ),
                        ),
                        pin_one,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Confirm transaction pin',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "DefaultFontFamily",
                          ),
                        ),
                        pin_two,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.height / 80,
                      MediaQuery.of(context).size.height / 300,
                      MediaQuery.of(context).size.height / 80,
                      MediaQuery.of(context).size.height / 300,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GFCheckbox(
                          size: GFSize.SMALL,
                          activeIcon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          activeBgColor: brandOne,
                          inactiveBorderColor: brandOne,
                          activeBorderColor: brandOne,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value;
                            });
                            print(value);
                          },
                          value: isChecked,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'You agree to our ',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 60,
                            color: Colors.black,
                            fontFamily: "DefaultFontFamily",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(TermsAndConditions());
                          },
                          child: Text(
                            'Terms of service',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: "DefaultFontFamily",
                              fontSize: MediaQuery.of(context).size.height / 60,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RoundedLoadingButton(
                    child: Text(
                      'Create account',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "DefaultFontFamily",
                      ),
                    ),
                    elevation: 0.0,
                    borderRadius: 5.0,
                    successColor: brandOne,
                    color: brandOne,
                    controller: _btnController,
                    onPressed: () {
                      if (validateFirst(_firstnameController.text.trim()) ==
                              "" &&
                          validateLast(_lastnameController.text.trim()) == "" &&
                          validatePhone(_phoneController.text.trim()) == "" &&
                          validatePass(_passwordController.text.trim()) == "" &&
                          validateMail(_emailController.text.trim()) == "" &&
                          validatePinOne(_pinOneController.text.trim()) == "" &&
                          validatePinTwo(_pinOneController.text.trim()) == "" &&
                          (_pinOneController.text.trim() ==
                              _pinTwoController.text.trim())) {
                        _doSomething();
                      } else {
                        Timer(Duration(seconds: 1), () {
                          _btnController.stop();
                        });
                        Get.snackbar(
                          "Invalid",
                          'Please fill the form properly to proceed',
                          animationDuration: Duration(seconds: 1),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
