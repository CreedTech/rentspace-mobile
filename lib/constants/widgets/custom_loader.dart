import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rentspace/constants/colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      widthFactor: 0.4,
      child: SizedBox(
        height: 40,
        width: 40,
        child: SpinKitSpinningLines(
          color: brandTwo,
        ),
      ),
    );
  }
}
