import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

import '../../api/wp-api.dart';
import '../../constants/utils/responsive_height.dart';
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
int currentPos = 0;

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double sliderHeight = sliderDynamicScreen(screenHeight);
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Obx(
        () => LiquidPullToRefresh(
          height: 100,
          animSpeedFactor: 2,
          color: brandOne,
          backgroundColor: Colors.white,
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
                                          .userModel!.userDetails![0].avatar,
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
                                          height: 30.h,
                                          width: 30.w,
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
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Text(
                                    _greeting,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.0.sp,
                                      // letterSpacing: 1.0,
                                      fontWeight: FontWeight.w500,
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
                        height: 15.h,
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
                                  padding: EdgeInsets.symmetric(vertical: 26.h),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Space Wallet",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16.sp,
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
                                              size: 18.sp,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Center(
                                        child: Container(
                                          // width: 280,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 5.h),

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
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 22.sp,
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
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                        fontSize: 14.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              userController.fetchData();
                                              walletController.fetchWallet();
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Iconsax.refresh,
                                              color: Colors.white,
                                              size: 18.sp,
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
                                            style: GoogleFonts.poppins(
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
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
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
                                          } else {}
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
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
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
                  // SizedBox(
                  //   height: 20.h,
                  // ),
                  SizedBox(
                    height: 15.h,
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
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(const FundWallet());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: brandOne,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 120.h, // Adjust height as needed
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -30,
                                  bottom: -30,
                                  child: Opacity(
                                    opacity: 0.2,
                                    child: Icon(
                                      Icons.add_circle,
                                      color: brandTwo,
                                      size: 120.sp,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 14.sp,
                                      top: 13.sp,
                                      bottom: 20.sp,
                                      right: 10.sp),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.sp,
                                                vertical: 7.sp),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Text(
                                              'Add Money',
                                              style: GoogleFonts.poppins(
                                                color: brandOne,
                                                fontSize: 13.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Top up your wallet for seamless transactions!',
                                            // overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                                fontSize: 12.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
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
                      const SizedBox(width: 10), // Adjust spacing between boxes
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(const TransferPage());
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: brandTwo,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 120.h, // Adjust height as needed
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 14, top: 13, bottom: 20, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.sp,
                                                vertical: 7.sp),
                                            decoration: BoxDecoration(
                                              color: brandOne,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Text(
                                              'Transfer Now',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 13.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Transfer your funds with ease and security.',
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                                fontSize: 12.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -25,
                                bottom: -25,
                                child: Opacity(
                                  opacity: 0.2,
                                  child: Icon(
                                    Iconsax.empty_wallet_remove,
                                    color: brandOne,
                                    size: 120.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                          height: 10.h,
                        ),
                        InkWell(
                          onTap: () {
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.error(
                                backgroundColor: brandOne,
                                message: 'Coming Soon :)',
                                textStyle: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding:
                                EdgeInsets.fromLTRB(20.sp, 10.sp, 20.sp, 20.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: brandTwo,
                            ),
                            child: 
                            // const Row(
                            //   children: [
                            //     Flexible(
                            //       flex: 2,
                            //       child: Icon(Icons.share),
                            //     ),
                            //     Flexible(
                            //       flex: 10,
                            //       child: Text(
                            //           'Refer Your Friends and Earnjfjsdjgbfdfsjgdfkndfsvkjvfbgfnkdbsvskfbgfnkdsvkfjbgfndlsvfdlgfnbdlbklgfndlkblkgdklfbklgf'),
                            //     ),
                            //   ],
                            // ),
                            Column(
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
                                            style: GoogleFonts.poppins(
                                              fontSize: 16.0.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          Text(
                                            "View the amazing community\nof other Spacers!",
                                            style: GoogleFonts.poppins(
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
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     "Blog Section",
                        //     textAlign: TextAlign.left,
                        //     style: GoogleFonts.poppins(
                        //         color: brandOne, fontSize: 15.sp),
                        //   ),
                        // ),
                        // Container(
                        //   height: 250.h,
                        //   child: FutureBuilder(
                        //     future: fetchWpPosts(),
                        //     builder: (context, AsyncSnapshot snapshot) {
                        //       if (snapshot.hasData) {
                        //         return CarouselSlider.builder(
                        //           itemCount: snapshot.data.length,
                        //           itemBuilder: (context, index, realIndex) {
                        //             Map wppost = snapshot.data[index];
                        //             var imageurl = wppost['_embedded']
                        //                 ['wp:featuredmedia'][0]['source_url'];
                        //             return Padding(
                        //               padding: const EdgeInsets.only(
                        //                   top: 10, left: 0, right: 0),
                        //               child: InkWell(
                        //                 onTap: () {},
                        //                 child: Column(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.start,
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: [
                        //                     Stack(
                        //                       children: [
                        //                         ClipRRect(
                        //                           borderRadius:
                        //                               BorderRadius.circular(
                        //                                   10.0),
                        //                           child: CachedNetworkImage(
                        //                             width: 160
                        //                                 .w, // Adjust the width as needed
                        //                             height: 160
                        //                                 .h, // Adjust the height as needed
                        //                             imageUrl: imageurl ?? '',
                        //                             fit: BoxFit.cover,
                        //                             placeholder:
                        //                                 (context, url) {
                        //                               return Container(
                        //                                 width:
                        //                                     100, // Adjust the width as needed
                        //                                 height:
                        //                                     100, // Adjust the height as needed
                        //                                 child: CustomLoader(),
                        //                               );
                        //                             },
                        //                             errorWidget:
                        //                                 (context, url, error) =>
                        //                                     Container(
                        //                               width:
                        //                                   100, // Adjust the width as needed
                        //                               height:
                        //                                   100, // Adjust the height as needed
                        //                               child: Image.asset(
                        //                                   'assets/images/logo_full.png'),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                     Padding(
                        //                       padding:
                        //                           const EdgeInsets.symmetric(
                        //                         horizontal: 0.0,
                        //                       ),
                        //                       child: Column(
                        //                         children: [
                        //                           Padding(
                        //                             padding:
                        //                                 const EdgeInsets.only(
                        //                               right: 10,
                        //                             ),
                        //                             child: Html(
                        //                                 style: {
                        //                                   "body": Style(
                        //                                       padding:
                        //                                           HtmlPaddings
                        //                                               .zero,
                        //                                       margin:
                        //                                           Margins.zero,
                        //                                       textOverflow:
                        //                                           TextOverflow
                        //                                               .clip,
                        //                                       maxLines: 2,
                        //                                       fontFamily:
                        //                                           "Poppins",
                        //                                       fontSize: screenWidth >
                        //                                               400
                        //                                           ? FontSize
                        //                                               .small
                        //                                           : FontSize
                        //                                               .smaller,
                        //                                       fontWeight:
                        //                                           FontWeight
                        //                                               .w500,
                        //                                       color: brandOne),
                        //                                 },
                        //                                 data: wppost['title']
                        //                                     ['rendered']),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //           options: CarouselOptions(
                        //             onPageChanged: ((index, reason) {
                        //               setState(() {
                        //                 currentPos = index;
                        //               });
                        //             }),
                        //             autoPlay: true,
                        //             height: sliderHeight + 50,
                        //             enlargeCenterPage: false,
                        //             viewportFraction: 0.5,
                        //           ),
                        //         );

                        //       }
                        //       return CustomLoader();
                        //     },
                        //   ),
                        // ),
                     
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
}
