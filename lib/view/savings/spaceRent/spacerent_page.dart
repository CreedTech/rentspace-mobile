import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../constants/colors.dart';
import '../../../controller/rent/rent_controller.dart';
import '../../dashboard/dashboard.dart';
import '../../kyc/kyc_intro.dart';
import '../../loan/loan_page.dart';
import 'spacerent_history.dart';

class SpaceRentPage extends StatefulWidget {
  const SpaceRentPage({super.key, required this.current});
  final int current;

  @override
  State<SpaceRentPage> createState() => _SpaceRentPageState();
}

var ch8t = NumberFormat.simpleCurrency(name: 'NGN');
var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
var testdum = "".obs();
String savedAmount = "0";
String fundingId = "";
String fundDate = "";

int rentBalance = 0;
int totalSavings = 0;
bool hideBalance = false;

class _SpaceRentPageState extends State<SpaceRentPage> {
  final RentController rentController = Get.find();

  // DateTime parseDate(String dateString) {
  //   List<int> parts = dateString.split('-').map(int.parse).toList();
  //   return DateTime(parts[0], parts[1], parts[2]);
  // }
  // DateTime parseDate(String dateString) {
  //   // Split the dateString by 'T' to get only the date part
  //   String datePart = dateString.split('T')[0];

  //   // Split the datePart by '-' to extract year, month, and day
  //   List<int> parts = datePart.split('-').map(int.parse).toList();

  //   // Create a DateTime object using the extracted parts
  //   return DateTime(parts[0], parts[1], parts[2]);
  // }

  // void main() {
  //   String dateString = '2024-02-16T16:14:29.466Z';
  //   DateTime parsedDate = parseDate(dateString);
  //   print(parsedDate); // Output: 2024-02-16 00:00:00.000
  // }

  // String formatDate(DateTime date) {
  //   print(date);
  //   print(DateFormat('dd/MM/yyyy').format(date));
  //   return DateFormat('dd/MM/yyyy').format(date);
  // }

  // DateTime calculateNextPaymentDateUpdate(
  //     DateTime lastPaymentDate, String interval) {
  //   // Calculate the next payment date based on the interval
  //   DateTime nextPaymentDate;
  //   if (interval == 'weekly') {
  //     nextPaymentDate = lastPaymentDate.add(const Duration(days: 7));
  //   } else {
  //     // Assuming monthly intervals, you can adjust this logic as needed
  //     nextPaymentDate = lastPaymentDate.add(const Duration(days: 30));
  //   }
  //   return nextPaymentDate;
  // }

  // DateTime calculateNextPaymentDate(
  //     String chosenDateString, String interval, int numberOfIntervals) {
  //   DateTime chosenDate = parseDate(chosenDateString);
  //   print('chosen date: $chosenDate' );
  //   DateTime nextPaymentDate;

  //   switch (interval.toLowerCase()) {
  //     // case 'daily':
  //     //   nextPaymentDate = chosenDate.add(const Duration(days: 1));
  //     //   break;
  //     case 'weekly':
  //       nextPaymentDate = chosenDate.add(const Duration(days: 7));
  //       break;
  //     case 'monthly':
  //       nextPaymentDate =
  //           DateTime(chosenDate.year, chosenDate.month + 1, chosenDate.day);
  //       break;
  //     default:
  //       throw Exception("Invalid interval: $interval");
  //   }

  //   return nextPaymentDate;
  // }

  @override
  initState() {
    super.initState();
    setState(() {
      savedAmount = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    // String chosenDateString =
    //     rentController.rentModel!.rents![widget.current].date;
    // print(chosenDateString);
    // print(chosenDateString);
    // String interval = rentController.rentModel!.rents![widget.current].interval;
    // int numberOfIntervals = int.parse(
    //     rentController.rentModel!.rents![widget.current].paymentCount);
    // // DateTime nextPaymentDate =
    // //     calculateNextPaymentDate(chosenDateString, interval, numberOfIntervals);
    // //     print(nextPaymentDate);
    // // String formattedNextDate = formatDate(nextPaymentDate);
    // print(((rentController.rentModel!.rents![widget.current].paidAmount
    //         .abs()) ==
    //     (rentController.rentModel!.rents![widget.current].amount * 0.7).abs()));
    // print(((rentController.rentModel!.rents![widget.current].paidAmount)));
    // print(((rentController.rentModel!.rents![widget.current].amount * 0.7)));

    // return Text(
    //   formattedTimeAgo,
    //   style: TextStyle(fontSize: 18.0),
    // );
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 105.0,
        backgroundColor: ((rentController
                    .rentModel!.rents![widget.current].paidAmount) <=
                (rentController.rentModel!.rents![widget.current].amount * 0.7))
            ? Theme.of(context).primaryColorLight
            : Theme.of(context).canvasColor,
        elevation: 1.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: ((rentController
                        .rentModel!.rents![widget.current].paidAmount) <=
                    (rentController.rentModel!.rents![widget.current].amount *
                        0.7))
                ? Colors.white
                : Theme.of(context).primaryColor,
          ),
        ),
        // centerTitle: true,
        title: Text(
          'Space Rent',
          style: GoogleFonts.nunito(
            color: ((rentController
                        .rentModel!.rents![widget.current].paidAmount) <=
                    (rentController.rentModel!.rents![widget.current].amount *
                        0.7))
                ? Colors.white
                : Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      //
      body: Obx(
        () => ((rentController.rentModel!.rents![widget.current].paidAmount) <=
                (rentController.rentModel!.rents![widget.current].amount.obs *
                    0.7))
            ? SingleChildScrollView(
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
                              "${nairaFormaet.format(rentController.rentModel!.rents![widget.current].paidAmount).toString()} $testdum",
                              style: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.background,
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
                                      .format(rentController.rentModel!
                                          .rents![widget.current].amount)
                                      .toString(),
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
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
                                //   ' ${((rentController.rentModel!.rents![widget.current].paidAmount / rentController.rentModel!.rents![widget.current].amount) * 100).toInt()}%',
                                //   style: GoogleFonts.nunito(
                                //     fontSize: MediaQuery.of(context).size.width / 30,
                                //     fontWeight: FontWeight.w700,
                                //     color: brandOne,
                                //   ),
                                // ),
                                percent: ((rentController.rentModel!
                                            .rents![widget.current].paidAmount /
                                        rentController.rentModel!
                                            .rents![widget.current].amount))
                                    .toDouble(),
                                animation: true,
                                barRadius: const Radius.circular(10.0),
                                lineHeight:
                                    MediaQuery.of(context).size.width / 40,
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
                                      .format(rentController
                                          .rentModel!
                                          .rents![widget.current]
                                          .intervalAmount)
                                      .toString(),
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                Text(
                                  rentController.rentModel!
                                          .rents![widget.current].interval
                                          .substring(0, 1)
                                          .toUpperCase() +
                                      rentController.rentModel!
                                          .rents![widget.current].interval
                                          .substring(1),
                                  // intl.capitalizedFirst(rentController.rentModel!.rents![widget.current].interval),
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 48),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 5),
                                  //   child: Container(
                                  //     width: 152,
                                  //     height: 56,
                                  //     // padding: const EdgeInsets.all(12),
                                  //     decoration: BoxDecoration(
                                  //       color: (themeChange.isSavedDarkMode())
                                  //           ? Colors.white
                                  //           : Colors.white.withOpacity(0.13),
                                  //       borderRadius: BorderRadius.circular(43),
                                  //     ),
                                  //     child: Center(
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.center,
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         children: [
                                  //           Text(
                                  //             'Loan Amount:',
                                  //             style: GoogleFonts.nunito(
                                  //               color: (themeChange
                                  //                       .isSavedDarkMode())
                                  //                   ? brandTwo
                                  //                   : Colors.white
                                  //                       .withOpacity(0.75),
                                  //               fontWeight: FontWeight.w400,
                                  //               fontSize: 12,
                                  //             ),
                                  //           ),
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //               horizontal: 15,
                                  //             ),
                                  //             child: Text(
                                  //               nairaFormaet
                                  //                   .format(rentController
                                  //                           .rentModel!
                                  //                           .rents![
                                  //                               widget.current]
                                  //                           .amount -
                                  //                       (rentController
                                  //                               .rentModel!
                                  //                               .rents![widget
                                  //                                   .current]
                                  //                               .amount *
                                  //                           0.7))
                                  //                   .toString(),
                                  //               overflow: TextOverflow.ellipsis,
                                  //               style: GoogleFonts.nunito(
                                  //                 color: Theme.of(context)
                                  //                     .colorScheme
                                  //                     .background,
                                  //                 fontWeight: FontWeight.w700,
                                  //                 fontSize: 16,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 5),
                                  //   child: Container(
                                  //     width: 152,
                                  //     height: 56,
                                  //     // padding: const EdgeInsets.all(12),
                                  //     decoration: BoxDecoration(
                                  //       color: (themeChange.isSavedDarkMode())
                                  //           ? Colors.white
                                  //           : Colors.white.withOpacity(0.13),
                                  //       borderRadius: BorderRadius.circular(43),
                                  //     ),
                                  //     child: Center(
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.center,
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         children: [
                                  //           Text(
                                  //             'Interest Rate:',
                                  //             style: GoogleFonts.nunito(
                                  //               color: (themeChange
                                  //                       .isSavedDarkMode())
                                  //                   ? brandTwo
                                  //                   : Colors.white
                                  //                       .withOpacity(0.75),
                                  //               fontWeight: FontWeight.w400,
                                  //               fontSize: 12,
                                  //             ),
                                  //           ),
                                  //           Text(
                                  //             '10%',
                                  //             style: GoogleFonts.nunito(
                                  //               color: Theme.of(context)
                                  //                   .colorScheme
                                  //                   .background,
                                  //               fontWeight: FontWeight.w700,
                                  //               fontSize: 16,
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
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
                                  rentController.rentModel!
                                      .rents![widget.current].nextDate,
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
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
                    Container(
                      height: MediaQuery.of(context).size.height - 400,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(26),
                            topRight: Radius.circular(26)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 20,
                          bottom: 5,
                          right: 10,
                        ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Savings History',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.nunito(
                                        fontSize: 14.0.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // print(int.parse(rentController.rentModel!.rents![widget.current].id));
                                        Get.to(SpaceRentHistory(
                                          current: widget.current,
                                        ));
                                      },
                                      child: Text(
                                        "See All",
                                        style: GoogleFonts.nunito(
                                          fontSize: 12.0.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).primaryColor,
                                          // decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              rentController.rentModel!.rents![widget.current]
                                      .rentHistories.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Image.asset(
                                          'assets/card_empty.png',
                                          height: 200,
                                        ),
                                        Center(
                                          child: Text(
                                            "Nothing to show",
                                            style: GoogleFonts.nunito(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                            .rentModel!
                                            .rents![widget.current]
                                            .rentHistories
                                            .length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final history = rentController
                                              .rentModel!
                                              .rents![widget.current]
                                              .rentHistories[index];

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7),
                                            child: ListTile(
                                              leading: Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: brandOne,
                                                ),
                                                child: Image.asset(
                                                  "assets/icons/savings/spacerent.png",
                                                  height: 20,
                                                  width: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              title: Text(
                                                history['message'],
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              subtitle: Text(
                                                _formatTime(DateTime.parse(
                                                        (history['createdAt']))
                                                    .add(const Duration(
                                                        hours: 1))),
                                                style: GoogleFonts.nunito(
                                                  color: brandOne,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              // subtitle: Text(
                                              //   _formatTime(DateTime.parse(
                                              //           history['createdAt'])
                                              //       .add(const Duration(
                                              //           hours: 1))),
                                              //   style: GoogleFonts.nunito(
                                              //     color: brandOne,
                                              //     fontSize: 12.sp,
                                              //     fontWeight: FontWeight.w400,
                                              //   ),
                                              // ),
                                              // onTap: () {
                                              //   Get.to(
                                              //       CustomTransactionDetailsCard(current: index));
                                              //   // Navigator.pushNamed(context, RouteList.profile);
                                              // },
                                              trailing: Text(
                                                '+ ${ch8t.format(history['amount'])}',
                                                style: GoogleFonts.nunito(
                                                  color: Colors.green,
                                                  fontSize: 12.sp,
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
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/check.png',
                    width: 120.w,
                  ),
                  SizedBox(
                    height: 55.h,
                  ),
                  Text(
                    'Congrats, you are eligile for a loan',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    'Total Loanable amount',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    nairaFormaet
                        .format(rentController
                                .rentModel!.rents![widget.current].amount -
                            (rentController
                                    .rentModel!.rents![widget.current].amount *
                                0.7))
                        .toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 31.sp,
                    ),
                  ),

                  SizedBox(
                    height: 70.h,
                  ),
                  // Spacer(),
                  Column(
                    children: [
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 50),
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: brandOne),
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          onPressed: () {
                            // Get.to(const LoanPage());
                          },
                          child: Text(
                            'Continue Saving',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: brandOne,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 50),
                            backgroundColor: brandOne,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          onPressed: () {
                            (userController.userModel!.userDetails![0]
                                        .hasVerifiedKyc ==
                                    false)
                                ? Get.to(const KYCIntroPage())
                                : Get.to(const LoanPage());
                          },
                          child: Text(
                            'Take Loan',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  // Spacer(),
                ],
              ),
      ),

      backgroundColor: ((rentController
                  .rentModel!.rents![widget.current].paidAmount) <=
              (rentController.rentModel!.rents![widget.current].amount * 0.7))
          ? Theme.of(context).primaryColorLight
          : Theme.of(context).canvasColor,
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  String extractAmount(String input) {
    final nairaIndex = input.indexOf('₦');
    if (nairaIndex != -1 && nairaIndex < input.length - 1) {
      return input.substring(nairaIndex + 1).trim();
    }
    return '';
  }
}
