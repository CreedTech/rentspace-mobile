import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/controller/rent_controller.dart';
import 'package:rentspace/view/actions/immediate_rent_funding.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_details.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_liquidate.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_subscription.dart';
import 'package:badges/badges.dart' as badge;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../constants/widgets/custom_dialog.dart';

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

int rentBalance = 0;
int totalSavings = 0;
bool hideBalance = false;

class _RentSpaceListState extends State<RentSpaceList> {
  final RentController rentController = Get.find();

  @override
  initState() {
    super.initState();
    setState(() {
      savedAmount = '0';
    });
  }

  // goToHistory(index) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => SpaceRentHistory(current: index)));
  //   // Get.to(SpaceRentHistory(current: index));
  // }

  // goToDetails(index) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => SpaceRentDetails(current: index)));
  // }

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
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        // centerTitle: true,
        title: const Text(
          'Space Rent',
          style: TextStyle(
            color: brandOne,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      //
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 45, bottom: 5, right: 20),
                child: Container(
                  // height: 100,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  decoration: BoxDecoration(
                    color: brandOne,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Available Balance ',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                // fontFamily: "DefaultFontFamily",
                                // letterSpacing: 0.5,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Space Rent',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
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
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: brandTwo,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            Get.to(const RentSpaceSubscription());
                          },
                          child: Text(
                            'Save',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 25.0,
                              // fontFamily: "DefaultFontFamily",
                              // letterSpacing: 0.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 25, bottom: 5, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    // color: brandThree,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 25, bottom: 25, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Space Rents',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.nunito(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: brandOne,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Get.to(AllActivities(
                                //   activities: userController.user[0].activities,
                                //   activitiesLength:
                                //       userController.user[0].activities.length,
                                // ));
                              },
                              child: Text(
                                "See all",
                                style: GoogleFonts.nunito(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                  color: brandOne,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          // itemCount: (rentController.rent.length < 3)
                          //     ? rentController.rent.length
                          //     : 2,
                          itemCount: rentController.rent.length,
                          itemBuilder: (context, int index) {
                            // print(rentController.rent.length);
                            return (rentController.rent.isNotEmpty)
                                ? Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.bottomSheet(
                                            SizedBox(
                                              height: 350,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(30.0),
                                                  topRight:
                                                      Radius.circular(30.0),
                                                ),
                                                child: Container(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 10, 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Close',
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                // fontFamily: "DefaultFontFamily",
                                                                color: brandOne,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Info',
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                // fontFamily: "DefaultFontFamily",
                                                                color: brandOne,
                                                              ),
                                                            ),
                                                            SizedBox(),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          height: 1,
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color:
                                                                      brandOne),
                                                        ),
                                                      ),
                                                      // Padding(
                                                      //   padding:
                                                      //       const EdgeInsets
                                                      //           .symmetric(
                                                      //     vertical: 15,
                                                      //   ),
                                                      //   child: Text(
                                                      //     'Space Rent ${rentController.rent[index].rentId}',
                                                      //     textAlign:
                                                      //         TextAlign.start,
                                                      //     style: GoogleFonts
                                                      //         .nunito(
                                                      //       fontSize: 18,
                                                      //       fontWeight:
                                                      //           FontWeight.w500,
                                                      //       // fontFamily: "DefaultFontFamily",
                                                      //       color: brandOne,
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      // Padding(
                                                      //   padding:
                                                      //       const EdgeInsets
                                                      //           .all(8.0),
                                                      //   child: Container(
                                                      //     height: 2,
                                                      //     width:
                                                      //         double.infinity,
                                                      //     decoration:
                                                      //         const BoxDecoration(
                                                      //             color:
                                                      //                 brandOne),
                                                      //   ),
                                                      // ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                top: 10,
                                                                bottom: 10,
                                                                right: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'SpaceRent ID:',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        rentController
                                                                            .rent[index]
                                                                            .rentId,
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        'Created:',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        DateFormat.yMMMMd()
                                                                            .format(
                                                                          DateTime.parse(rentController
                                                                              .rent[index]
                                                                              .date),
                                                                        ),
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'Target no of payments:',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        rentController
                                                                            .rent[index]
                                                                            .numPayment,
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        'No of payments:',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        rentController
                                                                            .rent[index]
                                                                            .currentPayment,
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'Payment intervals:',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${nairaFormaet.format(double.parse(rentController.rent[index].intervalAmount.toString()))} ${rentController.rent[index].interval}',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        'Paid Amount:',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        nairaFormaet.format(double.parse(rentController
                                                                            .rent[index]
                                                                            .savedAmount
                                                                            .toString())),
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'Target Amount:',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        nairaFormaet.format(double.parse(rentController
                                                                            .rent[index]
                                                                            .targetAmount
                                                                            .toString())),
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        'Remaining Amount:',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        nairaFormaet.format(double.parse((rentController.rent[index].targetAmount -
                                                                                rentController.rent[index].savedAmount)
                                                                            .toString())),
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Slidable(
                                            key: ValueKey(rentController
                                                .rent[index].rentId),

                                            startActionPane: ActionPane(
                                              motion: const DrawerMotion(),
                                              dismissible: DismissiblePane(
                                                  onDismissed: () {}),
                                              children: [
                                                // A SlidableAction can have an icon and/or a label.
                                                (rentController.rent[index]
                                                            .savedAmount ==
                                                        0)
                                                    ? SlidableAction(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        onPressed: ((context) {
                                                          Get.bottomSheet(
                                                            SizedBox(
                                                              height: 250,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30.0),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          5,
                                                                          10,
                                                                          5),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height:
                                                                            50,
                                                                      ),
                                                                      Text(
                                                                        'Are you sure you want to delete this SpaceRent?',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          // fontFamily: "DefaultFontFamily",
                                                                          color:
                                                                              brandOne,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      //card
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(3),
                                                                            child:
                                                                                ElevatedButton(
                                                                              onPressed: () async {
                                                                                Get.back();
                                                                                var rentspaces = FirebaseFirestore.instance.collection('rent_space');
                                                                                var snapshot = await rentspaces.where('rentspace_id', isEqualTo: rentController.rent[index].rentId).get();
                                                                                for (var doc in snapshot.docs) {
                                                                                  await doc.reference.delete().then((value) {
                                                                                    Get.back();
                                                                                    if (context.mounted) {
                                                                                      customErrorDialog(context, 'SpaceRent Deleted!', 'Selected spacerent has been deleted!');
                                                                                    }
                                                                                    // Get.snackbar(
                                                                                    //   "SpaceRent Deleted!",
                                                                                    //   'Selected spacerent has been deleted!',
                                                                                    //   animationDuration: const Duration(seconds: 1),
                                                                                    //   backgroundColor: brandOne,
                                                                                    //   colorText: Colors.white,
                                                                                    //   snackPosition: SnackPosition.TOP,
                                                                                    // );
                                                                                  }).catchError((error) {
                                                                                    if (context.mounted) {
                                                                                      customErrorDialog(
                                                                                        context,
                                                                                        'Error',
                                                                                        error.toString(),
                                                                                      );
                                                                                    }
                                                                                    // Get.snackbar(
                                                                                    //   "Error",
                                                                                    //   error.toString(),
                                                                                    //   animationDuration: const Duration(seconds: 2),
                                                                                    //   backgroundColor: Colors.red,
                                                                                    //   colorText: Colors.white,
                                                                                    //   snackPosition: SnackPosition.BOTTOM,
                                                                                    // );
                                                                                  });
                                                                                }
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.red,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                                                                textStyle: const TextStyle(color: brandFour, fontSize: 13),
                                                                              ),
                                                                              child: const Text(
                                                                                "Yes",
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                20,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(3),
                                                                            child:
                                                                                ElevatedButton(
                                                                              onPressed: () {
                                                                                Get.back();
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: brandTwo,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                                                                textStyle: const TextStyle(color: brandFour, fontSize: 13),
                                                                              ),
                                                                              child: const Text(
                                                                                "No",
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  fontSize: 16,
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
                                                        }),
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon: Icons.delete,
                                                        label: 'Delete',
                                                      )
                                                    : SlidableAction(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        onPressed: ((context) {
                                                          Get.to(RentLiquidate(
                                                            index: index,
                                                            isWallet: false,
                                                            balance: 0,
                                                          ));
                                                        }),
                                                        backgroundColor:
                                                            brandOne,
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon: Icons
                                                            .eject_outlined,
                                                        label: 'Liquidate',
                                                      ),
                                              ],
                                            ),

                                            // The end action pane is the one at the right or the bottom side.
                                            endActionPane: ActionPane(
                                              motion: const DrawerMotion(),
                                              children: [
                                                SlidableAction(
                                                  // An action can be bigger than the others.
                                                  // flex: 2,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  onPressed: (context) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SpaceRentHistory(
                                                                current: index),
                                                      ),
                                                    );
                                                  },
                                                  backgroundColor: brandTwo,
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.history_sharp,
                                                  label: 'History',
                                                ),
                                              ],
                                            ),

                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                decoration: BoxDecoration(
                                                  color:
                                                      brandTwo.withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: brandOne,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                          ),
                                                          child: Image.asset(
                                                            "assets/icons/savings/spacerent.png",
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                // mainAxisAlignment:
                                                                //     MainAxisAlignment
                                                                //         .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: 100,
                                                                    child: Text(
                                                                      'Rent_${rentController.rent[index].rentId}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts
                                                                          .nunito(
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color:
                                                                            brandOne,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    width: 100,
                                                                    child: Text(
                                                                      DateFormat
                                                                              .yMMMMd()
                                                                          .format(
                                                                        DateTime.parse(rentController
                                                                            .rent[index]
                                                                            .date),
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts
                                                                          .nunito(
                                                                        fontSize:
                                                                            10.0,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color:
                                                                            brandOne,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  // Text(
                                                                  //     'Rent_${rentController.rent[index].rentId}'),
                                                                  Text(
                                                                    '${nairaFormaet.format(rentController.rent[index].targetAmount)} Target',
                                                                    style: GoogleFonts
                                                                        .nunito(
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color:
                                                                          brandOne,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    '${nairaFormaet.format(double.parse(rentController.rent[index].intervalAmount.toString()))} ${rentController.rent[index].interval}',
                                                                    style: GoogleFonts
                                                                        .nunito(
                                                                      fontSize:
                                                                          10.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color:
                                                                          brandOne,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child:
                                                          LinearPercentIndicator(
                                                        backgroundColor:
                                                            Colors.white,
                                                        trailing: Text(
                                                          ' ${((rentController.rent[index].savedAmount / rentController.rent[index].targetAmount) * 100).toInt()}%',
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                30,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: brandOne,
                                                          ),
                                                        ),
                                                        percent: ((rentController
                                                                    .rent[index]
                                                                    .savedAmount /
                                                                rentController
                                                                    .rent[index]
                                                                    .targetAmount))
                                                            .toDouble(),
                                                        animation: true,
                                                        barRadius: const Radius
                                                            .circular(10.0),
                                                        lineHeight:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                40,
                                                        fillColor:
                                                            Colors.transparent,
                                                        progressColor: brandOne,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.fromLTRB(
                                      //       20, 20, 20, 10),
                                      //   child: badge.Badge(
                                      //     badgeColor: Colors.red,
                                      //     badgeContent:
                                      //         (rentController.rent[index]
                                      //                     .savedAmount ==
                                      //                 0)
                                      //             ? InkWell(
                                      //                 onTap: () {
                                      //                   Get.bottomSheet(
                                      //                     SizedBox(
                                      //                       height: 200,
                                      //                       child: ClipRRect(
                                      //                         borderRadius:
                                      //                             const BorderRadius
                                      //                                 .only(
                                      //                           topLeft: Radius
                                      //                               .circular(
                                      //                                   30.0),
                                      //                           topRight: Radius
                                      //                               .circular(
                                      //                                   30.0),
                                      //                         ),
                                      //                         child: Container(
                                      //                           color: Theme.of(
                                      //                                   context)
                                      //                               .canvasColor,
                                      //                           padding:
                                      //                               const EdgeInsets
                                      //                                   .fromLTRB(
                                      //                                   10,
                                      //                                   5,
                                      //                                   10,
                                      //                                   5),
                                      //                           child: Column(
                                      //                             children: [
                                      //                               const SizedBox(
                                      //                                 height:
                                      //                                     50,
                                      //                               ),
                                      //                               Text(
                                      //                                 'Are you sure you want to delete this SpaceRent?',
                                      //                                 style:
                                      //                                     TextStyle(
                                      //                                   fontSize:
                                      //                                       14,
                                      //                                   fontFamily:
                                      //                                       "DefaultFontFamily",
                                      //                                   color: Theme.of(context)
                                      //                                       .primaryColor,
                                      //                                 ),
                                      //                               ),
                                      //                               const SizedBox(
                                      //                                 height:
                                      //                                     30,
                                      //                               ),
                                      //                               //card
                                      //                               Row(
                                      //                                 mainAxisAlignment:
                                      //                                     MainAxisAlignment
                                      //                                         .center,
                                      //                                 children: [
                                      //                                   InkWell(
                                      //                                     onTap:
                                      //                                         () {
                                      //                                       Get.back();
                                      //                                     },
                                      //                                     child:
                                      //                                         Container(
                                      //                                       width:
                                      //                                           MediaQuery.of(context).size.width / 4,
                                      //                                       decoration:
                                      //                                           BoxDecoration(
                                      //                                         color: brandTwo,
                                      //                                         borderRadius: BorderRadius.circular(20),
                                      //                                       ),
                                      //                                       padding: const EdgeInsets.fromLTRB(
                                      //                                           20,
                                      //                                           5,
                                      //                                           20,
                                      //                                           5),
                                      //                                       child:
                                      //                                           const Text(
                                      //                                         'No',
                                      //                                         style: TextStyle(
                                      //                                           fontSize: 12,
                                      //                                           fontFamily: "DefaultFontFamily",
                                      //                                           color: Colors.white,
                                      //                                         ),
                                      //                                       ),
                                      //                                     ),
                                      //                                   ),
                                      //                                   const SizedBox(
                                      //                                     width:
                                      //                                         20,
                                      //                                   ),
                                      //                                   InkWell(
                                      //                                     onTap:
                                      //                                         () async {
                                      //                                       Get.back();
                                      //                                       var rentspaces =
                                      //                                           FirebaseFirestore.instance.collection('rent_space');
                                      //                                       var snapshot =
                                      //                                           await rentspaces.where('rentspace_id', isEqualTo: rentController.rent[index].rentId).get();
                                      //                                       for (var doc
                                      //                                           in snapshot.docs) {
                                      //                                         await doc.reference.delete().then((value) {
                                      //                                           Get.back();
                                      //                                           Get.snackbar(
                                      //                                             "SpaceRent Deleted!",
                                      //                                             'Selected spacerent has been deleted!',
                                      //                                             animationDuration: const Duration(seconds: 1),
                                      //                                             backgroundColor: brandOne,
                                      //                                             colorText: Colors.white,
                                      //                                             snackPosition: SnackPosition.TOP,
                                      //                                           );
                                      //                                         }).catchError((error) {
                                      //                                           Get.snackbar(
                                      //                                             "Error",
                                      //                                             error.toString(),
                                      //                                             animationDuration: const Duration(seconds: 2),
                                      //                                             backgroundColor: Colors.red,
                                      //                                             colorText: Colors.white,
                                      //                                             snackPosition: SnackPosition.BOTTOM,
                                      //                                           );
                                      //                                         });
                                      //                                       }
                                      //                                     },
                                      //                                     child:
                                      //                                         Container(
                                      //                                       width:
                                      //                                           MediaQuery.of(context).size.width / 4,
                                      //                                       decoration:
                                      //                                           BoxDecoration(
                                      //                                         color: Colors.red,
                                      //                                         borderRadius: BorderRadius.circular(20),
                                      //                                       ),
                                      //                                       padding: const EdgeInsets.fromLTRB(
                                      //                                           20,
                                      //                                           5,
                                      //                                           20,
                                      //                                           5),
                                      //                                       child:
                                      //                                           const Text(
                                      //                                         'Yes',
                                      //                                         style: TextStyle(
                                      //                                           fontSize: 12,
                                      //                                           fontFamily: "DefaultFontFamily",
                                      //                                           color: Colors.white,
                                      //                                         ),
                                      //                                       ),
                                      //                                     ),
                                      //                                   ),
                                      //                                 ],
                                      //                               ),

                                      //                               //card
                                      //                             ],
                                      //                           ),
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   );
                                      //                 },
                                      //                 child: const Icon(
                                      //                   Icons.delete_outlined,
                                      //                   color: Colors.white,
                                      //                 ),
                                      //               )
                                      //             : InkWell(
                                      //                 onTap: () {
                                      //                   Get.to(RentLiquidate(
                                      //                     index: index,
                                      //                     isWallet: false,
                                      //                     balance: 0,
                                      //                   ));
                                      //                 },
                                      //                 child: const Icon(
                                      //                   Icons.eject_outlined,
                                      //                   color: Colors.white,
                                      //                 ),
                                      //               ),
                                      //     position:
                                      //         badge.BadgePosition.topEnd(),
                                      //     child: Container(
                                      //       decoration: BoxDecoration(
                                      //         borderRadius:
                                      //             BorderRadius.circular(10),
                                      //         color: brandOne,
                                      //       ),
                                      //       padding: const EdgeInsets.fromLTRB(
                                      //           0, 10, 0, 10),
                                      //       child: Column(
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.center,
                                      //         children: [
                                      //           const SizedBox(
                                      //             height: 4,
                                      //           ),
                                      //           GFListTile(
                                      //             title: const Text(
                                      //               "My SpaceRent" /* rentController.rent[index].planName +
                                      //                     changeOne */
                                      //               ,
                                      //               style: TextStyle(
                                      //                 fontSize: 18,
                                      //                 fontFamily:
                                      //                     "DefaultFontFamily",
                                      //                 color: Colors.white,
                                      //               ),
                                      //             ),
                                      //             avatar: Image.asset(
                                      //               "assets/icons/savings/spacerent.png",
                                      //               height: 25,
                                      //               width: 25,
                                      //             ),
                                      //             subTitle: Padding(
                                      //               padding: const EdgeInsets
                                      //                   .fromLTRB(0, 5, 0, 5),
                                      //               child: Text(
                                      //                 "${nairaFormaet.format(rentController.rent[index].targetAmount)} Target",
                                      //                 style: const TextStyle(
                                      //                   fontSize: 12,
                                      //                   fontFamily:
                                      //                       "DefaultFontFamily",
                                      //                   color: Colors.white,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             description:
                                      //                 LinearPercentIndicator(
                                      //               center: Text(
                                      //                 ' ${((rentController.rent[index].savedAmount / rentController.rent[index].targetAmount) * 100).toInt()}%',
                                      //                 style: TextStyle(
                                      //                   fontSize: MediaQuery.of(
                                      //                               context)
                                      //                           .size
                                      //                           .width /
                                      //                       30,
                                      //                   fontFamily:
                                      //                       "DefaultFontFamily",
                                      //                 ),
                                      //               ),
                                      //               percent: ((rentController
                                      //                           .rent[index]
                                      //                           .savedAmount /
                                      //                       rentController
                                      //                           .rent[index]
                                      //                           .targetAmount))
                                      //                   .toDouble(),
                                      //               animation: true,
                                      //               barRadius:
                                      //                   const Radius.circular(
                                      //                       10.0),
                                      //               lineHeight:
                                      //                   MediaQuery.of(context)
                                      //                           .size
                                      //                           .width /
                                      //                       25,
                                      //               fillColor:
                                      //                   Colors.transparent,
                                      //               progressColor:
                                      //                   Colors.greenAccent,
                                      //             ),
                                      //             icon: (rentController
                                      //                         .rent[index]
                                      //                         .hasPaid ==
                                      //                     'true')
                                      //                 ? const Icon(
                                      //                     Icons.check_circle,
                                      //                     color: Colors.green,
                                      //                     size: 30,
                                      //                   )
                                      //                 : const Icon(
                                      //                     Icons.error_outlined,
                                      //                     color: Colors.red,
                                      //                     size: 30,
                                      //                   ),
                                      //             color: Colors.transparent,
                                      //             padding:
                                      //                 const EdgeInsets.fromLTRB(
                                      //                     5, 0, 5, 0),
                                      //           ),
                                      //           Padding(
                                      //             padding:
                                      //                 const EdgeInsets.fromLTRB(
                                      //                     20, 0, 20, 0),
                                      //             child: Row(
                                      //               mainAxisAlignment:
                                      //                   MainAxisAlignment
                                      //                       .spaceBetween,
                                      //               crossAxisAlignment:
                                      //                   CrossAxisAlignment
                                      //                       .center,
                                      //               children: [
                                      //                 GFButton(
                                      //                   onPressed: () {
                                      //                     Get.to(
                                      //                         SpaceRentHistory(
                                      //                       current: index,
                                      //                     ));
                                      //                   },
                                      //                   shape:
                                      //                       GFButtonShape.pills,
                                      //                   fullWidthButton: false,
                                      //                   borderSide:
                                      //                       const BorderSide(
                                      //                     color: brandTwo,
                                      //                     width: 3.0,
                                      //                   ),
                                      //                   color: brandOne,
                                      //                   child: const Text(
                                      //                     '    History    ',
                                      //                     style: TextStyle(
                                      //                       color: Colors.white,
                                      //                       fontSize: 13,
                                      //                       fontFamily:
                                      //                           "DefaultFontFamily",
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //           Padding(
                                      //             padding:
                                      //                 const EdgeInsets.fromLTRB(
                                      //                     10, 0, 10, 0),
                                      //             child: GFAccordion(
                                      //               expandedIcon: Container(
                                      //                 decoration: BoxDecoration(
                                      //                   color: brandThree,
                                      //                   borderRadius:
                                      //                       BorderRadius
                                      //                           .circular(20.0),
                                      //                 ),
                                      //                 padding:
                                      //                     const EdgeInsets.all(
                                      //                         2),
                                      //                 child: const Icon(
                                      //                   Icons.remove,
                                      //                   color: brandOne,
                                      //                 ),
                                      //               ),
                                      //               collapsedIcon: Container(
                                      //                 decoration: BoxDecoration(
                                      //                   color: brandThree,
                                      //                   borderRadius:
                                      //                       BorderRadius
                                      //                           .circular(20.0),
                                      //                 ),
                                      //                 padding:
                                      //                     const EdgeInsets.all(
                                      //                         2),
                                      //                 child: const Icon(
                                      //                   Icons.add,
                                      //                   color: brandOne,
                                      //                 ),
                                      //               ),
                                      //               title: "View details",
                                      //               textStyle: const TextStyle(
                                      //                 color: Colors.black,
                                      //                 fontFamily:
                                      //                     "DefaultFontFamily",
                                      //               ),
                                      //               contentBackgroundColor:
                                      //                   brandThree,
                                      //               expandedTitleBackgroundColor:
                                      //                   brandThree,
                                      //               collapsedTitleBackgroundColor:
                                      //                   brandThree,
                                      //               onToggleCollapsed: (e) {},
                                      //               contentChild: Column(
                                      //                 crossAxisAlignment:
                                      //                     CrossAxisAlignment
                                      //                         .start,
                                      //                 children: [
                                      //                   Text(
                                      //                     'SpaceRent ID: ${rentController.rent[index].rentId}',
                                      //                     style:
                                      //                         const TextStyle(
                                      //                       color: Colors.black,
                                      //                       fontFamily:
                                      //                           "DefaultFontFamily",
                                      //                     ),
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 20,
                                      //                   ),
                                      //                   Text(
                                      //                     'Created: ${rentController.rent[index].date}',
                                      //                     style:
                                      //                         const TextStyle(
                                      //                       color: Colors.black,
                                      //                       fontFamily:
                                      //                           "DefaultFontFamily",
                                      //                     ),
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 20,
                                      //                   ),
                                      //                   Text(
                                      //                     'Target no of payments: ${rentController.rent[index].numPayment}',
                                      //                     style:
                                      //                         const TextStyle(
                                      //                       color: Colors.black,
                                      //                       fontFamily:
                                      //                           "DefaultFontFamily",
                                      //                     ),
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 20,
                                      //                   ),
                                      //                   Text(
                                      //                     'No of payments: ${rentController.rent[index].currentPayment}',
                                      //                     style:
                                      //                         const TextStyle(
                                      //                       color: Colors.black,
                                      //                       fontFamily:
                                      //                           "DefaultFontFamily",
                                      //                     ),
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 20,
                                      //                   ),
                                      //                   Text(
                                      //                     'Payment intervals: ${nairaFormaet.format(double.parse(rentController.rent[index].intervalAmount.toString()))} ${rentController.rent[index].interval}',
                                      //                     style:
                                      //                         const TextStyle(
                                      //                       color: Colors.black,
                                      //                       fontFamily:
                                      //                           "DefaultFontFamily",
                                      //                     ),
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 20,
                                      //                   ),
                                      //                   Text(
                                      //                     'Paid Amount: ${nairaFormaet.format(double.parse(rentController.rent[index].savedAmount.toString()))}',
                                      //                     style:
                                      //                         const TextStyle(
                                      //                       color: Colors.black,
                                      //                       fontFamily:
                                      //                           "DefaultFontFamily",
                                      //                     ),
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 20,
                                      //                   ),
                                      //                   Text(
                                      //                     'Target Amount: ${nairaFormaet.format(double.parse(rentController.rent[index].targetAmount.toString()))}',
                                      //                     style:
                                      //                         const TextStyle(
                                      //                       color: Colors.black,
                                      //                       fontFamily:
                                      //                           "DefaultFontFamily",
                                      //                     ),
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 20,
                                      //                   ),
                                      //                   Text(
                                      //                     'Remaining Amount: ${nairaFormaet.format(double.parse((rentController.rent[index].targetAmount - rentController.rent[index].savedAmount).toString()))}',
                                      //                     style:
                                      //                         const TextStyle(
                                      //                       color: Colors.black,
                                      //                       fontFamily:
                                      //                           "DefaultFontFamily",
                                      //                     ),
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // const SizedBox(
                                      //   height: 40,
                                      // ),
                                    ],
                                  )
                                : const Center(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add your onPressed code here!
      //     Get.to(const RentSpaceSubscription());
      //   },
      //   backgroundColor: brandOne,
      //   child: const Icon(
      //     Icons.add_outlined,
      //     size: 30,
      //     color: Colors.white,
      //   ),
      // ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
