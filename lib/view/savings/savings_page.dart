// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
// import 'package:rentspace/controller/auth/user_controller.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:rentspace/controller/box_controller.dart';
// import 'package:rentspace/controller/deposit_controller.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
// import 'package:rentspace/controller/tank_controller.dart';
// import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_intro.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_list.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_intro.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_list.dart';
import 'package:rentspace/view/savings/spaceTank/spacetank_subscription.dart';

import '../../constants/widgets/custom_dialog.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet_controller.dart';
import '../../model/spacerent_model.dart';

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
// final FirebaseFirestore firestore = FirebaseFirestore.instance;

String _hasRent = "";
double tankBalance = 0;
// var dum2 = "".obs();
double boxBalance = 0;
double depositBalance = 0;
double rentBalance = 0;
double targetBalance = 0;
double totalSavings = 0;
double totalAssets = 0;
bool hideBalance = false;
// List<SpaceRent> _cachedRentData = [];
bool _isLoading = false;

class _SavingsPageState extends State<SavingsPage> {
  final RentController rentController = Get.find();
  // final BoxController boxController = Get.find();
  // final DepositController depositController = Get.find();
  // final TankController tankController = Get.find();
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();

  // deleteSpecifiedDocs() async {
  //   // Query the collection for documents where "amount" is 0 and "id" is "me"
  //   QuerySnapshot querySnapshot = await firestore
  //       .collection('spacetank')
  //       .where('has_paid', isEqualTo: "false")
  //       .where('id', isEqualTo: userController.user[0].id)
  //       .get();

  //   // Loop through the documents and delete each one
  //   for (QueryDocumentSnapshot doc in querySnapshot.docs) {
  //     await firestore.collection('spacetank').doc(doc.id).delete();
  //   }
  // }

  // getUser() async {
  //   var collection = FirebaseFirestore.instance.collection('accounts');
  //   var docSnapshot = await collection.doc(userId).get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     setState(() {
  //       _hasRent = data?['has_rent'];
  //     });
  //   }
  // }

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
        print('paid');
        print(rentController.rentModel!.rents![j].paidAmount);
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
    print(totalSavings);
    print(totalAssets);
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
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Save',
          style: GoogleFonts.nunito(
            color: Theme.of(context).primaryColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 15,
              bottom: 25,
              right: 20,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                color: brandOne,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                             Icon(
                              Icons.verified_user,
                              color: Colors.green,
                              size: 17.sp,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Total Assets",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                fontSize: 15.0.sp,
                                // fontFamily: "DefaultFontFamily",
                                // letterSpacing: 0.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  hideBalance = !hideBalance;
                                });
                              },
                              child: Icon(
                                hideBalance
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ],
                        ),
                         SizedBox(
                          height: 10.sp,
                        ),
                        (walletController.isLoading.value)
                            ? Text(
                                nairaFormaet.format(0),
                                style: GoogleFonts.nunito(
                                  fontSize: 22.0.sp,
                                  // fontFamily: "DefaultFontFamily",
                                  // letterSpacing: 0.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                " ${hideBalance ? nairaFormaet.format(totalAssets).toString() : "*****"}",
                                //  textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  fontSize: 22.0.sp,
                                  // fontFamily: "DefaultFontFamily",
                                  // letterSpacing: 0.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 90.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(left: 10.w, bottom: 15.h),
                          child: Container(
                            width: 170.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5.sp),
                                            decoration: BoxDecoration(
                                              color: brandTwo.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(100.sp),
                                            ),
                                            child: Image.asset(
                                              'assets/icons/space_rent.png',
                                              color: brandOne,
                                              scale: 4.sp,
                                              // width: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'SpaceRent',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.nunito(
                                              fontSize: 15.0.sp,
                                              fontWeight: FontWeight.w600,
                                              // fontFamily: "DefaultFontFamily",
                                              // letterSpacing: 0.5,
                                              color: brandOne,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     (rentController.rent.isEmpty)
                                      //         ? Get.to(const SpaceRentIntro())
                                      //         : Get.to(const RentSpaceList());
                                      //   },
                                      //   child: const Icon(
                                      //     Icons.arrow_forward_ios,
                                      //     size: 15,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: (rentController.isLoading.value)
                                      ? Text(
                                          nairaFormaet.format(0),
                                          style: GoogleFonts.nunito(
                                            fontSize: 17.0.sp,
                                            // fontFamily: "DefaultFontFamily",
                                            // letterSpacing: 0.5,
                                            fontWeight: FontWeight.w700,
                                            color: brandOne,
                                          ),
                                        )
                                      : Text(
                                          " ${hideBalance ? nairaFormaet.format(rentBalance).toString() : "*****"}",
                                          //  textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                            fontSize: 17.0.sp,
                                            // fontFamily: "DefaultFontFamily",
                                            // letterSpacing: 0.5,
                                            fontWeight: FontWeight.w700,
                                            color: brandOne,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 10, bottom: 15, right: 10),
                        //   child: Container(
                        //     width: 200,
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(15),
                        //     ),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     padding: EdgeInsets.all(5.sp),
                        //                     decoration: BoxDecoration(
                        //                       color: brandTwo.withOpacity(0.2),
                        //                       borderRadius:
                        //                           BorderRadius.circular(100.sp),
                        //                     ),
                        //                     child: Image.asset(
                        //                       'assets/icons/space_deposit.png',
                        //                       color: brandOne,
                        //                       scale: 5.sp,
                        //                       // width: 20,
                        //                     ),
                        //                   ),
                        //                   const SizedBox(
                        //                     width: 5,
                        //                   ),
                        //                   Text(
                        //                     'Space Deposit',
                        //                     textAlign: TextAlign.center,
                        //                     style: GoogleFonts.nunito(
                        //                       fontSize: 15.0,
                        //                       fontWeight: FontWeight.w600,
                        //                       // fontFamily: "DefaultFontFamily",
                        //                       // letterSpacing: 0.5,
                        //                       color: brandOne,
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               GestureDetector(
                        //                 onTap: () {
                        //                   (depositController.deposit.isEmpty)
                        //                       ? Get.to(
                        //                           const SpaceDepositIntro())
                        //                       : Get.to(
                        //                           const SpaceDepositList());
                        //                 },
                        //                 child: const Icon(
                        //                   Icons.arrow_forward_ios,
                        //                   size: 15,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Text(
                        //             " ${hideBalance ? nairaFormaet.format(depositBalance).toString() : "*****"}",
                        //             //  textAlign: TextAlign.center,
                        //             style: GoogleFonts.nunito(
                        //               fontSize: 17.0.sp,
                        //               // fontFamily: "DefaultFontFamily",
                        //               // letterSpacing: 0.5,
                        //               fontWeight: FontWeight.w700,
                        //               color: brandOne,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              // top: 45,
              bottom: 25,
              right: 20,
            ),
            child: Container(
              padding: const EdgeInsets.only(
                left: 10,
                top: 10,
                bottom: 20,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: brandTwo.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 15,
                      bottom: 10,
                      // right: 20,
                    ),
                    child: Text(
                      'Savings Plan',
                      style: GoogleFonts.nunito(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      (userController
                                  .userModel!.userDetails![0].hasVerifiedBvn ==
                              true)
                          ? (rentController.rentModel!.rents!.isEmpty)
                              ? Get.to(const SpaceRentIntro())
                              : Get.to(const RentSpaceList())
                          : customErrorDialog(
                              context,
                              'Verification!',
                              'You need to verify your BVN in order to use this service!',
                            );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: brandTwo.withOpacity(0.2),
                              ),
                              // child: const Icon(
                              //   Iconsax.security,
                              //   color: brandOne,
                              // ),
                              child: Image.asset(
                                'assets/icons/space_rent.png',
                                scale: 4,
                                color: brandTwo,
                              ),
                            ),
                            title: Text(
                              'Space Rent',
                              style: GoogleFonts.nunito(
                                color: brandOne,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Save 70% of your rent and get up to 30% loan.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunito(
                                color: navigationcolorText,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // onTap: () {
                            //   // Navigator.pushNamed(context, RouteList.profile);
                            // },
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: brandTwo,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Save",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  fontSize: 12.0.sp,
                                  // fontFamily: "DefaultFontFamily",
                                  // letterSpacing: 0.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // GestureDetector(
                  //   onTap: () {
                  //     (depositController.deposit.isEmpty)
                  //         ? Get.to(const SpaceDepositIntro())
                  //         : Get.to(const SpaceDepositList());
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Container(
                  //       // height: 200,
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 15),
                  //         child: ListTile(
                  //           leading: Container(
                  //             padding: const EdgeInsets.all(12),
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: brandTwo.withOpacity(0.2),
                  //             ),
                  //             // child: const Icon(
                  //             //   Iconsax.security,
                  //             //   color: brandOne,
                  //             // ),
                  //             child: Image.asset(
                  //               'assets/icons/space_deposit.png',
                  //               scale: 4,
                  //               color: brandTwo,
                  //             ),
                  //           ),
                  //           title: Text(
                  //             'Space Deposit',
                  //             style: GoogleFonts.nunito(
                  //               color: brandOne,
                  //               fontSize: 17,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //           subtitle: Text(
                  //             'Save 70% of rent for a minimum of 90 days at an interest of 14% and get 100% (Terms and conditions apply).',
                  //             maxLines: 2,
                  //             overflow: TextOverflow.ellipsis,
                  //             style: GoogleFonts.nunito(
                  //               color: navigationcolorText,
                  //               fontSize: 12,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //           // onTap: () {
                  //           //   // Navigator.pushNamed(context, RouteList.profile);
                  //           // },
                  //           trailing: Container(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 15, vertical: 5),
                  //             decoration: BoxDecoration(
                  //               color: brandTwo,
                  //               borderRadius: BorderRadius.circular(20),
                  //             ),
                  //             child: Text(
                  //               "Save",
                  //               textAlign: TextAlign.center,
                  //               style: GoogleFonts.nunito(
                  //                 fontSize: 15.0,
                  //                 // fontFamily: "DefaultFontFamily",
                  //                 // letterSpacing: 0.5,
                  //                 fontWeight: FontWeight.w700,
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )

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
                  //                 style: GoogleFonts.nunito(
                  //                   color: brandOne,
                  //                   fontSize: 17,
                  //                   fontWeight: FontWeight.w600,
                  //                 ),
                  //               ),
                  //               subtitle: Text(
                  //                 'Save 70% of your rent and get 30% loan.',
                  //                 maxLines: 2,
                  //                 overflow: TextOverflow.ellipsis,
                  //                 style: GoogleFonts.nunito(
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
                  //                   style: GoogleFonts.nunito(
                  //                     fontSize: 15.0,
                  //                     // fontFamily: "DefaultFontFamily",
                  //                     // letterSpacing: 0.5,
                  //                     fontWeight: FontWeight.w700,
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

  // Padding _savingsWidget(
  //     String imageIcon, String title, subTitle, String interest) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       // height: 200,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 15),
  //         child: ListTile(
  //           leading: Container(
  //             padding: const EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: brandTwo.withOpacity(0.2),
  //             ),
  //             // child: const Icon(
  //             //   Iconsax.security,
  //             //   color: brandOne,
  //             // ),
  //             child: Image.asset(
  //               imageIcon,
  //               scale: 4,
  //               color: brandTwo,
  //             ),
  //           ),
  //           title: Text(
  //             title,
  //             style: GoogleFonts.nunito(
  //               color: brandOne,
  //               fontSize: 17,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           subtitle: Text(
  //             subTitle,
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,
  //             style: GoogleFonts.nunito(
  //               color: navigationcolorText,
  //               fontSize: 12,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           // onTap: () {
  //           //   // Navigator.pushNamed(context, RouteList.profile);
  //           // },
  //           trailing: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
  //             decoration: BoxDecoration(
  //               color: brandTwo,
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             child: Text(
  //               "Save",
  //               textAlign: TextAlign.center,
  //               style: GoogleFonts.nunito(
  //                 fontSize: 15.0,
  //                 // fontFamily: "DefaultFontFamily",
  //                 // letterSpacing: 0.5,
  //                 fontWeight: FontWeight.w700,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
