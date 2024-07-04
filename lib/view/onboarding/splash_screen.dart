import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/extensions.dart';
import 'package:rentspace/view/auth/registration/login_page.dart';
import 'package:rentspace/view/onboarding/onboarding_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import '../../api/global_services.dart';
import '../../widgets/common/annnotated_scaffold.dart';
import '../../widgets/custom_loader.dart';
import '../offline/no_internet_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

@override
onReady() {}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<InternetConnectionStatus> _connectivitySubscription;
  bool isInternetConnected = true;
  late bool hasSeenOnboarding = false;

  @override
  void initState() {
    checkConnectivity();
    loadHasSeenOnboarding();
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  Future<void> loadHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    });

    print("====================");
    print("Checking for new users(splash screen).....");
    print(prefs.get('hasSeenOnboarding'));
    print("====================");
  }

  void checkConnectivity() async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    final hasConnection = await InternetConnectionChecker().hasConnection;
    print(hasConnection);
    EasyLoading.dismiss();
    setState(() {
      isInternetConnected = hasConnection;
    });

    if (isInternetConnected) {
      redirectToAppropriateScreen();
    } else {
      showNoInternetScreen();
    }

    _connectivitySubscription = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      if (status == InternetConnectionStatus.connected) {
        redirectToAppropriateScreen();
      } else {
        showNoInternetScreen();
      }
    });
  }

  Future<void> redirectToAppropriateScreen() async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    await Future.delayed(const Duration(seconds: 2));
    // bool isNewUser = true;

    if (hasSeenOnboarding) {
      if (mounted) {
        if (authToken == '') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (route) => false,
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingSlider()),
          (route) => false,
        );
      }
    }
  }

  void showNoInternetScreen() {
    setState(() {
      isInternetConnected = false;
    });
  }

  void onTryAgain() {
    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        showIgnore: false,
        durationUntilAlertAgain: const Duration(seconds: 5),
        debugLogging: true,
        // debugDisplayAlways:true,
        dialogStyle: UpgradeDialogStyle.cupertino,
        showLater: false,
        canDismissDialog: false,
        showReleaseNotes: true,
      ),
      child: Scaffold(
        body: Container(
          child: isInternetConnected
              ? const SplashScreenContent()
              // WelcomeBackScreen()
              : No_internetScreen(onTap: onTryAgain),
        ),
        // ),
      ),
    );
  }
}

class SplashScreenContent extends StatefulWidget {
  const SplashScreenContent({super.key});

  @override
  State<SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<SplashScreenContent> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedScaffold(
      tint: brandOne,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff39728D),
              Color(0xff105182),
            ],
            stops: [0, 100],
          ),
        ),
        child: Center(
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
      ),
    );
  }
}
