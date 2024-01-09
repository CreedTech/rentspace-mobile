// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:rentspace/controller/auto_controller.dart';
import 'package:rentspace/controller/box_controller.dart';
import 'package:rentspace/controller/deposit_controller.dart';
import 'package:rentspace/controller/notification_controller.dart';
import 'package:rentspace/controller/rent_controller.dart';
import 'package:rentspace/controller/tank_controller.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/controller/utility_controller.dart';
import 'package:rentspace/controller/withdrawal_controller.dart';
import 'package:rentspace/view/actions/in_active_page.dart';
import 'package:rentspace/view/dashboard/dashboard.dart';
import 'package:rentspace/view/dashboard/settings.dart';
import 'package:rentspace/view/portfolio/portfolio_page.dart';
import 'package:rentspace/view/savings/savings_page.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:once/once.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';
import 'package:upgrader/upgrader.dart';

final LocalAuthentication _localAuthentication = LocalAuthentication();
final UserController userController = Get.find();
String _message = "Not Authorized";
bool _hasBiometric = false;
final hasBiometricStorage = GetStorage();
String _userWalletBalance = "";
String _email = "";
String fundedAmount = "0";
String randomRef = "";
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
String _newWalletBalance = "0";
bool hasLoaded = false;
bool _hasOpened = false;
final openedAppStorage = GetStorage();
final hasReferredStorage = GetStorage();
String _isSet = "false";
String imgUrl =
    "https://firebasestorage.googleapis.com/v0/b/rentspace-1aebe.appspot.com/o/assets%2Fblack%20man%20(1).png?alt=media&token=ae5ac473-406e-4e70-ad92-8a8b1b7db9d9";
List<String> transIds = [];
List<Widget> listWidgets = [
  Dashboard(),
  SavingsPage(),
  const PortfolioPage(),
  // UtilitiesPage(),
  // UserProfile()
  SettingsPage()
];
int _selectedIndex = 0;

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

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool _hasPutController = false;
  // final UserController userController = Get.find();

  @override
  initState() {
    super.initState();
    Get.put(UserController());
    Get.put(NotificationController());
    Get.put(WithdrawalController());
    Get.put(UtilityController());
    Get.put(RentController());
    Get.put(AutoController());
    Get.put(BoxController());
    Get.put(TankController());
    Get.put(DepositController());

    // setState(() {
    //   _hasPutController = true;
    // });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _hasPutController = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    Get.put(NotificationController());
    Get.put(UtilityController());
    Get.put(WithdrawalController());
    Get.put(RentController());
    Get.put(AutoController());
    Get.put(BoxController());
    Get.put(TankController());
    Get.put(DepositController());
    return (!_hasPutController)
        ? Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                    'assets/slider3.png',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), // Adjust the opacity here
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 30,
                    width: 90,
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/RentSpace-1011.png"),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome Spacer",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DefaultFontFamily",
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Lottie.asset(
                    'assets/loader.json',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Builder(
              builder: (context) => const HomePage(),
              //  (context) => (userController.user[0].bvn != "")
              //     ? const HomePage()
              //     : (userController.user[0].dvaUsername == '' ||
              //             userController.user[0].gender == '' ||
              //             userController.user[0].date_of_birth == '' ||
              //             userController.user[0].address == '')
              //         ? UpdateUserInfo()
              //         : CreateDVA(),
              // : const HomePage(),
            ),
            // ShowCaseWidget(
            //   autoPlay: true,
            //   onFinish: () {
            //     Get.defaultDialog(
            //       titlePadding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            //       title: "Discover",
            //       content: Container(
            //         height: MediaQuery.of(context).size.height / 2,
            //         padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            //         child: ListView(
            //           shrinkWrap: true,
            //           physics: const ClampingScrollPhysics(),
            //           children: [
            //             Image.asset(
            //               "assets/discover.png",
            //               fit: BoxFit.cover,
            //               height: 200,
            //             ),
            //             const SizedBox(
            //               height: 10,
            //             ),
            //             const Text(
            //               "Dynamic Virtual Account (DVA): This provides a streamlined solution for receiving funds directly, utilizing a unique assigned bank account. It's accessible to anyone seeking to send you funds.",
            //               style: TextStyle(
            //                 fontSize: 13.0,
            //                 letterSpacing: 0.5,
            //                 fontFamily: "DefaultFontFamily",
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             const SizedBox(
            //               height: 10,
            //             ),
            //             const Text(
            //               "Fund Wallet: Fuel Your Financial Adventure with Fund Wallet! Click here to top up your funds and embark on your financial journey today!",
            //               style: TextStyle(
            //                 fontSize: 13.0,
            //                 letterSpacing: 0.5,
            //                 fontFamily: "DefaultFontFamily",
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             const SizedBox(
            //               height: 10,
            //             ),
            //             const Text(
            //               "Withdrawal: Experience Effortless Fund Withdrawals in an Instant access! Take control of your finances by clicking here to start the withdrawal process, granting you immediate access to your funds.",
            //               style: TextStyle(
            //                 fontSize: 13.0,
            //                 letterSpacing: 0.5,
            //                 fontFamily: "DefaultFontFamily",
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             const SizedBox(
            //               height: 10,
            //             ),
            //           ],
            //         ),
            //       ),
            //       actions: <Widget>[
            //         Padding(
            //           padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
            //           child: GFButton(
            //             onPressed: () {
            //               Get.back();
            //             },
            //             fullWidthButton: true,
            //             shape: GFButtonShape.pills,
            //             text: "That's Nice",
            //             icon: const Icon(
            //               Icons.arrow_right_outlined,
            //               color: Colors.white,
            //               size: 18,
            //             ),
            //             color: brandOne,
            //             textStyle: const TextStyle(
            //               color: Colors.white,
            //               fontSize: 16,
            //             ),
            //           ),
            //         ),
            //       ],
            //       barrierDismissible: true,
            //     );
            //   },
            //   builder: Builder(
            //     builder: (context) => const HomePage(),
            //     //  (context) => (userController.user[0].bvn != "")
            //     //     ? const HomePage()
            //     //     : (userController.user[0].dvaUsername == '' ||
            //     //             userController.user[0].gender == '' ||
            //     //             userController.user[0].date_of_birth == '' ||
            //     //             userController.user[0].address == '')
            //     //         ? UpdateUserInfo()
            //     //         : CreateDVA(),
            //     // : const HomePage(),
            //   ),
            // ),
          );
  }
}

//Second page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // IconData _homeIcon = Iconsax.home_21;
  // IconData _transactionIcon = Iconsax.transaction_minus;
  // IconData _supportIcon = Iconsax.message_notif;
  // IconData _settingsIcon = Iconsax.setting_2;

  // final IconData _defaultHomeIcon = Iconsax.home;
  // final IconData _defaultTransactionIcon = Iconsax.transaction_minus;
  // final IconData _defaultSupportIcon = Iconsax.message_notif;
  // final IconData _defaultSettingsIcon = Iconsax.profile;

  checkStatus() {
    final FirebaseFirestore firestoreFile = FirebaseFirestore.instance;
    DocumentReference docReference =
        firestoreFile.collection('maintenance').doc('27-09-2023-maintenance');

    docReference.snapshots().listen((snapshot) {
      var data = snapshot.data() as Map<String, dynamic>?;
      var newStatus = data?['status'];

      if (newStatus != "active") {
        Get.to(const InActivePage());
      } else {
        print("All good!!!");
      }
    });
  }

  mustRefer() async {
    //get the referal code in the users collection
    if (userController.user[0].referalId != "") {
      CollectionReference allUsersR =
          FirebaseFirestore.instance.collection('accounts');

      var snapshot = await allUsersR
          .where('referal_code',
              isEqualTo: userController.user[0].referalId.toUpperCase())
          .get();
      var collection = FirebaseFirestore.instance.collection('accounts');

      var docSnapshot = await collection.doc(userId).get();
      for (var doc in snapshot.docs) {
        var data = snapshot.docs.first.data() as Map;
        var value = data["referals"];
        var newValue = value! + 1;

        await doc.reference.update({
          'referals': newValue,
        }).then((value) {
          docSnapshot.reference.update({
            'referals': 1,
            'referar_id': "@${userController.user[0].referalId}@"
          });
          //R09K673ELR
          Get.snackbar(
            "All set!",
            'Your account has been setup successfully!',
            animationDuration: const Duration(seconds: 1),
            backgroundColor: brandOne,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }).catchError((error) {
          showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: null,
              elevation: 0,
              content: SizedBox(
                height: 250,
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
                            borderRadius: BorderRadius.circular(30),
                            // color: brandOne,
                          ),
                          child: const Icon(
                            Iconsax.close_circle,
                            color: brandOne,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Iconsax.warning_24,
                        color: Colors.red,
                        size: 75,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Oops...",
                      style: GoogleFonts.nunito(
                        color: Colors.red,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Something went wrong",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(color: brandOne, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          });
     
          // Get.snackbar(
          //   "Oops...",
          //   "Something went wrong",
          //   animationDuration: const Duration(seconds: 2),
          //   backgroundColor: Colors.red,
          //   colorText: Colors.white,
          //   snackPosition: SnackPosition.BOTTOM,
          // );
        });
      }
    } else {
      print("No referal");
    }
  }

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
        mustRefer();
        Get.defaultDialog(
          titlePadding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          title: "Welcome Spacer!",
          content: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              children: [
                Image.asset(
                  "assets/ava_intro.png",
                  fit: BoxFit.fill,
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "I'm Ava. I'm happy to see you on our platform and will help you get started on the app. Take a few moments to see the basics.",
                  style: TextStyle(
                    fontSize: 13.0,
                    letterSpacing: 0.5,
                    fontFamily: "DefaultFontFamily",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: GFButton(
                onPressed: () {
                  Get.back();
                  startShowCase();
                },
                fullWidthButton: true,
                shape: GFButtonShape.pills,
                text: "Start",
                icon: const Icon(
                  Icons.arrow_right_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                color: brandOne,
                textStyle: const TextStyle(
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

  startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase([
        counter._one,
        counter._two,
        counter._three,
        counter._four,
        counter._five,
        /* counter._six,
        counter._seven,
        counter._eight, */
      ]),
    );
  }

  @override
  initState() {
    super.initState();
    transIds.clear();
    checkStatus();
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
                borderRadius: BorderRadius.circular(10),
              ),
              title: null,
              elevation: 0,
              content: SizedBox(
                height: 250,
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
                            borderRadius: BorderRadius.circular(30),
                            // color: brandOne,
                          ),
                          child: const Icon(
                            Iconsax.close_circle,
                            color: brandOne,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Iconsax.warning_24,
                        color: Colors.red,
                        size: 75,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Error',
                      style: GoogleFonts.nunito(
                        color: Colors.red,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Biometrics failed",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(color: brandOne, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
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
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: null,
              elevation: 0,
              content: SizedBox(
                height: 250,
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
                            borderRadius: BorderRadius.circular(30),
                            // color: brandOne,
                          ),
                          child: const Icon(
                            Iconsax.close_circle,
                            color: brandOne,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Iconsax.warning_24,
                        color: Colors.red,
                        size: 75,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Error',
                      style: GoogleFonts.nunito(
                        color: Colors.red,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Biometrics failed",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(color: brandOne, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
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
      // if (index == 0) {
      //   _homeIcon = Iconsax.home_21;
      //   _transactionIcon = _defaultTransactionIcon;
      //   _supportIcon = _defaultSupportIcon;
      //   _settingsIcon = _defaultSettingsIcon;
      // } else if (index == 1) {
      //   _transactionIcon = Iconsax.transaction_minus5;
      //   _supportIcon = _defaultSupportIcon;
      //   _settingsIcon = _defaultSettingsIcon;
      //   _homeIcon = _defaultHomeIcon;
      // } else if (index == 2) {
      //   _supportIcon = Iconsax.message_notif5;
      //   _settingsIcon = _defaultSettingsIcon;
      //   _transactionIcon = _defaultTransactionIcon;
      //   _homeIcon = _defaultHomeIcon;
      // } else if (index == 3) {
      //   _settingsIcon = Icons.settings;
      //   _supportIcon = _defaultSupportIcon;
      //   _transactionIcon = _defaultTransactionIcon;
      //   _homeIcon = _defaultHomeIcon;
      // }

      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.bottomSheet(
          SizedBox(
            height: 250,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: Container(
                color: Theme.of(context).canvasColor,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Are you sure you want to exit?',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        // fontFamily: "DefaultFontFamily",
                        color: brandOne,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              textStyle: const TextStyle(
                                  color: brandFour, fontSize: 13),
                            ),
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandTwo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              textStyle: const TextStyle(
                                  color: brandFour, fontSize: 13),
                            ),
                            child: const Text(
                              "No",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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
          ),
        );

        // Get.bottomSheet(
        //   SizedBox(
        //     height: 100,
        //     child: ClipRRect(
        //       borderRadius: const BorderRadius.only(
        //         topLeft: Radius.circular(30.0),
        //         topRight: Radius.circular(30.0),
        //       ),
        //       child: Container(
        //         color: Theme.of(context).canvasColor,
        //         child: Column(
        //           children: [
        //             const SizedBox(
        //               height: 10,
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
        //               child: Text(
        //                 'Are you sure you want to exit?',
        //                 style: TextStyle(
        //                   fontSize: 16,
        //                   color: Theme.of(context).primaryColor,
        //                   fontFamily: "DefaultFontFamily",
        //                 ),
        //               ),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   GFButton(
        //                     onPressed: () {
        //                       Get.back();
        //                     },
        //                     shape: GFButtonShape.pills,
        //                     text: "Cancel",
        //                     fullWidthButton: false,
        //                     color: Colors.greenAccent,
        //                     textStyle: const TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 12,
        //                       fontFamily: "DefaultFontFamily",
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     width: 20,
        //                   ),
        //                   GFButton(
        //                     onPressed: () {
        //                       exit(0);
        //                     },
        //                     shape: GFButtonShape.pills,
        //                     text: "Exit",
        //                     fullWidthButton: false,
        //                     color: Colors.red,
        //                     textStyle: const TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 12,
        //                       fontFamily: "DefaultFontFamily",
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // );

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
            child: listWidgets[_selectedIndex],
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
                        width: 29,
                        color: brandOne,
                      )
                    : Image.asset(
                        "assets/icons/carbon_portfolio.png",
                        // height: 28,
                        width: 29,
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
            selectedIconTheme: const IconThemeData(color: brandOne),
            selectedLabelStyle: GoogleFonts.nunito(
                color: brandOne, fontWeight: FontWeight.w700),
            onTap: _onItemTapped,
            key: _bottomNavigationKey,
          ),
        ),
      ),
    );
  }
}
