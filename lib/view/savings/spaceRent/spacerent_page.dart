import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_list.dart';

import '../../../constants/colors.dart';
import '../../../controller/rent/rent_controller.dart';
import '../../actions/transaction_receipt.dart';
import '../../actions/transaction_receipt_dva.dart';
import '../../actions/transaction_receipt_transfer.dart';
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

var ch8t = NumberFormat.simpleCurrency(name: 'N');
var nairaFormaet = NumberFormat.simpleCurrency(name: 'N', decimalDigits: 0);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF6F6F8),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: colorBlack,
              ),
            ),
            SizedBox(
              width: 4.h,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Text(
                rentController.rentModel!.rents![widget.current].rentName,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  color: colorBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
      //
      body: Obx(
        () => ((rentController.rentModel!.rents![widget.current].paidAmount) <=
                (rentController.rentModel!.rents![widget.current].amount.obs *
                    0.7))
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0, bottom: 20.h),
                      child: IntrinsicHeight(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xff278210),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 40.h,
                                right: -30.w,
                                child: Transform.scale(
                                  scale: MediaQuery.of(context).size.width /
                                      300, // Adjust the reference width as needed
                                  child: Image.asset(
                                    'assets/house_slant.png',
                                    width: 103.91, // Width without scaling
                                    height: 144.17, // Height without scaling
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 15.w,
                                    top: 14.h,
                                    right: 0.w,
                                    bottom: 14.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${rentController.rentModel!.rents![widget.current].rentName} Balance',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: colorWhite,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          nairaFormaet.format(rentController
                                              .rentModel!
                                              .rents![widget.current]
                                              .paidAmount),
                                          style: GoogleFonts.lato(
                                            fontSize: 30,
                                            color: colorWhite,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.8,
                                          child: LinearPercentIndicator(
                                            padding: EdgeInsets.only(
                                                left: 0, right: 19.w),
                                            animateFromLastPercent: true,
                                            backgroundColor:
                                                const Color(0xff134107),
                                            trailing: Text(
                                              ' ${((rentController.rentModel!.rents![widget.current].paidAmount / rentController.rentModel!.rents![widget.current].amount) * 100).toInt()}%',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: colorWhite,
                                              ),
                                            ),
                                            percent: ((rentController
                                                        .rentModel!
                                                        .rents![widget.current]
                                                        .paidAmount /
                                                    rentController
                                                        .rentModel!
                                                        .rents![widget.current]
                                                        .amount))
                                                .toDouble(),
                                            animation: true,
                                            barRadius:
                                                const Radius.circular(50.0),
                                            lineHeight: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                40,
                                            fillColor: Colors.transparent,
                                            progressColor: colorWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 14.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 11.w,
                                              right: 25.w,
                                              top: 9.h,
                                              bottom: 9.h),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFFFFFF)
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Target',
                                                style: GoogleFonts.lato(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: colorWhite,
                                                ),
                                              ),
                                              // AutoSizeText(
                                              //   nairaFormaet.format(
                                              //       rentController
                                              //           .rentModel!
                                              //           .rents![widget.current]
                                              //           .amount),
                                              //   maxLines: 2,
                                              //   // minFontSize: 2.0,
                                              //   // textAlign: TextAlign.center,
                                              //   style: GoogleFonts.lato(
                                              //     fontSize: 16.0,
                                              //     fontWeight: FontWeight.w600,
                                              //     color: colorWhite,
                                              //   ),
                                              // ),
                                              SizedBox(
                                                width: 106.w,
                                                child: Text(
                                                  nairaFormaet.format(50000000),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: colorWhite,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 11.w, vertical: 9.h),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFFFFFF)
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Due in',
                                                style: GoogleFonts.lato(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: colorWhite,
                                                ),
                                              ),
                                              Text(
                                                '${_calculateDaysDifference(rentController.rentModel!.rents![widget.current].dueDate, rentController.rentModel!.rents![widget.current].date).toString()} Days',
                                                style: GoogleFonts.lato(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorWhite,
                                                ),
                                              ),
                                            ],
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
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 92.h,
                      padding: EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Saving Schedule',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: colorDark,
                                ),
                              ),
                              SizedBox(
                                height: 9.h,
                              ),
                              Text(
                                '${ch8t.format(rentController.rentModel!.rents![widget.current].intervalAmount)}/${rentController.rentModel!.rents![widget.current].interval.toLowerCase()}',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: colorDark,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff4B4B4B),
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              RichText(
                                text: TextSpan(
                                    style: GoogleFonts.lato(
                                      // fontWeight: FontWeight.w700,
                                      color: colorBlack,
                                      fontSize: 12,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Next Payment: ',
                                        style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: rentController.rentModel!
                                            .rents![widget.current].nextDate,
                                        style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'History',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colorBlack,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(SpaceRentHistory(
                              current: widget.current,
                            ));
                          },
                          child: Text(
                            'View All',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: brandTwo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      height: rentController.rentModel!.rents![widget.current]
                                  .rentHistories.length <
                              3
                          ? (rentController.rentModel!.rents![widget.current]
                                  .rentHistories.length *
                              80)
                          : rentController.rentModel!.rents![widget.current]
                                  .rentHistories.isEmpty
                              ? 240.h
                              : 240.h,
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: (rentController.rentModel!.rents![widget.current]
                              .rentHistories.isEmpty)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Image.asset(
                                  'assets/card_empty.png',
                                  height: 150.h,
                                ),
                                Center(
                                  child: Text(
                                    "No Transaction history",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: (rentController
                                          .rentModel!
                                          .rents![widget.current]
                                          .rentHistories
                                          .length <
                                      3)
                                  ? rentController
                                      .rentModel!
                                      .rents![widget.current]
                                      .rentHistories
                                      .length
                                  : 3,
                              itemBuilder: (BuildContext context, int index) {
                                int reversedIndex = rentController
                                        .rentModel!
                                        .rents![widget.current]
                                        .rentHistories
                                        .length -
                                    1 -
                                    index;
                                // Access the activities in reverse order
                                final history = rentController
                                    .rentModel!
                                    .rents![widget.current]
                                    .rentHistories[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      (history['transactionGroup']
                                                  .toString()
                                                  .toLowerCase() ==
                                              'transfer')
                                          ? TransactionReceiptTransfer(
                                              amount: history['amount'],
                                              status: history['status'],
                                              fees: history['fees'] ?? 0,
                                              transactionType:
                                                  history['transactionType'],
                                              description:
                                                  history['description'],
                                              transactionGroup:
                                                  history['transactionGroup'],
                                              transactionDate:
                                                  history['createdAt'],
                                              transactionRef: history[
                                                      'transactionReference'] ??
                                                  '',
                                              merchantRef:
                                                  history['merchantReference'],
                                              // sessionId: history['sessionId'] ?? '',
                                            )
                                          : (history['transactionGroup']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'static-account-transfer')
                                              ? TransactionReceiptDVA(
                                                  amount: history['amount'],
                                                  status: history['status'],
                                                  fees: history['fees'] ?? 0,
                                                  transactionType: history[
                                                      'transactionType'],
                                                  description:
                                                      history['description'],
                                                  transactionGroup: history[
                                                      'transactionGroup'],
                                                  transactionDate:
                                                      history['createdAt'],
                                                  transactionRef: history[
                                                          'transactionReference'] ??
                                                      '',
                                                  merchantRef: history[
                                                      'merchantReference'],
                                                  remarks: history['remarks'],
                                                )
                                              : TransactionReceipt(
                                                  amount: history['amount'],
                                                  status: history['status'],
                                                  fees: history['fees'] ?? 0,
                                                  transactionType: history[
                                                      'transactionType'],
                                                  description:
                                                      history['description'],
                                                  transactionGroup: history[
                                                      'transactionGroup'],
                                                  transactionDate:
                                                      history['createdAt'],
                                                  transactionRef: history[
                                                          'transactionReference'] ??
                                                      '',
                                                  merchantRef: history[
                                                      'merchantReference'],
                                                ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: brandTwo,
                                          ),
                                          child: (history['transactionType'] ==
                                                  'Credit')
                                              ? Icon(
                                                  Icons.arrow_outward_sharp,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                )
                                              : const Icon(
                                                  Icons.call_received,
                                                  color: Color(0xff80FF00),
                                                ),
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${history['message']} ",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: colorBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          formatDateTime(history['createdAt']),
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            color: const Color(0xff4B4B4B),
                                          ),
                                        ),
                                        trailing: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            (history['transactionType'] ==
                                                    'Credit')
                                                ? Text(
                                                    "+ ${nairaFormaet.format(double.parse(history['amount'].toString()))}",
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: const Color(
                                                          0xff56AB00),
                                                    ),
                                                  )
                                                : Text(
                                                    nairaFormaet.format(
                                                        double.parse(
                                                            history['amount']
                                                                .toString())),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: colorBlack,
                                                    ),
                                                  ),
                                            const Text('')
                                          ],
                                        ),
                                      ),
                                      (rentController
                                                  .rentModel!
                                                  .rents![widget.current]
                                                  .rentHistories
                                                  .length >
                                              1)
                                          ? const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 13),
                                              child: Divider(
                                                thickness: 1,
                                                color: Color(0xffC9C9C9),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    // SizedBox(
                    //   height: 400,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 20, bottom: 26),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           'You have saved',
                    //           style: GoogleFonts.lato(
                    //             color: Colors.white.withOpacity(0.75),
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 12,
                    //           ),
                    //         ),
                    //         Text(
                    //           "${nairaFormaet.format(rentController.rentModel!.rents![widget.current].paidAmount).toString()} $testdum",
                    //           style: GoogleFonts.roboto(
                    //             color: Theme.of(context).colorScheme.background,
                    //             fontWeight: FontWeight.w600,
                    //             fontSize: 31,
                    //           ),
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               'of your ',
                    //               style: GoogleFonts.lato(
                    //                 color: Colors.white.withOpacity(0.75),
                    //                 fontWeight: FontWeight.w400,
                    //                 fontSize: 12,
                    //               ),
                    //             ),
                    //             Text(
                    //               nairaFormaet
                    //                   .format(rentController.rentModel!
                    //                       .rents![widget.current].amount)
                    //                   .toString(),
                    //               style: GoogleFonts.roboto(
                    //                 color: Theme.of(context)
                    //                     .colorScheme
                    //                     .background,
                    //                 fontWeight: FontWeight.w600,
                    //                 fontSize: 16,
                    //               ),
                    //             ),
                    //             Text(
                    //               ' Target',
                    //               style: GoogleFonts.lato(
                    //                 color: Colors.white.withOpacity(0.75),
                    //                 fontWeight: FontWeight.w400,
                    //                 fontSize: 12,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //               horizontal: 40, vertical: 18),
                    //           child: LinearPercentIndicator(
                    //             backgroundColor: Colors.white,
                    //             // trailing: Text(
                    //             //   ' ${((rentController.rentModel!.rents![widget.current].paidAmount / rentController.rentModel!.rents![widget.current].amount) * 100).toInt()}%',
                    //             //   style: GoogleFonts.lato(
                    //             //     fontSize: MediaQuery.of(context).size.width / 30,
                    //             //     fontWeight: FontWeight.w600,
                    //             //     color: brandOne,
                    //             //   ),
                    //             // ),
                    //             percent: ((rentController.rentModel!
                    //                         .rents![widget.current].paidAmount /
                    //                     rentController.rentModel!
                    //                         .rents![widget.current].amount))
                    //                 .toDouble(),
                    //             animation: true,
                    //             barRadius: const Radius.circular(10.0),
                    //             lineHeight:
                    //                 MediaQuery.of(context).size.width / 40,
                    //             fillColor: Colors.transparent,
                    //             progressColor: brandTwo,
                    //           ),
                    //         ),
                    //         Text(
                    //           'Your savings schedule is',
                    //           style: GoogleFonts.lato(
                    //             color: Colors.white.withOpacity(0.75),
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 12,
                    //           ),
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               nairaFormaet
                    //                   .format(rentController
                    //                       .rentModel!
                    //                       .rents![widget.current]
                    //                       .intervalAmount)
                    //                   .toString(),
                    //               style: GoogleFonts.roboto(
                    //                 color: Theme.of(context)
                    //                     .colorScheme
                    //                     .background,
                    //                 fontWeight: FontWeight.w600,
                    //                 fontSize: 16,
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding:
                    //                   const EdgeInsets.symmetric(horizontal: 5),
                    //               child: Container(
                    //                 padding: const EdgeInsets.all(2),
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.white,
                    //                   borderRadius: BorderRadius.circular(100),
                    //                 ),
                    //               ),
                    //             ),
                    //             Text(
                    //               rentController.rentModel!
                    //                       .rents![widget.current].interval
                    //                       .substring(0, 1)
                    //                       .toUpperCase() +
                    //                   rentController.rentModel!
                    //                       .rents![widget.current].interval
                    //                       .substring(1),
                    //               // intl.capitalizedFirst(rentController.rentModel!.rents![widget.current].interval),
                    //               style: GoogleFonts.lato(
                    //                 color: Theme.of(context)
                    //                     .colorScheme
                    //                     .background,
                    //                 fontWeight: FontWeight.w600,
                    //                 fontSize: 16,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         const Padding(
                    //           padding: EdgeInsets.only(top: 10, bottom: 48),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [],
                    //           ),
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               'Next payement date: ',
                    //               style: GoogleFonts.lato(
                    //                 color: Colors.white.withOpacity(0.75),
                    //                 fontWeight: FontWeight.w400,
                    //                 fontSize: 12,
                    //               ),
                    //             ),
                    //             Text(
                    //               rentController.rentModel!
                    //                   .rents![widget.current].nextDate,
                    //               style: GoogleFonts.lato(
                    //                 color: Theme.of(context)
                    //                     .colorScheme
                    //                     .background,
                    //                 fontWeight: FontWeight.w600,
                    //                 fontSize: 16,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    // Container(
                    //   height: MediaQuery.of(context).size.height - 400,
                    //   decoration: BoxDecoration(
                    //     color: Theme.of(context).colorScheme.primary,
                    //     borderRadius: const BorderRadius.only(
                    //         topLeft: Radius.circular(26),
                    //         topRight: Radius.circular(26)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(
                    //       left: 10,
                    //       top: 20,
                    //       bottom: 5,
                    //       right: 10,
                    //     ),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         // color: brandThree,
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.only(
                    //                 left: 20, top: 0, bottom: 25, right: 20),
                    //             child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'Savings History',
                    //                   textAlign: TextAlign.left,
                    //                   style: GoogleFonts.lato(
                    //                     fontSize: 14.0,
                    //                     fontWeight: FontWeight.w600,
                    //                     color: Theme.of(context).primaryColor,
                    //                   ),
                    //                 ),
                    //                 GestureDetector(
                    //                   onTap: () {
                    //                     // print(int.parse(rentController.rentModel!.rents![widget.current].id));
                    //                     Get.to(SpaceRentHistory(
                    //                       current: widget.current,
                    //                     ));
                    //                   },
                    //                   child: Text(
                    //                     "See All",
                    //                     style: GoogleFonts.lato(
                    //                       fontSize: 12.0,
                    //                       fontWeight: FontWeight.w600,
                    //                       color: Theme.of(context).primaryColor,
                    //                       // decoration: TextDecoration.underline,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           rentController.rentModel!.rents![widget.current]
                    //                   .rentHistories.isEmpty
                    //               ? Column(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.stretch,
                    //                   children: [
                    //                     Image.asset(
                    //                       'assets/card_empty.png',
                    //                       height: 200,
                    //                     ),
                    //                     Center(
                    //                       child: Text(
                    //                         "Nothing to show",
                    //                         style: GoogleFonts.lato(
                    //                           fontSize: 20,
                    //                           color: Theme.of(context)
                    //                               .primaryColor,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 )
                    //               : Expanded(
                    //                   child: ListView.builder(
                    //                     scrollDirection: Axis.vertical,
                    //                     shrinkWrap: true,
                    //                     physics: const ClampingScrollPhysics(),
                    //                     itemCount: rentController
                    //                         .rentModel!
                    //                         .rents![widget.current]
                    //                         .rentHistories
                    //                         .length,
                    //                     itemBuilder:
                    //                         (BuildContext context, int index) {
                    //                       final history = rentController
                    //                           .rentModel!
                    //                           .rents![widget.current]
                    //                           .rentHistories[index];

                    //                       return Padding(
                    //                         padding: const EdgeInsets.symmetric(
                    //                             vertical: 7),
                    //                         child: ListTile(
                    //                           leading: Container(
                    //                             padding:
                    //                                 const EdgeInsets.all(12),
                    //                             decoration: const BoxDecoration(
                    //                               shape: BoxShape.circle,
                    //                               color: brandOne,
                    //                             ),
                    //                             child: Image.asset(
                    //                               "assets/icons/savings/spacerent.png",
                    //                               height: 20,
                    //                               width: 20,
                    //                               color: Colors.white,
                    //                             ),
                    //                           ),
                    //                           title: Text(
                    //                             history['message'],
                    //                             style: GoogleFonts.lato(
                    //                               color: Theme.of(context)
                    //                                   .primaryColor,
                    //                               fontSize: 13,
                    //                               fontWeight: FontWeight.w600,
                    //                             ),
                    //                           ),
                    //                           subtitle: Text(
                    //                             _formatTime(DateTime.parse(
                    //                                     (history['createdAt']))
                    //                                 .add(const Duration(
                    //                                     hours: 1))),
                    //                             style: GoogleFonts.lato(
                    //                               color: brandOne,
                    //                               fontSize: 12,
                    //                               fontWeight: FontWeight.w400,
                    //                             ),
                    //                           ),
                    //                           // subtitle: Text(
                    //                           //   _formatTime(DateTime.parse(
                    //                           //           history['createdAt'])
                    //                           //       .add(const Duration(
                    //                           //           hours: 1))),
                    //                           //   style: GoogleFonts.lato(
                    //                           //     color: brandOne,
                    //                           //     fontSize: 12,
                    //                           //     fontWeight: FontWeight.w400,
                    //                           //   ),
                    //                           // ),
                    //                           // onTap: () {
                    //                           //   Get.to(
                    //                           //       CustomTransactionDetailsCard(current: index));
                    //                           //   // Navigator.pushNamed(context, RouteList.profile);
                    //                           // },
                    //                           trailing: Text(
                    //                             '+ ${ch8t.format(history['amount'])}',
                    //                             style: GoogleFonts.roboto(
                    //                               color: Colors.green,
                    //                               fontSize: 12,
                    //                               fontWeight: FontWeight.w600,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       );
                    //                     },
                    //                   ),
                    //                 ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    'Total Loanable amount',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 12,
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
                    style: GoogleFonts.roboto(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 31,
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
                              side: const BorderSide(color: brandOne),
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
                            style: GoogleFonts.lato(
                              color: brandOne,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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

      backgroundColor: const Color(0xffF6F6F8),
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

  String formatDateTime(String dateTimeString) {
    // Parse the date string into a DateTime object
    DateTime dateTime =
        DateTime.parse(dateTimeString).add(const Duration(hours: 1));

    // Define the date format you want
    final DateFormat formatter = DateFormat('MMMM dd, yyyy hh:mm a');

    // Format the DateTime object into a string
    String formattedDateTime = formatter.format(dateTime);

    return formattedDateTime;
  }

  int _calculateDaysDifference(String endDateString, String startDateString) {
    // Parse the provided date strings into DateTime objects
    DateFormat format = DateFormat('dd/MM/yyyy');
    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    DateTime startDate = format.parse(startDateString);
    DateTime endDate = format.parse(endDateString);

    // Calculate the difference in days
    Duration difference = endDate.difference(startDate);

    // Convert the difference to days
    int differenceInDays = difference.inDays.abs();

    return differenceInDays;
  }

  String extractAmount(String input) {
    final nairaIndex = input.indexOf('₦');
    if (nairaIndex != -1 && nairaIndex < input.length - 1) {
      return input.substring(nairaIndex + 1).trim();
    }
    return '';
  }
}
