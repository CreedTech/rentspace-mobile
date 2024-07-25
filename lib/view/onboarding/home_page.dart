// ignore_for_file: use_build_context_synchronously

//Second page
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
import 'package:rentspace/controller/wallet/wallet_controller.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:upgrader/upgrader.dart';
import '../../constants/colors.dart';
import '../dashboard/dashboard.dart';
import '../settings/settings.dart';
import '../portfolio/portfolio_page.dart';
import '../savings/savings_page.dart';

class CounterNew extends GetxController {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  final GlobalKey _six = GlobalKey();
  final GlobalKey _seven = GlobalKey();
  final GlobalKey _eight = GlobalKey();
  final GlobalKey _nine = GlobalKey();
  final GlobalKey _ten = GlobalKey();

  get fewsureHelper1 => _eight;
  get fewsureHelper2 => _nine;
  get fewsureHelper3 => _ten;
  get fewsureHelper4 => _six;
  get fewsureHelper5 => _seven;
}

//Showcase player controller

final counter = Get.put(CounterNew());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _hasOpened = false;
  final openedAppStorage = GetStorage();
  final hasReferredStorage = GetStorage();
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  late StreamSubscription subscription;
  // List<String> transIds = [];
  String fundedAmount = "0";
  // String _message = "Not Authorized";
  // int _selectedIndex = 0;
  final WalletController walletController = Get.put(WalletController());
  final RentController rentController = Get.put(RentController());

  checkIsOpenedApp() {
    print('storage opened');
    print(openedAppStorage.read('hasOpenedApp'));
    if (openedAppStorage.read('hasOpenedApp') == null) {
      openedAppStorage.write('hasOpenedApp', false);
      if ((openedAppStorage.read('hasOpenedApp') == false)) {
        setState(
          () {
            _hasOpened = true;
            openedAppStorage.write('hasOpenedApp', _hasOpened);
          },
        );
        // mustRefer();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  'Welcome Spacer!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 2.2,
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/ava_intro.png",
                          fit: BoxFit.fill,
                          height: 200.h,
                          width: 200.w,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "I'm Ava. I'm happy to see you on our platform and will help you get started on the app. Take a few moments to see the basics.",
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.pop();
                            startShowCase();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandOne,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.w, vertical: 15.h),
                            textStyle: GoogleFonts.lato(
                                color: Colors.white, fontSize: 17),
                          ),
                          child: Text(
                            "Start",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 12,
                              // letterSpacing: 0.3,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
                ),
              );
            });
      } else {
        return;
      }
    } else {
      // print(openedAppStorage.read('hasOpenedApp').toString());
    }
    //print()
  }

  startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ShowCaseWidget.of(context).startShowCase([
        counter._one,
        counter._two,
        counter._three,
        counter._four,
        counter._five,
      ]);
    });
  }

  @override
  initState() {
    super.initState();
    getConnectivity();
    setState(() {
      fundedAmount = "0";
    });
  }

  var currentIndex = 0;

  void getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && !isAlertSet) {
          noInternetConnectionScreen(context);
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  noInternetConnectionScreen(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
            elevation: 0.0,
            alignment: Alignment.bottomCenter,
            insetPadding: const EdgeInsets.all(0),
            title: null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            content: SizedBox(
              height: 170.h,
              child: Container(
                width: 400.w,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Text(
                      'No internet Connection',
                      style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(MediaQuery.of(context).size.width - 50, 50),
                          backgroundColor: brandTwo,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          // EasyLoading.dismiss();
                          setState(() => isAlertSet = false);
                          isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!isDeviceConnected && isAlertSet == false) {
                            // showDialogBox();
                            noInternetConnectionScreen(context);
                            setState(() => isAlertSet = true);
                          }
                        },
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
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showModalBottomSheet(
          barrierColor: const Color.fromRGBO(74, 74, 74, 100),
          backgroundColor: Theme.of(context).canvasColor,
          context: context,
          // barrierDismissible: true,
          builder: (BuildContext context) {
            return SizedBox(
              height: 250.h,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  color: Theme.of(context).canvasColor,
                  padding: EdgeInsets.fromLTRB(
                    10.w,
                    5.h,
                    10.w,
                    5.h,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50.h,
                      ),
                      Text(
                        'Are you sure you want to exit?',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      //card
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: ElevatedButton(
                              onPressed: () async {
                                exit(0);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 40.w,
                                  vertical: 15.h,
                                ),
                                textStyle: GoogleFonts.lato(
                                  color: brandFour,
                                  fontSize: 13,
                                ),
                              ),
                              child: Text(
                                "Yes",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: ElevatedButton(
                              onPressed: () {
                                context.pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: brandTwo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 40.w,
                                  vertical: 15.h,
                                ),
                                textStyle: GoogleFonts.lato(
                                    color: brandFour, fontSize: 13),
                              ),
                              child: Text(
                                "No",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //card
                    ],
                  ),
                ),
              ),
            );
          },
        );

        return false;
      },
      // ?TODO CHANGE UPGRADER
      child: UpgradeAlert(
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
          body: Center(
            child: _buildPage(currentIndex),
          ),
          bottomNavigationBar: Container(
            margin:
                const EdgeInsets.only(bottom: 35, top: 20, left: 20, right: 20),
            height: (MediaQuery.of(context).size.height >= 1000) ? 120 : 80,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .024,
                  vertical: 0),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  setState(
                    () {
                      currentIndex = index;
                    },
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      margin: EdgeInsets.only(
                        bottom: index == currentIndex
                            ? 0
                            : MediaQuery.of(context).size.width * .029,
                        right: MediaQuery.of(context).size.width * .0422,
                        left: MediaQuery.of(context).size.width * .0422,
                      ),
                      width: MediaQuery.of(context).size.width * .128,
                      height: index == currentIndex
                          ? MediaQuery.of(context).size.width * .014
                          : 0,
                      decoration: const BoxDecoration(
                        color: brandTwo,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                      ),
                    ),
                    Showcase(
                      key: showCaseCounter[index],
                      // titleTextStyle: GoogleFonts.lato(),
                      title: showCaseTitle[index],
                      description: showCaseDesc[index],
                      disableAnimation: false,
                      showcaseBackgroundColor: brandTwo,
                      showArrow: true,
                      textColor: Colors.white,
                      overlayPadding: const EdgeInsets.all(5),
                      animationDuration: const Duration(seconds: 2),

                      child: Image.asset(
                        index == currentIndex
                            ? listOfHomeIcons[index]
                            : listOfUnselectedHomeIcons[index],
                        width: iconSize[index],
                        height: iconSize[index],
                      ),
                    ),
                    Text(
                      navText[index],
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: index == currentIndex ? brandTwo : Colors.grey,
                        fontWeight: index == currentIndex
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * .03),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> showCaseDesc = [
    'All your dashboard in one place.',
    'Create, manange and grow your savings',
    'Build your portfolio, improve your finance health',
    'Manage your account information',
  ];

  List<String> showCaseTitle = [
    'Home',
    'Savings',
    'Portfolio',
    'Profile',
  ];
  List<String> navText = [
    'Home',
    'Savings',
    'Portfolio',
    'Profile',
  ];
  List<double> iconSize = [
    31,
    29,
    29,
    32,
  ];
  List showCaseCounter = [
    counter._one,
    counter._two,
    counter._three,
    counter._four,
  ];
  List<IconData> listOfIcons = [
    Icons.home,
    Iconsax.activity5,
    Iconsax.chart_square5,
    Icons.person,
  ];
  List<String> listOfHomeIcons = [
    'assets/icons/home_icon.png',
    'assets/icons/savings_icon_filled.png',
    'assets/icons/portfolio_filled_icon.png',
    'assets/icons/profile_filled_icon.png',
  ];
  List<IconData> listOfUnselectedIcons = [
    Icons.home,
    Iconsax.activity,
    Iconsax.chart_square,
    Icons.person_outline,
  ];
  List<String> listOfUnselectedHomeIcons = [
    'assets/icons/home_outline_icon.png',
    'assets/icons/savings_icon.png',
    'assets/icons/portfolio_icon.png',
    'assets/icons/person_icon.png',
  ];

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const Dashboard();
      case 1:
        return SavingsPage();
      case 2:
        return const PortfolioPage();
      case 3:
        return const SettingsPage();
      default:
        return const Dashboard();
    }
  }
}
