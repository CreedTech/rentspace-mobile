import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/savings/spaceDeposit/space_deposit_name_page.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_subscription.dart';

import '../../dashboard/dashboard.dart';

class SpaceDepositIntro extends StatefulWidget {
  const SpaceDepositIntro({super.key});

  @override
  _SpaceDepositIntroState createState() => _SpaceDepositIntroState();
}

class _SpaceDepositIntroState extends State<SpaceDepositIntro> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          'Create Savings Plans',
          style: GoogleFonts.lato(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.close,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: brandOne,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(
                "assets/deposit_bg_white.png",
                height: 15,
                width: 15,
              ),
            ),
            // Image.asset(
            //   "assets/icons/savings/spacedeposit.png",
            // ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Space Deposit",
              style: GoogleFonts.lato(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Save 70% of rent for a minimum of 90 days at an interest of 14% and get 100% (Terms and conditions apply).",
              style: GoogleFonts.lato(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 70.h,
            ),
            // (themeChange.isSavedDarkMode())
            //     ? Center(
            //         child: Image.asset(
            //           "assets/deposit_bg_dark.png",
            //           width: MediaQuery.of(context).size.width / 1.5,
            //         ),
            //       )
            //     : Center(
            //         child: Image.asset(
            //           "assets/deposit_bg_white.png",
            //           width: MediaQuery.of(context).size.width / 1.5,
            //         ),
            //       ),

            SizedBox(
              height: 85.h,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(350, 50),
                  backgroundColor: brandOne,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                onPressed: () {
                  Get.to(const SpaceDepositNamePage());
                },
                child: Text(
                  'Create new Space Deposit',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // GFButton(
            //   onPressed: () {
            //     Get.to(const SpaceDepositSubscription());
            //   },
            //   icon: const Icon(
            //     Icons.add_circle_outline_outlined,
            //     size: 30,
            //     color: Colors.white,
            //   ),
            //   color: brandOne,
            //   text: "Create new SpaceDeposit",
            //   shape: GFButtonShape.square,
            //   fullWidthButton: true,
            // ),
          ],
        ),
      ),
    );
  }
}
