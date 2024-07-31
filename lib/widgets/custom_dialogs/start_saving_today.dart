import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../view/savings/spaceRent/spacerent_creation.dart';

void startSavingToday(BuildContext context) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: null,
          scrollable: true,
          elevation: 0,
          content: SizedBox(
            // height: 220.h,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 24,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(240, 255, 238, 10),
                  ),
                  // child: const Icon(
                  //   Iconsax.security,
                  //   color: brandOne,
                  // ),
                  child: Image.asset(
                    'assets/icons/house.png',
                    width: 45,
                    height: 45,
                    // scale: 4,
                    // color: brandOne,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Start Saving Today!',
                      style: GoogleFonts.lato(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.h,
                ),
                Text(
                  'Let\'s kickstart your rent savings! Start \n now to stay ahead of your rent and earn \n interest along the way.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 29,
                ),
                Align(
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
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SpaceRentCreation(),
                        ),
                      );
                    },
                    child: Text(
                      'Create Space Rent',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
