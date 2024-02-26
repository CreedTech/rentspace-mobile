import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
// import 'package:rentspace/controller/rent_controller.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_history.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';

import '../../../controller/rent/rent_controller.dart';
import '../../dashboard/dashboard.dart';
import '../../loan/loan_page.dart';

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
var testdum = "".obs();
String savedAmount = "0";
String fundingId = "";
String fundDate = "";

int rentBalance = 0;
int totalSavings = 0;
bool hideBalance = false;

class _RentSpaceListState extends State<RentSpaceList> {
  final RentController rentController = Get.find();

  // DateTime parseDate(String dateString) {
  //   List<int> parts = dateString.split('-').map(int.parse).toList();
  //   return DateTime(parts[0], parts[1], parts[2]);
  // }
  DateTime parseDate(String dateString) {
    // Split the dateString by 'T' to get only the date part
    String datePart = dateString.split('T')[0];

    // Split the datePart by '-' to extract year, month, and day
    List<int> parts = datePart.split('-').map(int.parse).toList();

    // Create a DateTime object using the extracted parts
    return DateTime(parts[0], parts[1], parts[2]);
  }

  void main() {
    String dateString = '2024-02-16T16:14:29.466Z';
    DateTime parsedDate = parseDate(dateString);
    print(parsedDate); // Output: 2024-02-16 00:00:00.000
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

  @override
  Widget build(BuildContext context) {
    String chosenDateString = rentController.rentModel!.rent![0].date;
    String interval = rentController.rentModel!.rent![0].interval;
    int numberOfIntervals =
        int.parse(rentController.rentModel!.rent![0].paymentCount);
    DateTime nextPaymentDate =
        calculateNextPaymentDate(chosenDateString, interval, numberOfIntervals);
    String formattedNextDate = formatDate(nextPaymentDate);
    print(((rentController.rentModel!.rent![0].paidAmount.abs()) ==
        (rentController.rentModel!.rent![0].amount * 0.7).abs()));
    print(((rentController.rentModel!.rent![0].paidAmount)));
    print(((rentController.rentModel!.rent![0].amount * 0.7)));

    // return Text(
    //   formattedTimeAgo,
    //   style: TextStyle(fontSize: 18.0),
    // );
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 105.0,
        backgroundColor:
            ((rentController.rentModel!.rent![0].paidAmount) !=
                    (rentController.rentModel!.rent![0].amount * 0.7))
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
            color: ((rentController.rentModel!.rent![0].paidAmount) !=
                    (rentController.rentModel!.rent![0].amount * 0.7))
                ? Colors.white
                : Theme.of(context).primaryColor,
          ),
        ),
        // centerTitle: true,
        title: Text(
          'Space Rent',
          style: GoogleFonts.nunito(
            color: ((rentController.rentModel!.rent![0].paidAmount) !=
                    (rentController.rentModel!.rent![0].amount * 0.7))
                ? Colors.white
                : Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      //
      body: Obx(
        () => ((rentController.rentModel!.rent![0].paidAmount.obs()) !=
                (rentController.rentModel!.rent![0].amount * 0.7))
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
                              "${nairaFormaet.format(rentController.rentModel!.rent![0].paidAmount).toString()} $testdum",
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
                                      .format(rentController
                                          .rentModel!.rent![0].amount)
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
                                //   ' ${((rentController.rentModel!.rent![0].paidAmount / rentController.rentModel!.rent![0].amount) * 100).toInt()}%',
                                //   style: GoogleFonts.nunito(
                                //     fontSize: MediaQuery.of(context).size.width / 30,
                                //     fontWeight: FontWeight.w700,
                                //     color: brandOne,
                                //   ),
                                // ),
                                percent: ((rentController.rentModel!
                                            .rent![0].paidAmount /
                                        rentController
                                            .rentModel!.rent![0].amount))
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
                                      .format(rentController.rentModel!
                                          .rent![0].intervalAmount)
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
                                  rentController
                                          .rentModel!.rent![0].interval
                                          .substring(0, 1)
                                          .toUpperCase() +
                                      rentController
                                          .rentModel!.rent![0].interval
                                          .substring(1),
                                  // intl.capitalizedFirst(rentController.rentModel!.rent![0].interval),
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Container(
                                      width: 152,
                                      height: 56,
                                      // padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: (themeChange.isSavedDarkMode())
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.13),
                                        borderRadius: BorderRadius.circular(43),
                                      ),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Loan Amount:',
                                              style: GoogleFonts.nunito(
                                                color: (themeChange
                                                        .isSavedDarkMode())
                                                    ? brandTwo
                                                    : Colors.white
                                                        .withOpacity(0.75),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                nairaFormaet
                                                    .format(rentController
                                                            .rentModel!
                                                            .rent![0]
                                                            .amount -
                                                        (rentController
                                                                .rentModel!
                                                                .rent![0]
                                                                .amount *
                                                            0.7))
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Container(
                                      width: 152,
                                      height: 56,
                                      // padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: (themeChange.isSavedDarkMode())
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.13),
                                        borderRadius: BorderRadius.circular(43),
                                      ),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Interest Rate:',
                                              style: GoogleFonts.nunito(
                                                color: (themeChange
                                                        .isSavedDarkMode())
                                                    ? brandTwo
                                                    : Colors.white
                                                        .withOpacity(0.75),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              '30%',
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
                          left: 20,
                          top: 20,
                          bottom: 5,
                          right: 20,
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
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // print(int.parse(rentController.rentModel!.rent![0].id));
                                        Get.to(SpaceRentHistory(
                                          current: 0,
                                        ));
                                      },
                                      child: Text(
                                        "See All",
                                        style: GoogleFonts.nunito(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).primaryColor,
                                          // decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // rentController.rentModel!.rent![0].history.isEmpty
                              //     ? Column(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.stretch,
                              //         children: [
                              //           Image.asset(
                              //             'assets/card_empty.png',
                              //             height: 200,
                              //           ),
                              //           Center(
                              //             child: Text(
                              //               "Nothing to show",
                              //               style: GoogleFonts.nunito(
                              //                 fontSize: 20,
                              //                 color: Theme.of(context)
                              //                     .primaryColor,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       )
                              //     : Expanded(
                              //         child: ListView.builder(
                              //           scrollDirection: Axis.vertical,
                              //           shrinkWrap: true,
                              //           physics: const ClampingScrollPhysics(),
                              //           itemCount: rentController
                              //               .rentModel!.rent![0].history.reversed
                              //               .toList()
                              //               .length,
                              //           itemBuilder:
                              //               (BuildContext context, int index) {
                              //             // DateTime targetDate = DateTime.parse(
                              //             //     rentController.rentModel!.rent![0].history.reversed
                              //             //         .toList()[index]
                              //             //         .split(" ")[0]);
                              //             // String formattedTimeAgo = timeago
                              //             //     .format(targetDate, locale: 'en');

                              //             // // If the difference is more than 24 hours, convert to days
                              //             // if (DateTime.now()
                              //             //         .difference(targetDate)
                              //             //         .inHours >
                              //             //     24) {
                              //             //   int daysAgo = DateTime.now()
                              //             //       .difference(targetDate)
                              //             //       .inDays;
                              //             //   formattedTimeAgo =
                              //             //       '$daysAgo ${daysAgo == 1 ? 'day' : 'days'} ago';
                              //             // }
                              //             return Padding(
                              //               padding: const EdgeInsets.symmetric(
                              //                   vertical: 7),
                              //               child: ListTile(
                              //                 leading: Container(
                              //                   padding:
                              //                       const EdgeInsets.all(12),
                              //                   decoration: BoxDecoration(
                              //                     shape: BoxShape.circle,
                              //                     color: Theme.of(context)
                              //                         .primaryColor,
                              //                   ),
                              //                   child: Icon(
                              //                     Icons.arrow_outward_sharp,
                              //                     color: Theme.of(context)
                              //                         .colorScheme
                              //                         .primary,
                              //                   ),
                              //                 ),
                              //                 title: Text(
                              //                   'Space Rent Saving',
                              //                   style: GoogleFonts.nunito(
                              //                     color: Theme.of(context)
                              //                         .primaryColor,
                              //                     fontSize: 17,
                              //                     fontWeight: FontWeight.w600,
                              //                   ),
                              //                 ),
                              //                 subtitle: Text(
                              //                   _formatTime(DateTime.parse(
                              //                           (rentController.rentModel!.rent![0]
                              //                               .history.reversed
                              //                               .toList()[index]
                              //                               .split(" ")[0]
                              //                               .substring(
                              //                                   0,
                              //                                   rentController
                              //                                           .rentModel!.rent![0]
                              //                                           .history
                              //                                           .reversed
                              //                                           .toList()[
                              //                                               index]
                              //                                           .split(
                              //                                               " ")[0]
                              //                                           .length -
                              //                                       4))))
                              //                       .toString(),
                              //                   style: GoogleFonts.nunito(
                              //                     color: brandTwo,
                              //                     fontSize: 12,
                              //                     fontWeight: FontWeight.w400,
                              //                   ),
                              //                 ),
                              //                 // onTap: () {
                              //                 //   Get.to(
                              //                 //       CustomTransactionDetailsCard(current: index));
                              //                 //   // Navigator.pushNamed(context, RouteList.profile);
                              //                 // },
                              //                 trailing: Text(
                              //                   '+ ₦${extractAmount(rentController.rentModel!.rent![0].history.reversed.toList()[index])}'
                              //                   // rentController
                              //                   //     .rentModel!.rent![0].history.reversed
                              //                   //     .toList()[index]
                              //                   //     .split(" ")
                              //                   //     .last
                              //                   ,
                              //                   style: GoogleFonts.nunito(
                              //                     color: Theme.of(context)
                              //                         .primaryColor,
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w600,
                              //                   ),
                              //                 ),
                              //               ),
                              //             );
                              //           },
                              //         ),
                              //       ),
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
                        .format(rentController.rentModel!.rent![0].amount -
                            (rentController.rentModel!.rent![0].amount *
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
                        Get.to(const LoanPage());
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
                  )
                  // Spacer(),
                ],
              ),
      ),

      backgroundColor: ((rentController.rentModel!.rent![0].paidAmount) !=
              (rentController.rentModel!.rent![0].amount * 0.7))
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
