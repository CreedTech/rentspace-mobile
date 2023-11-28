import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentspace/constants/colors.dart';

class ConfirmResetPage extends StatefulWidget {
  const ConfirmResetPage({Key? key}) : super(key: key);

  @override
  State<ConfirmResetPage> createState() => _ConfirmResetPageState();
}

class _ConfirmResetPageState extends State<ConfirmResetPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(
                Icons.mail,
                size: 100,
                color: brandTwo,
              ),
            ),
            Text(
              "Check your email",
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: "DefaultFontFamily",
                letterSpacing: 4.0,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "A password reset link has been sent to your email",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "DefaultFontFamily",
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
