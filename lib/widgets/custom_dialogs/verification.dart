
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../view/auth/registration/login_page.dart';

void verification(BuildContext context, String message, String subText,
    String redirectText) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.primary,
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
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.primary,
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
                      FocusScope.of(context).unfocus();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(
                            ),
                          ),
                          (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandFive,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    child: Text(
                      redirectText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
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
