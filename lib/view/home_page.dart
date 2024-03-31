// ignore_for_file: use_build_context_synchronously

//Second page
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rentspace/controller/wallet_controller.dart';
import 'package:rentspace/view/utility/utilities_page.dart';
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
  List<String> transIds = [];
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

  // mustRefer() async {
  //   //get the referal code in the users collection
  //   if (userController.user[0].referalId != "") {
  //     CollectionReference allUsersR =
  //         FirebaseFirestore.instance.collection('accounts');

  //     var snapshot = await allUsersR
  //         .where('referal_code',
  //             isEqualTo: userController.user[0].referalId.toUpperCase())
  //         .get();
  //     var collection = FirebaseFirestore.instance.collection('accounts');

  //     var docSnapshot = await collection.doc(userId).get();
  //     for (var doc in snapshot.docs) {
  //       var data = snapshot.docs.first.data() as Map;
  //       var value = data["referals"];
  //       var newValue = value! + 1;

  //       await doc.reference.update({
  //         'referals': newValue,
  //       }).then((value) {
  //         docSnapshot.reference.update({
  //           'referals': 1,
  //           'referar_id': "@${userController.user[0].referalId}@"
  //         });
  //         //R09K673ELR
  //         showTopSnackBar(
  //           Overlay.of(context),
  //           CustomSnackBar.success(
  //             backgroundColor: brandOne,
  //             message: 'Your account has been setup successfully!',
  //             textStyle: GoogleFonts.nunito(
  //               fontSize: 14.sp,
  //               color: Colors.white,
  //               fontWeight: FontWeight.w700,
  //             ),
  //           ),
  //         );
  //       }).catchError((error) {
  //         showDialog(
  //             context: context,
  //             barrierDismissible: false,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10.sp),
  //                 ),
  //                 title: null,
  //                 elevation: 0,
  //                 content: SizedBox(
  //                   height: 250.h,
  //                   child: Column(
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                         child: Align(
  //                           alignment: Alignment.topRight,
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(30.sp),
  //                               // color: brandOne,
  //                             ),
  //                             child: Icon(
  //                               Iconsax.close_circle,
  //                               color: Theme.of(context).primaryColor,
  //                               size: 30.sp,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Icon(
  //                           Iconsax.warning_24,
  //                           color: Colors.red,
  //                           size: 75.sp,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 12.h,
  //                       ),
  //                       Text(
  //                         "Oops...",
  //                         style: GoogleFonts.nunito(
  //                           color: Colors.red,
  //                           fontSize: 28.sp,
  //                           fontWeight: FontWeight.w800,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 5.h,
  //                       ),
  //                       Text(
  //                         "Something went wrong",
  //                         textAlign: TextAlign.center,
  //                         style: GoogleFonts.nunito(
  //                             color: Colors.red, fontSize: 18.sp),
  //                       ),
  //                       SizedBox(
  //                         height: 10.h,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             });
  //       });
  //     }
  //   } else {
  //     print("No referal");
  //   }
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
                  style: GoogleFonts.nunito(
                    fontSize: 20.0,
                    color: brandOne,
                    fontWeight: FontWeight.w700,
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
                          style: GoogleFonts.nunito(
                            fontSize: 13.0,
                            color: brandOne,
                            fontWeight: FontWeight.w700,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                          child: Text(
                            "Start",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 14,
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
    print('started');

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
    transIds.clear();
    // checkStatus();

    setState(() {
      fundedAmount = "0";
    });
    Future.delayed(const Duration(seconds: 1), () {
      checkIsOpenedApp();
    });
  }

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    _authenticateMe();
    return canCheckBiometrics;
  }

  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Authentication required",
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });
      if (_message == "Authorized") {
        Get.to(const HomePage());
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                title: null,
                elevation: 0,
                content: SizedBox(
                  height: 250.h,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.sp),
                              // color: brandOne,
                            ),
                            child: Icon(
                              Iconsax.close_circle,
                              color: Theme.of(context).primaryColor,
                              size: 30.sp,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Iconsax.warning_24,
                          color: Colors.red,
                          size: 75.sp,
                        ),
                      ),
                      SizedBox(
                        height: 12.sp,
                      ),
                      Text(
                        'Error',
                        style: GoogleFonts.nunito(
                          color: Colors.red,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Biometrics failed",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            color: Colors.red, fontSize: 18.sp),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    } catch (e) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              title: null,
              elevation: 0,
              content: SizedBox(
                height: 250.h,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.sp),
                            // color: brandOne,
                          ),
                          child: Icon(
                            Iconsax.close_circle,
                            color: Theme.of(context).primaryColor,
                            size: 30.sp,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Iconsax.warning_24,
                        color: Colors.red,
                        size: 75.sp,
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      'Error',
                      style: GoogleFonts.nunito(
                        color: Colors.red,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Biometrics failed",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: Colors.red,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            );
          });
    }
    if (!mounted) return;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
                      style: GoogleFonts.nunito(
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
                              textStyle: GoogleFonts.nunito(
                                color: brandFour,
                                fontSize: 13.sp,
                              ),
                            ),
                            child: Text(
                              "Yes",
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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
                              textStyle: GoogleFonts.nunito(
                                  color: brandFour, fontSize: 13.sp),
                            ),
                            child: Text(
                              "No",
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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
            child: _buildPage(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon:
                    // _selectedIndex == 0
                    //     ? const Icon(Iconsax.home5)
                    //     : const Icon(Iconsax.home),
                    Showcase(
                  key: counter._one,
                  // titleTextStyle: TextStyle(),
                  title: 'Home',
                  description: 'All your dashboard in one place.',
                  disableAnimation: false,
                  showcaseBackgroundColor: brandOne,
                  showArrow: true,
                  textColor: Colors.white,
                  overlayPadding: const EdgeInsets.all(5),
                  animationDuration: const Duration(seconds: 2),
                  child: _selectedIndex == 0
                      ?  Icon(Iconsax.home5,size: 20.sp)
                      :  Icon(Iconsax.home,size: 20.sp),
                  // Image.asset(
                  //   "assets/icons/home_icon.png",
                  //   height: 30,
                  //   width: 30,
                  //   color: _selectedIndex == 0 ? brandOne : navigationcolorText,
                  // )
                  // ,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Showcase(
                  key: counter._two,
                  title: 'Savings',
                  textColor: Colors.white,
                  description: 'Create, manange and grow your savings',
                  disableAnimation: false,
                  showcaseBackgroundColor: brandOne,
                  showArrow: true,
                  overlayPadding: const EdgeInsets.all(5),
                  animationDuration: const Duration(seconds: 2),
                  child: _selectedIndex == 1
                      ?  Icon(Iconsax.activity5,size: 20.sp)
                      :  Icon(Iconsax.activity,size: 20.sp),
                ),
                label: "Savings",
              ),
              BottomNavigationBarItem(
                icon: Showcase(
                  key: counter._three,
                  title: 'Portfolio',
                  textColor: Colors.white,
                  description:
                      'Build your portfolio, improve your finance health',
                  disableAnimation: false,
                  showcaseBackgroundColor: brandOne,
                  showArrow: true,
                  overlayPadding: const EdgeInsets.all(5),
                  animationDuration: const Duration(seconds: 2),
                  child: _selectedIndex == 2
                      ? Image.asset(
                          "assets/icons/carbon_portfolio.png",
                          // height: 28,
                          width: 20.sp,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : Image.asset(
                          "assets/icons/carbon_portfolio.png",
                          // height: 28,
                          width: 20.sp,
                          color: navigationcolorText,
                        ),
                ),
                label: "Portfolio",
              ),
              BottomNavigationBarItem(
                icon: Showcase(
                  key: counter._four,
                  title: 'Utility',
                  textColor: Colors.white,
                  description:
                      'Pay your bills directly from your wallet and earn SpacePoint!',
                  disableAnimation: false,
                  showcaseBackgroundColor: brandOne,
                  showArrow: true,
                  overlayPadding: const EdgeInsets.all(5),
                  animationDuration: const Duration(seconds: 2),
                  child: _selectedIndex == 3
                      ? Image.asset(
                          "assets/icons/utility_icon.png",
                          // height: 28,
                          width: 20.sp,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : Image.asset(
                          "assets/icons/utility_icon.png",
                          height: 20.sp,
                          width: 20.sp,
                          color: navigationcolorText,
                        ),
                ),
                label: "Utility",
              ),
              BottomNavigationBarItem(
                icon: Showcase(
                  key: counter._five,
                  title: 'Profile',
                  textColor: Colors.white,
                  description: 'Manage your account information',
                  disableAnimation: false,
                  showcaseBackgroundColor: brandOne,
                  showArrow: true,
                  overlayPadding: const EdgeInsets.all(5),
                  animationDuration: const Duration(seconds: 2),
                  child: _selectedIndex == 4
                      ?  Icon(Icons.person,size: 20.sp,)
                      :  Icon(Icons.person_outline,size: 20.sp),
                ),
                label: "Profile",
              ),
            ],
            currentIndex: _selectedIndex,
            // showUnselectedLabels: true,
            showSelectedLabels: true,

            selectedItemColor: brandOne,
            backgroundColor: navigationcolorText,
            showUnselectedLabels: true,
            unselectedIconTheme: const IconThemeData(
              color: navigationcolorText,
            ),
            unselectedItemColor: navigationcolorText,
            unselectedLabelStyle:
                GoogleFonts.nunito(color: navigationcolorText),
            selectedIconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.secondary,
            ),
            selectedLabelStyle: GoogleFonts.nunito(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
            ),
            onTap: _onItemTapped,
            key: _bottomNavigationKey,
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Dashboard();
      case 1:
        return SavingsPage();
      case 2:
        return const PortfolioPage();
      case 3:
        return UtilitiesPage();
      case 4:
        return const SettingsPage();
      default:
        return Dashboard();
    }
  }
}
