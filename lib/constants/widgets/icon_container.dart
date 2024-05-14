import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';

class IconsContainer extends StatelessWidget {
  final String IconsName;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const IconsContainer(
      {super.key,
      required this.IconsName,
      required this.icon,
      required this.iconColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              // Iconsax.wifi_square5,
              icon,
              color: iconColor,
              size: 24.h,
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              IconsName,
              style: GoogleFonts.lato(
                color: colorBlack,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
