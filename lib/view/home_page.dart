// ignore_for_file: use_build_context_synchronously

//Second page
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rentspace/controller/wallet_controller.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:upgrader/upgrader.dart';
import '../constants/colors.dart';
import 'dashboard/dashboard.dart';
import 'dashboard/settings.dart';
import 'portfolio/portfolio_page.dart';
import 'savings/savings_page.dart';

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
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _hasOpened = false;
  final openedAppStorage = GetStorage();
  final hasReferredStorage = GetStorage();
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  late StreamSubscription subscription;
  // List<String> transIds = [];
  String fundedAmount = "0";
  String _message = "Not Authorized";
  int _selectedIndex = 0;
  final WalletController walletController = Get.put(WalletController());
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // checkStatus() {
  //   final FirebaseFirestore firestoreFile = FirebaseFirestore.instance;
  //   DocumentReference docReference =
  //       firestoreFile.collection('maintenance').doc('27-09-2023-maintenance');

  //   docReference.snapshots().listen((snapshot) {
  //     var data = snapshot.data() as Map<String, dynamic>?;
  //     var newStatus = data?['status'];

  //     if (newStatus != "active") {
  //       Get.to(const InActivePage());
  //     } else {
  //       print("All good!!!");
  //     }
  //   });
  // }

  checkIsOpenedApp() {
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
                title: Text(
                  'Welcome Spacer!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    color: brandOne,
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
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: brandOne,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
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
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                          child: Text(
                            "Start",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12.sp,
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
      print(openedAppStorage.read('hasOpenedApp').toString());
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
        /* counter._six,
        counter._seven,
        counter._eight, */
      ]);
    });
  }

  @override
  initState() {
    super.initState();
    // transIds.clear();
    // checkStatus();
    getConnectivity();
    setState(() {
      fundedAmount = "0";
    });
    Future.delayed(const Duration(seconds: 1), () {
      checkIsOpenedApp();
    });
  }

  // Future<bool> checkingForBioMetrics() async {
  //   bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
  //   print(canCheckBiometrics);
  //   _authenticateMe();
  //   return canCheckBiometrics;
  // }

  // Future<void> _authenticateMe() async {
  //   bool authenticated = false;
  //   try {
  //     authenticated = await _localAuthentication.authenticate(
  //       localizedReason: "Authentication required",
  //     );
  //     setState(() {
  //       _message = authenticated ? "Authorized" : "Not Authorized";
  //     });
  //     if (_message == "Authorized") {
  //       Get.to(const HomePage());
  //     } else {
  //       showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10.sp),
  //               ),
  //               title: null,
  //               elevation: 0,
  //               content: SizedBox(
  //                 height: 250.h,
  //                 child: Column(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: Align(
  //                         alignment: Alignment.topRight,
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(30.sp),
  //                             // color: brandOne,
  //                           ),
  //                           child: Icon(
  //                             Iconsax.close_circle,
  //                             color: Theme.of(context).primaryColor,
  //                             size: 30.sp,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Align(
  //                       alignment: Alignment.center,
  //                       child: Icon(
  //                         Iconsax.warning_24,
  //                         color: Colors.red,
  //                         size: 75.sp,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 12.sp,
  //                     ),
  //                     Text(
  //                       'Error',
  //                       style: GoogleFonts.poppins(
  //                         color: Colors.red,
  //                         fontSize: 28.sp,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 5.h,
  //                     ),
  //                     Text(
  //                       "Biometrics failed",
  //                       textAlign: TextAlign.center,
  //                       style: GoogleFonts.poppins(
  //                           color: Colors.red, fontSize: 18.sp),
  //                     ),
  //                     SizedBox(
  //                       height: 10.h,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           });
  //     }
  //   } catch (e) {
  //     showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10.sp),
  //             ),
  //             title: null,
  //             elevation: 0,
  //             content: SizedBox(
  //               height: 250.h,
  //               child: Column(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Align(
  //                       alignment: Alignment.topRight,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(30.sp),
  //                           // color: brandOne,
  //                         ),
  //                         child: Icon(
  //                           Iconsax.close_circle,
  //                           color: Theme.of(context).primaryColor,
  //                           size: 30.sp,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Align(
  //                     alignment: Alignment.center,
  //                     child: Icon(
  //                       Iconsax.warning_24,
  //                       color: Colors.red,
  //                       size: 75.sp,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 12.h,
  //                   ),
  //                   Text(
  //                     'Error',
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.red,
  //                       fontSize: 28.sp,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 5.h,
  //                   ),
  //                   Text(
  //                     "Biometrics failed",
  //                     textAlign: TextAlign.center,
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.red,
  //                       fontSize: 18.sp,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 10.h,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         });
  //   }
  //   if (!mounted) return;
  // }

  var currentIndex = 0;

  void _onItemTapped(String index) {
    setState(() {
      currentIndex = int.parse(index);
    });
  }

  void getConnectivity() {
    print('checking internet...');
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
            contentPadding: EdgeInsets.fromLTRB(30.sp, 30.sp, 30.sp, 20.sp),
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
                      style: GoogleFonts.poppins(
                          color: brandOne,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: brandOne,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Align(
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
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12.sp,
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
        Get.bottomSheet(
          SizedBox(
            height: 250.h,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0.sp),
                topRight: Radius.circular(30.0.sp),
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
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        // fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
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
                          padding: EdgeInsets.all(3.sp),
                          child: ElevatedButton(
                            onPressed: () async {
                              exit(0);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.sp),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40.w,
                                vertical: 15.h,
                              ),
                              textStyle: GoogleFonts.poppins(
                                color: brandFour,
                                fontSize: 13.sp,
                              ),
                            ),
                            child: Text(
                              "Yes",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.sp),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandTwo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.sp),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40.w,
                                vertical: 15.h,
                              ),
                              textStyle: GoogleFonts.poppins(
                                  color: brandFour, fontSize: 13.sp),
                            ),
                            child: Text(
                              "No",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
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
          ),
        );

        return false;
      },
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
            margin: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.width * .155,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: brandOne.withOpacity(.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
              borderRadius: BorderRadius.circular(50),
            ),
            child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .024),
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
                        color: brandOne,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                      ),
                    ),
                    Showcase(
                      key: showCaseCounter[index],
                      // titleTextStyle: TextStyle(),
                      title: showCaseTitle[index],
                      description: showCaseDesc[index],
                      disableAnimation: false,
                      showcaseBackgroundColor: brandOne,
                      showArrow: true,
                      textColor: Colors.white,
                      overlayPadding: const EdgeInsets.all(5),
                      animationDuration: const Duration(seconds: 2),
                      child: Icon(
                        index == currentIndex
                            ? listOfIcons[index]
                            : listOfUnselectedIcons[index],
                        size: MediaQuery.of(context).size.width * .05,
                        color: index == currentIndex
                            ? brandOne
                            : navigationcolorText,
                      ),
                    ),
                    Text(
                      navText[index],
                      style: GoogleFonts.nunito(
                          fontSize: 12.sp,
                          color: index == currentIndex ? brandOne : Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * .03),
                  ],
                ),
              ),
            ),
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   items: <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(
          //       icon:
          //           // _selectedIndex == 0
          //           //     ? const Icon(Iconsax.home5)
          //           //     : const Icon(Iconsax.home),
          //           Showcase(
          //         key: counter._one,
          //         // titleTextStyle: TextStyle(),
          //         title: 'Home',
          //         description: 'All your dashboard in one place.',
          //         disableAnimation: false,
          //         showcaseBackgroundColor: brandOne,
          //         showArrow: true,
          //         textColor: Colors.white,
          //         overlayPadding: const EdgeInsets.all(5),
          //         animationDuration: const Duration(seconds: 2),
          //         child: _selectedIndex == 0
          //             ? Icon(Iconsax.home5, size: 25.sp)
          //             : Icon(Iconsax.home, size: 25.sp),
          //         // Image.asset(
          //         //   "assets/icons/home_icon.png",
          //         //   height: 30,
          //         //   width: 30,
          //         //   color: _selectedIndex == 0 ? brandOne : navigationcolorText,
          //         // )
          //         // ,
          //       ),
          //       label: "Home",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Showcase(
          //         key: counter._two,
          //         title: 'Savings',
          //         textColor: Colors.white,
          //         description: 'Create, manange and grow your savings',
          //         disableAnimation: false,
          //         showcaseBackgroundColor: brandOne,
          //         showArrow: true,
          //         overlayPadding: const EdgeInsets.all(5),
          //         animationDuration: const Duration(seconds: 2),
          //         child: _selectedIndex == 1
          //             ? Icon(Iconsax.activity5, size: 25.sp)
          //             : Icon(Iconsax.activity, size: 25.sp),
          //       ),
          //       label: "Savings",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Showcase(
          //         key: counter._three,
          //         title: 'Portfolio',
          //         textColor: Colors.white,
          //         description:
          //             'Build your portfolio, improve your finance health',
          //         disableAnimation: false,
          //         showcaseBackgroundColor: brandOne,
          //         showArrow: true,
          //         overlayPadding: const EdgeInsets.all(5),
          //         animationDuration: const Duration(seconds: 2),
          //         child: _selectedIndex == 2
          //             ? Image.asset(
          //                 "assets/icons/carbon_portfolio.png",
          //                 // height: 28,
          //                 width: 25.sp,
          //                 color: Theme.of(context).colorScheme.secondary,
          //               )
          //             : Image.asset(
          //                 "assets/icons/carbon_portfolio.png",
          //                 // height: 28,
          //                 width: 25.sp,
          //                 color: navigationcolorText,
          //               ),
          //       ),
          //       label: "Portfolio",
          //     ),
          //     // BottomNavigationBarItem(
          //     //   icon: Showcase(
          //     //     key: counter._four,
          //     //     title: 'Utility',
          //     //     textColor: Colors.white,
          //     //     description:
          //     //         'Pay your bills directly from your wallet and earn SpacePoint!',
          //     //     disableAnimation: false,
          //     //     showcaseBackgroundColor: brandOne,
          //     //     showArrow: true,
          //     //     overlayPadding: const EdgeInsets.all(5),
          //     //     animationDuration: const Duration(seconds: 2),
          //     //     child: _selectedIndex == 3
          //     //         ? Image.asset(
          //     //             "assets/icons/utility_icon.png",
          //     //             // height: 28,
          //     //             width: 20.sp,
          //     //             color: Theme.of(context).colorScheme.secondary,
          //     //           )
          //     //         : Image.asset(
          //     //             "assets/icons/utility_icon.png",
          //     //             height: 20.sp,
          //     //             width: 20.sp,
          //     //             color: navigationcolorText,
          //     //           ),
          //     //   ),
          //     //   label: "Utility",
          //     // ),

          //     BottomNavigationBarItem(
          //       icon: Showcase(
          //         key: counter._five,
          //         title: 'Profile',
          //         textColor: Colors.white,
          //         description: 'Manage your account information',
          //         disableAnimation: false,
          //         showcaseBackgroundColor: brandOne,
          //         showArrow: true,
          //         overlayPadding: const EdgeInsets.all(5),
          //         animationDuration: const Duration(seconds: 2),
          //         child: _selectedIndex == 4
          //             ? Icon(
          //                 Icons.person,
          //                 size: 25.sp,
          //               )
          //             : Icon(Icons.person_outline, size: 25.sp),
          //       ),
          //       label: "Profile",
          //     ),
          //   ],
          //   currentIndex: _selectedIndex,
          //   // showUnselectedLabels: true,
          //   showSelectedLabels: true,

          //   selectedItemColor: brandOne,
          //   backgroundColor: navigationcolorText,
          //   showUnselectedLabels: true,
          //   unselectedIconTheme: const IconThemeData(
          //     color: navigationcolorText,
          //   ),
          //   unselectedItemColor: navigationcolorText,
          //   unselectedLabelStyle:
          //       GoogleFonts.poppins(color: navigationcolorText),
          //   selectedIconTheme: IconThemeData(
          //     color: Theme.of(context).colorScheme.secondary,
          //   ),
          //   selectedLabelStyle: GoogleFonts.poppins(
          //     color: Theme.of(context).colorScheme.secondary,
          //     fontSize: 10.sp,
          //     fontWeight: FontWeight.w600,
          //   ),
          //   onTap: _onItemTapped,
          //   key: _bottomNavigationKey,
          // ),
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
  List showCaseCounter = [
    counter._one,
    counter._two,
    counter._three,
    counter._four,
  ];
  List<IconData> listOfIcons = [
    Iconsax.home5,
    Iconsax.activity5,
    Icons.assessment,
    Icons.person,
  ];
  List<IconData> listOfUnselectedIcons = [
    Iconsax.home,
    Iconsax.activity,
    Icons.assessment_outlined,
    Icons.person_outline,
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
      // case 4:
      //   return const SettingsPage();
      default:
        return const Dashboard();
    }
  }
}
