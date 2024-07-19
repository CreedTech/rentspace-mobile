import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../view/onboarding/FirstPage.dart';
import '../paint/custom_paint.dart';

Future<void> successfulReceipt(
    BuildContext context, accountName, amount, bank, subject) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: null,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          insetPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 15.h,
          ),
          alignment: Alignment.bottomCenter,
          contentPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
          content: SizedBox(
            height: 474.h,
            width: 380.h,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 21.h,
                vertical: 13.h,
              ),
              child: Column(
                children: [
                  ClipPath(
                    clipper: ZigzagClip(
                      width: 13,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: brandOne,
                      ),
                      height: 374.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 21.h,
                          vertical: 23.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Center(
                              child: Icon(
                                Icons.verified,
                                color: Colors.greenAccent,
                                size: 68,
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Text(
                              // '₦ 10,000',
                              NumberFormat.simpleCurrency(name: 'NGN')
                                  .format(amount),

                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '$subject $accountName',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              bank,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 50),
                          backgroundColor: brandOne,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              50,
                            ),
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          userController.fetchData();
                          walletController.fetchWallet();
                          rentController.fetchRent();
                          while (context.canPop()) {
                            context.pop();
                          }
                          // Navigate to the first page
                          context.go('/login');
                          // Get.to(
                          //   const FirstPage(),
                          // );
                        },
                        child: Text(
                          'Back Home',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
