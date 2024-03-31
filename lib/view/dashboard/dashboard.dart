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
import 'package:rentspace/view/FirstPage.dart';
import 'package:rentspace/view/actions/fund_wallet.dart';
import 'package:rentspace/view/actions/transaction_receipt.dart';

import 'package:rentspace/view/dashboard/all_activities.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentspace/view/dashboard/settings.dart';
import 'package:rentspace/view/dashboard/transfer.dart';
import 'package:rentspace/view/savings/savings_withdrawal.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../api/global_services.dart';
import '../../constants/widgets/custom_dialog.dart';
// import '../../controller/settings_controller.dart';
import '../../constants/widgets/icon_container.dart';
import '../../core/helper/helper_route_path.dart';
import '../actions/onboarding_page.dart';
import '../actions/transaction_receipt_dva.dart';
import '../actions/transaction_receipt_transfer.dart';
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
// CollectionReference users = FirebaseFirestore.instance.collection('accounts');
// CollectionReference allUsers =
//     FirebaseFirestore.instance.collection('accounts');
// final CollectionReference announcements =
//     FirebaseFirestore.instance.collection('announcements');
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

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

  // Future<void> _showAnnouncementNotification(String title, String body) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'announcement_channel_id',
  //     'Announcement Notifications',
  //     channelDescription: 'Notifications for announcements',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.show(
  //     id++,
  //     title,
  //     body,
  //     platformChannelSpecifics,
  //     payload: 'item x',
  //   );
  // }

  // final CollectionReference notifications =
  //     FirebaseFirestore.instance.collection('notifications');
  // late ValueNotifier<double> valueNotifier;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  initState() {
    super.initState();
    // ref.read(userSettingsProvider.notifier).getUserProfileDetails();
    // _firebaseMessaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   provisional: false,
    //   sound: true,
    // );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // final notification = message.notification?.title ?? 'No Title';
      userController.fetchData();
      walletController.fetchWallet();
      rentController.fetchRent();
      // context.read().addNotification(notification);
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
        // context.read().addNotification(notification);
      }
    });

    getConnectivity();
    print("isLoading");
    hideBalance = false;
    print(userController.isLoading.value);
    // userController.fetchData();
    // Fetch user details when the widget is initialized
    // _getUserDetailsFromPrefs();

    // getWalletData(refresh: true);

    // Provider.of<NotificationService>(context, listen: false)
    //     .fetchNotificationsFromFirestore();

    // addNotification('test', 'Testing notifications');

    // userInfo.isEmpty
    //     ? valueNotifier = ValueNotifier(0.0)
    //     : valueNotifier = ValueNotifier(
    //         double.tryParse(userInfo[0].finance_health)!);
    greeting();
    // _fetchNews();
  }

  // Function to add a notification
  // Future<void> addNotification(String title, String message) async {
  //   try {
  //     await notifications.add({
  //       'title': title,
  //       'message': message,
  //       'timestamp': FieldValue.serverTimestamp(),
  //       'isRead': false
  //     });
  //     print('Notification added successfully.');
  //   } catch (error) {
  //     print('Error adding notification: $error');
  //   }
  // }

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
  // Future<void> _getUserDetailsFromPrefs() async {
  //   try {
  //     // final prefs = SharedPreferencesManager();
  //     final userDetails =
  //         await GlobalService.sharedPreferencesManager.getUserDetails();
  //     print('====================');
  //     print('userDetails');
  //     print(userDetails);

  //     if (userDetails.userDetails.isNotEmpty) {
  //       // List? userInfo = userDetails.userDetails;
  //       String? firstName = userDetails.userDetails[0].firstName;
  //       String? lastName = userDetails.userDetails[0].lastName;
  //       // final userName = userDetails['userName'] ?? '';
  //       print('fullname:');
  //       print('fullname: $firstName $lastName');
  //       // print('userInfo: $userInfo');

  //       setState(() {
  //         fullName = fullName; // Update the user name
  //       });
  //     } else {
  //       print('Invalid user details format');
  //     }
  //   } catch (e) {
  //     print('Error fetching user details from SharedPreferences: $e');
  //   }
  // }

  // Future<bool> getWalletData({bool refresh = true}) async {
  //   String token = await GlobalService.sharedPreferencesManager.getAuthToken();
  //   print('token');
  //   print(token);
  //   if (refresh) {
  //     if (mounted) {
  //       setState(() {});
  //       // currentPage = widget.id == 30762 ? 2 : 1;
  //     }
  //   }

  //   final response = await http.get(
  //       Uri.parse(AppConstants.BASE_URL + AppConstants.GET_WALLET),
  //       headers: {
  //         'Content-type': 'application/json; charset=UTF-8',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token'
  //       });
  //   // final response = await dio.get(categoryWiseUrls.toString());
  //   // print("response");
  //   // print(response);

  //   if (response.statusCode == 200) {
  //     final jsonStr = json.encode(response.body);
  //     print('jsonStr');
  //     print(jsonStr);
  //     final result = walletModelFromJson(response.body);
  //     print('result');
  //     print(result);

  //     if (refresh) {
  //       wallet_info = result;
  //     } else {
  //       wallet_info.addAll(result);
  //       // textCopy = wallet_info[0].wallet.virtualAccountNumber;
  //     }
  //     if (mounted) {
  //       setState(() {});
  //       // currentPage++;
  //     }

  //     return true;
  //   } else {
  //     print("error");
  //     print(response);
  //     return false;
  //   }
  // }

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

  // void onLoading() async {
  //   final result = await getWalletData(refresh: true);
  //   if (result == true) {
  //     refreshController.loadComplete();
  //   } else {
  //     refreshController.loadNoData();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final data = ref.watch(userProfileDetailsProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showTopSnackBar(
      //       Overlay.of(context),
      //       CustomSnackBar.error(
      //         backgroundColor: brandOne,
      //         message: 'Coming Soon :)',
      //         textStyle: GoogleFonts.nunito(
      //           fontSize: 14,
      //           color: Colors.white,
      //           fontWeight: FontWeight.w700,
      //         ),
      //       ),
      //     );
      //     // Get.to(const ChatMain());
      //   },
      //   child: const Icon(Icons.support_agent_sharp),
      // ),
      body: Obx(
        () =>
            //  userController.isLoading.value
            //     ? const Center(
            //         child: CustomLoader(),
            //       )
            //     :
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
                                  // Text(
                                  //   "Hi, ${userInfo[0].userFirst}👋$dum1",
                                  //   style: GoogleFonts.nunito(
                                  //     fontSize: 20.0.sp,
                                  //     fontWeight: FontWeight.w700,
                                  //     color: Theme.of(context).primaryColor,
                                  //   ),
                                  // ),
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
                              Get.to(AllActivities());
                            },
                            child: Icon(
                              Icons.history_sharp,
                              color: Theme.of(context).primaryColor,
                              size: 24.sp,
                            ),
                          ),
                          // riverpod.Consumer(
                          //   builder: (context, watch, _) {
                          //     final count =
                          //         ref.watch(notificationCountProvider);
                          //     return Stack(
                          //       children: [
                          //         Icon(
                          //           Icons.notifications_outlined,
                          //           color: Theme.of(context).primaryColor,
                          //           size: 22.sp,
                          //         ),
                          //         if (count > 0)
                          //           Positioned(
                          //             top: 0.sp,
                          //             right: 0.0.sp,
                          //             child: Container(
                          //               padding: EdgeInsets.all(4.0.sp),
                          //               decoration: const BoxDecoration(
                          //                 shape: BoxShape.circle,
                          //                 color: Colors.red,
                          //               ),
                          //             ),
                          //           ),
                          //       ],
                          //     );
                          //   },
                          // ),

                          // <NotificationService>(
                          //     builder: (context, notificationService, _) {
                          //   return Padding(
                          //     padding: EdgeInsets.all(8.0.sp),
                          //     child: GestureDetector(
                          //       onTap: () async {
                          //         await notificationService
                          //             .fetchNotificationsFromFirestore();
                          //         Get.to(const NotificationsPage());
                          //       },
                          //       child: Stack(
                          //         children: [
                          //           Icon(
                          //             Icons.notifications_outlined,
                          //             color: Theme.of(context).primaryColor,
                          //             size: 22.sp,
                          //           ),
                          //           if (notificationService.hasUnreadNotification)
                          //             Positioned(
                          //               top: 0.sp,
                          //               right: 0.0.sp,
                          //               child: Container(
                          //                 padding: EdgeInsets.all(4.0.sp),
                          //                 decoration: const BoxDecoration(
                          //                   shape: BoxShape.circle,
                          //                   color: Colors.red,
                          //                 ),
                          //               ),
                          //             ),
                          //         ],
                          //       ),
                          //     ),
                          //   );
                          // }),
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
                                // width: 420.w,
                                // height: 210.h,
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
                                      // SizedBox(
                                      //   height: 5.h,
                                      // ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [
                                      //     Text(
                                      //       (userController.userModel!
                                      //                   .userDetails![0].hasDva
                                      //                   .obs() ==
                                      //               true)
                                      //           ? userController.userModel!
                                      //               .userDetails![0].dvaNumber
                                      //               .toString()
                                      //           : '${userController.userModel!.userDetails![0].wallet.walletId.obs.substring(0, 3)}-${userController.userModel!.userDetails![0].wallet.walletId.obs().substring(3, 6)}-${userController.userModel!.userDetails![0].wallet.walletId.obs().substring(6, 10)}',
                                      //       style: GoogleFonts.nunito(
                                      //           fontSize: 16.sp,
                                      //           fontWeight: FontWeight.bold,
                                      //           color: Colors.white,
                                      //           letterSpacing: 4),
                                      //       textAlign: TextAlign.center,
                                      //     ),
                                      //     SizedBox(
                                      //       width: 10.w,
                                      //     ),
                                      //     (userController.userModel!
                                      //                 .userDetails![0].hasDva
                                      //                 .obs() ==
                                      //             true)
                                      //         ? InkWell(
                                      //             onTap: () {
                                      //               Clipboard.setData(
                                      //                 ClipboardData(
                                      //                   text: userController
                                      //                       .userModel!
                                      //                       .userDetails![0]
                                      //                       .dvaNumber
                                      //                       .obs()
                                      //                       .toString(),
                                      //                 ),
                                      //               );
                                      //               Fluttertoast.showToast(
                                      //                 msg:
                                      //                     "Account Number copied to clipboard!",
                                      //                 toastLength:
                                      //                     Toast.LENGTH_SHORT,
                                      //                 gravity:
                                      //                     ToastGravity.CENTER,
                                      //                 timeInSecForIosWeb: 1,
                                      //                 backgroundColor: brandOne,
                                      //                 textColor: Colors.white,
                                      //                 fontSize: 16.0,
                                      //               );
                                      //             },
                                      //             child: Icon(
                                      //               Icons.copy,
                                      //               size: 16.sp,
                                      //               color: Colors.white,
                                      //             ),
                                      //           )
                                      //         : const SizedBox(),
                                      //   ],
                                      // ),

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
                                            // Get.to(ViewBvnAndKyc(
                                            //   bvn: userController.userModel?.userDetails![0].bvn,
                                            //   hasVerifiedBvn: userController
                                            //       .users[0].hasVerifiedBvn
                                            //       .toString(),
                                            //   hasVerifiedKyc: userController
                                            //       .users[0].hasVerifiedKyc
                                            //       .toString(),
                                            //   kyc: userController.userModel?.userDetails![0].kyc,
                                            //   idImage: userController
                                            //       .users[0].Idimage
                                            //       .toString(),
                                            // ));
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

                        // Container(
                        //     height: 220,
                        //     padding: const EdgeInsets.fromLTRB(
                        //         20.0, 20.0, 20.0, 20.0),
                        //     decoration: BoxDecoration(
                        //       color: brandOne,
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //     child: Stack(
                        //       children: [
                        //         Positioned(
                        //           top: 0,
                        //           left: 0,
                        //           child: Image.asset(
                        //             'assets/cash.png',
                        //             width: 42,
                        //           ),
                        //         ),
                        //         Positioned(
                        //           bottom: 0,
                        //           left: 0,
                        //           child: Column(
                        //             children: [
                        //               Text(
                        //                 '₦0.00',
                        //                 style: GoogleFonts.nunito(
                        //                   color: Colors.white,
                        //                   fontSize: 22,
                        //                   fontWeight: FontWeight.w700,
                        //                 ),
                        //               ),
                        //               const SizedBox(
                        //                 height: 5,
                        //               ),
                        //               Text(
                        //                 'Space Wallet',
                        //                 style: GoogleFonts.nunito(
                        //                   color: Colors.white,
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.w400,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     // width: ,
                        //   ),
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
                                onTap: () {},
                              ),
                              IconsContainer(
                                IconsName: 'More',
                                icon: Iconsax.more5,
                                iconColor: brandOne,
                                onTap: () {
                                  // Navigator.pushNamed(context, RouteList.electricity);
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Transaction Histories",
                  //       style: GoogleFonts.nunito(
                  //         fontSize: 16.0.sp,
                  //         fontWeight: FontWeight.w700,
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         Get.to(AllActivities());
                  //       },
                  //       child: Text(
                  //         "See all",
                  //         style: GoogleFonts.nunito(
                  //           fontSize: 14.0.sp,
                  //           // letterSpacing: 1.0,
                  //           // fontFamily: "DefaultFontFamily",
                  //           fontWeight: FontWeight.w700,
                  //           color: Theme.of(context).primaryColor,
                  //           decoration: TextDecoration.underline,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // // Text(activitiesController.activitiesModel!.activities![0].description),
                  // userController.userModel!.userDetails![0].walletHistories
                  //         .obs()
                  //         .isNotEmpty
                  //     ? ListView.builder(
                  //         scrollDirection: Axis.vertical,
                  //         shrinkWrap: true,
                  //         physics: const ClampingScrollPhysics(),
                  //         itemCount: 1,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           int reversedIndex = userController.userModel!
                  //                   .userDetails![0].walletHistories.length -
                  //               1 -
                  //               index;
                  //           final history = userController.userModel!
                  //               .userDetails![0].walletHistories[reversedIndex];
                  //           return GestureDetector(
                  //             onTap: () {
                  //               Get.to(
                  //                 (history['transactionGroup']
                  //                             .toString()
                  //                             .toLowerCase() ==
                  //                         'transfer')
                  //                     ? TransactionReceiptTransfer(
                  //                         amount: history['amount'],
                  //                         status: history['status'],
                  //                         fees: history['fees'] ?? 0,
                  //                         transactionType:
                  //                             history['transactionType'],
                  //                         description: history['description'],
                  //                         transactionGroup:
                  //                             history['transactionGroup'],
                  //                         transactionDate: history['createdAt'],
                  //                         transactionRef:
                  //                             history['transactionReference'] ??
                  //                                 '',
                  //                         merchantRef:
                  //                             history['merchantReference'],
                  //                         // sessionId: history['sessionId'],
                  //                       )
                  //                     : (history['transactionGroup']
                  //                                 .toString()
                  //                                 .toLowerCase() ==
                  //                             'static-account-transfer')
                  //                         ? TransactionReceiptDVA(
                  //                             amount: history['amount'],
                  //                             status: history['status'],
                  //                             fees: history['fees'] ?? 0,
                  //                             transactionType:
                  //                                 history['transactionType'],
                  //                             description:
                  //                                 history['description'],
                  //                             transactionGroup:
                  //                                 history['transactionGroup'],
                  //                             transactionDate:
                  //                                 history['createdAt'],
                  //                             transactionRef: history[
                  //                                     'transactionReference'] ??
                  //                                 '',
                  //                             merchantRef:
                  //                                 history['merchantReference'],
                  //                             remarks: history['remarks'],
                  //                           )
                  //                         : TransactionReceipt(
                  //                             amount: history['amount'],
                  //                             status: history['status'],
                  //                             fees: history['fees'] ?? 0,
                  //                             transactionType:
                  //                                 history['transactionType'],
                  //                             description:
                  //                                 history['description'],
                  //                             transactionGroup:
                  //                                 history['transactionGroup'],
                  //                             transactionDate:
                  //                                 history['createdAt'],
                  //                             transactionRef: history[
                  //                                     'transactionReference'] ??
                  //                                 '',
                  //                             merchantRef:
                  //                                 history['merchantReference'],
                  //                           ),
                  //               );
                  //             },
                  //             child: ListTile(
                  //               contentPadding: EdgeInsets.zero,
                  //               minLeadingWidth: 0,
                  //               leading: Container(
                  //                 padding: const EdgeInsets.all(8),
                  //                 decoration: BoxDecoration(
                  //                   shape: BoxShape.circle,
                  //                   color:
                  //                       (history['transactionType'] == 'Credit')
                  //                           ? Colors.green
                  //                           : Colors.red,
                  //                 ),
                  //                 child:
                  //                     (history['transactionType'] == 'Credit')
                  //                         ? Icon(Icons.call_received,
                  //                             color: Theme.of(context)
                  //                                 .colorScheme
                  //                                 .primary)
                  //                         : Icon(Icons.arrow_outward_sharp,
                  //                             color: Theme.of(context)
                  //                                 .colorScheme
                  //                                 .primary),
                  //               ),
                  //               title: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     "${history['description']}",
                  //                     maxLines: 1,
                  //                     overflow: TextOverflow.ellipsis,
                  //                     style: GoogleFonts.nunito(
                  //                       fontSize: 12.sp,
                  //                       fontWeight: FontWeight.w700,
                  //                       color: Theme.of(context).primaryColor,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               subtitle: Text(
                  //                 formatDateTime(history['createdAt']),
                  //                 style: GoogleFonts.nunito(
                  //                   fontSize: 10.sp,
                  //                   fontWeight: FontWeight.w300,
                  //                   color: Theme.of(context).primaryColor,
                  //                 ),
                  //               ),
                  //               trailing: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.end,
                  //                 children: [
                  //                   Text(
                  //                     "${(history['transactionType'] == 'Credit') ? '+' : '-'} ${nairaFormaet.format(double.parse(history['amount'].toString()))}",
                  //                     style: GoogleFonts.nunito(
                  //                       fontSize: 16.sp,
                  //                       fontWeight: FontWeight.w700,
                  //                       color: brandOne,
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                     (history['status']
                  //                                 .toString()
                  //                                 .toLowerCase() ==
                  //                             'completed')
                  //                         ? 'Successful'
                  //                         : (history['transactionType']
                  //                                     .toString()
                  //                                     .toLowerCase() ==
                  //                                 'failed')
                  //                             ? 'Failed'
                  //                             : 'Pending',
                  //                     style: GoogleFonts.nunito(
                  //                       fontSize: 14.sp,
                  //                       fontWeight: FontWeight.w500,
                  //                       color: (history['status']
                  //                                   .toString()
                  //                                   .toLowerCase() ==
                  //                               'completed')
                  //                           ? Colors.green
                  //                           : (history['transactionType']
                  //                                       .toString()
                  //                                       .toLowerCase() ==
                  //                                   'failed')
                  //                               ? Colors.red
                  //                               : Colors.yellow[800],
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       )
                  //     : Padding(
                  //         padding: const EdgeInsets.all(15.0),
                  //         child: Center(
                  //           child: Text(
                  //             "No Wallet Transactions Yet",
                  //             style: GoogleFonts.nunito(
                  //               fontSize: 16.sp,
                  //               // fontFamily: "DefaultFontFamily",
                  //               color: Theme.of(context).primaryColor,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ),
                  //       ),

                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // Visibility(
                  //   visible: isContainerVisible,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).cardColor,
                  //       borderRadius: BorderRadius.circular(15),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //           vertical: 10.0, horizontal: 20.0),
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text(
                  //                   'Account Setup',
                  //                   style: GoogleFonts.nunito(
                  //                     color: brandOne,
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.w700,
                  //                   ),
                  //                 ),
                  //                 GestureDetector(
                  //                   onTap: () {
                  //                     setState(() {
                  //                       isContainerVisible = false;
                  //                     });
                  //                   },
                  //                   child: const Icon(
                  //                     Iconsax.close_circle,
                  //                     color: brandOne,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           GestureDetector(
                  //             onTap: () {
                  //               Get.to(const PersonalDetails());
                  //             },
                  //             child: Row(
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               children: [
                  //                 Icon(
                  //                   (userController.userModel!.userDetails![0]
                  //                               .hasVerifiedBvn
                  //                               .obs() ==
                  //                           false)
                  //                       ? Iconsax.verify
                  //                       : Iconsax.verify5,
                  //                   color: brandOne,
                  //                 ),
                  //                 const SizedBox(
                  //                   width: 10,
                  //                 ),
                  //                 Text(
                  //                   'BVN Setup',
                  //                   textAlign: TextAlign.center,
                  //                   style: GoogleFonts.nunito(
                  //                     color: brandOne,
                  //                     fontSize: 14,
                  //                     fontWeight: FontWeight.w600,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           // const MySeparator(),
                  //           // GestureDetector(
                  //           //   onTap: () {
                  //           //     Get.to(const KYCIntroPage());
                  //           //   },
                  //           //   child: Row(
                  //           //     crossAxisAlignment: CrossAxisAlignment.center,
                  //           //     children: [
                  //           //       Icon(
                  //           //         (userController.userModel!.userDetails![0]
                  //           //                     .hasVerifiedKyc
                  //           //                     .obs() ==
                  //           //                 false)
                  //           //             ? Iconsax.verify
                  //           //             : Iconsax.verify5,
                  //           //         color: brandOne,
                  //           //       ),
                  //           //       const SizedBox(
                  //           //         width: 10,
                  //           //       ),
                  //           //       Text(
                  //           //         'KYC Setup',
                  //           //         textAlign: TextAlign.center,
                  //           //         style: GoogleFonts.nunito(
                  //           //           color: brandOne,
                  //           //           fontSize: 14,
                  //           //           fontWeight: FontWeight.w600,
                  //           //         ),
                  //           //       ),
                  //           //     ],
                  //           //   ),
                  //           // ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // (userController.userModel!.userDetails![0].bvn.obs() != "" &&
                  //         userController.userModel!.userDetails![0].hasDva
                  //                 .obs() ==
                  //             false)
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(top: 20),
                  //         child: Container(
                  //           padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                  //           width: MediaQuery.of(context).size.width,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(20),
                  //             color: brandThree,
                  //           ),
                  //           child: ListTile(
                  //             onTap: () {
                  //               Get.to(const CreateDVA());
                  //             },
                  //             leading: const Icon(
                  //               Icons.person_add_outlined,
                  //               color: Colors.black,
                  //             ),
                  //             title: Text(
                  //               "Activate DVA",
                  //               style: GoogleFonts.nunito(
                  //                 fontSize: 15.0,
                  //                 fontWeight: FontWeight.w800,
                  //                 color: Colors.black,
                  //               ),
                  //             ),
                  //             subtitle: Text(
                  //               "Free Dynamic Virtual Account (DVA)",
                  //               style: GoogleFonts.nunito(
                  //                 fontSize: 14.0,
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //             trailing: const Icon(
                  //               Icons.arrow_right_outlined,
                  //               color: Colors.black,
                  //             ),
                  //             tileColor: Colors.white,
                  //           ),
                  //         ),
                  //       )
                  //     : const SizedBox(
                  //         height: 1,
                  //       ),

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
                              // showDialog(
                              //     context: context,
                              //     barrierDismissible: true,
                              //     builder: (BuildContext context) {
                              //       return Column(
                              //         mainAxisAlignment: MainAxisAlignment.end,
                              //         children: [
                              //           AlertDialog(
                              //             contentPadding:
                              //                 const EdgeInsets.fromLTRB(
                              //                     30, 30, 30, 20),
                              //             elevation: 0,
                              //             alignment: Alignment.bottomCenter,
                              //             insetPadding: const EdgeInsets.all(0),
                              //             scrollable: true,
                              //             title: null,
                              //             shape: const RoundedRectangleBorder(
                              //               borderRadius: BorderRadius.only(
                              //                 topLeft: Radius.circular(30),
                              //                 topRight: Radius.circular(30),
                              //               ),
                              //             ),
                              //             content: SizedBox(
                              //               child: SizedBox(
                              //                 width: MediaQuery.of(context)
                              //                     .size
                              //                     .width,
                              //                 child: Column(
                              //                   children: [
                              //                     Padding(
                              //                       padding:
                              //                           EdgeInsets.symmetric(
                              //                               vertical: 40.h),
                              //                       child: Column(
                              //                         children: [
                              //                           Padding(
                              //                             padding:
                              //                                 const EdgeInsets
                              //                                     .symmetric(
                              //                                     vertical: 15),
                              //                             child: Align(
                              //                               alignment: Alignment
                              //                                   .topCenter,
                              //                               child: Text(
                              //                                 'Transfer your Secured Funds',
                              //                                 style: GoogleFonts
                              //                                     .nunito(
                              //                                   color: brandOne,
                              //                                   fontSize: 16.sp,
                              //                                   fontWeight:
                              //                                       FontWeight
                              //                                           .w500,
                              //                                 ),
                              //                               ),
                              //                             ),
                              //                           ),
                              //                           Padding(
                              //                             padding:
                              //                                 const EdgeInsets
                              //                                     .symmetric(
                              //                                     vertical: 10),
                              //                             child: Column(
                              //                               children: [
                              //                                 Padding(
                              //                                   padding:
                              //                                       const EdgeInsets
                              //                                           .all(3),
                              //                                   child:
                              //                                       ElevatedButton(
                              //                                     onPressed:
                              //                                         () {
                              //                                       (userController.userModel!.userDetails![0].wallet.mainBalance >
                              //                                               0)
                              //                                           ?
                              //                                           //  Get.to(
                              //                                           //     TransactionReceipt())
                              //                                           Get.to(
                              //                                               const WalletWithdrawal())
                              //                                           : customErrorDialog(
                              //                                               context,
                              //                                               'Wallet Empty! :)',
                              //                                               'You need to fund your wallet first!',
                              //                                             );
                              //                                     },
                              //                                     style: ElevatedButton
                              //                                         .styleFrom(
                              //                                       minimumSize:
                              //                                           const Size(
                              //                                               300,
                              //                                               50),
                              //                                       maximumSize:
                              //                                           const Size(
                              //                                               300,
                              //                                               50),
                              //                                       backgroundColor:
                              //                                           brandOne,
                              //                                       shape:
                              //                                           RoundedRectangleBorder(
                              //                                         borderRadius:
                              //                                             BorderRadius.circular(
                              //                                                 8),
                              //                                       ),
                              //                                       textStyle: const TextStyle(
                              //                                           color:
                              //                                               brandFour,
                              //                                           fontSize:
                              //                                               13),
                              //                                     ),
                              //                                     child: Row(
                              //                                       mainAxisAlignment:
                              //                                           MainAxisAlignment
                              //                                               .center,
                              //                                       children: [
                              //                                         const Icon(
                              //                                             Iconsax
                              //                                                 .card),
                              //                                         const SizedBox(
                              //                                           width:
                              //                                               10,
                              //                                         ),
                              //                                         Text(
                              //                                           "Proceed To Transfer",
                              //                                           style:
                              //                                               TextStyle(
                              //                                             color:
                              //                                                 Colors.white,
                              //                                             fontWeight:
                              //                                                 FontWeight.w500,
                              //                                             fontSize:
                              //                                                 12.sp,
                              //                                           ),
                              //                                         ),
                              //                                       ],
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                                 const SizedBox(
                              //                                   height: 10,
                              //                                 ),
                              //                               ],
                              //                             ),
                              //                           ),
                              //                         ],
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ),
                              //           )
                              //         ],
                              //       );
                              //     });
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

                              // showDialog(
                              //     context: context,
                              //     barrierDismissible: true,
                              //     builder: (BuildContext context) {
                              //       return Column(
                              //         mainAxisAlignment: MainAxisAlignment.end,
                              //         children: [
                              //           AlertDialog(
                              //             contentPadding:
                              //                 const EdgeInsets.fromLTRB(
                              //                     30, 30, 30, 20),
                              //             elevation: 0,
                              //             alignment: Alignment.bottomCenter,
                              //             insetPadding: const EdgeInsets.all(0),
                              //             scrollable: true,
                              //             title: null,
                              //             shape: const RoundedRectangleBorder(
                              //               borderRadius: BorderRadius.only(
                              //                 topLeft: Radius.circular(30),
                              //                 topRight: Radius.circular(30),
                              //               ),
                              //             ),
                              //             content: SizedBox(
                              //               child: SizedBox(
                              //                 width: 400.w,
                              //                 child: Column(
                              //                   children: [
                              //                     Padding(
                              //                       padding:
                              //                           EdgeInsets.symmetric(
                              //                               vertical: 40.h),
                              //                       child: Column(
                              //                         children: [
                              //                           Padding(
                              //                             padding: EdgeInsets
                              //                                 .symmetric(
                              //                                     vertical:
                              //                                         15.h),
                              //                             child: Align(
                              //                               alignment: Alignment
                              //                                   .topCenter,
                              //                               child: Text(
                              //                                 'Securely top up your wallet',
                              //                                 style: GoogleFonts
                              //                                     .nunito(
                              //                                   color: brandOne,
                              //                                   fontSize: 16.sp,
                              //                                   fontWeight:
                              //                                       FontWeight
                              //                                           .w500,
                              //                                 ),
                              //                               ),
                              //                             ),
                              //                           ),
                              //                           Padding(
                              //                             padding:
                              //                                 const EdgeInsets
                              //                                     .symmetric(
                              //                                     vertical: 10),
                              //                             child: Column(
                              //                               children: [
                              //                                 Padding(
                              //                                   padding:
                              //                                       const EdgeInsets
                              //                                           .all(3),
                              //                                   child:
                              //                                       ElevatedButton(
                              //                                     onPressed:
                              //                                         () {
                              //                                       Get.to(
                              //                                           const FundWallet());
                              //                                     },
                              //                                     style: ElevatedButton
                              //                                         .styleFrom(
                              //                                       minimumSize:
                              //                                           const Size(
                              //                                               300,
                              //                                               50),
                              //                                       maximumSize:
                              //                                           const Size(
                              //                                               300,
                              //                                               50),
                              //                                       backgroundColor:
                              //                                           brandOne,
                              //                                       shape:
                              //                                           RoundedRectangleBorder(
                              //                                         borderRadius:
                              //                                             BorderRadius.circular(
                              //                                                 8),
                              //                                       ),
                              //                                       textStyle: const TextStyle(
                              //                                           color:
                              //                                               brandFour,
                              //                                           fontSize:
                              //                                               13),
                              //                                     ),
                              //                                     child: Row(
                              //                                       mainAxisAlignment:
                              //                                           MainAxisAlignment
                              //                                               .center,
                              //                                       children: [
                              //                                         const Icon(
                              //                                             Iconsax
                              //                                                 .card),
                              //                                         const SizedBox(
                              //                                           width:
                              //                                               10,
                              //                                         ),
                              //                                         Text(
                              //                                           "Proceed To Top Up",
                              //                                           style:
                              //                                               TextStyle(
                              //                                             color:
                              //                                                 Colors.white,
                              //                                             fontWeight:
                              //                                                 FontWeight.w500,
                              //                                             fontSize:
                              //                                                 12.sp,
                              //                                           ),
                              //                                         ),
                              //                                       ],
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                                 const SizedBox(
                              //                                   height: 10,
                              //                                 ),
                              //                               ],
                              //                             ),
                              //                           ),
                              //                         ],
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ),
                              //           )
                              //         ],
                              //       );
                              //     });
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
