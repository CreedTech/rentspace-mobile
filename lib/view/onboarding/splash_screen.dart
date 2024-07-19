import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:upgrader/upgrader.dart';

import '../../api/global_services.dart';
import '../../widgets/common/annnotated_scaffold.dart';
import '../../widgets/custom_loader.dart';
import '../offline/no_internet_screen.dart';

bool _initialURILinkHandled = false;

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
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  StreamSubscription? _streamSubscription;
  StreamSubscription? _sub;
  late StreamSubscription<InternetConnectionStatus> _connectivitySubscription;
  bool isInternetConnected = true;
  late bool hasSeenOnboarding = false;

  @override
  void initState() {
    // initUniLinks();
    checkConnectivity();
    loadHasSeenOnboarding();
    super.initState();
    // _initURIHandler();
    // _incomingLinkHandler();
  }

  @override
  void dispose() {
    // if (_sub != null) _sub!.cancel();
    _streamSubscription?.cancel();
    _connectivitySubscription.cancel();

    super.dispose();
  }

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      Fluttertoast.showToast(
          msg: "Invoked _initURIHandler",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white);
      try {
        final initialURI = await getInitialUri();
        // Use the initialURI and warn the user if it is not correct,
        // but keep in mind it could be `null`.
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
          });
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        // Platform messages may fail, so we use a try/catch PlatformException.
        // Handle exception by warning the user their action did not succeed
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  /// Handle incoming links - the ones that the app will receive from the OS
  /// while already started.
  void _incomingLinkHandler() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');
        setState(() {
          _currentURI = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  Future<void> initUniLinks() async {
    try {
      _sub = getUriLinksStream().listen(
          (Uri uri) {
            if (!mounted) return;
            setState(() {
              // Handle the deep link URI here
              // Example: parse URI and navigate to a specific screen
              print('Received URI: $uri');
            });
          } as void Function(Uri? event)?, onError: (err) {
        print('Error receiving URI: $err');
      });

      // Get the initial deep link on app start
      Uri? initialUri = await getInitialUri();
      if (initialUri != null) {
        print('Initial URI: $initialUri');
        // Handle the initial deep link URI here if needed
      }
    } on PlatformException {
      print('Error initializing UniLinks');
    }
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
          context.replace('/login');
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const LoginPage(),
          //   ),
          //   (route) => false,
          // );
        } else {
          context.replace('/login');
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const LoginPage(),
          //   ),
          //   (route) => false,
          // );
        }
      }
    } else {
      if (mounted) {
        context.replace('/onboardingSlider');
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => const OnboardingSlider()),
        //   (route) => false,
        // );
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
