import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_creation.dart';
// import 'package:rentspace/view/savings/spaceRent/spacerent_subscription.dart';
import 'package:rentspace/view/terms_and_conditions.dart';

import '../../dashboard/dashboard.dart';

class SpaceRentIntro extends StatefulWidget {
  const SpaceRentIntro({Key? key}) : super(key: key);

  @override
  _SpaceRentIntroState createState() => _SpaceRentIntroState();
}

class _SpaceRentIntroState extends State<SpaceRentIntro> {
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
          style: GoogleFonts.nunito(
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
                "assets/icons/savings/spacerent.png",
                height: 15,
                width: 15,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Space Rent",
              style: GoogleFonts.nunito(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Save 70% of rent for a minimum of 6 months (maximum of 8 months) and get 30% loan. (Terms and conditions apply)",
              style: GoogleFonts.nunito(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 70.h,
            ),
            // (Theme.of)
            (themeChange.isSavedDarkMode())
                ? Image.asset(
                    "assets/space_rent_intro_one.png",
                    width: MediaQuery.of(context).size.width,
                  )
                : Image.asset(
                    "assets/space_rent_intro.png",
                    width: MediaQuery.of(context).size.width,
                  ),
            const SizedBox(
              height: 70,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 50),
                  backgroundColor: brandOne,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                onPressed: () {
                  Get.to(const SpaceRentCreation());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create SpaceRent',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      // padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: brandOne,
                        // size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Get.to(const TermsAndConditions());
                },
                child: Text(
                  "By proceeding, you agree with our terms and conditions",
                  style: GoogleFonts.nunito(
                    decoration: TextDecoration.underline,
                    color: Colors.red,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
