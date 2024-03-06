import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:io';

import '../../controller/auth/user_controller.dart';

class IdlePage extends StatefulWidget {
  const IdlePage({Key? key}) : super(key: key);

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
    final defaultPinTheme = PinTheme(
      width: 30,
      height: 30,
      textStyle: GoogleFonts.nunito(
        fontSize: 20,
        color: Theme.of(context).primaryColor,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
    );

    //Pin
    final pinInput = Pinput(
      defaultPinTheme: defaultPinTheme,
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
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 100,
              width: 90,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/idle.gif"),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
              child: Text(
                "Enter your transaction PIN to return to RentSpace App",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "DefaultFontFamily",
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            pinInput,
            SizedBox(
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
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
