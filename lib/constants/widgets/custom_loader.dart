import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rentspace/constants/colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      widthFactor: 0.2,
      child: SizedBox(
        height: 30.h,
        width: 30.w,
        child: const SpinKitSpinningLines(
          color: brandTwo,
        ),
      ),
    );
  }
}
