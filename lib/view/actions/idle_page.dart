import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:io';

import '../../constants/colors.dart';
import '../../controller/auth/user_controller.dart';

class IdlePage extends StatefulWidget {
  const IdlePage({super.key});

  @override
  _IdlePageState createState() => _IdlePageState();
}

final TextEditingController _pinController = TextEditingController();

class _IdlePageState extends State<IdlePage> {
  final UserController userController = Get.find();

  @override
  initState() {
    super.initState();
    setState(() {
      _pinController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    //validation function
    validatePin(pinOneValue) {
      if (pinOneValue.isEmpty) {
        return 'pin cannot be empty';
      }
      if (pinOneValue.length < 4) {
        return 'pin is incomplete';
      }

      if (BCrypt.checkpw(
            int.tryParse(pinOneValue).toString(),
            userController.userModel!.userDetails![0].wallet.pin,
          ) ==
          false) {
        return 'incorrect PIN';
      }
      if (int.tryParse(pinOneValue) == null) {
        return 'enter valid number';
      }
      return '';
    }

    //pin theme


    //Pin
    final pinInput = Pinput(
      useNativeKeyboard: false,
      defaultPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: TextStyle(
          fontSize: 25.sp,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: TextStyle(
          fontSize: 25.sp,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandOne, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      submittedPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: TextStyle(
          fontSize: 25.sp,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandOne, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      followingPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: TextStyle(
          fontSize: 25.sp,
          color: brandOne,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: brandTwo, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      controller: _pinController,
      length: 4,
      validator: validatePin,
      onChanged: validatePin,
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );

    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 100,
              width: 90,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/idle.gif"),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
              child: Text(
                "Enter your transaction PIN to return to RentSpace App",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            pinInput,
            const SizedBox(
              height: 50,
            ),
            GFButton(
              onPressed: () {
                if (validatePin(_pinController.text.trim()) == "") {
                  Get.back();
                } else {
                  null;
                }
              },
              text: "   Return to App    ",
              shape: GFButtonShape.pills,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
