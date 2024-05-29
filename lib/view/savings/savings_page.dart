import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_intro.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_list.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/widgets/custom_dialog.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet_controller.dart';

class SavingsPage extends StatefulWidget {
  SavingsPage({
    Key? key,
  }) : super(key: key);

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

// final RentController rentController = Get.put(RentController());
List savingOptions = [
  {
    'imageIcon': 'assets/icons/space_rent.png',
    'title': 'SpaceRent',
    'content': 'Save 70% of your rent and get 30% loan.',
    'locationInitial': 'SpaceRentIntro',
    'location': 'RentSpaceList',
  },
  {
    'imageIcon': 'assets/icons/space_deposit.png',
    'title': 'Space Deposit',
    'content':
        'Save 70% of rent for a minimum of 90 days at an interest of 14% and get 100% (Terms and conditions apply)',
    'locationInitial': 'SpaceDepositIntro',
    'location': 'SpaceDepositList',
  },
];

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');

String _hasRent = "";
double tankBalance = 0;
double boxBalance = 0;
double depositBalance = 0;
double rentBalance = 0;
double targetBalance = 0;
double totalSavings = 0;
double totalAssets = 0;
bool hideBalance = false;
bool _isLoading = false;

class _SavingsPageState extends State<SavingsPage> {
  final RentController rentController = Get.find();
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();

  getSavings() {
    print("rentController.rent");
    // if (tankController.tank.isNotEmpty) {
    //   for (int i = 0; i < tankController.tank.length; i++) {
    //     tankBalance += tankController.tank[i].targetAmount.toInt();
    //   }
    // } else {
    //   setState(() {
    //     tankBalance = 0;
    //   });
    // }
    // if (userController.userModel!.userDetails![0].hasRent == true) {
    if (rentController.rentModel!.rents!.isNotEmpty) {
      // rentBalance += rentController.rentModel!.rent![0].paidAmount;
      // targetBalance += rentController.rentModel!.rent![0].amount;
      for (int j = 0; j < rentController.rentModel!.rents!.length; j++) {
        rentBalance += rentController.rentModel!.rents![j].paidAmount;
        targetBalance += rentController.rentModel!.rents![j].amount;
      }
    }
    // }
    else {
      setState(() {
        rentBalance = 0;
        targetBalance = 0;
      });
      // }
      // if (boxController.box.isNotEmpty) {
      //   for (int i = 0; i < boxController.box.length; i++) {
      //     boxBalance += boxController.box[i].savedAmount.toInt();
      //   }
      // } else {
      //   setState(() {
      //     boxBalance = 0;
      //   });
      // }
      // if (depositController.deposit.isNotEmpty) {
      //   for (int i = 0; i < depositController.deposit.length; i++) {
      //     depositBalance += depositController.deposit[i].savedAmount.toInt();
      //   }
      // } else {
      //   setState(() {
      //     depositBalance = 0;
      //   });
    }

    setState(() {
      totalSavings = (tankBalance + rentBalance + boxBalance + depositBalance);
      totalAssets =
          (walletController.walletModel!.wallet![0].mainBalance + rentBalance
          // +
          // boxBalance +
          // depositBalance
          );
    });
  }

  @override
  initState() {
    super.initState();
    rentBalance = 0;
    targetBalance = 0;
    tankBalance = 0;
    boxBalance = 0;
    depositBalance = 0;
    totalSavings = 0;
    totalAssets = 0;
    hideBalance = false;
    // walletController.fetchWallet();
    // fetchCachedRentData();
    // Then start fetching the updated data
    // fetchRentData();
    // rentController.startFetchingRent();
    // getUser();
    //deleteSpecifiedDocs();
    getSavings();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffF6F6F8),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Text(
            'Savings',
            style: GoogleFonts.lato(
              color: colorBlack,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: 24.w, top: 0, right: 24.w, bottom: 20.h),
            child: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: brandOne,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15.w, top: 14.h, right: 0.w, bottom: 14.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Savings',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: colorWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    nairaFormaet.format(totalSavings),
                                    style: GoogleFonts.lato(
                                      fontSize: 30,
                                      color: colorWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 14.h), // Add space between the columns
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Space Deposit',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: const Color(0xffB9B9B9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '0',
                                  style: GoogleFonts.lato(
                                    fontSize: 30,
                                    color: const Color(0xffB9B9B9),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 40.h,
                      right: -10.w,
                      child: Transform.scale(
                        scale: MediaQuery.of(context).size.width /
                            300, // Adjust the reference width as needed
                        child: Image.asset(
                          'assets/logo_blue.png',
                          width: 103.91, // Width without scaling
                          height: 144.17, // Height without scaling
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Padding(
          //   padding:
          //       EdgeInsets.only(left: 0.w, top: 0, right: 0.w, bottom: 20.h),
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.h),
          //     height: 150.h,
          //     width: MediaQuery.of(context).size.width,
          //     decoration: const BoxDecoration(
          //       image: DecorationImage(
          //         image: AssetImage(
          //           'assets/savings_img.png',
          //         ),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignmentaceBetween,
          //       children: [
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Text(
          //               'Space Rent',
          //               style: GoogleFonts.lato(
          //                   fontSize: 12,
          //                   color: colorWhite,
          //                   fontWeight: FontWeight.w500),
          //             ),
          //             Text(
          //               nairaFormaet.format(rentBalance),
          //               style: GoogleFonts.lato(
          //                   fontSize: 30,
          //                   color: colorWhite,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //           ],
          //         ),
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Text(
          //               'Space Deposit',
          //               style: GoogleFonts.lato(
          //                   fontSize: 12,
          //                   color: const Color(0xffB9B9B9),
          //                   fontWeight: FontWeight.w500),
          //             ),
          //             Text(
          //               nairaFormaet.format(0),
          //               style: GoogleFonts.lato(
          //                   fontSize: 30,
          //                   color: const Color(0xffB9B9B9),
          //                   fontWeight: FontWeight.w600),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // Padding(
          //   padding: EdgeInsets.only(
          //     left: 20,
          //     top: 0,
          //     bottom: 20,
          //     right: 20,
          //   ),
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     height: 200.h,
          //     decoration: BoxDecoration(
          //       color: brandOne,
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignmentaceBetween,
          //       children: [
          //         Padding(
          //           padding:
          //               EdgeInsets.only(top: 15, left: 10, right: 10),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Row(
          //                 children: [
          //                   Icon(
          //                     Icons.verified_user,
          //                     color: Colors.green,
          //                     size: 17,
          //                   ),
          //                   const SizedBox(
          //                     width: 5,
          //                   ),
          //                   Text(
          //                     "Total Assets",
          //                     textAlign: TextAlign.center,
          //                     style: GoogleFonts.lato(
          //                       fontSize: 15.0,
          //                       // fontFamily: "DefaultFontFamily",
          //                       // letterSpacing: 0.5,
          //                       fontWeight: FontWeight.w600,
          //                       color: Colors.white,
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     width: 5,
          //                   ),
          //                   GestureDetector(
          //                     onTap: () {
          //                       setState(() {
          //                         hideBalance = !hideBalance;
          //                       });
          //                     },
          //                     child: Icon(
          //                       hideBalance
          //                           ? Icons.visibility_outlined
          //                           : Icons.visibility_off_outlined,
          //                       color: Colors.white,
          //                       size: 20,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               SizedBox(
          //                 height: 5,
          //               ),
          //               (walletController.isLoading.value)
          //                   ? Text(
          //                       nairaFormaet.format(0),
          //                       style: GoogleFonts.roboto(
          //                         fontSize: 20.0,
          //                         // fontFamily: "DefaultFontFamily",
          //                         // letterSpacing: 0.5,
          //                         fontWeight: FontWeight.w600,
          //                         color: Colors.white,
          //                       ),
          //                     )
          //                   : Text(
          //                       " ${hideBalance ? nairaFormaet.format(totalAssets).toString() : "*****"}",
          //                       //  textAlign: TextAlign.center,
          //                       style: GoogleFonts.roboto(
          //                         fontSize: 20.0,
          //                         // fontFamily: "DefaultFontFamily",
          //                         // letterSpacing: 0.5,
          //                         fontWeight: FontWeight.w600,
          //                         color: Colors.white,
          //                       ),
          //                     ),
          //             ],
          //           ),
          //         ),
          //         SizedBox(
          //           height: 120.h,
          //           child: ListView(
          //             scrollDirection: Axis.horizontal,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.only(left: 10.w, bottom: 15.h),
          //                 child: Container(
          //                   width: 170.w,
          //                   decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     borderRadius: BorderRadius.circular(15),
          //                   ),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     mainAxisAlignment: MainAxisAlignmentaceBetween,
          //                     children: [
          //                       Padding(
          //                         padding: EdgeInsets.all(8.0),
          //                         child: Row(
          //                           mainAxisAlignment:
          //                               MainAxisAlignmentaceBetween,
          //                           children: [
          //                             Row(
          //                               children: [
          //                                 Container(
          //                                   padding: EdgeInsets.all(5),
          //                                   decoration: BoxDecoration(
          //                                     color: brandTwo.withOpacity(0.2),
          //                                     borderRadius:
          //                                         BorderRadius.circular(100),
          //                                   ),
          //                                   child: Image.asset(
          //                                     'assets/icons/space_rent.png',
          //                                     color: brandOne,
          //                                     scale: 4,
          //                                     // width: 20,
          //                                   ),
          //                                 ),
          //                                 const SizedBox(
          //                                   width: 5,
          //                                 ),
          //                                 Text(
          //                                   'Space Rent',
          //                                   textAlign: TextAlign.center,
          //                                   style: GoogleFonts.lato(
          //                                     fontSize: 15.0,
          //                                     fontWeight: FontWeight.w600,
          //                                     // fontFamily: "DefaultFontFamily",
          //                                     // letterSpacing: 0.5,
          //                                     color: brandOne,
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                       Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: (rentController.isLoading.value)
          //                             ? Text(
          //                                 nairaFormaet.format(0),
          //                                 style: GoogleFonts.roboto(
          //                                   fontSize: 17.0,
          //                                   // fontFamily: "DefaultFontFamily",
          //                                   // letterSpacing: 0.5,
          //                                   fontWeight: FontWeight.w600,
          //                                   color: brandOne,
          //                                 ),
          //                               )
          //                             : Text(
          //                                 " ${hideBalance ? nairaFormaet.format(rentBalance).toString() : "*****"}",
          //                                 //  textAlign: TextAlign.center,
          //                                 style: GoogleFonts.roboto(
          //                                   fontSize: 17.0,
          //                                   // fontFamily: "DefaultFontFamily",
          //                                   // letterSpacing: 0.5,
          //                                   fontWeight: FontWeight.w600,
          //                                   color: brandOne,
          //                                 ),
          //                               ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //               // Padding(
          //               //   padding: const EdgeInsets.only(
          //               //       left: 10, bottom: 15, right: 10),
          //               //   child: Container(
          //               //     width: 200,
          //               //     decoration: BoxDecoration(
          //               //       color: Colors.white,
          //               //       borderRadius: BorderRadius.circular(15),
          //               //     ),
          //               //     child: Column(
          //               //       crossAxisAlignment: CrossAxisAlignment.start,
          //               //       mainAxisAlignment: MainAxisAlignmentaceBetween,
          //               //       children: [
          //               //         Padding(
          //               //           padding: const EdgeInsets.all(8.0),
          //               //           child: Row(
          //               //             mainAxisAlignment:
          //               //                 MainAxisAlignmentaceBetween,
          //               //             children: [
          //               //               Row(
          //               //                 children: [
          //               //                   Container(
          //               //                     padding: EdgeInsets.all(5),
          //               //                     decoration: BoxDecoration(
          //               //                       color: brandTwo.withOpacity(0.2),
          //               //                       borderRadius:
          //               //                           BorderRadius.circular(100),
          //               //                     ),
          //               //                     child: Image.asset(
          //               //                       'assets/icons/space_deposit.png',
          //               //                       color: brandOne,
          //               //                       scale: 5,
          //               //                       // width: 20,
          //               //                     ),
          //               //                   ),
          //               //                   const SizedBox(
          //               //                     width: 5,
          //               //                   ),
          //               //                   Text(
          //               //                     'Space Deposit',
          //               //                     textAlign: TextAlign.center,
          //               //                     style: GoogleFonts.lato(
          //               //                       fontSize: 15.0,
          //               //                       fontWeight: FontWeight.w600,
          //               //                       // fontFamily: "DefaultFontFamily",
          //               //                       // letterSpacing: 0.5,
          //               //                       color: brandOne,
          //               //                     ),
          //               //                   ),
          //               //                 ],
          //               //               ),
          //               //               GestureDetector(
          //               //                 onTap: () {
          //               //                   (depositController.deposit.isEmpty)
          //               //                       ? Get.to(
          //               //                           const SpaceDepositIntro())
          //               //                       : Get.to(
          //               //                           const SpaceDepositList());
          //               //                 },
          //               //                 child: const Icon(
          //               //                   Icons.arrow_forward_ios,
          //               //                   size: 15,
          //               //                 ),
          //               //               ),
          //               //             ],
          //               //           ),
          //               //         ),
          //               //         Padding(
          //               //           padding: const EdgeInsets.all(8.0),
          //               //           child: Text(
          //               //             " ${hideBalance ? nairaFormaet.format(depositBalance).toString() : "*****"}",
          //               //             //  textAlign: TextAlign.center,
          //               //             style: GoogleFonts.lato(
          //               //               fontSize: 17.0,
          //               //               // fontFamily: "DefaultFontFamily",
          //               //               // letterSpacing: 0.5,
          //               //               fontWeight: FontWeight.w600,
          //               //               color: brandOne,
          //               //             ),
          //               //           ),
          //               //         ),
          //               //       ],
          //               //     ),
          //               //   ),
          //               // )
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 10.h),
            child: Text(
              'Top Savings',
              textScaleFactor: 1.0,
              style:
                  GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              // top: 45,
              bottom: 25,
              right: 24.w,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      (userController
                                  .userModel!.userDetails![0].hasVerifiedBvn ==
                              true)
                          ? Get.to(const RentSpaceList())
                          : customErrorDialog(
                              context,
                              'Verification!',
                              'You need to verify your BVN in order to use this service!',
                            );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: brandTwo.withOpacity(0.2),
                              ),
                              // child: const Icon(
                              //   Iconsax.security,
                              //   color: brandOne,
                              // ),
                              child: Image.asset(
                                'assets/icons/space_rent.png',
                                width: 19.5,
                                height: 19.5,
                                // color: brandOne,
                              ),
                            ),
                            title: Text(
                              'Space Rent',
                              style: GoogleFonts.lato(
                                color: brandOne,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Save 70% of your rent and get up to 30% loan.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                color: const Color(0xff4B4B4B),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(
                              Iconsax.arrow_right_3,
                              color: colorBlack,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17.w),
                    child: const Divider(
                      thickness: 1,
                      color: Color(0xffC9C9C9),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showTopSnackBar(
                        Overlay.of(context),
                        CustomSnackBar.success(
                          backgroundColor: brandOne,
                          message: 'Coming soon !!',
                          textStyle: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: brandTwo.withOpacity(0.2),
                              ),
                              // child: const Icon(
                              //   Iconsax.security,
                              //   color: brandOne,
                              // ),
                              child: Image.asset(
                                'assets/icons/lock_deposit_icon.png',
                                width: 19.5,
                                height: 19.5,
                                // scale: 4,
                                // color: brandOne,
                              ),
                            ),
                            title: Text(
                              'Space Deposit',
                              style: GoogleFonts.lato(
                                color: brandOne,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Lock your money safely for later use.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                color: const Color(0xff4B4B4B),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: brandTwo.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "Coming Soon",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 12.0,
                                      // fontFamily: "DefaultFontFamily",
                                      // letterSpacing: 0.5,
                                      fontWeight: FontWeight.w600,
                                      color: brandOne,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ListView.builder(
                  //   scrollDirection: Axis.vertical,
                  //   shrinkWrap: true,
                  //   // padding: const EdgeInsets.all(10),
                  //   itemCount: 2,
                  //   physics: const ClampingScrollPhysics(),
                  //   itemBuilder: (BuildContext context, int index) {
                  //     // final savingsContent = savingOptions[index];
                  //     return
                  //     GestureDetector(
                  //       onTap: () {
                  //         (rentController.rent.isEmpty)
                  //             ? Get.to(SpaceRentIntro())
                  //             : Get.to(SpaceRentIntro());
                  //       },
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Container(
                  //           // height: 200,
                  //           decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           child: Padding(
                  //             padding: const EdgeInsets.symmetric(vertical: 15),
                  //             child: ListTile(
                  //               leading: Container(
                  //                 padding: const EdgeInsets.all(12),
                  //                 decoration: BoxDecoration(
                  //                   shape: BoxShape.circle,
                  //                   color: brandTwo.withOpacity(0.2),
                  //                 ),
                  //                 // child: const Icon(
                  //                 //   Iconsax.security,
                  //                 //   color: brandOne,
                  //                 // ),
                  //                 child: Image.asset(
                  //                   'assets/icons/space_rent.png',
                  //                   scale: 4,
                  //                   color: brandTwo,
                  //                 ),
                  //               ),
                  //               title: Text(
                  //                 'SpaceRent',
                  //                 style: GoogleFonts.lato(
                  //                   color: brandOne,
                  //                   fontSize: 17,
                  //                   fontWeight: FontWeight.w600,
                  //                 ),
                  //               ),
                  //               subtitle: Text(
                  //                 'Save 70% of your rent and get 30% loan.',
                  //                 maxLines: 2,
                  //                 overflow: TextOverflow.ellipsis,
                  //                 style: GoogleFonts.lato(
                  //                   color: navigationcolorText,
                  //                   fontSize: 12,
                  //                   fontWeight: FontWeight.w600,
                  //                 ),
                  //               ),
                  //               // onTap: () {
                  //               //   // Navigator.pushNamed(context, RouteList.profile);
                  //               // },
                  //               trailing: Container(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 15, vertical: 5),
                  //                 decoration: BoxDecoration(
                  //                   color: brandTwo,
                  //                   borderRadius: BorderRadius.circular(20),
                  //                 ),
                  //                 child: Text(
                  //                   "Save",
                  //                   textAlign: TextAlign.center,
                  //                   style: GoogleFonts.lato(
                  //                     fontSize: 15.0,
                  //                     // fontFamily: "DefaultFontFamily",
                  //                     // letterSpacing: 0.5,
                  //                     fontWeight: FontWeight.w600,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
