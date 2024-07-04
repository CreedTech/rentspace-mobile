import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../view/auth/registration/login_page.dart';

Future<dynamic> multipleLoginRedirectModal() {
  return Get.dialog(
    barrierDismissible: true,
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        color: Theme.of(Get.context!).colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Multiple Device Login Attempt",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          color: Theme.of(Get.context!).colorScheme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Your Rentspace Account has been logged in on another device. Multiple Device login may lead to theft.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Theme.of(Get.context!).colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  //Buttons
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFFFFFFFF),
                      minimumSize: const Size(0, 45),
                      backgroundColor: brandTwo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Get.offAll(
                          const LoginPage());
                    },
                    child: Text(
                      'Re Login',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
