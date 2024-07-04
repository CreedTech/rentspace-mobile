import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';

class No_internetScreen extends StatefulWidget {
  final VoidCallback onTap;

  const No_internetScreen({super.key, required this.onTap});

  @override
  State<No_internetScreen> createState() => _No_internetScreenState();
}

class _No_internetScreenState extends State<No_internetScreen> {
  bool isDeviceConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 230.h, horizontal: 25.h),
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.2)),
                        child: Padding(
                          padding: EdgeInsets.all(15.h),
                          child: Icon(
                            Iconsax.emoji_sad5,
                            size: 55,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Text(
                        'No Internet Connection',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        'Internet connection required, please connect to the the internet and try again. Thank you!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
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
                  minimumSize: Size(MediaQuery.of(context).size.width - 50, 50),
                  backgroundColor: brandTwo,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                onPressed: widget.onTap,
                child: Text(
                  "Try Again",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
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
