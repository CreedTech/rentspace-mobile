

//Second page
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rentspace/controller/wallet_controller.dart';
import 'package:upgrader/upgrader.dart';

import '../constants/colors.dart';
import 'dashboard/dashboard.dart';
import 'dashboard/settings.dart';
import 'portfolio/portfolio_page.dart';
import 'savings/savings_page.dart';

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

  // Future<void> checkInitialPinStatus(BuildContext context) async {
  //   if (walletController.walletModel!.wallet![0].isPinSet == false) {
  //     // If PIN is not set, navigate to PIN screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => TransactionPin()),
  //     );
  //   } else {
  //     // If PIN is set, navigate to the home screen or any other screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomeScreen()),
  //     );
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
        Get.defaultDialog(
          titlePadding: EdgeInsets.fromLTRB(0.w, 50.h, 0.w, 0.h),
          title: "Welcome Spacer!",
          content: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
            child: Column(
              children: [
                Image.asset(
                  "assets/ava_intro.png",
                  fit: BoxFit.fill,
                  height: 200.h,
                  width: 200.w,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "I'm Ava. I'm happy to see you on our platform and will help you get started on the app. Take a few moments to see the basics.",
                  style: GoogleFonts.nunito(
                    fontSize: 13.0.sp,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                10.w,
                0.h,
                10.w,
                20.h,
              ),
              child: GFButton(
                onPressed: () {
                  Get.back();
                  // startShowCase();
                },
                fullWidthButton: true,
                shape: GFButtonShape.pills,
                text: "Start",
                icon: Icon(
                  Icons.arrow_right_outlined,
                  color: Colors.white,
                  size: 18.sp,
                ),
                color: brandOne,
                textStyle: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          barrierDismissible: false,
        );
      } else {
        return;
      }
    } else {
      print(openedAppStorage.read('hasOpenedApp').toString());
    }
    //print()
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
      // checkIsOpenedApp();
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

      // Get.snackbar(
      //   "Error",
      //   "Biometrics failed",
      //   animationDuration: const Duration(seconds: 2),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
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
                
                icon: _selectedIndex == 0
                    ? const Icon(Iconsax.home5)
                    : const Icon(Iconsax.home),
                // Showcase(
                //   key: counter._one,
                //   // titleTextStyle: TextStyle(),
                //   title: 'Home',
                //   description: 'All your dashboard in one place.',
                //   disableAnimation: false,
                //   showcaseBackgroundColor: brandOne,
                //   showArrow: true,
                //   textColor: Colors.white,
                //   overlayPadding: const EdgeInsets.all(5),
                //   animationDuration: const Duration(seconds: 2),
                //   child: Image.asset(
                //     "assets/icons/home_icon.png",
                //     height: 30,
                //     width: 30,
                //     color: _selectedIndex == 0 ? brandOne : navigationcolorText,
                //   ),
                // ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 1
                    ? const Icon(Iconsax.activity5)
                    : const Icon(Iconsax.activity),
                //  Showcase(
                //   key: counter._two,
                //   title: 'Savings',
                //   textColor: brandOne,
                //   description: 'Create, manange and grow your savings',
                //   disableAnimation: false,
                //   showcaseBackgroundColor: brandOne,
                //   showArrow: true,
                //   overlayPadding: const EdgeInsets.all(5),
                //   animationDuration: const Duration(seconds: 2),
                //   child: Image.asset(
                //     "assets/icons/savings_icon.png",
                //     height: 30,
                //     width: 30,
                //     color: navigationcolorText,
                //   ),
                // ),
                label: "Savings",
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 2
                    ? Image.asset(
                        "assets/icons/carbon_portfolio.png",
                        // height: 28,
                        width: 29.w,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    : Image.asset(
                        "assets/icons/carbon_portfolio.png",
                        // height: 28,
                        width: 29.w,
                        color: navigationcolorText,
                      ),
                // Showcase(
                //   key: counter._three,
                //   title: 'Portfolio',
                //   textColor: Colors.white,
                //   description:
                //       'Build your portfolio, improve your finance health',
                //   disableAnimation: false,
                //   showcaseBackgroundColor: brandOne,
                //   showArrow: true,
                //   overlayPadding: const EdgeInsets.all(5),
                //   animationDuration: const Duration(seconds: 2),
                //   child: Image.asset(
                //     "assets/icons/portfolio_icon.png",
                //     height: 30,
                //     width: 30,
                //     color: navigationcolorText,
                //   ),
                // ),
                label: "Portfolio",
              ),
              // BottomNavigationBarItem(
              //   icon: Showcase(
              //     key: counter._four,
              //     title: 'Utility',
              //     textColor: Colors.white,
              //     description:
              //         'Pay your bills directly from your wallet and earn 1 SpacePoint!',
              //     disableAnimation: false,
              //     showcaseBackgroundColor: brandOne,
              //     showArrow: true,
              //     overlayPadding: const EdgeInsets.all(5),
              //     animationDuration: const Duration(seconds: 2),
              //     child: Image.asset(
              //       "assets/icons/utility_icon.png",
              //       height: 30,
              //       width: 30,
              //       color: brandTwo,
              //     ),
              //   ),
              //   label: "Utility",
              // ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 3
                    ? const Icon(Icons.person)
                    : const Icon(Icons.person_outline),
                // Showcase(
                //   key: counter._five,
                //   title: 'Profile',
                //   textColor: Colors.white,
                //   description: 'Manage your account information',
                //   disableAnimation: false,
                //   showcaseBackgroundColor: brandOne,
                //   showArrow: true,
                //   overlayPadding: const EdgeInsets.all(5),
                //   animationDuration: const Duration(seconds: 2),
                //   child: Icon(Icons.person_outline),
                // ),
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
        return const SettingsPage();
      default:
        return Dashboard();
    }
  }
}
