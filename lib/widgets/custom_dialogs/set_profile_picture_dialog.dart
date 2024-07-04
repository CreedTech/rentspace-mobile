import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

void setProfilePictuteDialog(BuildContext context, dynamic onTap) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        elevation: 0.h,
        alignment: Alignment.bottomCenter,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.h),
            topRight: Radius.circular(30.h),
          ),
        ),
        insetPadding: const EdgeInsets.all(0),
        title: null,
        content: SizedBox(
          height: 200.h,
          width: 400.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 70,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: brandThree,
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              GestureDetector(
                onTap: () => onTap,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: brandOne),
                  child: Image.asset(
                    'assets/icons/RentSpace-icon2.png',
                    width: 80,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onTap,
                child: Center(
                  child: Text(
                    'Tap to Change',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              //  SizedBox(
              //   height: 10,
              // ),
            ],
          ),
        ),
      );
    },
  );
}
