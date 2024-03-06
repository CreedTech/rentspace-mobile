// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
import 'package:rentspace/controller/activities_controller.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
import 'package:rentspace/controller/utility_controller.dart';
import 'package:rentspace/controller/wallet_controller.dart';
import 'package:rentspace/controller/wallet_histories_controller.dart';
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
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:upgrader/upgrader.dart';

import 'actions/transaction_pin.dart';
import 'home_page.dart';
import 'offline/no_internet_screen.dart';
import 'offline/something_went_wrong.dart';

final LocalAuthentication _localAuthentication = LocalAuthentication();
final UserController userController = Get.find();
// final ActivitiesController activitiesController = Get.find();
final WalletHistoriesController walletHistoriesController = Get.find();
final WalletController walletController = Get.find();
final RentController rentController = Get.find();
String _message = "Not Authorized";
bool _hasBiometric = false;
final hasBiometricStorage = GetStorage();
// String _userWalletBalance = "";
// String _email = "";
String fundedAmount = "0";
String randomRef = "";
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
// String formattedDate = formatter.format(now);
// String _newWalletBalance = "0";
bool hasLoaded = false;
bool _hasOpened = false;
final openedAppStorage = GetStorage();
final hasReferredStorage = GetStorage();
String _isSet = "false";
List<String> transIds = [];
List<Widget> listWidgets = [
  Dashboard(),
  SavingsPage(),
  const PortfolioPage(),
  // UtilitiesPage(),
  // UserProfile()
  const SettingsPage()
];

class CounterNew extends GetxController {}

//Showcase player controller

final counter = Get.put(CounterNew());

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late StreamSubscription<InternetConnectionStatus> _connectivitySubscription;
  bool isInternetConnected = true;
  // final UserController userController = Get.find();
  bool _hasPutController = false;

  void checkConnectivity() async {
    final hasConnection = await InternetConnectionChecker().hasConnection;
    setState(() {
      isInternetConnected = hasConnection;
    });

    // if (isInternetConnected) {
    //   redirectToAppropriateScreen();
    // } else {
    //   showNoInternetScreen();
    // }

    _connectivitySubscription = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      // if (status == InternetConnectionStatus.connected) {
      //   redirectToAppropriateScreen();
      // } else {
      //   showNoInternetScreen();
      // }
    });
  }

  Future<void> redirectToAppropriateScreen() async {}

  @override
  initState() {
    super.initState();
    checkConnectivity();
    Get.put(UserController());
    Get.put(WalletController());
    Get.put(WalletHistoriesController());
    Get.put(RentController());
    Get.put(UtilityController());
    // Get.put(ActivitiesController());
    Future.delayed(const Duration(seconds: 2), () {
      // fetchUserAndSetState();
      setState(() {
        _hasPutController = true;
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  void onTryAgain() {
    checkConnectivity();
  }

  void checkUserInfo() async {
    userController.fetchData();
    // final hasConnection = await InternetConnectionChecker().hasConnection;
    setState(() {
      userController.userModel != null;
    });
  }

  void onReloadAgain() {
    checkUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    Get.put(WalletController());
    Get.put(WalletHistoriesController());
    Get.put(RentController());
    Get.put(UtilityController());
    // Get.put(ActivitiesController());
    return Obx(
      () => (!_hasPutController.obs())
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 150),
                      child: Image.asset(
                        'assets/icons/RentSpaceWhite.png',
                        // width: 140,
                        height: 60,
                      ),
                    ),
                    const Center(
                      child: Column(
                        children: [
                          CustomLoader(),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            )
          : Scaffold(
              body: ShowCaseWidget(
                autoPlay: false,
                onFinish: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Discover',
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
                            height: MediaQuery.of(context).size.height / 2,
                            child: SingleChildScrollView(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/discover.png",
                                    fit: BoxFit.cover,
                                    height: 200,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Dynamic Virtual Account (DVA): This provides a streamlined solution for receiving funds directly, utilizing a unique assigned bank account. It's accessible to anyone seeking to send you funds.",
                                    style: GoogleFonts.nunito(
                                      fontSize: 13.0,
                                      color: brandOne,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Fund Wallet: Fuel Your Financial Adventure with Fund Wallet! Click here to top up your funds and embark on your financial journey today!",
                                    style: GoogleFonts.nunito(
                                      fontSize: 13.0,
                                      color: brandOne,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Withdrawal: Experience Effortless Fund Withdrawals in an Instant access! Take control of your finances by clicking here to start the withdrawal process, granting you immediate access to your funds.",
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
                                      Navigator.of(context).pop();
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
                                      "That's Nice",
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
                },
                builder: Builder(
                  builder: (context) => (isInternetConnected)
                      ? (userController.userModel == null)
                          ? SomethingWentWrong(onTap: onReloadAgain)
                          : (userController.userModel!.userDetails![0].isPinSet
                                      .obs() ==
                                  false)
                              ? const TransactionPin()
                              : const HomePage()
                      : No_internetScreen(onTap: onTryAgain),
                ),
              ),
            ),
    );
  }
}
