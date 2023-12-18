import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/extensions.dart';

import '../constants/widgets/common/annnotated_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

@override
onReady() {}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedScaffold(
      tint: brandOne,
      body: Center(
          child: Lottie.asset(
        'assets/splash.json',
        width: context.dx(240.0),
      )
          // .image(width: context.dx(240.0))
          // .animate(delay: 512.milliseconds)
          // .scale(
          //   begin: const Offset(0.512, 0.512),
          //   duration: 1024.milliseconds,
          //   curve: Curves.bounceOut,
          // )
          // .callback(
          //   callback: (_) => context.goNamed(
          //     authState.accessToken.isEmpty ||
          //             authState.currentUser.firstName.isEmpty
          //         ? '$OnboardingScreen'
          //         : '$DashboardScreen',
          //   ),
          // ),
          ),
    );
  }
}
