import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
              color: Theme.of(context).primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          bottom: TabBar(
            // isScrollable: true,
            // indicator: BoxDecoration(

            // ),
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 80),
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Savings',
                  style: GoogleFonts.nunito(
                    color: Theme.of(context).primaryColor,
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
                    color: Theme.of(context).primaryColor,
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
                    left: 20,
                    top: 45,
                    bottom: 25,
                    right: 20,
                  ),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: brandOne,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(20.0),
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 15, vertical: 5),
                        //     decoration: BoxDecoration(
                        //       color: brandTwo,
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //     child: Text(
                        //       "Earn up to 14% returns",
                        //       textAlign: TextAlign.center,
                        //       style: GoogleFonts.nunito(
                        //         fontSize: 15.0,
                        //         // fontFamily: "DefaultFontFamily",
                        //         // letterSpacing: 0.5,
                        //         fontWeight: FontWeight.w700,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        //  const SizedBox(
                        //    width: 15,
                        //  ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
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
            ((rentController.rent[0].savedAmount) !=
                    (rentController.rent[0].targetAmount * 0.7))
                ? Column(
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
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
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
