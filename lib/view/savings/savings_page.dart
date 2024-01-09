import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:getwidget/getwidget.dart';

import 'package:get/get.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/controller/box_controller.dart';
import 'package:rentspace/controller/deposit_controller.dart';
import 'package:rentspace/controller/rent_controller.dart';
import 'package:rentspace/controller/tank_controller.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/view/savings/spaceBox/spacebox_intro.dart';
import 'package:rentspace/view/savings/spaceBox/spacebox_list.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_intro.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_list.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_intro.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_list.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_subscription.dart';
import 'package:rentspace/view/savings/spaceTank/spacetank_intro.dart';
import 'package:rentspace/view/savings/spaceTank/spacetank_list.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
int totalSavings = 0;
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
      }
    } else {
      setState(() {
        rentBalance = 0;
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
    });
    print(totalSavings);
  }

  @override
  initState() {
    super.initState();
    rentBalance = 0;
    tankBalance = 0;
    boxBalance = 0;
    depositBalance = 0;
    totalSavings = 0;

    getUser();
    //deleteSpecifiedDocs();
    getSavings();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).canvasColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Finance',
            style: GoogleFonts.nunito(
              color: brandOne,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          bottom: TabBar(
            // isScrollable: true,
            // indicator: BoxDecoration(

            // ),
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 80),
            indicatorColor: brandOne,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Savings',
                  style: GoogleFonts.nunito(
                    color: brandOne,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Loans',
                  style: GoogleFonts.nunito(
                    color: brandOne,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 45, bottom: 45, right: 20),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: brandOne,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total Savings',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                  // fontFamily: "DefaultFontFamily",
                                  // letterSpacing: 0.5,
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
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                " ${hideBalance ? nairaFormaet.format(totalSavings).toString() : "********"}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  fontSize: 35.0,
                                  // fontFamily: "DefaultFontFamily",
                                  // letterSpacing: 0.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: 20, top: 15, bottom: 0, right: 20),
                //   child: Column(
                //     children: [
                //       Row(
                //         children: [
                //           Text(
                //             'Total Savings',
                //             style: GoogleFonts.nunito(
                //               fontSize: 14.0,
                //               fontWeight: FontWeight.w400,
                //               // fontFamily: "DefaultFontFamily",
                //               // letterSpacing: 0.5,
                //               color: const Color(0xff4F4F4F),
                //             ),
                //           ),
                //           GestureDetector(
                //             onTap: () {
                //               setState(() {
                //                 hideBalance = !hideBalance;
                //               });
                //             },
                //             child: Icon(
                //               hideBalance
                //                   ? Icons.visibility_off_outlined
                //                   : Icons.visibility_outlined,
                //               color: const Color(0xff4F4F4F),
                //               size: 17,
                //             ),
                //           )
                //         ],
                //       ),
                //       Row(
                //         children: [
                //           Text(
                //             " ${hideBalance ? nairaFormaet.format(totalSavings).toString() : "********"}",
                //             style: GoogleFonts.nunito(
                //               fontSize: 25.0,
                //               // fontFamily: "DefaultFontFamily",
                //               // letterSpacing: 0.5,
                //               fontWeight: FontWeight.w700,
                //               color: const Color(0xff4F4F4F),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),

                Flexible(
                  child: GridView.count(
                    crossAxisCount: 2,
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    // crossAxisSpacing: 1,
                    // mainAxisSpacing: 1,
                    childAspectRatio:
                        1, // Set this to ensure each item has a height of 200
                    children: [
                      GestureDetector(
                        onTap: () {
                          (rentController.rent.isEmpty)
                              ? Get.to(const SpaceRentIntro())
                              : Get.to(const RentSpaceList());
                        },
                        child: _savingsWidget(
                          'assets/icons/space_rent.png',
                          'SpaceRent',
                          'Target savings for rent at 14% interest per annum.',
                          '14% interest per annum.',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // (tankController.tank.isEmpty)
                          //     ? Get.to(const SpaceTankIntro())
                          //     : Get.to(const SpaceTankList());
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.success(
                              backgroundColor: brandOne,
                              message: 'Coming Soon. !!',
                              textStyle: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                        child: _savingsWidget(
                          'assets/icons/safe_tank.png',
                          'Safe Tank',
                          'Target savings for anything at 12% per annum.',
                          '12% interest per annum.',
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     (boxController.box.isEmpty)
                      //         ? Get.to(const SpaceBoxIntro())
                      //         : Get.to(const SpaceBoxList());
                      //   },
                      //   child: _savingsWidget(
                      //     'assets/icons/safe_box.png',
                      //     'Safe Box',
                      //     'Savings with an upfront interest payment at 11% per annum',
                      //     '11% interest per annum.',
                      //   ),
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     (depositController.deposit.isEmpty)
                      //         ? Get.to(const SpaceDepositIntro())
                      //         : Get.to(const SpaceDepositList());
                      //   },
                      //   child: _savingsWidget(
                      //     'assets/icons/space_deposit.png',
                      //     'Space Deposit',
                      //     'Maintain a minimum balance of 100,000 or multiple of same and enjoy 3.5% quarterly interest payment',
                      //     '3.5% interest quarterly.',
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/cooming_soon.png',
                ),
                Text(
                  'Coming Soon!!!',
                  style: GoogleFonts.nunito(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: brandOne,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding _savingsWidget(
      String imageIcon, String title, subTitle, String interest) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: brandTwo,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Positioned(
                bottom: 5,
                right: 10,
                child: Transform.scale(
                  scale: 1.4, // Adjust the scale as needed
                  child: Image.asset(
                    imageIcon,
                    color: brandOne.withOpacity(0.3),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        imageIcon,
                        width: 25,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        title,
                        style: GoogleFonts.nunito(
                          fontSize: 16.0,
                          // fontFamily: "DefaultFontFamily",
                          // letterSpacing: 0.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    subTitle,
                    style: GoogleFonts.nunito(
                      fontSize: 10.0,
                      // fontFamily: "DefaultFontFamily",
                      // letterSpacing: 0.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    interest,
                    style: GoogleFonts.nunito(
                      fontSize: 10.0,
                      // fontFamily: "DefaultFontFamily",
                      // letterSpacing: 0.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
