import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
// import 'package:swift/router/route_constants.dart';

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
     
      child: Column(
        children: [
          Container(
             padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: brandTwo.withOpacity(0.2),
        borderRadius: BorderRadius.circular(100),
        
      ),
            child: Icon(
              // Iconsax.wifi_square5,
              icon,
              color: iconColor,
              size: 25.h,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(IconsName,
              style: GoogleFonts.nunito(
                  color: brandOne,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800))
        ],
      ),
    );
  }
}
