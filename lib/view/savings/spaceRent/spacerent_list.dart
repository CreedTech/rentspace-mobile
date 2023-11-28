import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/controller/rent_controller.dart';
import 'package:rentspace/view/actions/immediate_rent_funding.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_liquidate.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_subscription.dart';
import 'package:badges/badges.dart' as badge;

class RentSpaceList extends StatefulWidget {
  const RentSpaceList({Key? key}) : super(key: key);

  @override
  _RentSpaceListState createState() => _RentSpaceListState();
}

var ch8t = NumberFormat.simpleCurrency(name: 'NGN');
var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
var changeOne = "".obs();
String savedAmount = "0";
String fundingId = "";
String fundDate = "";

class _RentSpaceListState extends State<RentSpaceList> {
  final RentController rentController = Get.find();

  @override
  initState() {
    super.initState();
    setState(() {
      savedAmount = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.close,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      //
      body: Obx(
        () => Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/icons/RentSpace-icon.png"),
              fit: BoxFit.cover,
              opacity: 0.1,
            ),
          ),
          child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: rentController.rent.length,
              itemBuilder: (context, int index) {
                return (rentController.rent.isNotEmpty)
                    ? Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
                            child: badge.Badge(
                              badgeColor: Colors.red,
                              badgeContent: (rentController
                                          .rent[index].savedAmount ==
                                      0)
                                  ? InkWell(
                                      onTap: () {
                                        Get.bottomSheet(
                                          SizedBox(
                                            height: 200,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30.0),
                                                topRight: Radius.circular(30.0),
                                              ),
                                              child: Container(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 5, 10, 5),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                    ),
                                                    Text(
                                                      'Are you sure you want to delete this SpaceRent?',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            "DefaultFontFamily",
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    //card
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                4,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: brandTwo,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            padding: EdgeInsets
                                                                .fromLTRB(20, 5,
                                                                    20, 5),
                                                            child: Text(
                                                              'No',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            Get.back();
                                                            var rentspaces =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'rent_space');
                                                            var snapshot = await rentspaces
                                                                .where(
                                                                    'rentspace_id',
                                                                    isEqualTo: rentController
                                                                        .rent[
                                                                            index]
                                                                        .rentId)
                                                                .get();
                                                            for (var doc
                                                                in snapshot
                                                                    .docs) {
                                                              await doc
                                                                  .reference
                                                                  .delete()
                                                                  .then(
                                                                      (value) {
                                                                Get.back();
                                                                Get.snackbar(
                                                                  "SpaceRent Deleted!",
                                                                  'Selected spacerent has been deleted!',
                                                                  animationDuration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                  backgroundColor:
                                                                      brandOne,
                                                                  colorText:
                                                                      Colors
                                                                          .white,
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                );
                                                              }).catchError(
                                                                      (error) {
                                                                Get.snackbar(
                                                                  "Error",
                                                                  error
                                                                      .toString(),
                                                                  animationDuration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  colorText:
                                                                      Colors
                                                                          .white,
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .BOTTOM,
                                                                );
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                4,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            padding: EdgeInsets
                                                                .fromLTRB(20, 5,
                                                                    20, 5),
                                                            child: Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    //card
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete_outlined,
                                        color: Colors.white,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Get.to(RentLiquidate(
                                          index: index,
                                          isWallet: false,
                                          balance: 0,
                                        ));
                                      },
                                      child: Icon(
                                        Icons.eject_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                              position: badge.BadgePosition.topEnd(),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: brandOne,
                                ),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 4,
                                    ),
                                    GFListTile(
                                      title: Text(
                                        "My SpaceRent" /* rentController.rent[index].planName +
                                            changeOne */
                                        ,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "DefaultFontFamily",
                                          color: Colors.white,
                                        ),
                                      ),
                                      avatar: Image.asset(
                                        "assets/icons/savings/spacerent.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                      subTitle: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Text(
                                          nairaFormaet.format(rentController
                                                  .rent[index].targetAmount) +
                                              " Target",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "DefaultFontFamily",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      description: LinearPercentIndicator(
                                        center: Text(
                                          ' ${((rentController.rent[index].savedAmount / rentController.rent[index].targetAmount) * 100).toInt()}%',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30,
                                            fontFamily: "DefaultFontFamily",
                                          ),
                                        ),
                                        percent: ((rentController
                                                    .rent[index].savedAmount /
                                                rentController
                                                    .rent[index].targetAmount))
                                            .toDouble(),
                                        animation: true,
                                        barRadius: Radius.circular(10.0),
                                        lineHeight:
                                            MediaQuery.of(context).size.width /
                                                25,
                                        fillColor: Colors.transparent,
                                        progressColor: Colors.greenAccent,
                                      ),
                                      icon:
                                          (rentController.rent[index].hasPaid ==
                                                  'true')
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 30,
                                                )
                                              : Icon(
                                                  Icons.error_outlined,
                                                  color: Colors.red,
                                                  size: 30,
                                                ),
                                      color: Colors.transparent,
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GFButton(
                                            onPressed: () {
                                              Get.to(SpaceRentHistory(
                                                current: index,
                                              ));
                                            },
                                            shape: GFButtonShape.pills,
                                            fullWidthButton: false,
                                            borderSide: BorderSide(
                                              color: brandTwo,
                                              width: 3.0,
                                            ),
                                            child: Text(
                                              '    History    ',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            color: brandOne,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: GFAccordion(
                                        expandedIcon: Container(
                                          decoration: BoxDecoration(
                                            color: brandThree,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.remove,
                                            color: brandOne,
                                          ),
                                        ),
                                        collapsedIcon: Container(
                                          decoration: BoxDecoration(
                                            color: brandThree,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.add,
                                            color: brandOne,
                                          ),
                                        ),
                                        title: "View details",
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "DefaultFontFamily",
                                        ),
                                        contentBackgroundColor: brandThree,
                                        expandedTitleBackgroundColor:
                                            brandThree,
                                        collapsedTitleBackgroundColor:
                                            brandThree,
                                        onToggleCollapsed: (e) {},
                                        contentChild: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'SpaceRent ID: ${rentController.rent[index].rentId}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Created: ${rentController.rent[index].date}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Target no of payments: ${rentController.rent[index].numPayment}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'No of payments: ${rentController.rent[index].currentPayment}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Payment intervals: ${nairaFormaet.format(double.parse(rentController.rent[index].intervalAmount.toString()))} ${rentController.rent[index].interval}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Paid Amount: ${nairaFormaet.format(double.parse(rentController.rent[index].savedAmount.toString()))}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Target Amount: ${nairaFormaet.format(double.parse(rentController.rent[index].targetAmount.toString()))}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Remaining Amount: ${nairaFormaet.format(double.parse((rentController.rent[index].targetAmount - rentController.rent[index].savedAmount).toString()))}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          "Nothing to show here",
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: "DefaultFontFamily",
                            color: Colors.red,
                          ),
                        ),
                      );
              }),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Get.to(RentSpaceSubscription());
        },
        child: Icon(
          Icons.add_outlined,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: brandOne,
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
