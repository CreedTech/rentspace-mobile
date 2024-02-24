// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
import 'package:rentspace/controller/activities_controller.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
import 'package:rentspace/controller/wallet_controller.dart';
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

final LocalAuthentication _localAuthentication = LocalAuthentication();
final UserController userController = Get.find();
final ActivitiesController activitiesController = Get.find();
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
String formattedDate = formatter.format(now);
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
  const FirstPage({super.key});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // final UserController userController = Get.find();
  bool _hasPutController = false;

  @override
  initState() {
    super.initState();
    Get.put(UserController());
    Get.put(WalletController());
    Get.put(ActivitiesController());
    Get.put(RentController());
    // print("isLoading");
    // print(userController.isLoading.value);
    // print(walletController.isLoading.value);
    // print(activitiesController.isLoading.value);

    Future.delayed(const Duration(seconds: 2), () {
      // fetchUserAndSetState();
      
      setState(() {
        _hasPutController = true;
      });
    });
  }
  // Future<void> fetchUserAndSetState() async {
  //   try {
  //     print('==============================================');
  //     print('fetching users');
  //     await userController
  //         .fetchUsers()
  //         .then((value) => (walletController.fetchWallet()))
  //         .then((value) => (activitiesController.fetchActivities()))
  //         .then(
  //           (value) => setState(
  //             () {
  //               _hasPutController =
  //                   true; // Set _hasPutController to true after users are fetched
  //             },
  //           ),
  //         ); // Fetch users
  //   } catch (error) {
  //     print('Error fetching users: $error');
  //     // Handle error (e.g., show error message)
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    Get.put(ActivitiesController());
    Get.put(WalletController());
    Get.put(RentController());
    return 
    // Obx(
    //   () =>
       (!_hasPutController)
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
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     // const SizedBox(
                    //     //   height: 50,
                    //     // ),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           screenInfo,
                    //           style: TextStyle(
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold,
                    //             fontFamily: "DefaultFontFamily",
                    //             color: Theme.of(context).primaryColor,
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           height: 30,
                    //         ),
                    //       ],
                    //     ),
                    //     // const SizedBox(
                    //     //   height: 50,
                    //     // ),
                    //     const CircularProgressIndicator(
                    //       color: brandOne,
                    //     ),
                    //     const SizedBox(
                    //       height: 50,
                    //     ),
                    //     (_canShowAuth)
                    //         ? GFButton(
                    //             onPressed: () {
                    //               checkingForBioMetrics();
                    //             },
                    //             text: "   Authenticate    ",
                    //             shape: GFButtonShape.pills,
                    //           )
                    //         : const SizedBox(),
                    //   ],
                    // ),
                  ],
                ),
              ),
            )
          : (walletController.walletModel!.wallet![0].isPinSet == false)
              ? const TransactionPin()
              : const HomePage();
    // );
  }
}