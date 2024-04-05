import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
import 'package:rentspace/constants/widgets/custom_loader.dart';
// import 'package:rentspace/controller/activities_controller.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
import 'package:rentspace/controller/wallet_controller.dart';
import 'package:rentspace/model/user_details_model.dart';
import 'package:rentspace/view/actions/fund_wallet.dart';

import 'package:rentspace/view/dashboard/all_activities.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentspace/view/dashboard/settings.dart';
import 'package:rentspace/view/dashboard/transfer.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/widgets/custom_dialog.dart';
// import '../../controller/settings_controller.dart';
import '../../constants/widgets/icon_container.dart';
import '../../core/helper/helper_route_path.dart';
import '../actions/onboarding_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

final hasFeedsStorage = GetStorage();
int id = 0;

String _greeting = "";
bool _hasReferred = false;
String referalCode = "";
int referalCount = 0;
int userReferal = 0;
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
String _isSet = "false";
var dum1 = "".obs;
String previousAnnouncementText = '';
bool hideBalance = false;

class _DashboardConsumerState extends ConsumerState<Dashboard> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  String? fullName = '';
  List<UserDetailsModel> userInfo = [];
// String? fullName = '';
  // List<WalletModel> wallet_info = [];
  bool isAlertSet = false;
  bool isRefresh = false;

  final form = intl.NumberFormat.decimalPattern();
  bool isContainerVisible = true;
  // List<dynamic> _articles = [];
  greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      setState(() {
        _greeting = 'Good morning 🌅 ';
      });
    } else if (hour < 17) {
      setState(() {
        _greeting = 'Good Afternoon 🕑';
      });
    } else {
      setState(() {
        _greeting = 'Good evening 🌙 ';
      });
    }
  }
  @override
  initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // final notification = message.notification?.title ?? 'No Title';
      userController.fetchData();
      walletController.fetchWallet();
      rentController.fetchRent();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification?.title ?? 'No Title';
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
    print("isLoading");
    hideBalance = false;
    print(userController.isLoading.value);

    greeting();
    // _fetchNews();
  }


  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            // showDialogBox();
            noInternetConnectionScreen(context);
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
  }


  @override
  Widget build(BuildContext context) {
    // final data = ref.watch(userProfileDetailsProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,

      body: Obx(
        () =>
           
            LiquidPullToRefresh(
          height: 70,
          animSpeedFactor: 2,
          color: Colors.white,
          backgroundColor: brandOne,
          showChildOpacityTransition: false,
          onRefresh: onRefresh,
          child: SafeArea(
            child: Padding(
              //padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              padding: EdgeInsets.fromLTRB(
                20.0.w,
                0.0.h,
                20.0.w,
                0.0.h,
              ),
              child: ListView(
                children: [
                  Column(
                    children: [
                      // SizedBox(
                      //   height: 30.h,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(const SettingsPage());
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.sp),
                                    child: CachedNetworkImage(
                                      imageUrl: userController
                                          .userModel!.userDetails![0].avatar
                                          .obs(),
                                      height: 40.h,
                                      width: 40.w,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return Image.asset(
                                          'assets/icons/RentSpace-icon.png',
                                          height: 40.h,
                                          width: 40.w,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                          'assets/icons/RentSpace-icon.png',
                                          height: 40.h,
                                          width: 40.w,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      // progressIndicatorBuilder:
                                      //     (context, url, progress) {
                                      //   return const CircularProgressIndicator();
                                      // },
                                    ),
                                    // Image.network(
                                    //   userInfo[0].image,
                                    //   height: 40,
                                    //   width: 40,
                                    //   fit: BoxFit.fill,
                                    // ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi, ${userController.userModel!.userDetails![0].firstName.obs}👋 $dum1",
                                    style: GoogleFonts.nunito(
                                      fontSize: 20.0.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                
                                  Text(
                                    _greeting,
                                    style: GoogleFonts.nunito(
                                      fontSize: 16.0.sp,
                                      // letterSpacing: 1.0,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(const AllActivities());
                            },
                            child: Icon(
                              Icons.history_sharp,
                              color: Theme.of(context).primaryColor,
                              size: 24.sp,
                            ),
                          ),
                      
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: (userController.userModel!.userDetails![0].hasDva
                                    .obs() ==
                                true)
                            ? Container(
                                decoration: BoxDecoration(
                                    color: brandOne,
                                    borderRadius: BorderRadius.circular(20.sp)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.h),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Space Wallet",
                                            style: GoogleFonts.nunito(
                                              color: Colors.white,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                hideBalance = !hideBalance;
                                              });
                                            },
                                            child: Icon(
                                              hideBalance
                                                  ? Icons
                                                      .visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                              color: Colors.white,
                                              size: 18.sp,
                                            ),
                                          )
                                        ],
                                      ),
                                     
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Center(
                                        child: Container(
                                          // width: 280,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 10.h),

                                          child: (walletController
                                                  .isLoading.value)
                                              ? const CustomLoader()
                                              : Text(
                                                  hideBalance
                                                      ? nairaFormaet
                                                          .format(walletController
                                                                  .walletModel!
                                                                  .wallet![0]
                                                                  .mainBalance ??
                                                              0)
                                                          .toString()
                                                      : "******",
                                                  style: GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 25.sp,
                                                      color: Colors.white),
                                                ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(const FundWallet());
                                            },
                                            child: Container(
                                              height: 40.h,
                                              width: 140.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        35.sp),
                                                color:
                                                    brandTwo.withOpacity(0.3),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add_circle,
                                                    size: 14.sp,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    'Add Money',
                                                    style: GoogleFonts.nunito(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white,
                                                        fontSize: 14.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              userController.fetchData();
                                              walletController.fetchWallet();
                                              setState(() {});
                                            },
                                            child: const Icon(
                                              Iconsax.refresh,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                width: 420.w,
                                height: 230.h,
                                decoration: BoxDecoration(
                                    color: brandTwo,
                                    image: DecorationImage(
                                      image: const AssetImage(
                                        "assets/card.jpg",
                                      ),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.white.withOpacity(
                                            0.5), // Adjust the opacity here
                                        BlendMode.darken,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(20.sp)),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 24.h),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Space Wallet',
                                            style: GoogleFonts.nunito(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                hideBalance = !hideBalance;
                                              });
                                            },
                                            child: Icon(
                                              hideBalance
                                                  ? Icons
                                                      .visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                              color: Colors.white,
                                              size: 27.sp,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Center(
                                        child: Container(
                                          // width: 280,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 10.h),
                                          decoration: BoxDecoration(
                                            color: brandFour,
                                            borderRadius:
                                                BorderRadius.circular(10.sp),
                                          ),
                                          child: Text(
                                            " ${hideBalance ? nairaFormaet.format(userController.userModel!.userDetails![0].wallet.mainBalance).toString() : "********"}",
                                            style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 25.sp,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25.h,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (userController.userModel!
                                                  .userDetails![0].bvn ==
                                              "") {
                                            Get.to(BvnPage(
                                                email: userController.userModel!
                                                    .userDetails![0].email));
                                          } else {
                                          
                                          }
                                        },
                                        child: Container(
                                          height: 61.h,
                                          width: 210.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35.sp),
                                            color: brandTwo.withOpacity(0.3),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Setup Wallet',
                                                style: GoogleFonts.nunito(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    fontSize: 20.sp),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Icon(
                                                Icons.add_circle,
                                                size: 30.sp,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: brandTwo.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0.h, horizontal: 20.0.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconsContainer(
                                IconsName: 'Airtime',
                                icon: Iconsax.mobile5,
                                iconColor: brandOne,
                                onTap: () {
                                  // Navigator.push(context, route)

                                  Navigator.pushNamed(context, airtime);
                                },
                              ),
                              IconsContainer(
                                IconsName: 'Data',
                                icon: Icons.wifi,
                                iconColor: brandOne,
                                onTap: () {
                                  Navigator.pushNamed(context, dataBundle);
                                },
                              ),
                              IconsContainer(
                                IconsName: 'Cable',
                                icon: Icons.tv_rounded,
                                iconColor: brandOne,
                                onTap: () {
                                  Navigator.pushNamed(context, cable);
                                },
                              ),
                              IconsContainer(
                                IconsName: 'Electricity',
                                icon: Iconsax.electricity,
                                iconColor: brandOne,
                                onTap: () {
                                  Navigator.pushNamed(context, electricity);
                                  // Navigator.pushNamed(context, RouteList.pay_bills);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20.h,
                  ),
             
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    width: 400.w,
                    height: 225.sp,
                    decoration: BoxDecoration(
                      color: brandOne,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 24.h, horizontal: 24.w),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/iconset/uil_money-withdrawal.png',
                                width: 30.w,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                'Transfer Your Funds',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 14.h,
                          ),
                          Text(
                            'Your security matters. Transfer with confidence knowing your transactions are encrypted and secure.',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              (userController.userModel!.userDetails![0].wallet
                                          .mainBalance >
                                      0)
                                  ?
                                  //  Get.to(
                                  //     TransactionReceipt())
                                  Get.to(const TransferPage())
                                  : customErrorDialog(
                                      context,
                                      'Wallet Empty! :)',
                                      'You need to fund your wallet first!',
                                    );
                            },
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                height: 49.h,
                                width: 180.w,
                                decoration: BoxDecoration(
                                  color: brandTwo,
                                  borderRadius: BorderRadius.circular(30.sp),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/iconset/uil_money-withdrawal.png',
                                      width: 24.w,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      'Transfer Now',
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: 400.w,
                    height: 225.sp,
                    decoration: BoxDecoration(
                      color: brandTwo,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 24.h, horizontal: 24.w),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/iconset/fundwallet.png',
                                width: 30.sp,
                                color: brandOne,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                'Top Up Your Wallet',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 14.h,
                          ),
                          Text(
                            'Top up your wallet for seamless transactions! Add funds now and enjoy a hassle-free experience.',
                            style: GoogleFonts.nunito(
                              color: brandOne,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(const FundWallet());

                             },
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                height: 49.h,
                                width: 150.w,
                                decoration: BoxDecoration(
                                  color: brandOne,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/iconset/fundwallet.png',
                                      width: 20.sp,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      'Fund Now',
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        InkWell(
                          onTap: () {
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.error(
                                backgroundColor: brandOne,
                                message: 'Coming Soon :)',
                                textStyle: GoogleFonts.nunito(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: brandTwo,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/community.png',
                                        width: 28.w,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "RentSpace community",
                                            style: GoogleFonts.nunito(
                                              fontSize: 18.0.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          Text(
                                            "View the amazing community\nof other Spacers!",
                                            style: GoogleFonts.nunito(
                                                fontSize: 12.0.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
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
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                      style: GoogleFonts.nunito(
                          color: brandOne,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          color: brandOne,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context, 'Cancel');
                        setState(() => isAlertSet = false);
                        isDeviceConnected =
                            await InternetConnectionChecker().hasConnection;
                        if (!isDeviceConnected && isAlertSet == false) {
                          // showDialogBox();
                          noInternetConnectionScreen(context);
                          setState(() => isAlertSet = true);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: brandOne,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Align(
                            child: Text(
                              'Try Again',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
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
