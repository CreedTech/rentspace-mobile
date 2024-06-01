// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:html/parser.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
// import 'package:rentspace/constants/widgets/app_scrolling.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
// import 'package:rentspace/controller/activities_controller.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
import 'package:rentspace/controller/wallet_controller.dart';
import 'package:rentspace/model/user_details_model.dart';
import 'package:rentspace/view/FirstPage.dart';
import 'package:rentspace/view/actions/contact_us.dart';
import 'package:rentspace/view/actions/fund_wallet.dart';
import 'package:rentspace/view/dashboard/all_activities.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:rentspace/view/dashboard/settings.dart';
import 'package:rentspace/view/dashboard/transfer.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/view/dashboard/withdraw_continuation_page.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_creation.dart';
import 'package:rentspace/view/utility/airtime.dart';
// import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// import '../../api/wp-api.dart';
// import '../../constants/utils/responsive_height.dart';
// import '../../constants/widgets/custom_dialog.dart';
// import '../../controller/settings_controller.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/icon_container.dart';
import '../../core/helper/helper_route_path.dart';
// import '../actions/onboarding_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../actions/transaction_pin.dart';
import '../actions/transaction_receipt.dart';
import '../actions/transaction_receipt_dva.dart';
import '../actions/transaction_receipt_transfer.dart';
import 'withdraw_page.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  _DashboardConsumerState createState() => _DashboardConsumerState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
final themeChange = Get.put(ThemeServices());
final UserController userController = Get.put(UserController());
// final ActivitiesController activitiesController =
//     Get.put(ActivitiesController());
final WalletController walletController = Get.put(WalletController());
final RentController rentController = Get.put(RentController());

int id = 0;

String _greeting = "";
// bool _hasReferred = false;
String referalCode = "";
int referalCount = 0;
int userReferal = 0;
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
// String _isSet = "false";
var dum1 = "".obs;
String previousAnnouncementText = '';
bool hideBalance = false;
int currentPos = 0;

class _DashboardConsumerState extends ConsumerState<Dashboard> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  String? fullName = '';
  double rentBalance = 0;
  List<UserDetailsModel> userInfo = [];
// String? fullName = '';
  // List<WalletModel> wallet_info = [];
  bool isAlertSet = false;
  bool isRefresh = false;
  List rentspaceProducts = ['Space Wallet', 'Space Rent', 'Space Deposit'];
  String selectedIndex = 'Space Wallet';

  final form = intl.NumberFormat.decimalPattern();
  bool isContainerVisible = true;
  // List<dynamic> _articles = [];
  greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      setState(() {
        _greeting = 'Good morning';
      });
    } else if (hour < 17) {
      setState(() {
        _greeting = 'Good Afternoon';
      });
    } else {
      setState(() {
        _greeting = 'Good evening';
      });
    }
  }

  Future<bool> fetchUserData({bool refresh = true}) async {
    setState(() {});
    if (refresh) {
      await userController.fetchData();
      await walletController.fetchWallet();
      setState(() {}); // Move setState inside fetchData
    }
    return true;
  }

  getSavings() async {
    // print("rentController.rent");
    await rentController.fetchRent().then((value) {
      // if (userController.userModel!.userDetails![0].hasRent == true) {
      if (rentController.rentModel!.rents!.isNotEmpty) {
        // rentBalance += rentController.rentModel!.rent![0].paidAmount;
        // targetBalance += rentController.rentModel!.rent![0].amount;
        for (int j = 0; j < rentController.rentModel!.rents!.length; j++) {
          setState(() {
            rentBalance += rentController.rentModel!.rents![j].paidAmount;
          });
        }
      }
      // }
      else {
        setState(() {
          rentBalance = 0;
        });
      }
    });
  }

  Future<void> setTransationPin() async {
    await Future.delayed(const Duration(seconds: 1));
    if (userController.userModel!.userDetails![0].isPinSet == true) {
      // Get.to(TransactionPin());
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TransactionPin()),
        );
      }
    }
  }

  @override
  initState() {
    super.initState();
    // setTransationPin();
    setState(() {
      rentBalance = 0;
    });
    fetchUserData();
    // print(userController.userModel!.userDetails![0].firstName);
    selectedIndex = rentspaceProducts[0];
    getSavings();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // final notification = message.notification?.title ?? 'No Title';
      userController.fetchData();
      walletController.fetchWallet();
      rentController.fetchRent();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // final notification = message.notification?.title ?? 'No Title';
      // context.read().addNotification(notification);
      userController.fetchData();
      walletController.fetchWallet();
      rentController.fetchRent();
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        userController.fetchData();
        walletController.fetchWallet();
        rentController.fetchRent();
        // final notification = message.notification?.title ?? 'No Title';
      }
    });

    getConnectivity();
    // print("isLoading");
    hideBalance = false;
    // print(userController.isLoading.value);

    greeting();
    // _fetchNews();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            // showDialogBox();
            if (mounted) {
              noInternetConnectionScreen(context);
            }
            setState(() => isAlertSet = true);
          }
        },
      );

  Future<void> onRefresh() async {
    refreshController.refreshCompleted();
    // if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
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
    print(MediaQuery.of(context).size.height);
    // print('nextWithdrawalDate');
    // print(walletController.walletModel!.wallet![0].nextWithdrawalDate != '');
    // final data = ref.watch(userProfileDetailsProvider);
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // double sliderHeight = sliderDynamicScreen(screenHeight);
    return Scaffold(
      backgroundColor: brandOne,
      body: Obx(
        () => LiquidPullToRefresh(
          height: 100,
          animSpeedFactor: 2,
          color: brandOne,
          backgroundColor: Colors.white,
          showChildOpacityTransition: false,
          onRefresh: onRefresh,
          child: SafeArea(
            top: false,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: brandOne,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -30,
                        right: -50,
                        child: Image.asset(
                          'assets/logo_transparent.png',
                          width: 255.47,
                          height: 291.75,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              24.0.w,
                              0.0.h,
                              24.0.w,
                              0.0.h,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Hi, ${userController.userModel!.userDetails![0].firstName.obs}, $dum1",
                                              style: GoogleFonts.lato(
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.w500,
                                                color: colorWhite,
                                              ),
                                            ),
                                            Text(
                                              _greeting,
                                              style: GoogleFonts.lato(
                                                fontSize: 12.0,
                                                // letterSpacing: 1.0,
                                                fontWeight: FontWeight.w500,
                                                color: colorWhite,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(const ContactUsPage());
                                      },
                                      child: Image.asset(
                                        'assets/icons/message_icon.png',
                                        width: 24,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 23.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Space Wallet',
                                          style: GoogleFonts.lato(
                                            color: colorWhite,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              hideBalance = !hideBalance;
                                            });
                                          },
                                          child: Icon(
                                            hideBalance
                                                ? Iconsax.eye
                                                : Iconsax.eye_slash,
                                            color: colorWhite,
                                            size: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      hideBalance
                                          ? nairaFormaet
                                              .format((selectedIndex ==
                                                          rentspaceProducts[0]
                                                      ? walletController
                                                          .walletModel!
                                                          .wallet![0]
                                                          .mainBalance
                                                      : selectedIndex ==
                                                              rentspaceProducts[
                                                                  1]
                                                          ? rentBalance
                                                          : selectedIndex ==
                                                                  rentspaceProducts[
                                                                      2]
                                                              ? 0
                                                              : walletController
                                                                  .walletModel!
                                                                  .wallet![0]
                                                                  .mainBalance) ??
                                                  0)
                                              .toString()
                                          : "******",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                          color: colorWhite,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(const FundWallet());
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 39, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(
                                                      0x1A000000), // Color with 15% opacity
                                                  blurRadius: 19.0,
                                                  spreadRadius: -4.0,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.add_circle,
                                                  color: brandTwo,
                                                  size: 26,
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Text(
                                                  'Add Money ',
                                                  style: GoogleFonts.lato(
                                                    color: brandTwo,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 22.h,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: (screenHeight >= 1000)
                                ? MediaQuery.of(context).size.height / 1.2
                                : MediaQuery.of(context).size.height / 1.8,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                24.0.w,
                                0.0.h,
                                24.0.w,
                                0.0.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    'Quick Actions',
                                    style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: colorBlack),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.45,
                                              45),
                                          backgroundColor: colorWhite,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.to(const AirtimePage());
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/icons/call_icon.png',
                                                width: 24,
                                                height: 24,
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              Text(
                                                'Buy Airtime',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                  color: colorBlack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.45,
                                              45),
                                          backgroundColor: colorWhite,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.to(const SpaceRentCreation());
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/icons/space_rent.png',
                                                width: 24,
                                                height: 24,
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              Text(
                                                'New Space Rent',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                  color: colorBlack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Transactions',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: colorBlack,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(const AllActivities());
                                        },
                                        child: Text(
                                          'View All',
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: brandTwo,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  (userController.userModel!.userDetails![0]
                                          .walletHistories.isEmpty)
                                      ? SizedBox(
                                          height: 240,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Image.asset(
                                                'assets/icons/history_icon.png',
                                                height: 33.5.h,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: 180,
                                                  child: Text(
                                                    "Your transactions will be displayed here",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: colorBlack,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          child: Container(
                                            // height: 249,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: (userController
                                                          .userModel!
                                                          .userDetails![0]
                                                          .walletHistories
                                                          .length <
                                                      3)
                                                  ? userController
                                                      .userModel!
                                                      .userDetails![0]
                                                      .walletHistories
                                                      .length
                                                  : 3,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                int reversedIndex =
                                                    userController
                                                            .userModel!
                                                            .userDetails![0]
                                                            .walletHistories
                                                            .length -
                                                        1 -
                                                        index;
                                                final history = userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .walletHistories[index];

                                                final item = userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .walletHistories[index];
                                                final itemLength = item.length;

                                                bool showDivider = true;

                                                if (index <
                                                    userController
                                                            .userModel!
                                                            .userDetails![0]
                                                            .walletHistories
                                                            .length -
                                                        1) {
                                                  if ((itemLength == 1 &&
                                                          index % 2 == 0) ||
                                                      (itemLength == 2 &&
                                                          (index + 1) % 2 ==
                                                              0) ||
                                                      (itemLength >= 3 &&
                                                          (index + 1) % 3 ==
                                                              0)) {
                                                    showDivider = false;
                                                  }
                                                } else {
                                                  showDivider = false;
                                                }
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const TransactionReceipt(),
                                                        settings: RouteSettings(
                                                          arguments: userController
                                                                  .userModel!
                                                                  .userDetails![0]
                                                                  .walletHistories[
                                                              index],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      // const SizedBox(
                                                      //   height: 24,
                                                      // ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              flex: 7,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                // mainAxisAlignment:
                                                                //     MainAxisAlignment
                                                                //         .spaceBetween,
                                                                children: [
                                                                  Flexible(
                                                                    flex: 2,
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          12),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: (history['transactionType'] ==
                                                                                'Credit')
                                                                            ? brandTwo
                                                                            : brandTwo,
                                                                      ),
                                                                      child: (history['transactionType'] ==
                                                                              'Credit')
                                                                          ? const Icon(
                                                                              Icons.call_received,
                                                                              color: Color(0xff80FF00),
                                                                              size: 20,
                                                                            )
                                                                          : const Icon(
                                                                              Icons.arrow_outward_sharp,
                                                                              color: colorWhite,
                                                                              size: 20,
                                                                            ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          12),
                                                                  Flexible(
                                                                    flex: 8,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "${history['description'] ?? history['message'] ?? 'No Description Found'} "
                                                                              .capitalize!,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                colorBlack,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                5),
                                                                        Text(
                                                                          formatDateTime(
                                                                              history['createdAt']),
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                const Color(0xff4B4B4B),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 3,
                                                              child: (history[
                                                                          'transactionType'] ==
                                                                      'Credit')
                                                                  ? Text(
                                                                      "+ ${nairaFormaet.format(double.parse(history['amount'].toString()))}",
                                                                      style: GoogleFonts
                                                                          .lato(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: const Color(
                                                                            0xff56AB00),
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      nairaFormaet
                                                                          .format(
                                                                              double.parse(history['amount'].toString())),
                                                                      style: GoogleFonts
                                                                          .lato(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color:
                                                                            colorBlack,
                                                                      ),
                                                                    ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      if (showDivider)
                                                        const Divider(
                                                          thickness: 1,
                                                          color:
                                                              Color(0xffC9C9C9),
                                                          indent: 17,
                                                          endIndent: 17,
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),

                                  // SizedBox(
                                  //   height: 60.h,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    // valueNotifier.dispose();
    super.dispose();
  }

  String formatMongoDBDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    int day = date.day;
    String daySuffix;

    if (day >= 11 && day <= 13) {
      daySuffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          daySuffix = 'st';
          break;
        case 2:
          daySuffix = 'nd';
          break;
        case 3:
          daySuffix = 'rd';
          break;
        default:
          daySuffix = 'th';
      }
    }

    String month = DateFormat('MMMM').format(date);
    return '$day$daySuffix $month';
  }

  String formatDateTime(String dateTimeString) {
    // Parse the date string into a DateTime object
    DateTime dateTime =
        DateTime.parse(dateTimeString).add(const Duration(hours: 1));

    // Define the date format you want
    final DateFormat formatter = DateFormat('MMMM dd, yyyy hh:mm a');

    // Format the DateTime object into a string
    String formattedDateTime = formatter.format(dateTime);

    return formattedDateTime;
  }

  noInternetConnectionScreen(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
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
                          color: brandOne,
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
                          color: brandOne,
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
                          // Timer

                          // EasyLoading.show(
                          //   indicator: const CustomLoader(),
                          //   maskType: EasyLoadingMaskType.black,
                          //   dismissOnTap: false,
                          // );

                          // Navigator.pop(context, 'Cancel');
                          Navigator.pop(context);
                          // EasyLoading.dismiss();
                          setState(() => isAlertSet = false);
                          isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!isDeviceConnected && isAlertSet == false) {
                            // showDialogBox();
                            if (context.mounted) {
                              noInternetConnectionScreen(context);
                            }
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
}
