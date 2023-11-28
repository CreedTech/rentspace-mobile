import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'package:rentspace/constants/icons.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';

class ForgotPin extends StatefulWidget {
  String password, pin;
  ForgotPin({Key? key, required this.password, required this.pin})
      : super(key: key);

  @override
  _ForgotPinState createState() => _ForgotPinState();
}

class _ForgotPinState extends State<ForgotPin> {
  final TextEditingController _pinOneController = TextEditingController();
  final TextEditingController _pinTwoController = TextEditingController();
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

  Future updatePin() async {
    var userPinUpdate = FirebaseFirestore.instance.collection('accounts');
    await userPinUpdate.doc(userId).update({
      'transaction_pin': _pinOneController.text.trim(),
    }).then((value) {
      Get.back();
      Get.snackbar(
        "PIN updated!",
        'Your transaction PIN has been updated successfully',
        animationDuration: Duration(seconds: 1),
        backgroundColor: brandOne,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }).catchError((error) {
      Get.snackbar(
        "Oops",
        "something went wrong, please try again",
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  void _doSomething() async {
    Timer(Duration(seconds: 1), () {
      _btnController.stop();
    });
    if (_pinOneController.text.trim() == "" ||
        _pinTwoController.text.trim() == "" ||
        (_pinOneController.text.trim() != _pinTwoController.text.trim())) {
      Get.snackbar(
        "Invalid",
        'PIN is unacceptable.',
        animationDuration: Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    if (_pinOneController.text.trim() == widget.pin ||
        _pinTwoController.text.trim() == widget.pin) {
      Get.snackbar(
        "Error!",
        'PIN cannot be the same as existing one.',
        animationDuration: Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else if (widget.password != _passwordController.text.trim() ||
        _passwordController.text.trim() == "") {
      Get.snackbar(
        "Invalid",
        'Password is incorrect',
        animationDuration: Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      updatePin();
    }
  }

  bool obscurity = true;
  Icon lockIcon = LockIcon().open;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 30,
      height: 30,
      textStyle: TextStyle(
        fontSize: 20,
        color: Theme.of(context).primaryColor,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: brandOne, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
    );
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

    //Pin
    final pin_one = Pinput(
      defaultPinTheme: defaultPinTheme,
      validator: validatePinOne,
      onChanged: validatePinOne,
      controller: _pinOneController,
      length: 4,
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );
    //Pin
    final pin_two = Pinput(
      defaultPinTheme: defaultPinTheme,
      controller: _pinTwoController,
      validator: validatePinTwo,
      onChanged: validatePinTwo,
      length: 4,
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );
    //Textform field
    final password = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _passwordController,
      obscureText: obscurity,
      style: TextStyle(
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
        hintText: 'Enter your password...',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Reset PIN',
          style: TextStyle(
            fontFamily: "DefaultFontFamily",
            color: Theme.of(context).primaryColor,
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
          ListView(
            children: [
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'New transaction pin',
                            style: TextStyle(
                              fontFamily: "DefaultFontFamily",
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
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
                              fontWeight: FontWeight.bold,
                              fontFamily: "DefaultFontFamily",
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          pin_two,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    password,
                    SizedBox(
                      height: 50,
                    ),
                    RoundedLoadingButton(
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "DefaultFontFamily",
                        ),
                      ),
                      elevation: 0.0,
                      successColor: brandOne,
                      color: brandOne,
                      controller: _btnController,
                      onPressed: () {
                        if (validatePinOne(
                                    _pinOneController.text.trim()) ==
                                "" &&
                            validatePinTwo(_pinOneController.text.trim()) ==
                                "" &&
                            (_pinOneController.text.trim() ==
                                _pinTwoController.text.trim())) {
                          _doSomething();
                        } else {
                          Timer(Duration(seconds: 1), () {
                            _btnController.stop();
                          });
                          Get.snackbar(
                            "Invalid pin!",
                            'Make sure the pins you entered are the same',
                            animationDuration: Duration(seconds: 1),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
