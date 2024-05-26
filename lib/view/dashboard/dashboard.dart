// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
import 'package:rentspace/view/actions/contact_us.dart';
import 'package:rentspace/view/actions/fund_wallet.dart';
import 'package:rentspace/view/dashboard/all_activities.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:rentspace/view/dashboard/settings.dart';
import 'package:rentspace/view/dashboard/transfer.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// import '../../api/wp-api.dart';
// import '../../constants/utils/responsive_height.dart';
// import '../../constants/widgets/custom_dialog.dart';
// import '../../controller/settings_controller.dart';
import '../../constants/widgets/icon_container.dart';
import '../../core/helper/helper_route_path.dart';
// import '../actions/onboarding_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../actions/transaction_receipt.dart';
import '../actions/transaction_receipt_dva.dart';
import '../actions/transaction_receipt_transfer.dart';

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
    if (refresh) {
      await userController.fetchData();
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

  @override
  initState() {
    super.initState();
    rentBalance = 0;
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
    // final data = ref.watch(userProfileDetailsProvider);
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    // double sliderHeight = sliderDynamicScreen(screenHeight);
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),
      body: Obx(
        () => LiquidPullToRefresh(
          height: 100,
          animSpeedFactor: 2,
          color: brandTwo,
          backgroundColor: Colors.white,
          showChildOpacityTransition: false,
          onRefresh: onRefresh,
          child: SafeArea(
            child: Padding(
              //padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              padding: EdgeInsets.fromLTRB(
                24.0.w,
                0.0.h,
                24.0.w,
                0.0.h,
              ),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     Get.to(const SettingsPage());
                              //   },
                              //   child: CircleAvatar(
                              //     backgroundColor: Colors.transparent,
                              //     child: ClipRRect(
                              //       borderRadius: BorderRadius.circular(50),
                              //       child: CachedNetworkImage(
                              //         imageUrl: userController
                              //             .userModel!.userDetails![0].avatar,
                              //         height: 40.h,
                              //         width: 40.w,
                              //         fit: BoxFit.cover,
                              //         placeholder: (context, url) {
                              //           return Image.asset(
                              //             'assets/icons/RentSpace-icon.png',
                              //             height: 40.h,
                              //             width: 40.w,
                              //             fit: BoxFit.cover,
                              //           );
                              //         },
                              //         errorWidget: (context, url, error) {
                              //           return Image.asset(
                              //             'assets/icons/RentSpace-icon.png',
                              //             height: 30.h,
                              //             width: 30.w,
                              //             fit: BoxFit.cover,
                              //           );
                              //         },
                              //         // progressIndicatorBuilder:
                              //         //     (context, url, progress) {
                              //         //   return const CircularProgressIndicator();
                              //         // },
                              //       ),
                              //       // Image.network(
                              //       //   userInfo[0].image,
                              //       //   height: 40,
                              //       //   width: 40,
                              //       //   fit: BoxFit.fill,
                              //       // ),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   width: 10.w,
                              // ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi, ${userController.userModel!.userDetails![0].firstName.obs}, $dum1",
                                    style: GoogleFonts.lato(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w500,
                                      color: colorBlack,
                                    ),
                                  ),
                                  Text(
                                    _greeting,
                                    style: GoogleFonts.lato(
                                      fontSize: 12.0,
                                      // letterSpacing: 1.0,
                                      fontWeight: FontWeight.w500,
                                      color: colorBlack,
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
                        height: 15.h,
                      ),
                      (rentController.isLoading.value.obs() == true &&
                              walletController.isLoading.value.obs() == true)
                          ? const CustomLoader()
                          : SizedBox(
                              height: 20,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: rentspaceProducts.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex =
                                              rentspaceProducts[index];
                                        });
                                        if (selectedIndex == 'Space Deposit') {
                                          showTopSnackBar(
                                            Overlay.of(context),
                                            CustomSnackBar.error(
                                              backgroundColor: brandOne,
                                              message: 'Coming Soon :)',
                                              textStyle: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        }
                                        // print(selectedIndex);
                                        // Handle tap event
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: colorWhite,
                                        ),
                                        child: Center(
                                          child: Text(
                                            rentspaceProducts[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: (selectedIndex ==
                                                      rentspaceProducts[index])
                                                  ? brandOne
                                                  : const Color(0xff9DA6AD),
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //                       selectedIndex == 'Space Wallet'
                          // ? 'Show this for Space Wallet'
                          // : selectedIndex == 'Space Rent'
                          //     ? 'Show this for Space Rent'
                          //     : selectedIndex == 'Space Deposit'
                          //         ? 'Show this for Space Deposit'
                          //         : 'Nothing'
                          Text(
                            hideBalance
                                ? nairaFormaet
                                    .format(
                                        (selectedIndex == rentspaceProducts[0]
                                                ? walletController.walletModel!
                                                    .wallet![0].mainBalance
                                                : selectedIndex ==
                                                        rentspaceProducts[1]
                                                    ? rentBalance
                                                    : selectedIndex ==
                                                            rentspaceProducts[2]
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
                                color: (selectedIndex == rentspaceProducts[0]
                                    ? brandOne
                                    : selectedIndex == rentspaceProducts[1]
                                        ? Colors.green
                                        : selectedIndex == rentspaceProducts[2]
                                            ? const Color(0xff1CC2CD)
                                            : brandOne),
                                fontSize: 40,
                                fontWeight: FontWeight.w600),
                          ),

                          (selectedIndex == rentspaceProducts[0])
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      hideBalance = !hideBalance;
                                    });
                                  },
                                  child: Icon(
                                    hideBalance
                                        ? Iconsax.eye4
                                        : Iconsax.eye_slash5,
                                    color: colorBlack,
                                    size: 24,
                                  ),
                                )
                              : (selectedIndex == rentspaceProducts[1])
                                  ? Image.asset(
                                      'assets/icons/house_icon.png',
                                      color: const Color(0xff105182),
                                      width: 24,
                                    )
                                  : (selectedIndex == rentspaceProducts[2])
                                      ? Image.asset(
                                          'assets/icons/lock_icon.png',
                                          color: const Color(0xff105182),
                                          width: 24,
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              hideBalance = !hideBalance;
                                            });
                                          },
                                          child: Icon(
                                            hideBalance
                                                ? Iconsax.eye4
                                                : Iconsax.eye_slash5,
                                            color: colorBlack,
                                            size: 24,
                                          ),
                                        ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(const TransferPage());
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 7),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(10),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.swap_horizontal_circle,
                                      color: brandTwo,
                                      size: 26,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      'Send Money',
                                      style: GoogleFonts.lato(
                                        color: brandTwo,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                              width: 10), // Adjust spacing between boxes
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(const FundWallet());
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 7),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(10),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                          ),
                        ],
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 10),
                      //   child: (userController.userModel!.userDetails![0].hasDva
                      //               .obs() ==
                      //           true)
                      //       ? Container(
                      //           decoration: BoxDecoration(
                      //             color: brandOne,
                      //             borderRadius: BorderRadius.circular(20),
                      //           ),
                      //           child: Padding(
                      //             padding: EdgeInsets.symmetric(vertical: 26.h),
                      //             child: Column(
                      //               children: [
                      //                 Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   children: [
                      //                     Text(
                      //                       "Space Wallet",
                      //                       style: GoogleFonts.lato(
                      //                         color: Colors.white,
                      //                         fontSize: 16,
                      //                         fontWeight: FontWeight.w500,
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: 5.w,
                      //                     ),
                      //                     GestureDetector(
                      //                       onTap: () {
                      //                         setState(() {
                      //                           hideBalance = !hideBalance;
                      //                         });
                      //                       },
                      //                       child: Icon(
                      //                         hideBalance
                      //                             ? Icons
                      //                                 .visibility_off_outlined
                      //                             : Icons.visibility_outlined,
                      //                         color: Colors.white,
                      //                         size: 18,
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //                 SizedBox(
                      //                   height: 3.h,
                      //                 ),
                      //                 Center(
                      //                   child: Container(
                      //                     // width: 280,
                      //                     padding: EdgeInsets.symmetric(
                      //                         horizontal: 20.w, vertical: 5.h),

                      //                     child: (walletController
                      //                             .isLoading.value)
                      //                         ? const CustomLoader()
                      //                         : Text(
                      //                             hideBalance
                      //                                 ? nairaFormaet
                      //                                     .format(walletController
                      //                                             .walletModel!
                      //                                             .wallet![0]
                      //                                             .mainBalance ??
                      //                                         0)
                      //                                     .toString()
                      //                                 : "******",
                      //                             style: GoogleFonts.roboto(
                      //                                 fontWeight:
                      //                                     FontWeight.w600,
                      //                                 fontSize: 22,
                      //                                 color: Colors.white),
                      //                           ),
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 5.h,
                      //                 ),
                      //                 Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.center,
                      //                   children: [
                      //                     GestureDetector(
                      //                       onTap: () {
                      //                         Get.to(const FundWallet());
                      //                       },
                      //                       child: Container(
                      //                         height: 40.h,
                      //                         width: 140.w,
                      //                         decoration: BoxDecoration(
                      //                           borderRadius:
                      //                               BorderRadius.circular(
                      //                                   35),
                      //                           color:
                      //                               brandTwo.withOpacity(0.3),
                      //                         ),
                      //                         child: Row(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment.center,
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.center,
                      //                           children: [
                      //                             Icon(
                      //                               Icons.add_circle,
                      //                               size: 14,
                      //                               color: Colors.white,
                      //                             ),
                      //                             SizedBox(
                      //                               width: 5.w,
                      //                             ),
                      //                             Text(
                      //                               'Add Money',
                      //                               style: GoogleFonts.lato(
                      //                                   fontWeight:
                      //                                       FontWeight.w500,
                      //                                   color: Colors.white,
                      //                                   fontSize: 14),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: 10.w,
                      //                     ),
                      //                     GestureDetector(
                      //                       onTap: () {
                      //                         userController.fetchData();
                      //                         walletController.fetchWallet();
                      //                         setState(() {});
                      //                       },
                      //                       child: Icon(
                      //                         Iconsax.refresh,
                      //                         color: Colors.white,
                      //                         size: 18,
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         )
                      //       : Container(
                      //           width: 420.w,
                      //           height: 230.h,
                      //           decoration: BoxDecoration(
                      //               color: brandTwo,
                      //               image: DecorationImage(
                      //                 image: const AssetImage(
                      //                   "assets/card.jpg",
                      //                 ),
                      //                 fit: BoxFit.cover,
                      //                 colorFilter: ColorFilter.mode(
                      //                   Colors.white.withOpacity(
                      //                       0.5), // Adjust the opacity here
                      //                   BlendMode.darken,
                      //                 ),
                      //               ),
                      //               borderRadius: BorderRadius.circular(20)),
                      //           child: Padding(
                      //             padding: EdgeInsets.only(top: 24.h),
                      //             child: Column(
                      //               children: [
                      //                 Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   children: [
                      //                     Text(
                      //                       'Space Wallet',
                      //                       style: GoogleFonts.lato(
                      //                         color: Colors.white,
                      //                         fontSize: 20,
                      //                         fontWeight: FontWeight.w500,
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: 5.w,
                      //                     ),
                      //                     GestureDetector(
                      //                       onTap: () {
                      //                         setState(() {
                      //                           hideBalance = !hideBalance;
                      //                         });
                      //                       },
                      //                       child: Icon(
                      //                         hideBalance
                      //                             ? Icons
                      //                                 .visibility_off_outlined
                      //                             : Icons.visibility_outlined,
                      //                         color: Colors.white,
                      //                         size: 27,
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //                 SizedBox(
                      //                   height: 15.h,
                      //                 ),
                      //                 Center(
                      //                   child: Container(
                      //                     // width: 280,
                      //                     padding: EdgeInsets.symmetric(
                      //                         horizontal: 20.w, vertical: 10.h),
                      //                     decoration: BoxDecoration(
                      //                       color: brandFour,
                      //                       borderRadius:
                      //                           BorderRadius.circular(10),
                      //                     ),
                      //                     child: Text(
                      //                       " ${hideBalance ? nairaFormaet.format(userController.userModel!.userDetails![0].wallet.mainBalance).toString() : "********"}",
                      //                       style: GoogleFonts.roboto(
                      //                           fontWeight: FontWeight.w600,
                      //                           fontSize: 25,
                      //                           color: Colors.white),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 25.h,
                      //                 ),
                      //                 GestureDetector(
                      //                   onTap: () {
                      //                     if (userController.userModel!
                      //                             .userDetails![0].bvn ==
                      //                         "") {
                      //                       Get.to(BvnPage(
                      //                           email: userController.userModel!
                      //                               .userDetails![0].email));
                      //                     } else {}
                      //                   },
                      //                   child: Container(
                      //                     height: 61.h,
                      //                     width: 210.w,
                      //                     decoration: BoxDecoration(
                      //                       borderRadius:
                      //                           BorderRadius.circular(35),
                      //                       color: brandTwo.withOpacity(0.3),
                      //                     ),
                      //                     child: Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.center,
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.center,
                      //                       children: [
                      //                         Text(
                      //                           'Setup Wallet',
                      //                           style: GoogleFonts.lato(
                      //                               fontWeight: FontWeight.w500,
                      //                               color: Colors.white,
                      //                               fontSize: 20),
                      //                         ),
                      //                         SizedBox(
                      //                           width: 10.w,
                      //                         ),
                      //                         Icon(
                      //                           Icons.add_circle,
                      //                           size: 30,
                      //                           color: Colors.white,
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      // ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 20.h,
                  // ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Quick Payment',
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorBlack),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 80.w,
                        height: 80.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: IconsContainer(
                            IconsName: 'Airtime',
                            icon: Iconsax.call5,
                            iconColor: brandOne,
                            onTap: () {
                              Navigator.pushNamed(context, airtime);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80.w,
                        height: 80.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: IconsContainer(
                            IconsName: 'Data',
                            icon: Icons.wifi,
                            iconColor: brandOne,
                            onTap: () {
                              Navigator.pushNamed(context, dataBundle);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80.w,
                        height: 80.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: IconsContainer(
                            IconsName: 'Cable',
                            icon: Icons.tv_rounded,
                            iconColor: brandOne,
                            onTap: () {
                              Navigator.pushNamed(context, cable);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80.w,
                        height: 80.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: IconsContainer(
                              IconsName: 'Electricity',
                              icon: Icons.lightbulb_sharp,
                              iconColor: brandOne,
                              onTap: () {
                                Navigator.pushNamed(context, electricity);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
                            fontWeight: FontWeight.w600,
                            color: brandTwo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    height: userController.userModel!.userDetails![0]
                                .walletHistories.length <
                            3
                        ? userController.userModel!.userDetails![0]
                                .walletHistories.length *
                            80
                        : 240.h,
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: (userController
                            .userModel!.userDetails![0].walletHistories.isEmpty)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.asset(
                                'assets/card_empty.png',
                                height: 150.h,
                              ),
                              Center(
                                child: Text(
                                  "No Transaction history",
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: (userController
                                        .userModel!
                                        .userDetails![0]
                                        .walletHistories
                                        .length <
                                    3)
                                ? userController.userModel!.userDetails![0]
                                        .walletHistories.length -
                                    1
                                : 3,
                            itemBuilder: (BuildContext context, int index) {
                              int reversedIndex = userController.userModel!
                                      .userDetails![0].walletHistories.length -
                                  1 -
                                  index;
                              // Access the activities in reverse order
                              final history = userController
                                  .userModel!
                                  .userDetails![0]
                                  .walletHistories[reversedIndex];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    (history['transactionGroup']
                                                .toString()
                                                .toLowerCase() ==
                                            'transfer')
                                        ? TransactionReceiptTransfer(
                                            amount: history['amount'],
                                            status: history['status'],
                                            fees: history['fees'] ?? 0,
                                            transactionType:
                                                history['transactionType'],
                                            description: history['description'],
                                            transactionGroup:
                                                history['transactionGroup'],
                                            transactionDate:
                                                history['createdAt'],
                                            transactionRef: history[
                                                    'transactionReference'] ??
                                                '',
                                            merchantRef:
                                                history['merchantReference'],
                                            // sessionId: history['sessionId'] ?? '',
                                          )
                                        : (history['transactionGroup']
                                                    .toString()
                                                    .toLowerCase() ==
                                                'static-account-transfer')
                                            ? TransactionReceiptDVA(
                                                amount: history['amount'],
                                                status: history['status'],
                                                fees: history['fees'] ?? 0,
                                                transactionType:
                                                    history['transactionType'],
                                                description:
                                                    history['description'],
                                                transactionGroup:
                                                    history['transactionGroup'],
                                                transactionDate:
                                                    history['createdAt'],
                                                transactionRef: history[
                                                        'transactionReference'] ??
                                                    '',
                                                merchantRef: history[
                                                    'merchantReference'],
                                                remarks: history['remarks'],
                                              )
                                            : TransactionReceipt(
                                                amount: history['amount'],
                                                status: history['status'],
                                                fees: history['fees'] ?? 0,
                                                transactionType:
                                                    history['transactionType'],
                                                description:
                                                    history['description'],
                                                transactionGroup:
                                                    history['transactionGroup'],
                                                transactionDate:
                                                    history['createdAt'],
                                                transactionRef: history[
                                                        'transactionReference'] ??
                                                    '',
                                                merchantRef: history[
                                                    'merchantReference'],
                                              ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (history['transactionType'] ==
                                                  'Credit')
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        child: (history['transactionType'] ==
                                                'Credit')
                                            ? Icon(
                                                Icons.call_received,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              )
                                            : Icon(
                                                Icons.arrow_outward_sharp,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${history['description']} ",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        formatDateTime(history['createdAt']),
                                        style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          (history['transactionType'] ==
                                                  'Credit')
                                              ? Text(
                                                  "+ ${nairaFormaet.format(double.parse(history['amount'].toString()))}",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: brandOne,
                                                  ),
                                                )
                                              : Text(
                                                  "- ${nairaFormaet.format(double.parse(history['amount'].toString()))}",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: brandOne,
                                                  ),
                                                ),
                                          (history['status']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'completed')
                                              ? Text(
                                                  'Successful',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green,
                                                  ),
                                                )
                                              : (history['status']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'failed')
                                                  ? Text(
                                                      'Failed',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  : Text(
                                                      'Pending',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors.yellow[800],
                                                      ),
                                                    )
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 13),
                                      child: Divider(
                                        thickness: 1,
                                        color: Color(0xffC9C9C9),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  // SizedBox(
                  //   height: 15.h,
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           Get.to(const FundWallet());
                  //         },
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //             color: brandOne,
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           height: 120.h, // Adjust height as needed
                  //           child: Stack(
                  //             children: [
                  //               Positioned(
                  //                 right: -30,
                  //                 bottom: -30,
                  //                 child: Opacity(
                  //                   opacity: 0.2,
                  //                   child: Icon(
                  //                     Icons.add_circle,
                  //                     color: brandTwo,
                  //                     size: 120,
                  //                   ),
                  //                 ),
                  //               ),
                  //               Padding(
                  //                 padding: EdgeInsets.only(
                  //                     left: 14,
                  //                     top: 13,
                  //                     bottom: 20,
                  //                     right: 10),
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceBetween,
                  //                   children: [
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.end,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.end,
                  //                       children: [
                  //                         Container(
                  //                           padding: EdgeInsets.symmetric(
                  //                               horizontal: 15,
                  //                               vertical: 7),
                  //                           decoration: BoxDecoration(
                  //                             color: Colors.white,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(100),
                  //                           ),
                  //                           child: Text(
                  //                             'Add Money',
                  //                             style: GoogleFonts.lato(
                  //                               color: brandOne,
                  //                               fontSize: 13,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.start,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           'Top up your wallet seamlessly',
                  //                           // overflow: TextOverflow.ellipsis,
                  //                           maxLines: 2,
                  //                           style: GoogleFonts.lato(
                  //                               fontSize: 12,
                  //                               color: Colors.white,
                  //                               fontWeight: FontWeight.w500),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10), // Adjust spacing between boxes
                  //     Expanded(
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           Get.to(const TransferPage());
                  //         },
                  //         child: Stack(
                  //           children: [
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                 color: brandTwo,
                  //                 borderRadius: BorderRadius.circular(10),
                  //               ),
                  //               height: 120.h, // Adjust height as needed
                  //               child: Padding(
                  //                 padding: const EdgeInsets.only(
                  //                     left: 14, top: 13, bottom: 20, right: 10),
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceBetween,
                  //                   children: [
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.end,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.end,
                  //                       children: [
                  //                         Container(
                  //                           padding: EdgeInsets.symmetric(
                  //                               horizontal: 15,
                  //                               vertical: 7),
                  //                           decoration: BoxDecoration(
                  //                             color: brandOne,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(100),
                  //                           ),
                  //                           child: Text(
                  //                             'Transfer Now',
                  //                             style: GoogleFonts.lato(
                  //                               color: Colors.white,
                  //                               fontSize: 13,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.start,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           'Transfer your funds with ease and security.',
                  //                           maxLines: 2,
                  //                           style: GoogleFonts.lato(
                  //                               fontSize: 12,
                  //                               color: Colors.white,
                  //                               fontWeight: FontWeight.w500),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //             Positioned(
                  //               right: -25,
                  //               bottom: -25,
                  //               child: Opacity(
                  //                 opacity: 0.2,
                  //                 child: Icon(
                  //                   Iconsax.empty_wallet_remove,
                  //                   color: brandOne,
                  //                   size: 120,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // Container(
                  //   padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                  //   decoration: BoxDecoration(
                  //     // color: Theme.of(context).canvasColor,
                  //     borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(20),
                  //       topRight: Radius.circular(20),
                  //     ),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       SizedBox(
                  //         height: 10.h,
                  //       ),
                  //       InkWell(
                  //         onTap: () {
                  //           showTopSnackBar(
                  //             Overlay.of(context),
                  //             CustomSnackBar.error(
                  //               backgroundColor: brandOne,
                  //               message: 'Coming Soon :)',
                  //               textStyle: GoogleFonts.lato(
                  //                 fontSize: 14,
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //         child: Container(
                  //           width: double.infinity,
                  //           padding:
                  //               EdgeInsets.fromLTRB(20, 10, 20, 20),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: brandTwo,
                  //           ),
                  //           child:
                  //               // const Row(
                  //               //   children: [
                  //               //     Flexible(
                  //               //       flex: 2,
                  //               //       child: Icon(Icons.share),
                  //               //     ),
                  //               //     Flexible(
                  //               //       flex: 10,
                  //               //       child: Text(
                  //               //           'Refer Your Friends and Earnjfjsdjgbfdfsjgdfkndfsvkjvfbgfnkdbsvskfbgfnkdsvkfjbgfndlsvfdlgfnbdlbklgfndlkblkgdklfbklgf'),
                  //               //     ),
                  //               //   ],
                  //               // ),
                  //               Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Container(
                  //                 margin:
                  //                     const EdgeInsets.fromLTRB(0, 10, 0, 30),
                  //                 child: Row(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     Image.asset(
                  //                       'assets/community.png',
                  //                       width: 28.w,
                  //                       color: Colors.white,
                  //                     ),
                  //                     SizedBox(
                  //                       width: 10.w,
                  //                     ),
                  //                     Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.start,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           "RentSpace community",
                  //                           style: GoogleFonts.lato(
                  //                             fontSize: 16.0,
                  //                             color: Colors.white,
                  //                             fontWeight: FontWeight.w500,
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           height: 15.h,
                  //                         ),
                  //                         Text(
                  //                           "View the amazing community\nof other Spacers!",
                  //                           style: GoogleFonts.lato(
                  //                               fontSize: 12.0,
                  //                               color: Colors.white,
                  //                               fontWeight: FontWeight.w400),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),

                  //       SizedBox(
                  //         height: 20.h,
                  //       ),
                  //       // Align(
                  //       //   alignment: Alignment.centerLeft,
                  //       //   child: Text(
                  //       //     "Blog Section",
                  //       //     textAlign: TextAlign.left,
                  //       //     style: GoogleFonts.lato(
                  //       //         color: brandOne, fontSize: 15),
                  //       //   ),
                  //       // ),
                  //       // Container(
                  //       //   height: 250.h,
                  //       //   child: FutureBuilder(
                  //       //     future: fetchWpPosts(),
                  //       //     builder: (context, AsyncSnapshot snapshot) {
                  //       //       if (snapshot.hasData) {
                  //       //         return CarouselSlider.builder(
                  //       //           itemCount: snapshot.data.length,
                  //       //           itemBuilder: (context, index, realIndex) {
                  //       //             Map wppost = snapshot.data[index];
                  //       //             var imageurl = wppost['_embedded']
                  //       //                 ['wp:featuredmedia'][0]['source_url'];
                  //       //             return Padding(
                  //       //               padding: const EdgeInsets.only(
                  //       //                   top: 10, left: 0, right: 0),
                  //       //               child: InkWell(
                  //       //                 onTap: () {},
                  //       //                 child: Column(
                  //       //                   mainAxisAlignment:
                  //       //                       MainAxisAlignment.start,
                  //       //                   crossAxisAlignment:
                  //       //                       CrossAxisAlignment.start,
                  //       //                   children: [
                  //       //                     Stack(
                  //       //                       children: [
                  //       //                         ClipRRect(
                  //       //                           borderRadius:
                  //       //                               BorderRadius.circular(
                  //       //                                   10.0),
                  //       //                           child: CachedNetworkImage(
                  //       //                             width: 160
                  //       //                                 .w, // Adjust the width as needed
                  //       //                             height: 160
                  //       //                                 .h, // Adjust the height as needed
                  //       //                             imageUrl: imageurl ?? '',
                  //       //                             fit: BoxFit.cover,
                  //       //                             placeholder:
                  //       //                                 (context, url) {
                  //       //                               return Container(
                  //       //                                 width:
                  //       //                                     100, // Adjust the width as needed
                  //       //                                 height:
                  //       //                                     100, // Adjust the height as needed
                  //       //                                 child: CustomLoader(),
                  //       //                               );
                  //       //                             },
                  //       //                             errorWidget:
                  //       //                                 (context, url, error) =>
                  //       //                                     Container(
                  //       //                               width:
                  //       //                                   100, // Adjust the width as needed
                  //       //                               height:
                  //       //                                   100, // Adjust the height as needed
                  //       //                               child: Image.asset(
                  //       //                                   'assets/images/logo_full.png'),
                  //       //                             ),
                  //       //                           ),
                  //       //                         ),
                  //       //                       ],
                  //       //                     ),
                  //       //                     Padding(
                  //       //                       padding:
                  //       //                           const EdgeInsets.symmetric(
                  //       //                         horizontal: 0.0,
                  //       //                       ),
                  //       //                       child: Column(
                  //       //                         children: [
                  //       //                           Padding(
                  //       //                             padding:
                  //       //                                 const EdgeInsets.only(
                  //       //                               right: 10,
                  //       //                             ),
                  //       //                             child: Html(
                  //       //                                 style: {
                  //       //                                   "body": Style(
                  //       //                                       padding:
                  //       //                                           HtmlPaddings
                  //       //                                               .zero,
                  //       //                                       margin:
                  //       //                                           Margins.zero,
                  //       //                                       textOverflow:
                  //       //                                           TextOverflow
                  //       //                                               .clip,
                  //       //                                       maxLines: 2,
                  //       //                                       fontFamily:
                  //       //                                           "inter",
                  //       //                                       fontSize: screenWidth >
                  //       //                                               400
                  //       //                                           ? FontSize
                  //       //                                               .small
                  //       //                                           : FontSize
                  //       //                                               .smaller,
                  //       //                                       fontWeight:
                  //       //                                           FontWeight
                  //       //                                               .w500,
                  //       //                                       color: brandOne),
                  //       //                                 },
                  //       //                                 data: wppost['title']
                  //       //                                     ['rendered']),
                  //       //                           ),
                  //       //                         ],
                  //       //                       ),
                  //       //                     ),
                  //       //                   ],
                  //       //                 ),
                  //       //               ),
                  //       //             );
                  //       //           },
                  //       //           options: CarouselOptions(
                  //       //             onPageChanged: ((index, reason) {
                  //       //               setState(() {
                  //       //                 currentPos = index;
                  //       //               });
                  //       //             }),
                  //       //             autoPlay: true,
                  //       //             height: sliderHeight + 50,
                  //       //             enlargeCenterPage: false,
                  //       //             viewportFraction: 0.5,
                  //       //           ),
                  //       //         );

                  //       //       }
                  //       //       return CustomLoader();
                  //       //     },
                  //       //   ),
                  //       // ),
                  //     ],
                  //   ),
                  // ),
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
