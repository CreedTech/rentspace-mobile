import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:rentspace/controller/rent_controller.dart';
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
import 'package:timeago/timeago.dart' as timeago;

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

  DateTime parseDate(String dateString) {
    List<int> parts = dateString.split('-').map(int.parse).toList();
    return DateTime(parts[0], parts[1], parts[2]);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  DateTime calculateNextPaymentDate(
      String chosenDateString, String interval, int numberOfIntervals) {
    DateTime chosenDate = parseDate(chosenDateString);
    DateTime nextPaymentDate;

    switch (interval.toLowerCase()) {
      case 'daily':
        nextPaymentDate = chosenDate.add(const Duration(days: 1));
        break;
      case 'weekly':
        nextPaymentDate = chosenDate.add(const Duration(days: 7));
        break;
      case 'monthly':
        nextPaymentDate =
            DateTime(chosenDate.year, chosenDate.month + 1, chosenDate.day);
        break;
      default:
        throw Exception("Invalid interval: $interval");
    }

    return nextPaymentDate;
  }

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
    String chosenDateString = rentController.rent[0].date;
    String interval = rentController.rent[0].interval;
    int numberOfIntervals = int.parse(rentController.rent[0].numPayment);
    DateTime nextPaymentDate =
        calculateNextPaymentDate(chosenDateString, interval, numberOfIntervals);
    String formattedNextDate = formatDate(nextPaymentDate);
    print(nextPaymentDate);

    // return Text(
    //   formattedTimeAgo,
    //   style: TextStyle(fontSize: 18.0),
    // );
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 105.0,
        backgroundColor: brandOne,
        elevation: 1.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).canvasColor,
          ),
        ),
        // centerTitle: true,
        title: Text(
          'Space Rent',
          style: GoogleFonts.nunito(
            color: Colors.white,
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
              SizedBox(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 26),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'You have saved',
                        style: GoogleFonts.nunito(
                          color: Colors.white.withOpacity(0.75),
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        nairaFormaet
                            .format(rentController.rent[0].savedAmount)
                            .toString(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontWeight: FontWeight.w800,
                          fontSize: 31,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'of your ',
                            style: GoogleFonts.nunito(
                              color: Colors.white.withOpacity(0.75),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            nairaFormaet
                                .format(rentController.rent[0].targetAmount)
                                .toString(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            ' Target',
                            style: GoogleFonts.nunito(
                              color: Colors.white.withOpacity(0.75),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 18),
                        child: LinearPercentIndicator(
                          backgroundColor: Colors.white,
                          // trailing: Text(
                          //   ' ${((rentController.rent[0].savedAmount / rentController.rent[0].targetAmount) * 100).toInt()}%',
                          //   style: GoogleFonts.nunito(
                          //     fontSize: MediaQuery.of(context).size.width / 30,
                          //     fontWeight: FontWeight.w700,
                          //     color: brandOne,
                          //   ),
                          // ),
                          percent: ((rentController.rent[0].savedAmount /
                                  rentController.rent[0].targetAmount))
                              .toDouble(),
                          animation: true,
                          barRadius: const Radius.circular(10.0),
                          lineHeight: MediaQuery.of(context).size.width / 40,
                          fillColor: Colors.transparent,
                          progressColor: brandTwo,
                        ),
                      ),
                      Text(
                        'Your savings schedule is',
                        style: GoogleFonts.nunito(
                          color: Colors.white.withOpacity(0.75),
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            nairaFormaet
                                .format(rentController.rent[0].intervalAmount)
                                .toString(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          Text(
                            rentController.rent[0].interval
                                    .substring(0, 1)
                                    .toUpperCase() +
                                rentController.rent[0].interval.substring(1),
                            // intl.capitalizedFirst(rentController.rent[0].interval),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 48),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                width: 152,
                                height: 56,
                                // padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.13),
                                  borderRadius: BorderRadius.circular(43),
                                ),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Interest Accrued:',
                                        style: GoogleFonts.nunito(
                                          color: Colors.white.withOpacity(0.75),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        nairaFormaet
                                            .format(rentController
                                                    .rent[0].targetAmount -
                                                (rentController
                                                        .rent[0].targetAmount *
                                                    0.7))
                                            .toString(),
                                        style: GoogleFonts.nunito(
                                          color: const Color(0xffF2F2F2),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                width: 152,
                                height: 56,
                                // padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.13),
                                  borderRadius: BorderRadius.circular(43),
                                ),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Interest Rate:',
                                        style: GoogleFonts.nunito(
                                          color: Colors.white.withOpacity(0.75),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '30%',
                                        style: GoogleFonts.nunito(
                                          color: const Color(0xffF2F2F2),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next payement date: ',
                            style: GoogleFonts.nunito(
                              color: Colors.white.withOpacity(0.75),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            formattedNextDate.toString(),
                            style: GoogleFonts.nunito(
                              color: Colors.white.withOpacity(0.75),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.only(
              //       left: 20, top: 45, bottom: 5, right: 20),
              //   child: Container(
              //     // height: 100,
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              //     decoration: BoxDecoration(
              //       color: brandOne,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Center(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Column(
              //             children: [
              //               Text(
              //                 'Available Balance ',
              //                 textAlign: TextAlign.center,
              //                 style: GoogleFonts.nunito(
              //                   fontSize: 20.0,
              //                   fontWeight: FontWeight.w400,
              //                   // fontFamily: "DefaultFontFamily",
              //                   // letterSpacing: 0.5,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //               Row(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   Text(
              //                     'Space Rent',
              //                     textAlign: TextAlign.center,
              //                     style: GoogleFonts.nunito(
              //                       fontSize: 16.0,
              //                       fontWeight: FontWeight.w400,
              //                       // fontFamily: "DefaultFontFamily",
              //                       // letterSpacing: 0.5,
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
              //                           ? Icons.visibility_off_outlined
              //                           : Icons.visibility_outlined,
              //                       color: Colors.white,
              //                       size: 20,
              //                     ),
              //                   )
              //                 ],
              //               ),
              //             ],
              //           ),
              //           Row(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Text(
              //                 " ${hideBalance ? nairaFormaet.format(totalSavings).toString() : "********"}",
              //                 textAlign: TextAlign.center,
              //                 style: GoogleFonts.nunito(
              //                   fontSize: 35.0,
              //                   // fontFamily: "DefaultFontFamily",
              //                   // letterSpacing: 0.5,
              //                   fontWeight: FontWeight.w700,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //               const SizedBox(
              //                 width: 15,
              //               ),
              //             ],
              //           ),
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //               minimumSize: const Size(150, 50),
              //               backgroundColor: brandTwo,
              //               elevation: 0,
              //               shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(
              //                   10,
              //                 ),
              //               ),
              //             ),
              //             onPressed: () async {
              //               Get.to(const RentSpaceSubscription());
              //             },
              //             child: Text(
              //               'Save',
              //               textAlign: TextAlign.center,
              //               style: GoogleFonts.nunito(
              //                 fontSize: 25.0,
              //                 // fontFamily: "DefaultFontFamily",
              //                 // letterSpacing: 0.5,
              //                 fontWeight: FontWeight.w700,
              //                 color: Colors.white,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              //  Stack()
              Container(
                height: MediaQuery.of(context).size.height - 400,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 20, bottom: 5, right: 20),
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
                              left: 20, top: 0, bottom: 25, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Savings History',
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
                                  "See All",
                                  style: GoogleFonts.nunito(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                    color: brandTwo,
                                    // decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        rentController.rent[0].history.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Image.asset(
                                    'assets/empty_state.png',
                                    height: 200,
                                  ),
                                  const Center(
                                    child: Text(
                                      "Nothing to show",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "DefaultFontFamily",
                                        color: brandOne,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: rentController
                                      .rent[0].history.reversed
                                      .toList()
                                      .length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    DateTime targetDate = DateTime.parse(
                                        rentController.rent[0].history.reversed
                                            .toList()[index]
                                            .split(" ")[0]);
                                    String formattedTimeAgo = timeago
                                        .format(targetDate, locale: 'en');

                                    // If the difference is more than 24 hours, convert to days
                                    if (DateTime.now()
                                            .difference(targetDate)
                                            .inHours >
                                        24) {
                                      int daysAgo = DateTime.now()
                                          .difference(targetDate)
                                          .inDays;
                                      formattedTimeAgo =
                                          '$daysAgo ${daysAgo == 1 ? 'day' : 'days'} ago';
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7),
                                      child: ListTile(
                                        leading: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: brandOne,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_outward_sharp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(
                                          'Space Rent Saving',
                                          style: GoogleFonts.nunito(
                                            color: brandOne,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          formattedTimeAgo,
                                          style: GoogleFonts.nunito(
                                            color: brandTwo,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        // onTap: () {
                                        //   Get.to(
                                        //       CustomTransactionDetailsCard(current: index));
                                        //   // Navigator.pushNamed(context, RouteList.profile);
                                        // },
                                        trailing: Text(
                                          rentController
                                              .rent[0].history.reversed
                                              .toList()[index]
                                              .split(" ")
                                              .last,
                                          style: GoogleFonts.nunito(
                                            color: brandOne,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
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
      backgroundColor: brandOne,
    );
  }
}
