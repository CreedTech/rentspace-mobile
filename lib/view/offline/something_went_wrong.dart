import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class SomethingWentWrong extends StatefulWidget {
  final VoidCallback onTap;
  const SomethingWentWrong({super.key, required this.onTap});

  @override
  State<SomethingWentWrong> createState() => _SomethingWentWrongState();
}

class _SomethingWentWrongState extends State<SomethingWentWrong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 230.h, horizontal: 25.h),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2)),
                          child: Padding(
                            padding: EdgeInsets.all(15.h),
                            child: Icon(
                              Iconsax.emoji_sad,
                              size: 55.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Center(
                        child: Text(
                          'Something Went Wrong',
                          style: GoogleFonts.nunito(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        '- Please check your connection and try again',
                        // textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '- Confirm that your celluar data or Wi-Fi is on',
                        // textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '- Confirm that your Rentspace App is given network access',
                        // textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 50),
                  maximumSize: const Size(400, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                onPressed: widget.onTap,
                child: Text(
                  "Retry",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
