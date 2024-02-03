import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/login_page.dart';

void verification(BuildContext context, String message, String subText,
    String redirectText) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: null,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: SizedBox(
            height: 300,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/mail_sent.png',
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    message,
                    style: GoogleFonts.nunito(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    subText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      // letterSpacing: 0.3,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.offUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandFive,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    child: Text(
                      redirectText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                        // letterSpacing: 0.3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            )),
          ),
        );
      });
}

void errorDialog(BuildContext context, String message, String subText) {
  Get.bottomSheet(
    isDismissible: false,
    SizedBox(
      height: 300,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Container(
          color: Theme.of(context).canvasColor,
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      // color: Colors
                      //     .red,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Iconsax.close_circle,
                        color: brandOne,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/error.png',
                width: 80,
                color: Colors.red,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                message,
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  // fontFamily:
                  //     "DefaultFontFamily",
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Text(
                subText,
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  // fontFamily:
                  //     "DefaultFontFamily",
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void customErrorDialog(
    BuildContext context, String message, String subText) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: null,
          elevation: 0,
          content: SizedBox(
            height: 250,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        // color: brandOne,
                      ),
                      child: Icon(
                        Iconsax.close_circle,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Iconsax.warning_24,
                    color: Colors.red,
                    size: 75,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  message,
                  style: GoogleFonts.nunito(
                    color: Colors.red,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  subText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: Colors.red,
                    fontSize: 14.sp,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      });
}
