import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
var dum2 = "".obs();
int boxBalance = 0;
int depositBalance = 0;
int rentBalance = 0;
int totalSavings = 0;

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
    return Obx(
      () => Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                gradientOne,
                gradientTwo,
              ],
            ),
          ),
          child: ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 25, 10, 25),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        brandOne,
                        brandTwo,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Total Savings" + dum2,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DefaultFontFamily",
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        nairaFormaet.format(totalSavings).toString(),
                        style: TextStyle(
                          fontSize: 40.0,
                          fontFamily: "DefaultFontFamily",
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 10),
                        decoration: BoxDecoration(
                          color: brandFour,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Create New Savings",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "DefaultFontFamily",
                                letterSpacing: 0.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  image: DecorationImage(
                    image: AssetImage("assets/icons/RentSpace-icon.png"),
                    fit: BoxFit.cover,
                    opacity: 0.3,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            (rentController.rent.isEmpty)
                                ? Get.to(SpaceRentIntro())
                                : Get.to(RentSpaceList());
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 2.2,
                            decoration: BoxDecoration(
                              color: brandFive,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/icons/savings/spacerent.png",
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "SpaceRent",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: "DefaultFontFamily",
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  "Target savings for rent up to 14% interest per annum.",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "DefaultFontFamily",
                                    letterSpacing: 0.5,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                (rentController.rent.isNotEmpty)
                                    ? SizedBox(
                                        height: 30,
                                      )
                                    : GFButton(
                                        onPressed: () {
                                          Get.to(SpaceRentIntro());
                                        },
                                        color: btnColor,
                                        text: "START SAVING",
                                        shape: GFButtonShape.pills,
                                        fullWidthButton: false,
                                      ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            (tankController.tank.isEmpty)
                                ? Get.to(SpaceTankIntro())
                                : Get.to(SpaceTankList());
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 2.2,
                            decoration: BoxDecoration(
                              color: brandOne,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/icons/savings/spacetank.png",
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "SpaceTank",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: "DefaultFontFamily",
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  "Lock in your savings and get 12% interest upfront.",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    letterSpacing: 0.5,
                                    fontFamily: "DefaultFontFamily",
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                (tankController.tank.isNotEmpty)
                                    ? SizedBox(
                                        height: 30,
                                      )
                                    : GFButton(
                                        onPressed: () {
                                          Get.to(SpaceTankIntro());
                                        },
                                        color: btnColor,
                                        text: "START SAVING",
                                        shape: GFButtonShape.pills,
                                        fullWidthButton: false,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            (boxController.box.isEmpty)
                                ? Get.to(SpaceBoxIntro())
                                : Get.to(SpaceBoxList());
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 2.2,
                            decoration: BoxDecoration(
                              color: brandOne,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/icons/savings/spacebox.png",
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "SpaceBox",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    fontFamily: "DefaultFontFamily",
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Save and earn up to 14% interest per annum",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    letterSpacing: 0.5,
                                    fontFamily: "DefaultFontFamily",
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                (boxController.box.isNotEmpty)
                                    ? SizedBox(
                                        height: 35,
                                      )
                                    : GFButton(
                                        onPressed: () {
                                          Get.to(SpaceBoxIntro());
                                        },
                                        color: btnColor,
                                        text: "START SAVING",
                                        shape: GFButtonShape.pills,
                                        fullWidthButton: false,
                                      ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            (depositController.deposit.isEmpty)
                                ? Get.to(SpaceDepositIntro())
                                : Get.to(SpaceDepositList());
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 2.2,
                            decoration: BoxDecoration(
                              color: brandFive,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/icons/savings/spacedeposit.png",
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "SpaceDeposit",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    fontFamily: "DefaultFontFamily",
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  "Enjoy up to 3.5% quarterly interest payment",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    letterSpacing: 0.5,
                                    fontFamily: "DefaultFontFamily",
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                (depositController.deposit.isNotEmpty)
                                    ? SizedBox(
                                        height: 30,
                                      )
                                    : GFButton(
                                        onPressed: () {
                                          Get.to(SpaceDepositIntro());
                                        },
                                        color: btnColor,
                                        text: "START SAVING",
                                        shape: GFButtonShape.pills,
                                        fullWidthButton: false,
                                      ),
                              ],
                            ),
                          ),
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
    );
  }
}
