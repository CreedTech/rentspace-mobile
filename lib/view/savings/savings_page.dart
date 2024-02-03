import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/controller/box_controller.dart';
import 'package:rentspace/controller/deposit_controller.dart';
import 'package:rentspace/controller/rent_controller.dart';
import 'package:rentspace/controller/tank_controller.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_intro.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_list.dart';

class SavingsPage extends StatefulWidget {
  SavingsPage({
    Key? key,
  }) : super(key: key);

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
final FirebaseFirestore firestore = FirebaseFirestore.instance;

String _hasRent = "";
int tankBalance = 0;
// var dum2 = "".obs();
int boxBalance = 0;
int depositBalance = 0;
int rentBalance = 0;
int targetBalance = 0;
int totalSavings = 0;
int totalAssets = 0;
bool hideBalance = false;

class _SavingsPageState extends State<SavingsPage> {
  final RentController rentController = Get.find();
  final BoxController boxController = Get.find();
  final DepositController depositController = Get.find();
  final TankController tankController = Get.find();
  final UserController userController = Get.find();

  deleteSpecifiedDocs() async {
    // Query the collection for documents where "amount" is 0 and "id" is "me"
    QuerySnapshot querySnapshot = await firestore
        .collection('spacetank')
        .where('has_paid', isEqualTo: "false")
        .where('id', isEqualTo: userController.user[0].id)
        .get();

    // Loop through the documents and delete each one
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await firestore.collection('spacetank').doc(doc.id).delete();
    }
  }

  getUser() async {
    var collection = FirebaseFirestore.instance.collection('accounts');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        _hasRent = data?['has_rent'];
      });
    }
  }

  getSavings() {
    if (tankController.tank.isNotEmpty) {
      for (int i = 0; i < tankController.tank.length; i++) {
        tankBalance += tankController.tank[i].targetAmount.toInt();
      }
    } else {
      setState(() {
        tankBalance = 0;
      });
    }
    if (rentController.rent.isNotEmpty) {
      for (int j = 0; j < rentController.rent.length; j++) {
        rentBalance += rentController.rent[j].savedAmount.toInt();
        targetBalance += rentController.rent[j].targetAmount.toInt();
      }
    } else {
      setState(() {
        rentBalance = 0;
        targetBalance = 0;
      });
    }
    if (boxController.box.isNotEmpty) {
      for (int i = 0; i < boxController.box.length; i++) {
        boxBalance += boxController.box[i].savedAmount.toInt();
      }
    } else {
      setState(() {
        boxBalance = 0;
      });
    }
    if (depositController.deposit.isNotEmpty) {
      for (int i = 0; i < depositController.deposit.length; i++) {
        depositBalance += depositController.deposit[i].savedAmount.toInt();
      }
    } else {
      setState(() {
        depositBalance = 0;
      });
    }

    setState(() {
      totalSavings = (tankBalance + rentBalance + boxBalance + depositBalance);
      totalAssets = (int.parse(userController.user[0].userWalletBalance) +
          rentBalance +
          boxBalance +
          depositBalance);
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

    getUser();
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
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        // bottom: TabBar(
        //   // isScrollable: true,
        //   // indicator: BoxDecoration(

        //   // ),
        //   indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
        //   indicatorColor: Theme.of(context).primaryColor,
        //   tabs: [
        //     Padding(
        //       padding: const EdgeInsets.all(8),
        //       child: Text(
        //         'Savings',
        //         style: GoogleFonts.nunito(
        //           color: Theme.of(context).primaryColor,
        //           fontSize: 22,
        //           fontWeight: FontWeight.w700,
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8),
        //       child: Text(
        //         'Loans',
        //         style: GoogleFonts.nunito(
        //           color: Theme.of(context).primaryColor,
        //           fontSize: 22,
        //           fontWeight: FontWeight.w700,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
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
                            const Icon(
                              Icons.verified_user,
                              color: Colors.green,
                              size: 17,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Total Assets",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                fontSize: 15.0,
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
                                size: 15.sp,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
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
                  //  Container(
                  //           width: 200,
                  //           decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(15),
                  //           ),
                  //           child: Column(
                  //             crossAxisAlignment:
                  //                 CrossAxisAlignment.start,
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Row(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceBetween,
                  //                   children: [
                  //                     Row(
                  //                       children: [
                  //                         Container(
                  //                           padding:
                  //                               EdgeInsets.all(5.sp),
                  //                           decoration: BoxDecoration(
                  //                             color: brandTwo
                  //                                 .withOpacity(0.2),
                  //                             borderRadius:
                  //                                 BorderRadius.circular(
                  //                                     100.sp),
                  //                           ),
                  //                           child: Image.asset(
                  //                             'assets/icons/space_rent.png',
                  //                             color: brandOne,
                  //                             scale: 4.sp,
                  //                             // width: 20,
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           width: 5,
                  //                         ),
                  //                         Text(
                  //                           'SpaceRent',
                  //                           textAlign: TextAlign.center,
                  //                           style: GoogleFonts.nunito(
                  //                             fontSize: 15.0,
                  //                             fontWeight:
                  //                                 FontWeight.w600,
                  //                             // fontFamily: "DefaultFontFamily",
                  //                             // letterSpacing: 0.5,
                  //                             color: brandOne,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     const Icon(
                  //                       Icons.arrow_forward_ios,
                  //                       size: 15,
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //               Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Text(
                  //                   " ${hideBalance ? nairaFormaet.format(totalSavings).toString() : "*****"}",
                  //                   //  textAlign: TextAlign.center,
                  //                   style: GoogleFonts.nunito(
                  //                     fontSize: 17.0.sp,
                  //                     // fontFamily: "DefaultFontFamily",
                  //                     // letterSpacing: 0.5,
                  //                     fontWeight: FontWeight.w700,
                  //                     color: brandOne,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 15),
                    child: Container(
                      width: 200,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        // fontFamily: "DefaultFontFamily",
                                        // letterSpacing: 0.5,
                                        color: brandOne,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    (rentController.rent.isEmpty)
                                        ? Get.to(const SpaceRentIntro())
                                        : Get.to(const RentSpaceList());
                                  },
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              " ${hideBalance ? nairaFormaet.format(totalSavings).toString() : "*****"}",
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

                  // SizedBox(
                  //   height: 100,
                  //   child: Expanded(
                  //     child: ListView(
                  //       scrollDirection: Axis.horizontal,
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(left: 10, bottom: 15),
                  //           child: Container(
                  //             width: 200,
                  //             decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(15),
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Row(
                  //                         children: [
                  //                           Container(
                  //                             padding: EdgeInsets.all(5.sp),
                  //                             decoration: BoxDecoration(
                  //                               color: brandTwo.withOpacity(0.2),
                  //                               borderRadius:
                  //                                   BorderRadius.circular(100.sp),
                  //                             ),
                  //                             child: Image.asset(
                  //                               'assets/icons/space_rent.png',
                  //                               color: brandOne,
                  //                               scale: 4.sp,
                  //                               // width: 20,
                  //                             ),
                  //                           ),
                  //                           const SizedBox(
                  //                             width: 5,
                  //                           ),
                  //                           Text(
                  //                             'SpaceRent',
                  //                             textAlign: TextAlign.center,
                  //                             style: GoogleFonts.nunito(
                  //                               fontSize: 15.0,
                  //                               fontWeight: FontWeight.w600,
                  //                               // fontFamily: "DefaultFontFamily",
                  //                               // letterSpacing: 0.5,
                  //                               color: brandOne,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       const Icon(
                  //                         Icons.arrow_forward_ios,
                  //                         size: 15,
                  //                       )
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Text(
                  //                     " ${hideBalance ? nairaFormaet.format(totalSavings).toString() : "*****"}",
                  //                     //  textAlign: TextAlign.center,
                  //                     style: GoogleFonts.nunito(
                  //                       fontSize: 17.0.sp,
                  //                       // fontFamily: "DefaultFontFamily",
                  //                       // letterSpacing: 0.5,
                  //                       fontWeight: FontWeight.w700,
                  //                       color: brandOne,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),

                  //         Padding(
                  //           padding: const EdgeInsets.only(left: 10, bottom: 15,right: 10),
                  //           child: Container(
                  //             width: 200,
                  //             decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(15),
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Row(
                  //                         children: [
                  //                           Container(
                  //                             padding: EdgeInsets.all(5.sp),
                  //                             decoration: BoxDecoration(
                  //                               color: brandTwo.withOpacity(0.2),
                  //                               borderRadius:
                  //                                   BorderRadius.circular(100.sp),
                  //                             ),
                  //                             child: Image.asset(
                  //                               'assets/icons/space_rent.png',
                  //                               color: brandOne,
                  //                               scale: 4.sp,
                  //                               // width: 20,
                  //                             ),
                  //                           ),
                  //                           const SizedBox(
                  //                             width: 5,
                  //                           ),
                  //                           Text(
                  //                             'SpaceRent',
                  //                             textAlign: TextAlign.center,
                  //                             style: GoogleFonts.nunito(
                  //                               fontSize: 15.0,
                  //                               fontWeight: FontWeight.w600,
                  //                               // fontFamily: "DefaultFontFamily",
                  //                               // letterSpacing: 0.5,
                  //                               color: brandOne,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       const Icon(
                  //                         Icons.arrow_forward_ios,
                  //                         size: 15,
                  //                       )
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Text(
                  //                     " ${hideBalance ? nairaFormaet.format(totalSavings).toString() : "*****"}",
                  //                     //  textAlign: TextAlign.center,
                  //                     style: GoogleFonts.nunito(
                  //                       fontSize: 17.0.sp,
                  //                       // fontFamily: "DefaultFontFamily",
                  //                       // letterSpacing: 0.5,
                  //                       fontWeight: FontWeight.w700,
                  //                       color: brandOne,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         )

                  //       ],
                  //     ),
                  //   ),
                  // ),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    // padding: const EdgeInsets.all(10),
                    itemCount: 1,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          (rentController.rent.isEmpty)
                              ? Get.to(const SpaceRentIntro())
                              : Get.to(const RentSpaceList());
                        },
                        child: _savingsWidget(
                          'assets/icons/space_rent.png',
                          'SpaceRent',
                          'Save 70% of your rent and get 30% loan.',
                          '14% interest per annum.',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _savingsWidget(
      String imageIcon, String title, subTitle, String interest) {
    return Padding(
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
                imageIcon,
                scale: 4,
                color: brandTwo,
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.nunito(
                color: brandOne,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              subTitle,
              style: GoogleFonts.nunito(
                color: navigationcolorText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            // onTap: () {
            //   // Navigator.pushNamed(context, RouteList.profile);
            // },
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: brandTwo,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Save",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 15.0,
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
    );
  }
}
