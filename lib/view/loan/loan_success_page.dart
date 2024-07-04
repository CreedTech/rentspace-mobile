import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class LoanSuccessPage extends StatefulWidget {
  const LoanSuccessPage({super.key});

  @override
  State<LoanSuccessPage> createState() => _LoanSuccessPageState();
}

class _LoanSuccessPageState extends State<LoanSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: () async {
      //   Navigator.of(context).pop(returningValue);

      //   return false;
      // }
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 24.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/success_glow_icon.png',
                              width: 24.h,
                              height: 24.h,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              'Success',
                              style: GoogleFonts.lato(
                                fontSize: 24,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 16.h),
                          child: Text(
                            'Your loan request has been received and the funds will be deposited into your Space Rent account within 24 hours. Glad we could help.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 50, 50),
                      backgroundColor: brandTwo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: () {
                      // for (var i = 0; i < 4; i++) {
                      //   Get.back();
                      // }
                      Get.back();
                      Get.back();
                      Get.back();
                      // Get.offAll(AvailableLoansPage());
                    },
                    child: Text(
                      'Continue',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
