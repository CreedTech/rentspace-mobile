// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/widgets/shimmer_widget.dart';
import 'package:rentspace/controller/utility/airtime_controller.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
import 'package:rentspace/controller/utility/utility_controller.dart';
import 'package:rentspace/controller/utility/utility_response_controller.dart';
import 'package:rentspace/controller/wallet/wallet_controller.dart';
import 'package:rentspace/view/dashboard/dashboard.dart';
import 'package:rentspace/view/settings/settings.dart';
import 'package:rentspace/view/portfolio/portfolio_page.dart';
import 'package:rentspace/view/savings/savings_page.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:intl/intl.dart';

import '../../controller/loan/loan_controller.dart';
import '../../widgets/custom_loader.dart';
import '../auth/pin/transaction_pin.dart';
import 'home_page.dart';
import '../offline/no_internet_screen.dart';
import '../offline/something_went_wrong.dart';

final LocalAuthentication _localAuthentication = LocalAuthentication();
final UserController userController = Get.find();
final WalletController walletController = Get.find();
final RentController rentController = Get.find();
final UtilityResponseController utilityResponseController = Get.find();
final AirtimesController airtimesController = Get.find();
final LoanController loanController = Get.find();
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
  const Dashboard(),
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
  // final StreamController<SessionState> sessionStateStream;
  const FirstPage({
    super.key,
    // required this.sessionStateStream,
  });
  //  final sessionStateStream = StreamController<SessionState>();

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  bool isRefresh = false;
  late StreamSubscription<InternetConnectionStatus> _connectivitySubscription;
  bool isInternetConnected = true;

  void checkConnectivity() async {
    final hasConnection = await InternetConnectionChecker().hasConnection;
    setState(() {
      isInternetConnected = hasConnection;
    });

    _connectivitySubscription = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {});
  }

  Future<void> redirectToAppropriateScreen() async {}

  @override
  initState() {
    super.initState();
    checkConnectivity();
    Get.put(UserController());
    Get.put(RentController());
    Get.put(WalletController());
    Get.put(UtilityResponseController(context));
    Get.put(AirtimesController(context));
    Get.put(UtilityController());
    Get.put(LoanController(context));
    Future.delayed(const Duration(seconds: 3), () {
      // fetchUserAndSetState();
      // setState(() {
      //   _hasPutController = true;
      // });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  void onTryAgain() {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    checkConnectivity();
    EasyLoading.dismiss();
  }

  void checkUserInfo() async {
    userController.fetchData();
    setState(() {
      userController.userModel != null;
    });
  }

  void onReloadAgain() {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    checkUserInfo();
    EasyLoading.dismiss();
  }

  Future<void> onRefresh() async {
    refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        isRefresh = true;
      });
    }
    userController.fetchData();
    walletController.fetchWallet();
    rentController.fetchRent();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    Get.put(RentController());
    Get.put(UtilityController());
    Get.put(WalletController());
    Get.put(UtilityResponseController(context));
    Get.put(LoanController(context));
    return Obx(
      () => (userController.isHomePageLoading.value.obs() == true)
          ? Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20.0.w,
                    0.0.h,
                    20.0.w,
                    0.0.h,
                  ),
                  child: LiquidPullToRefresh(
                    height: 70,
                    animSpeedFactor: 2,
                    color: Colors.white,
                    backgroundColor: brandOne,
                    showChildOpacityTransition: false,
                    onRefresh: onRefresh,
                    child: shimmerLoader(),
                  ),
                ),
              ),
            )
          : Scaffold(
              body: ShowCaseWidget(
                autoPlay: false,
                onFinish: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          title: Text(
                            'Discover',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 20.0,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          content: SingleChildScrollView(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      // Image.asset(
                                      //   "assets/discover.png",
                                      //   fit: BoxFit.cover,
                                      //   height: 200,
                                      // ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Virtual Account: This provides a streamlined solution for receiving funds directly, utilizing a unique assigned bank account. It's accessible to anyone seeking to send you funds.",
                                        style: GoogleFonts.lato(
                                          fontSize: 13.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Space Rent: Save 70% of rent for a minimum of 6 months (maximum of 8 months) and get up to 30% loan. Embark on your savings journey today!",
                                        style: GoogleFonts.lato(
                                          fontSize: 13.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15),
                                          textStyle: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                        child: Text(
                                          "That's Nice",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 14,
                                            // letterSpacing: 0.3,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
                builder: Builder(
                  builder: (context) => (isInternetConnected)
                      ? (userController.userModel == null)
                          ? SomethingWentWrong(onTap: onReloadAgain)
                          : (userController
                                      .userModel!.userDetails![0].isPinSet ==
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
