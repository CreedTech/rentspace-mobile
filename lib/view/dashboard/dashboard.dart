import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/constants/constants.dart';
import 'package:rentspace/controller/activities_controller.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/controller/wallet_controller.dart';
import 'package:rentspace/model/user_details_model.dart';
import 'package:rentspace/view/actions/fund_wallet.dart';

import 'package:rentspace/view/dashboard/all_activities.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentspace/view/dashboard/settings.dart';
import 'package:rentspace/view/dva/create_dva.dart';
import 'package:rentspace/view/savings/savings_withdrawal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'dart:convert';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/separator.dart';
// import '../../controller/settings_controller.dart';
import '../../model/response/user_details_response.dart';
import '../../model/wallet_model.dart';
import '../../services/implementations/notification_service.dart';
import '../actions/onboarding_page.dart';
import '../actions/view_bvn_and_kyc.dart';
import '../chat/chat_main.dart';
import '../kyc/kyc_intro.dart';
import 'notifications.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Dashboard extends StatefulWidget {
  Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
final themeChange = Get.put(ThemeServices());

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

class _DashboardState extends State<Dashboard> {
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
  final UserController userController = Get.put(UserController());
  // final ActivitiesController activitiesController = Get.put(ActivitiesController());
  // final WalletController walletController = Get.put(WalletController());

  final form = intl.NumberFormat.decimalPattern();
  bool isContainerVisible = true;
  List<dynamic> _articles = [];
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

  Future<void> _showAnnouncementNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'announcement_channel_id',
      'Announcement Notifications',
      channelDescription: 'Notifications for announcements',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id++,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  // final CollectionReference notifications =
  //     FirebaseFirestore.instance.collection('notifications');
  // late ValueNotifier<double> valueNotifier;
  @override
  initState() {
    super.initState();
    // ref.read(userSettingsProvider.notifier).getUserProfileDetails();
    getConnectivity();
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
            // noInternetConnectionScreen(context);
            setState(() => isAlertSet = true);
          }
        },
      );
  Future<void> _getUserDetailsFromPrefs() async {
    try {
      // final prefs = SharedPreferencesManager();
      final userDetails =
          await GlobalService.sharedPreferencesManager.getUserDetails();
      print('====================');
      print('userDetails');
      print(userDetails);

      if (userDetails.userDetails.isNotEmpty) {
        // List? userInfo = userDetails.userDetails;
        String? firstName = userDetails.userDetails[0].firstName;
        String? lastName = userDetails.userDetails[0].lastName;
        // final userName = userDetails['userName'] ?? '';
        print('fullname:');
        print('fullname: $firstName $lastName');
        // print('userInfo: $userInfo');

        setState(() {
          fullName = fullName; // Update the user name
        });
      } else {
        print('Invalid user details format');
      }
    } catch (e) {
      print('Error fetching user details from SharedPreferences: $e');
    }
  }

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

    // final result = await getWalletData(refresh: true);
    // if (result == true) {
    //   if (mounted) {
    //     setState(() {
    //       isRefresh = false;
    //     });
    //   }
    // } else {
    //   refreshController.refreshFailed();
    // }
    // }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const ChatMain());
        },
        child: const Icon(Icons.support_agent_sharp),
      ),
      body: Obx(
        () => userController.isLoading.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          :
           Center(child: Text(userController.userModel!.userDetails![0].firstName ,style: TextStyle(color: Colors.black),))
        //   LiquidPullToRefresh(
        //   height: 100,
        //   animSpeedFactor: 2,
        //   color: brandOne,
        //   backgroundColor: Colors.white,
        //   showChildOpacityTransition: false,
        //   onRefresh: onRefresh,
        //   child: SafeArea(
        //     child: Padding(
        //       //padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        //       padding: EdgeInsets.fromLTRB(
        //         20.0.w,
        //         0.0.h,
        //         20.0.w,
        //         0.0.h,
        //       ),
        //       child: ListView(
        //         children: [
        //           Column(
        //             children: [
        //               // SizedBox(
        //               //   height: 30.h,
        //               // ),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     children: [
        //                       userController.isLoading.value
        //                           ? Center(
        //                               child: CircularProgressIndicator(),
        //                             )
        //                           : GestureDetector(
        //                               onTap: () {
        //                                 Get.to(const SettingsPage());
        //                               },
        //                               child: CircleAvatar(
        //                                 backgroundColor: Colors.transparent,
        //                                 child: ClipRRect(
        //                                   borderRadius:
        //                                       BorderRadius.circular(50.sp),
        //                                   child: CachedNetworkImage(
        //                                     imageUrl:
        //                                         userController.users[0].avatar!,
        //                                     height: 40.h,
        //                                     width: 40.w,
        //                                     fit: BoxFit.cover,
        //                                     placeholder: (context, url) {
        //                                       return Image.asset(
        //                                         'assets/icons/RentSpace-icon.png',
        //                                         height: 40.h,
        //                                         width: 40.w,
        //                                         fit: BoxFit.cover,
        //                                       );
        //                                     },
        //                                     errorWidget: (context, url, error) {
        //                                       return Image.asset(
        //                                         'assets/icons/RentSpace-icon.png',
        //                                         height: 40.h,
        //                                         width: 40.w,
        //                                         fit: BoxFit.cover,
        //                                       );
        //                                     },
        //                                     // progressIndicatorBuilder:
        //                                     //     (context, url, progress) {
        //                                     //   return const CircularProgressIndicator();
        //                                     // },
        //                                   ),
        //                                   // Image.network(
        //                                   //   userInfo[0].image,
        //                                   //   height: 40,
        //                                   //   width: 40,
        //                                   //   fit: BoxFit.fill,
        //                                   // ),
        //                                 ),
        //                               ),
        //                             ),
        //                       SizedBox(
        //                         width: 10.w,
        //                       ),
        //                       Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: [
        //                          userController.isLoading.value
        //                           ? Center(
        //                               child: CircularProgressIndicator(),
        //                             )
        //                           :  Text(
        //                             "Hi, ${userController.users[0].firstName!.capitalize}👋 $dum1",
        //                             style: GoogleFonts.nunito(
        //                               fontSize: 20.0.sp,
        //                               fontWeight: FontWeight.w700,
        //                               color: Theme.of(context).primaryColor,
        //                             ),
        //                           ),
        //                           // Text(
        //                           //   "Hi, ${userInfo[0].userFirst}👋$dum1",
        //                           //   style: GoogleFonts.nunito(
        //                           //     fontSize: 20.0.sp,
        //                           //     fontWeight: FontWeight.w700,
        //                           //     color: Theme.of(context).primaryColor,
        //                           //   ),
        //                           // ),
        //                           Text(
        //                             _greeting,
        //                             style: GoogleFonts.nunito(
        //                               fontSize: 16.0.sp,
        //                               // letterSpacing: 1.0,
        //                               fontWeight: FontWeight.w700,
        //                               color: Theme.of(context).primaryColor,
        //                             ),
        //                           ),
        //                         ],
        //                       )
        //                     ],
        //                   ),
        //                   // <NotificationService>(
        //                   //     builder: (context, notificationService, _) {
        //                   //   return Padding(
        //                   //     padding: EdgeInsets.all(8.0.sp),
        //                   //     child: GestureDetector(
        //                   //       onTap: () async {
        //                   //         await notificationService
        //                   //             .fetchNotificationsFromFirestore();
        //                   //         Get.to(const NotificationsPage());
        //                   //       },
        //                   //       child: Stack(
        //                   //         children: [
        //                   //           Icon(
        //                   //             Icons.notifications_outlined,
        //                   //             color: Theme.of(context).primaryColor,
        //                   //             size: 22.sp,
        //                   //           ),
        //                   //           if (notificationService.hasUnreadNotification)
        //                   //             Positioned(
        //                   //               top: 0.sp,
        //                   //               right: 0.0.sp,
        //                   //               child: Container(
        //                   //                 padding: EdgeInsets.all(4.0.sp),
        //                   //                 decoration: const BoxDecoration(
        //                   //                   shape: BoxShape.circle,
        //                   //                   color: Colors.red,
        //                   //                 ),
        //                   //               ),
        //                   //             ),
        //                   //         ],
        //                   //       ),
        //                   //     ),
        //                   //   );
        //                   // }),
        //                 ],
        //               ),
        //               SizedBox(
        //                 height: 30.h,
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 0),
        //                 child: (userController.users[0].hasDva == true)
        //                     ? FlipCard(
        //                         front: Neumorphic(
        //                           style: NeumorphicStyle(
        //                               shape: NeumorphicShape.concave,
        //                               boxShape: NeumorphicBoxShape.roundRect(
        //                                   BorderRadius.circular(12)),
        //                               depth: 0,
        //                               lightSource: LightSource.topLeft,
        //                               color: Colors.white),
        //                           child: Container(
        //                             height: 220,
        //                             padding: const EdgeInsets.fromLTRB(
        //                                 20.0, 20.0, 20.0, 20.0),
        //                             decoration: BoxDecoration(
        //                               color: Theme.of(context).canvasColor,
        //                               image: const DecorationImage(
        //                                 image: AssetImage("assets/card.jpg"),
        //                                 fit: BoxFit.cover,
        //                               ),
        //                             ),
        //                             child: Row(
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.spaceBetween,
        //                               children: [
        //                                 Column(
        //                                   crossAxisAlignment:
        //                                       CrossAxisAlignment.start,
        //                                   children: [
        //                                     Row(
        //                                       mainAxisAlignment:
        //                                           MainAxisAlignment.start,
        //                                       children: [
        //                                         Image.asset(
        //                                           'assets/icons/logo.png',
        //                                           height: 24,
        //                                         ),
        //                                         const SizedBox(
        //                                           width: 10,
        //                                         ),
        //                                         Text(
        //                                           "Space Wallet$dum1${(userController.users[0].hasDva == true) ? " - DVA" : ""}",
        //                                           style: GoogleFonts.nunito(
        //                                             fontSize: 20.0,
        //                                             color: Colors.white,
        //                                           ),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                     const SizedBox(
        //                                       height: 5,
        //                                     ),
        //                                     Row(
        //                                       children: [
        //                                         Text(
        //                                           (userController.users[0]
        //                                                       .hasDva ==
        //                                                   true)
        //                                               ? '${userController.users[0].dvaNumber.toString().substring(0, 3)}-${userController.users[0].dvaNumber.toString().substring(3, 6)}-${userController.users[0].dvaNumber.toString().substring(6, 10)}'
        //                                               : '${walletController.wallet[0].walletId.substring(0, 3)}-${walletController.wallet[0].walletId.substring(3, 6)}-${walletController.wallet[0].walletId.substring(6, 10)}',
        //                                           style: GoogleFonts.nunito(
        //                                             fontSize: 20.0,
        //                                             fontWeight: FontWeight.bold,
        //                                             color: Colors.greenAccent,
        //                                           ),
        //                                           textAlign: TextAlign.center,
        //                                         ),
        //                                         const SizedBox(
        //                                           width: 10,
        //                                         ),
        //                                         (userController
        //                                                     .users[0].hasDva ==
        //                                                 true)
        //                                             ? InkWell(
        //                                                 onTap: () {
        //                                                   Clipboard.setData(
        //                                                     ClipboardData(
        //                                                       text: userController
        //                                                           .users[0]
        //                                                           .dvaNumber
        //                                                           .toString(),
        //                                                     ),
        //                                                   );
        //                                                   Fluttertoast
        //                                                       .showToast(
        //                                                     msg:
        //                                                         "Account Number copied to clipboard!",
        //                                                     toastLength: Toast
        //                                                         .LENGTH_SHORT,
        //                                                     gravity:
        //                                                         ToastGravity
        //                                                             .CENTER,
        //                                                     timeInSecForIosWeb:
        //                                                         1,
        //                                                     backgroundColor:
        //                                                         brandOne,
        //                                                     textColor:
        //                                                         Colors.white,
        //                                                     fontSize: 16.0,
        //                                                   );
        //                                                 },
        //                                                 child: const Icon(
        //                                                   Icons.copy,
        //                                                   size: 16,
        //                                                   color: Colors.white,
        //                                                 ),
        //                                               )
        //                                             : const SizedBox(),
        //                                       ],
        //                                     ),
        //                                     const SizedBox(
        //                                       height: 10,
        //                                     ),
        //                                     Container(
        //                                       width: 280,
        //                                       padding:
        //                                           const EdgeInsets.fromLTRB(
        //                                               0.0, 0.0, 0.0, 0.0),
        //                                       decoration: BoxDecoration(
        //                                         color: brandFour,
        //                                         borderRadius:
        //                                             BorderRadius.circular(10),
        //                                       ),
        //                                       child: Text(
        //                                         nairaFormaet
        //                                             .format(walletController
        //                                                 .wallet[0].mainBalance)
        //                                             .toString(),
        //                                         style: GoogleFonts.nunito(
        //                                           fontSize: 30.0,
        //                                           fontWeight: FontWeight.bold,
        //                                           color: Colors.white,
        //                                         ),
        //                                       ),
        //                                     ),
        //                                     const SizedBox(
        //                                       height: 40,
        //                                     ),
        //                                     Row(
        //                                       children: [
        //                                         Text(
        //                                           (userController.users[0]
        //                                                       .hasDva ==
        //                                                   false)
        //                                               ? "${userController.users[0].firstName!.toUpperCase()} ${userController.users[0].lastName!.toUpperCase()}"
        //                                               : userController
        //                                                   .users[0].dvaName
        //                                                   .toString()
        //                                                   .toUpperCase(),
        //                                           style: GoogleFonts.nunito(
        //                                             fontSize: 15.0,
        //                                             color: Colors.white,
        //                                           ),
        //                                           textAlign: TextAlign.center,
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                         ),
        //                         back: Neumorphic(
        //                           style: NeumorphicStyle(
        //                               shape: NeumorphicShape.concave,
        //                               boxShape: NeumorphicBoxShape.roundRect(
        //                                   BorderRadius.circular(12.sp)),
        //                               depth: 0,
        //                               lightSource: LightSource.topLeft,
        //                               color: Theme.of(context).canvasColor),
        //                           child: Container(
        //                             height: 220.h,
        //                             padding: EdgeInsets.fromLTRB(
        //                               0.0.w,
        //                               10.0.h,
        //                               0.0.w,
        //                               10.0.h,
        //                             ),
        //                             decoration: BoxDecoration(
        //                               color: Theme.of(context).canvasColor,
        //                               image: const DecorationImage(
        //                                 image: AssetImage("assets/card.jpg"),
        //                                 fit: BoxFit.cover,
        //                               ),
        //                             ),
        //                             child: Column(
        //                               children: [
        //                                 Row(
        //                                   mainAxisAlignment:
        //                                       MainAxisAlignment.start,
        //                                   children: [
        //                                     Padding(
        //                                       padding: EdgeInsets.fromLTRB(
        //                                         20.0.w,
        //                                         10.0.h,
        //                                         20.0.w,
        //                                         5.0.h,
        //                                       ),
        //                                       child: Text(
        //                                         "Property of RentSpace",
        //                                         style: GoogleFonts.nunito(
        //                                           fontSize: 14.0.sp,
        //                                           color: Colors.white,
        //                                         ),
        //                                       ),
        //                                     ),
        //                                   ],
        //                                 ),
        //                                 SizedBox(
        //                                   height: 5.h,
        //                                 ),
        //                                 Container(
        //                                   color: Colors.black,
        //                                   height: 40.h,
        //                                 ),
        //                                 Padding(
        //                                   padding: EdgeInsets.fromLTRB(
        //                                     40.0.w,
        //                                     20.0.h,
        //                                     40.0.w,
        //                                     5.0.h,
        //                                   ),
        //                                   child: Container(
        //                                     color: Colors.white,
        //                                     width: MediaQuery.of(context)
        //                                         .size
        //                                         .width,
        //                                     padding: EdgeInsets.fromLTRB(
        //                                       5.0.w,
        //                                       4.0.h,
        //                                       5.0.w,
        //                                       4.0.h,
        //                                     ),
        //                                     child: Text(
        //                                       (userController.users[0].id != "")
        //                                           ? userController.users[0].id!
        //                                               .substring(0, 3)
        //                                           : "000",
        //                                       style: GoogleFonts.nunito(
        //                                         fontSize: 14.0.sp,
        //                                         color: Colors.black,
        //                                       ),
        //                                       textAlign: TextAlign.end,
        //                                     ),
        //                                   ),
        //                                 ),
        //                                 Padding(
        //                                   padding: EdgeInsets.fromLTRB(
        //                                     20.0.w,
        //                                     10.0.h,
        //                                     20.0.w,
        //                                     5.0.h,
        //                                   ),
        //                                   child: Text(
        //                                     "Disclaimer: Space wallet is 'NOT' a bank account and as such, cannot be used as one. With space wallet, you can perform in app transactions including but not limited to utility payment, savings subscription and top-up",
        //                                     style: GoogleFonts.nunito(
        //                                       fontSize: 8.0.sp,
        //                                       color: Colors.white,
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                         ),
        //                       )
        //                     : Container(
        //                         width: 420.w,
        //                         height: 230.h,
        //                         decoration: BoxDecoration(
        //                             color: brandTwo,
        //                             image: DecorationImage(
        //                               image: const AssetImage(
        //                                 "assets/card.jpg",
        //                               ),
        //                               fit: BoxFit.cover,
        //                               colorFilter: ColorFilter.mode(
        //                                 Colors.white.withOpacity(
        //                                     0.5), // Adjust the opacity here
        //                                 BlendMode.darken,
        //                               ),
        //                             ),
        //                             borderRadius: BorderRadius.circular(20.sp)),
        //                         child: Padding(
        //                           padding: EdgeInsets.only(top: 24.h),
        //                           child: Column(
        //                             children: [
        //                               Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.center,
        //                                 children: [
        //                                   Text(
        //                                     'Space Wallet',
        //                                     style: GoogleFonts.nunito(
        //                                       color: Colors.white,
        //                                       fontSize: 20.sp,
        //                                       fontWeight: FontWeight.w500,
        //                                     ),
        //                                   ),
        //                                   SizedBox(
        //                                     width: 5.w,
        //                                   ),
        //                                   GestureDetector(
        //                                     onTap: () {
        //                                       setState(() {
        //                                         hideBalance = !hideBalance;
        //                                       });
        //                                     },
        //                                     child: Icon(
        //                                       hideBalance
        //                                           ? Icons
        //                                               .visibility_off_outlined
        //                                           : Icons.visibility_outlined,
        //                                       color: Colors.white,
        //                                       size: 27.sp,
        //                                     ),
        //                                   )
        //                                 ],
        //                               ),
        //                               SizedBox(
        //                                 height: 15.h,
        //                               ),
        //                               Center(
        //                                 child: Container(
        //                                   // width: 280,
        //                                   padding: EdgeInsets.symmetric(
        //                                       horizontal: 20.w, vertical: 10.h),
        //                                   decoration: BoxDecoration(
        //                                     color: brandFour,
        //                                     borderRadius:
        //                                         BorderRadius.circular(10.sp),
        //                                   ),
        //                                   child: Text(
        //                                     " ${hideBalance ? nairaFormaet.format(walletController.wallet[0].mainBalance).toString() : "********"}",
        //                                     style: GoogleFonts.nunito(
        //                                         fontWeight: FontWeight.w800,
        //                                         fontSize: 25.sp,
        //                                         color: Colors.white),
        //                                   ),
        //                                 ),
        //                               ),
        //                               SizedBox(
        //                                 height: 25.h,
        //                               ),
        //                               GestureDetector(
        //                                 onTap: () {
        //                                   if (userController.users[0].bvn ==
        //                                       "") {
        //                                     Get.to(const BvnPage());
        //                                   } else {
        //                                     // Get.to(ViewBvnAndKyc(
        //                                     //   bvn: userController.users[0].bvn,
        //                                     //   hasVerifiedBvn: userController
        //                                     //       .users[0].hasVerifiedBvn
        //                                     //       .toString(),
        //                                     //   hasVerifiedKyc: userController
        //                                     //       .users[0].hasVerifiedKyc
        //                                     //       .toString(),
        //                                     //   kyc: userController.users[0].kyc,
        //                                     //   idImage: userController
        //                                     //       .users[0].Idimage
        //                                     //       .toString(),
        //                                     // ));
        //                                   }
        //                                 },
        //                                 child: Container(
        //                                   height: 61.h,
        //                                   width: 210.w,
        //                                   decoration: BoxDecoration(
        //                                     borderRadius:
        //                                         BorderRadius.circular(35.sp),
        //                                     color: brandTwo.withOpacity(0.3),
        //                                   ),
        //                                   child: Row(
        //                                     mainAxisAlignment:
        //                                         MainAxisAlignment.center,
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.center,
        //                                     children: [
        //                                       Text(
        //                                         'Setup Wallet',
        //                                         style: GoogleFonts.nunito(
        //                                             fontWeight: FontWeight.w700,
        //                                             color: Colors.white,
        //                                             fontSize: 20.sp),
        //                                       ),
        //                                       SizedBox(
        //                                         width: 10.w,
        //                                       ),
        //                                       Icon(
        //                                         Icons.add_circle,
        //                                         size: 30.sp,
        //                                         color: Colors.white,
        //                                       )
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       ),

        //                 // Container(
        //                 //     height: 220,
        //                 //     padding: const EdgeInsets.fromLTRB(
        //                 //         20.0, 20.0, 20.0, 20.0),
        //                 //     decoration: BoxDecoration(
        //                 //       color: brandOne,
        //                 //       borderRadius: BorderRadius.circular(12),
        //                 //     ),
        //                 //     child: Stack(
        //                 //       children: [
        //                 //         Positioned(
        //                 //           top: 0,
        //                 //           left: 0,
        //                 //           child: Image.asset(
        //                 //             'assets/cash.png',
        //                 //             width: 42,
        //                 //           ),
        //                 //         ),
        //                 //         Positioned(
        //                 //           bottom: 0,
        //                 //           left: 0,
        //                 //           child: Column(
        //                 //             children: [
        //                 //               Text(
        //                 //                 '₦0.00',
        //                 //                 style: GoogleFonts.nunito(
        //                 //                   color: Colors.white,
        //                 //                   fontSize: 22,
        //                 //                   fontWeight: FontWeight.w700,
        //                 //                 ),
        //                 //               ),
        //                 //               const SizedBox(
        //                 //                 height: 5,
        //                 //               ),
        //                 //               Text(
        //                 //                 'Space Wallet',
        //                 //                 style: GoogleFonts.nunito(
        //                 //                   color: Colors.white,
        //                 //                   fontSize: 12,
        //                 //                   fontWeight: FontWeight.w400,
        //                 //                 ),
        //                 //               ),
        //                 //             ],
        //                 //           ),
        //                 //         ),
        //                 //       ],
        //                 //     ),
        //                 //     // width: ,
        //                 //   ),
        //               ),
        //               // const SizedBox(
        //               //   height: 40,
        //               // ),
        //             ],
        //           ),
        //           // const SizedBox(
        //           //   height: 25,
        //           // ),
        //           SizedBox(
        //             height: 20.h,
        //           ),
        //           Padding(
        //             padding: EdgeInsets.all(8.0.sp),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Text(
        //                   "Account Activities",
        //                   style: GoogleFonts.nunito(
        //                     fontSize: 16.0.sp,
        //                     fontWeight: FontWeight.w700,
        //                     color: Theme.of(context).primaryColor,
        //                   ),
        //                 ),
        //                 InkWell(
        //                   onTap: () {
        //                     Get.to(AllActivities(
        //                         // activities: userInfo[0].activities.id,
        //                         // activitiesLength:
        //                         //     userInfo[0].activities.length,
        //                         ));
        //                   },
        //                   child: Text(
        //                     "See all",
        //                     style: GoogleFonts.nunito(
        //                       fontSize: 14.0.sp,
        //                       // letterSpacing: 1.0,
        //                       // fontFamily: "DefaultFontFamily",
        //                       fontWeight: FontWeight.w700,
        //                       color: Theme.of(context).primaryColor,
        //                       decoration: TextDecoration.underline,
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           const SizedBox(
        //             height: 10,
        //           ),
        //           activitiesController.activities.isNotEmpty
        //               ? ListView.builder(
        //                   scrollDirection: Axis.vertical,
        //                   shrinkWrap: true,
        //                   physics: const ClampingScrollPhysics(),
        //                   itemCount:
        //                       (activitiesController.activities.length < 2)
        //                           ? activitiesController.activities.length
        //                           : 1,
        //                   itemBuilder: (BuildContext context, int index) {
        //                     return Container(
        //                       color: Theme.of(context).canvasColor,
        //                       padding:
        //                           const EdgeInsets.fromLTRB(10.0, 10, 10.0, 10),
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.start,
        //                         children: [
        //                           Image.asset(
        //                             'assets/icons/iconset/Group462.png',
        //                             height: 40,
        //                           ),
        //                           const SizedBox(
        //                             width: 10,
        //                           ),
        //                           Text(
        //                             activitiesController
        //                                 .activities[index].description,
        //                             style: GoogleFonts.nunito(
        //                               fontSize: 14,
        //                               color: Theme.of(context).primaryColor,
        //                               fontWeight: FontWeight.bold,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     );
        //                   },
        //                 )
        //               : Padding(
        //                   padding: const EdgeInsets.all(15.0),
        //                   child: Center(
        //                     child: Text(
        //                       "No Activites Yet",
        //                       style: GoogleFonts.nunito(
        //                         fontSize: 20,
        //                         // fontFamily: "DefaultFontFamily",
        //                         color: Theme.of(context).primaryColor,
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                   ),
        //                 ),

        //           const SizedBox(
        //             height: 10,
        //           ),
        //           Visibility(
        //             visible: isContainerVisible,
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 color: Theme.of(context).cardColor,
        //                 borderRadius: BorderRadius.circular(15),
        //               ),
        //               child: Padding(
        //                 padding: const EdgeInsets.symmetric(
        //                     vertical: 10.0, horizontal: 20.0),
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     Padding(
        //                       padding: const EdgeInsets.all(8.0),
        //                       child: Row(
        //                         mainAxisAlignment:
        //                             MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           Text(
        //                             'Account Setup',
        //                             style: GoogleFonts.nunito(
        //                               color: brandOne,
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.w700,
        //                             ),
        //                           ),
        //                           GestureDetector(
        //                             onTap: () {
        //                               setState(() {
        //                                 isContainerVisible = false;
        //                               });
        //                             },
        //                             child: const Icon(
        //                               Iconsax.close_circle,
        //                               color: brandOne,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                     GestureDetector(
        //                       onTap: () {},
        //                       child: Row(
        //                         crossAxisAlignment: CrossAxisAlignment.center,
        //                         children: [
        //                           Icon(
        //                             (userController.users[0].hasVerifiedBvn ==
        //                                     false)
        //                                 ? Iconsax.verify
        //                                 : Iconsax.verify5,
        //                             color: brandOne,
        //                           ),
        //                           const SizedBox(
        //                             width: 10,
        //                           ),
        //                           Text(
        //                             'BVN Setup',
        //                             textAlign: TextAlign.center,
        //                             style: GoogleFonts.nunito(
        //                               color: brandOne,
        //                               fontSize: 14,
        //                               fontWeight: FontWeight.w600,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                     const MySeparator(),
        //                     GestureDetector(
        //                       onTap: () {
        //                         Get.to(KYCIntroPage());
        //                       },
        //                       child: Row(
        //                         crossAxisAlignment: CrossAxisAlignment.center,
        //                         children: [
        //                           Icon(
        //                             (userController.users[0].hasVerifiedKyc ==
        //                                     false)
        //                                 ? Iconsax.verify
        //                                 : Iconsax.verify5,
        //                             color: brandOne,
        //                           ),
        //                           const SizedBox(
        //                             width: 10,
        //                           ),
        //                           Text(
        //                             'KYC Setup',
        //                             textAlign: TextAlign.center,
        //                             style: GoogleFonts.nunito(
        //                               color: brandOne,
        //                               fontSize: 14,
        //                               fontWeight: FontWeight.w600,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),

        //           (userController.users[0].bvn != "" &&
        //                   userController.users[0].hasDva == false)
        //               ? Padding(
        //                   padding: const EdgeInsets.only(top: 20),
        //                   child: Container(
        //                     padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        //                     width: MediaQuery.of(context).size.width,
        //                     decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(20),
        //                       color: brandThree,
        //                     ),
        //                     child: ListTile(
        //                       onTap: () {
        //                         Get.to(const CreateDVA());
        //                       },
        //                       leading: const Icon(
        //                         Icons.person_add_outlined,
        //                         color: Colors.black,
        //                       ),
        //                       title: Text(
        //                         "Activate DVA",
        //                         style: GoogleFonts.nunito(
        //                           fontSize: 15.0,
        //                           fontWeight: FontWeight.w800,
        //                           color: Colors.black,
        //                         ),
        //                       ),
        //                       subtitle: Text(
        //                         "Free Dynamic Virtual Account (DVA)",
        //                         style: GoogleFonts.nunito(
        //                           fontSize: 14.0,
        //                           color: Colors.black,
        //                           fontWeight: FontWeight.w500,
        //                         ),
        //                       ),
        //                       trailing: const Icon(
        //                         Icons.arrow_right_outlined,
        //                         color: Colors.black,
        //                       ),
        //                       tileColor: Colors.white,
        //                     ),
        //                   ),
        //                 )
        //               : const SizedBox(
        //                   height: 1,
        //                 ),

        //           const SizedBox(
        //             height: 20,
        //           ),
        //           Container(
        //             width: 400,
        //             height: 225,
        //             decoration: BoxDecoration(
        //               color: brandTwo,
        //               borderRadius: BorderRadius.circular(20),
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.symmetric(
        //                   vertical: 24, horizontal: 24),
        //               child: Column(
        //                 children: [
        //                   Row(
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       Image.asset(
        //                         'assets/icons/iconset/fundwallet.png',
        //                         width: 30,
        //                         color: brandOne,
        //                       ),
        //                       const SizedBox(
        //                         width: 10,
        //                       ),
        //                       Text(
        //                         'Top Up Your Wallet',
        //                         textAlign: TextAlign.center,
        //                         style: GoogleFonts.nunito(
        //                           color: Colors.white,
        //                           fontSize: 16,
        //                           fontWeight: FontWeight.w700,
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                   const SizedBox(
        //                     height: 14,
        //                   ),
        //                   Text(
        //                     'Top up your wallet for seamless transactions! Add funds now and enjoy a hassle-free experience.',
        //                     style: GoogleFonts.nunito(
        //                       color: brandOne,
        //                       fontWeight: FontWeight.w700,
        //                       fontSize: 14.sp,
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     height: 14,
        //                   ),
        //                   GestureDetector(
        //                     onTap: () {
        //                       showDialog(
        //                           context: context,
        //                           barrierDismissible: true,
        //                           builder: (BuildContext context) {
        //                             return Column(
        //                               mainAxisAlignment: MainAxisAlignment.end,
        //                               children: [
        //                                 AlertDialog(
        //                                   contentPadding:
        //                                       const EdgeInsets.fromLTRB(
        //                                           30, 30, 30, 20),
        //                                   elevation: 0,
        //                                   alignment: Alignment.bottomCenter,
        //                                   insetPadding: const EdgeInsets.all(0),
        //                                   scrollable: true,
        //                                   title: null,
        //                                   shape: const RoundedRectangleBorder(
        //                                     borderRadius: BorderRadius.only(
        //                                       topLeft: Radius.circular(30),
        //                                       topRight: Radius.circular(30),
        //                                     ),
        //                                   ),
        //                                   content: SizedBox(
        //                                     child: SizedBox(
        //                                       width: 400.w,
        //                                       child: Column(
        //                                         children: [
        //                                           Padding(
        //                                             padding:
        //                                                 EdgeInsets.symmetric(
        //                                                     vertical: 40.h),
        //                                             child: Column(
        //                                               children: [
        //                                                 Padding(
        //                                                   padding: EdgeInsets
        //                                                       .symmetric(
        //                                                           vertical:
        //                                                               15.h),
        //                                                   child: Align(
        //                                                     alignment: Alignment
        //                                                         .topCenter,
        //                                                     child: Text(
        //                                                       'Securely top up your wallet',
        //                                                       style: GoogleFonts
        //                                                           .nunito(
        //                                                         color: brandOne,
        //                                                         fontSize: 16.sp,
        //                                                         fontWeight:
        //                                                             FontWeight
        //                                                                 .w500,
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ),
        //                                                 Padding(
        //                                                   padding:
        //                                                       const EdgeInsets
        //                                                           .symmetric(
        //                                                           vertical: 10),
        //                                                   child: Column(
        //                                                     children: [
        //                                                       Padding(
        //                                                         padding:
        //                                                             const EdgeInsets
        //                                                                 .all(3),
        //                                                         child:
        //                                                             ElevatedButton(
        //                                                           onPressed:
        //                                                               () {
        //                                                             Get.to(
        //                                                                 const FundWallet());
        //                                                           },
        //                                                           style: ElevatedButton
        //                                                               .styleFrom(
        //                                                             minimumSize:
        //                                                                 const Size(
        //                                                                     300,
        //                                                                     50),
        //                                                             maximumSize:
        //                                                                 const Size(
        //                                                                     300,
        //                                                                     50),
        //                                                             backgroundColor:
        //                                                                 brandOne,
        //                                                             shape:
        //                                                                 RoundedRectangleBorder(
        //                                                               borderRadius:
        //                                                                   BorderRadius.circular(
        //                                                                       8),
        //                                                             ),
        //                                                             textStyle: const TextStyle(
        //                                                                 color:
        //                                                                     brandFour,
        //                                                                 fontSize:
        //                                                                     13),
        //                                                           ),
        //                                                           child: Row(
        //                                                             mainAxisAlignment:
        //                                                                 MainAxisAlignment
        //                                                                     .center,
        //                                                             children: [
        //                                                               const Icon(
        //                                                                   Iconsax
        //                                                                       .card),
        //                                                               const SizedBox(
        //                                                                 width:
        //                                                                     10,
        //                                                               ),
        //                                                               Text(
        //                                                                 "Proceed To Top Up",
        //                                                                 style:
        //                                                                     TextStyle(
        //                                                                   color:
        //                                                                       Colors.white,
        //                                                                   fontWeight:
        //                                                                       FontWeight.w500,
        //                                                                   fontSize:
        //                                                                       12.sp,
        //                                                                 ),
        //                                                               ),
        //                                                             ],
        //                                                           ),
        //                                                         ),
        //                                                       ),
        //                                                       const SizedBox(
        //                                                         height: 10,
        //                                                       ),
        //                                                     ],
        //                                                   ),
        //                                                 ),
        //                                               ],
        //                                             ),
        //                                           ),
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 )
        //                               ],
        //                             );
        //                           });
        //                     },
        //                     child: Align(
        //                       alignment: Alignment.topLeft,
        //                       child: Container(
        //                         height: 49,
        //                         width: 150,
        //                         decoration: BoxDecoration(
        //                           color: brandOne,
        //                           borderRadius: BorderRadius.circular(30),
        //                         ),
        //                         child: Row(
        //                           mainAxisAlignment: MainAxisAlignment.center,
        //                           children: [
        //                             Image.asset(
        //                               'assets/icons/iconset/fundwallet.png',
        //                               width: 24,
        //                             ),
        //                             const SizedBox(
        //                               width: 10,
        //                             ),
        //                             Text(
        //                               'Fund Now',
        //                               style: GoogleFonts.nunito(
        //                                 color: Colors.white,
        //                                 fontSize: 16,
        //                                 fontWeight: FontWeight.w700,
        //                               ),
        //                             )
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //           const SizedBox(
        //             height: 20,
        //           ),
        //           Container(
        //             width: 400.w,
        //             height: 225.sp,
        //             decoration: BoxDecoration(
        //               color: brandOne,
        //               borderRadius: BorderRadius.circular(20),
        //             ),
        //             child: Padding(
        //               padding: EdgeInsets.symmetric(
        //                   vertical: 24.h, horizontal: 24.w),
        //               child: Column(
        //                 children: [
        //                   Row(
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       Image.asset(
        //                         'assets/icons/iconset/uil_money-withdrawal.png',
        //                         width: 30.w,
        //                         color: Colors.white,
        //                       ),
        //                       SizedBox(
        //                         width: 10.w,
        //                       ),
        //                       Text(
        //                         'Withdraw Your Funds',
        //                         textAlign: TextAlign.center,
        //                         style: GoogleFonts.nunito(
        //                           color: Colors.white,
        //                           fontSize: 16.sp,
        //                           fontWeight: FontWeight.w700,
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                   SizedBox(
        //                     height: 14.h,
        //                   ),
        //                   Text(
        //                     'Your security matters. Withdraw with confidence knowing your transactions are encrypted and secure.',
        //                     style: GoogleFonts.nunito(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.w700,
        //                       fontSize: 14.sp,
        //                     ),
        //                   ),
        //                   SizedBox(
        //                     height: 14.h,
        //                   ),
        //                   GestureDetector(
        //                     onTap: () {
        //                       showDialog(
        //                           context: context,
        //                           barrierDismissible: true,
        //                           builder: (BuildContext context) {
        //                             return Column(
        //                               mainAxisAlignment: MainAxisAlignment.end,
        //                               children: [
        //                                 AlertDialog(
        //                                   contentPadding:
        //                                       const EdgeInsets.fromLTRB(
        //                                           30, 30, 30, 20),
        //                                   elevation: 0,
        //                                   alignment: Alignment.bottomCenter,
        //                                   insetPadding: const EdgeInsets.all(0),
        //                                   scrollable: true,
        //                                   title: null,
        //                                   shape: const RoundedRectangleBorder(
        //                                     borderRadius: BorderRadius.only(
        //                                       topLeft: Radius.circular(30),
        //                                       topRight: Radius.circular(30),
        //                                     ),
        //                                   ),
        //                                   content: SizedBox(
        //                                     child: SizedBox(
        //                                       width: MediaQuery.of(context)
        //                                           .size
        //                                           .width,
        //                                       child: Column(
        //                                         children: [
        //                                           Padding(
        //                                             padding:
        //                                                 EdgeInsets.symmetric(
        //                                                     vertical: 40.h),
        //                                             child: Column(
        //                                               children: [
        //                                                 Padding(
        //                                                   padding:
        //                                                       const EdgeInsets
        //                                                           .symmetric(
        //                                                           vertical: 15),
        //                                                   child: Align(
        //                                                     alignment: Alignment
        //                                                         .topCenter,
        //                                                     child: Text(
        //                                                       'Withdraw your Secured Funds',
        //                                                       style: GoogleFonts
        //                                                           .nunito(
        //                                                         color: brandOne,
        //                                                         fontSize: 16.sp,
        //                                                         fontWeight:
        //                                                             FontWeight
        //                                                                 .w500,
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ),
        //                                                 Padding(
        //                                                   padding:
        //                                                       const EdgeInsets
        //                                                           .symmetric(
        //                                                           vertical: 10),
        //                                                   child: Column(
        //                                                     children: [
        //                                                       Padding(
        //                                                         padding:
        //                                                             const EdgeInsets
        //                                                                 .all(3),
        //                                                         child:
        //                                                             ElevatedButton(
        //                                                           onPressed:
        //                                                               () {
        //                                                             (walletController.wallet[0].mainBalance >
        //                                                                     0)
        //                                                                 ? Get.to(
        //                                                                     const WalletWithdrawal())
        //                                                                 : customErrorDialog(
        //                                                                     context,
        //                                                                     'Wallet Empty! :)',
        //                                                                     'You need to fund your wallet first!',
        //                                                                   );
        //                                                           },
        //                                                           style: ElevatedButton
        //                                                               .styleFrom(
        //                                                             minimumSize:
        //                                                                 const Size(
        //                                                                     300,
        //                                                                     50),
        //                                                             maximumSize:
        //                                                                 const Size(
        //                                                                     300,
        //                                                                     50),
        //                                                             backgroundColor:
        //                                                                 brandOne,
        //                                                             shape:
        //                                                                 RoundedRectangleBorder(
        //                                                               borderRadius:
        //                                                                   BorderRadius.circular(
        //                                                                       8),
        //                                                             ),
        //                                                             textStyle: const TextStyle(
        //                                                                 color:
        //                                                                     brandFour,
        //                                                                 fontSize:
        //                                                                     13),
        //                                                           ),
        //                                                           child: Row(
        //                                                             mainAxisAlignment:
        //                                                                 MainAxisAlignment
        //                                                                     .center,
        //                                                             children: [
        //                                                               const Icon(
        //                                                                   Iconsax
        //                                                                       .card),
        //                                                               const SizedBox(
        //                                                                 width:
        //                                                                     10,
        //                                                               ),
        //                                                               Text(
        //                                                                 "Proceed To Withdrawal",
        //                                                                 style:
        //                                                                     TextStyle(
        //                                                                   color:
        //                                                                       Colors.white,
        //                                                                   fontWeight:
        //                                                                       FontWeight.w500,
        //                                                                   fontSize:
        //                                                                       10.sp,
        //                                                                 ),
        //                                                               ),
        //                                                             ],
        //                                                           ),
        //                                                         ),
        //                                                       ),
        //                                                       const SizedBox(
        //                                                         height: 10,
        //                                                       ),
        //                                                     ],
        //                                                   ),
        //                                                 ),
        //                                               ],
        //                                             ),
        //                                           ),
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 )
        //                               ],
        //                             );
        //                           });
        //                     },
        //                     child: Align(
        //                       alignment: Alignment.topLeft,
        //                       child: Container(
        //                         height: 49.h,
        //                         width: 180.w,
        //                         decoration: BoxDecoration(
        //                           color: brandTwo,
        //                           borderRadius: BorderRadius.circular(30.sp),
        //                         ),
        //                         child: Row(
        //                           mainAxisAlignment: MainAxisAlignment.center,
        //                           children: [
        //                             Image.asset(
        //                               'assets/icons/iconset/uil_money-withdrawal.png',
        //                               width: 24.w,
        //                             ),
        //                             SizedBox(
        //                               width: 10.w,
        //                             ),
        //                             Text(
        //                               'Withdraw Now',
        //                               style: GoogleFonts.nunito(
        //                                 color: Colors.white,
        //                                 fontSize: 14.sp,
        //                                 fontWeight: FontWeight.w500,
        //                               ),
        //                             )
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),

        //           Container(
        //             padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
        //             decoration: BoxDecoration(
        //               color: Theme.of(context).canvasColor,
        //               borderRadius: const BorderRadius.only(
        //                 topLeft: Radius.circular(20),
        //                 topRight: Radius.circular(20),
        //               ),
        //             ),
        //             child: Column(
        //               children: [
        //                 // const SizedBox(
        //                 //   height: 30,
        //                 // ),
        //                 // Row(
        //                 //   mainAxisAlignment: MainAxisAlignment.start,
        //                 //   children: [
        //                 //     Padding(
        //                 //       padding: const EdgeInsets.all(8.0),
        //                 //       child: Text(
        //                 //         "Quick Options",
        //                 //         style: GoogleFonts.nunito(
        //                 //           fontWeight: FontWeight.w700,
        //                 //           fontSize: 24.0,
        //                 //           // fontFamily: "DefaultFontFamily",
        //                 //           color: Theme.of(context).primaryColor,
        //                 //         ),
        //                 //       ),
        //                 //     ),
        //                 //   ],
        //                 // ),
        //                 // const SizedBox(
        //                 //   height: 10,
        //                 // ),
        //                 // Row(
        //                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 //   children: [
        //                 //     InkWell(
        //                 //       onTap: () {
        //                 //         //Wallet top up
        //                 //         Get.bottomSheet(
        //                 //           SizedBox(
        //                 //             height: 200,
        //                 //             child: ClipRRect(
        //                 //               borderRadius: const BorderRadius.only(
        //                 //                 topLeft: Radius.circular(30.0),
        //                 //                 topRight: Radius.circular(30.0),
        //                 //               ),
        //                 //               child: Container(
        //                 //                 color: Theme.of(context).canvasColor,
        //                 //                 padding: const EdgeInsets.fromLTRB(
        //                 //                     10, 5, 10, 5),
        //                 //                 child: Column(
        //                 //                   children: [
        //                 //                     const SizedBox(
        //                 //                       height: 50,
        //                 //                     ),
        //                 //                     Text(
        //                 //                       'Securely top up your wallet',
        //                 //                       style: TextStyle(
        //                 //                         fontSize: 14,
        //                 //                         color: Theme.of(context)
        //                 //                             .primaryColor,
        //                 //                         fontFamily: "DefaultFontFamily",
        //                 //                       ),
        //                 //                     ),
        //                 //                     const SizedBox(
        //                 //                       height: 10,
        //                 //                     ),
        //                 //                     //card
        //                 //                     InkWell(
        //                 //                       onTap: () async {
        //                 //                         Get.back();
        //                 //                         Get.to(const FundWallet());
        //                 //                       },
        //                 //                       child: Container(
        //                 //                         width: MediaQuery.of(context)
        //                 //                                 .size
        //                 //                                 .width /
        //                 //                             1.8,
        //                 //                         decoration: BoxDecoration(
        //                 //                           color: brandOne,
        //                 //                           borderRadius:
        //                 //                               BorderRadius.circular(20),
        //                 //                         ),
        //                 //                         padding:
        //                 //                             const EdgeInsets.fromLTRB(
        //                 //                                 20, 5, 20, 5),
        //                 //                         child: const Row(
        //                 //                           mainAxisAlignment:
        //                 //                               MainAxisAlignment.start,
        //                 //                           children: [
        //                 //                             Icon(
        //                 //                               Icons
        //                 //                                   .credit_card_outlined,
        //                 //                               color: Colors.white,
        //                 //                               size: 30,
        //                 //                             ),
        //                 //                             SizedBox(
        //                 //                               width: 10,
        //                 //                             ),
        //                 //                             Text(
        //                 //                               'Proceed to Top up',
        //                 //                               style: TextStyle(
        //                 //                                 fontSize: 12,
        //                 //                                 fontFamily:
        //                 //                                     "DefaultFontFamily",
        //                 //                                 color: Colors.white,
        //                 //                               ),
        //                 //                             ),
        //                 //                           ],
        //                 //                         ),
        //                 //                       ),
        //                 //                     ),
        //                 //                   ],
        //                 //                 ),
        //                 //               ),
        //                 //             ),
        //                 //           ),
        //                 //         );
        //                 //       },
        //                 //       child: Container(
        //                 //         height: 200,
        //                 //         width: MediaQuery.of(context).size.width / 2.2,
        //                 //         padding:
        //                 //             const EdgeInsets.fromLTRB(10, 10, 10, 10),
        //                 //         decoration: BoxDecoration(
        //                 //           color: brandFour,
        //                 //           borderRadius: BorderRadius.circular(10),
        //                 //         ),
        //                 //         child: Stack(
        //                 //           children: [
        //                 //             Positioned(
        //                 //               bottom: 5,
        //                 //               right: 5,
        //                 //               child: Image.asset(
        //                 //                 "assets/icons/iconset/fundwallet.png",
        //                 //                 color: Colors.white.withOpacity(0.3),
        //                 //                 width: 100,
        //                 //                 height: 100,
        //                 //                 fit: BoxFit.fitWidth,
        //                 //                 // colorBlendMode: BlendMode.darken,
        //                 //               ),
        //                 //             ),
        //                 //             Column(
        //                 //               crossAxisAlignment:
        //                 //                   CrossAxisAlignment.start,
        //                 //               children: [
        //                 //                 Image.asset(
        //                 //                   "assets/icons/iconset/fundwallet.png",
        //                 //                   width: 24,
        //                 //                 ),
        //                 //                 const SizedBox(
        //                 //                   height: 4,
        //                 //                 ),
        //                 //                 const Text(
        //                 //                   "Fund Wallet",
        //                 //                   style: TextStyle(
        //                 //                     fontSize: 12.0,
        //                 //                     letterSpacing: 0.5,
        //                 //                     color: Colors.white,
        //                 //                     fontFamily: "DefaultFontFamily",
        //                 //                   ),
        //                 //                 ),
        //                 //               ],
        //                 //             ),
        //                 //           ],
        //                 //         ),
        //                 //       ),
        //                 //     ),
        //                 //     InkWell(
        //                 //       onTap: () {
        //                 //         (int.tryParse(userController
        //                 //                     .user[0].userWalletBalance)! >
        //                 //                 0)
        //                 //             ? Get.to(const WalletWithdrawal())
        //                 //             : Get.snackbar(
        //                 //                 "Wallet Empty!",
        //                 //                 'You need to fund your wallet first!',
        //                 //                 animationDuration:
        //                 //                     const Duration(seconds: 1),
        //                 //                 backgroundColor: Colors.red,
        //                 //                 colorText: Colors.white,
        //                 //                 snackPosition: SnackPosition.BOTTOM,
        //                 //               );
        //                 //       },
        //                 //       child: Container(
        //                 //         height: 200,
        //                 //         width: MediaQuery.of(context).size.width / 2.2,
        //                 //         padding:
        //                 //             const EdgeInsets.fromLTRB(10, 10, 10, 10),
        //                 //         decoration: BoxDecoration(
        //                 //           color: brandTwo,
        //                 //           borderRadius: BorderRadius.circular(10),
        //                 //         ),
        //                 //         child: Stack(
        //                 //           children: [
        //                 //             Positioned(
        //                 //               bottom: 5,
        //                 //               right: 5,
        //                 //               child: Image.asset(
        //                 //                 "assets/icons/iconset/uil_money-withdrawal.png",
        //                 //                 // color: Colors.transparent.withOpacity(0.9),
        //                 //                 // opacity: Animation<0.3>,
        //                 //                 width: 100,
        //                 //                 height: 100,
        //                 //                 fit: BoxFit.fitWidth,
        //                 //                 colorBlendMode: BlendMode.overlay,
        //                 //               ),
        //                 //             ),
        //                 //             Column(
        //                 //               crossAxisAlignment:
        //                 //                   CrossAxisAlignment.start,
        //                 //               children: [
        //                 //                 Image.asset(
        //                 //                   "assets/icons/iconset/uil_money-withdrawal.png",
        //                 //                   width: 35,
        //                 //                 ),
        //                 //                 const SizedBox(
        //                 //                   height: 4,
        //                 //                 ),
        //                 //                 const Text(
        //                 //                   "Withdraw Funds",
        //                 //                   style: TextStyle(
        //                 //                     fontSize: 12.0,
        //                 //                     letterSpacing: 0.5,
        //                 //                     fontFamily: "DefaultFontFamily",
        //                 //                     color: Colors.white,
        //                 //                   ),
        //                 //                 ),
        //                 //               ],
        //                 //             ),
        //                 //           ],
        //                 //         ),
        //                 //       ),
        //                 //     ),
        //                 //   ],
        //                 // ),

        //                 const SizedBox(
        //                   height: 20,
        //                 ),
        //                 // (userInfo[0].bvn != "" &&
        //                 //         userInfo[0].hasDva == 'false')
        //                 //     ? Container(
        //                 //         padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        //                 //         width: MediaQuery.of(context).size.width,
        //                 //         decoration: BoxDecoration(
        //                 //           borderRadius: BorderRadius.circular(10),
        //                 //           color: brandThree,
        //                 //         ),
        //                 //         child: ListTile(
        //                 //           onTap: () {
        //                 //             Get.to(const CreateDVA());
        //                 //           },
        //                 //           leading: const Icon(
        //                 //             Icons.person_add_outlined,
        //                 //             color: Colors.black,
        //                 //           ),
        //                 //           title: const Text(
        //                 //             "Activate DVA",
        //                 //             style: TextStyle(
        //                 //               fontSize: 15.0,
        //                 //               fontWeight: FontWeight.bold,
        //                 //               fontFamily: "DefaultFontFamily",
        //                 //               letterSpacing: 0.5,
        //                 //               color: Colors.black,
        //                 //             ),
        //                 //           ),
        //                 //           subtitle: const Text(
        //                 //             "Free Dynamic Virtual Account (DVA)",
        //                 //             style: TextStyle(
        //                 //               fontSize: 14.0,
        //                 //               letterSpacing: 0.5,
        //                 //               fontFamily: "DefaultFontFamily",
        //                 //               color: Colors.black,
        //                 //             ),
        //                 //           ),
        //                 //           trailing: const Icon(
        //                 //             Icons.arrow_right_outlined,
        //                 //             color: Colors.black,
        //                 //           ),
        //                 //           tileColor: Colors.red,
        //                 //         ),
        //                 //       )
        //                 //     : const SizedBox(
        //                 //         height: 1,
        //                 //       ),

        //                 // const SizedBox(
        //                 //   height: 20,
        //                 // ),
        //                 InkWell(
        //                   onTap: () {
        //                     //Get.to(RentSpaceCommunity());
        //                     // Get.snackbar(
        //                     //   "Coming soon!",
        //                     //   'This feature is coming soon to RentSpace!',
        //                     //   animationDuration: const Duration(seconds: 1),
        //                     //   backgroundColor: brandOne,
        //                     //   colorText: Colors.white,
        //                     //   snackPosition: SnackPosition.TOP,
        //                     // );
        //                     showTopSnackBar(
        //                       Overlay.of(context),
        //                       CustomSnackBar.error(
        //                         backgroundColor: brandOne,
        //                         message: 'Coming Soon :)',
        //                         textStyle: GoogleFonts.nunito(
        //                           fontSize: 14,
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w700,
        //                         ),
        //                       ),
        //                     );
        //                   },
        //                   child: Container(
        //                     width: double.infinity,
        //                     padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        //                     decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(10),
        //                       color: brandTwo,
        //                     ),
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Container(
        //                           margin:
        //                               const EdgeInsets.fromLTRB(0, 10, 0, 30),
        //                           child: Row(
        //                             mainAxisAlignment: MainAxisAlignment.start,
        //                             crossAxisAlignment:
        //                                 CrossAxisAlignment.start,
        //                             children: [
        //                               // Icon(
        //                               //   Icons.forum_outlined,
        //                               //   color: Colors.white,
        //                               //   size: 20,
        //                               // ),
        //                               Image.asset(
        //                                 'assets/community.png',
        //                                 width: 28,
        //                                 color: Colors.white,
        //                               ),
        //                               const SizedBox(
        //                                 width: 10,
        //                               ),
        //                               Column(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.start,
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: [
        //                                   Text(
        //                                     "RentSpace community",
        //                                     style: GoogleFonts.nunito(
        //                                       fontSize: 18.0,
        //                                       color: Colors.white,
        //                                       fontWeight: FontWeight.w700,
        //                                     ),
        //                                   ),
        //                                   const SizedBox(
        //                                     height: 15,
        //                                   ),
        //                                   Text(
        //                                     "View the amazing community\nof other Spacers!",
        //                                     style: GoogleFonts.nunito(
        //                                         fontSize: 12.0,
        //                                         color: Colors.white,
        //                                         fontWeight: FontWeight.w400),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //                 const SizedBox(
        //                   height: 20,
        //                 ),

        //                 // StreamBuilder(
        //                 //     stream: announcements.snapshots(),
        //                 //     builder: (BuildContext context,
        //                 //         AsyncSnapshot<QuerySnapshot> snapshot) {
        //                 //       if (!snapshot.hasData ||
        //                 //           snapshot.data!.docs.isEmpty) {
        //                 //         return const SizedBox();
        //                 //       } else {
        //                 //         String announcementText =
        //                 //             snapshot.data!.docs[0]['body'];

        //                 //         // Check if this is a new announcement (compare with previous announcement)
        //                 //         if (announcementText !=
        //                 //             previousAnnouncementText) {
        //                 //           _showAnnouncementNotification(
        //                 //               'New Announcement', announcementText);

        //                 //           // Update the previous announcement text
        //                 //           previousAnnouncementText = announcementText;
        //                 //         }
        //                 //         //  _showAnnouncementNotification('New Announcement', announcementText);
        //                 //         return const Text(
        //                 //           '',
        //                 //           style: TextStyle(
        //                 //             color: Colors.white,
        //                 //             fontSize: 16,
        //                 //             fontFamily: "DefaultFontFamily",
        //                 //           ),
        //                 //         );
        //                 //         // },
        //                 //       }
        //                 //     }
        //                 //     // }

        //                 //     ),
        //               ],
        //             ),
        //           ),
        //           // Container(
        //           //   color: Theme.of(context).canvasColor,
        //           //   height: 80,
        //           // )
        //           //end of community
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    // valueNotifier.dispose();
    super.dispose();
  }
}
