import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
            const Icon(
              Icons.mail,
              size: 100,
              color: brandTwo,
            ),
            Text(
              "Check your email",
              style: GoogleFonts.nunito(
                fontSize: 20.0,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "A password reset link has been sent to your email",
              style: GoogleFonts.nunito(
                fontSize: 14.0,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
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
