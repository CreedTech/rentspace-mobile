import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_interest_histories.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_withdrawal.dart';

import '../../../constants/colors.dart';
import '../../../constants/utils/calulate_difference_in_days.dart';
import '../../../constants/utils/formatDateTime.dart';
import '../../../controller/rent/rent_controller.dart';
import '../../../widgets/custom_dialogs/index.dart';
import '../../credit_score/credit_score_page.dart';
import '../../dashboard/dashboard.dart';
import '../../loan/loan_details.dart';
import '../../receipts/transaction_receipt.dart';

import '../../withdrawal/withdraw_page.dart';
import 'spacerent_history.dart';
import 'spacerent_withdrawal_continuation_page.dart';

class SpaceRentPage extends StatefulWidget {
  const SpaceRentPage({super.key, required this.current});
  final int current;

  @override
  State<SpaceRentPage> createState() => _SpaceRentPageState();
}

var ch8t = NumberFormat.simpleCurrency(name: 'NGN');
var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0);
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: 4.h,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  rentController.rentModel!.rents![widget.current].rentName
                      .capitalizeFirst!,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0, bottom: 10.h),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: (rentController.rentModel!
                                        .rents![widget.current].completed ==
                                    false)
                                ? const Color(0xff278210)
                                : const Color(0xff556750),
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              flex: 4,
                                              child: Text(
                                                '${rentController.rentModel!.rents![widget.current].rentName.capitalizeFirst!} Balance',
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  color: colorWhite,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            if ((rentController
                                                    .rentModel!
                                                    .rents![widget.current]
                                                    .completed ==
                                                true))
                                              Flexible(
                                                flex: 4,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 15.w),
                                                  child: Text(
                                                    'Paid to Landlord',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      color: colorWhite,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        Text(
                                          nairaFormaet
                                              .format(rentController
                                                  .rentModel!
                                                  .rents![widget.current]
                                                  .paidAmount)
                                              .obs(),
                                          style: GoogleFonts.roboto(
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
                                            backgroundColor: (rentController
                                                        .rentModel!
                                                        .rents![widget.current]
                                                        .completed ==
                                                    false)
                                                ? const Color(0xff134107)
                                                : colorWhite,
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
                                              SizedBox(
                                                width: 100.w,
                                                child: Text(
                                                  nairaFormaet.format(
                                                      rentController
                                                          .rentModel!
                                                          .rents![
                                                              widget.current]
                                                          .amount),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
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
                                                ((rentController
                                                            .rentModel!
                                                            .rents![
                                                                widget.current]
                                                            .completed ==
                                                        false))
                                                    ? '${calculateDaysDifference(rentController.rentModel!.rents![widget.current].dueDate, rentController.rentModel!.rents![widget.current].date).toString()} Days'
                                                    : 'Completed',
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
                        GestureDetector(
                          onTap: () {
                            Get.to(SpaceRentInterestHistoryPage(
                                current: widget.current));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/percent_box.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'Total Interest accrued: ',
                                      style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      ch8t.format(rentController
                                          .rentModel!
                                          .rents![widget.current]
                                          .spaceRentInterest),
                                      style: GoogleFonts.roboto(
                                          color: const Color(0xff278210),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 20,
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
                if (rentController
                        .rentModel!.rents![widget.current].completed ==
                    false)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 92.h,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              height: 9.h,
                            ),
                            Text(
                              '${ch8t.format(rentController.rentModel!.rents![widget.current].intervalAmount)}/${rentController.rentModel!.rents![widget.current].interval.toLowerCase()}',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.primary,
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
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            RichText(
                              text: TextSpan(
                                  style: GoogleFonts.lato(
                                    // fontWeight: FontWeight.w700,
                                    color:
                                        Theme.of(context).colorScheme.primary,
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

                if ((((rentController.rentModel!.rents![widget.current]
                                    .paidAmount /
                                rentController
                                    .rentModel!.rents![widget.current].amount) *
                            100)
                        .toInt() <=
                    70))
                  SizedBox(
                    height: 20.h,
                  ),
                (((rentController.rentModel!.rents![widget.current].paidAmount /
                                    rentController.rentModel!
                                        .rents![widget.current].amount) *
                                100)
                            .toInt()<=
                        70)
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        // height: 92.h,
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Loan',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Text(
                                    'You are now eligible to ask for up to 30% loan for this Space Rent Plan',
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Flexible(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width - 50,
                                        40),
                                    backgroundColor: brandTwo,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    forfeitInterestModal(
                                        context, widget.current);
                                  },
                                  child: Text(
                                    'Apply',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 20.h,
                ),

                // ============= OUTSTANDING LOAN BEGINS ==============

                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   // height: 92.h,
                //   padding: const EdgeInsets.all(17),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).canvasColor,
                //     borderRadius: BorderRadius.circular(10.r),
                //   ),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Flexible(
                //         flex: 5,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               'Outstanding Loan',
                //               style: GoogleFonts.lato(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w600,
                //                 color: Theme.of(context).colorScheme.primary,
                //               ),
                //             ),
                //             SizedBox(
                //               height: 3.h,
                //             ),
                //             Text(
                //               'You have an outstanding loan on beta rent. Click to view ',
                //               style: GoogleFonts.lato(
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.w400,
                //                 color: Theme.of(context).colorScheme.primary,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       const Spacer(),
                //       Flexible(
                //         flex: 2,
                //         child: Align(
                //           alignment: Alignment.bottomCenter,
                //           child: ElevatedButton(
                //             style: ElevatedButton.styleFrom(
                //               minimumSize: Size(
                //                   MediaQuery.of(context).size.width - 50, 40),
                //               backgroundColor: brandTwo,
                //               elevation: 0,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(
                //                   10,
                //                 ),
                //               ),
                //             ),
                //             onPressed: () {
                //               Get.to(const LoanDetails());
                //               // forfeitInterestModal(context, widget.current);
                //             },
                //             child: Text(
                //               'View',
                //               textAlign: TextAlign.center,
                //               style: GoogleFonts.lato(
                //                 color: Colors.white,
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.w500,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 20.h,
                // ),

                // ============= OUTSTANDING LOAN ENDS ==============

                // ============= WITHDRAW NOTIFICATION BEGINS ==============
                if (rentController
                        .rentModel!.rents![widget.current].completed ==
                    true)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 92.h,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Withdraw Space Rent',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Text(
                                'Yay! You have completed your Alpha Rent savings.',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Flexible(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width - 50, 40),
                                backgroundColor: brandTwo,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                (userController.userModel!.userDetails![0]
                                            .withdrawalAccount ==
                                        null)
                                    ? Get.to(const WithdrawalPage(
                                        withdrawalType: 'space rent',
                                      ))
                                    : Get.to(
                                        SpaceRentWithdrawalContinuationPage(
                                          bankCode: userController
                                              .userModel!
                                              .userDetails![0]
                                              .withdrawalAccount!
                                              .bankCode,
                                          accountNumber: userController
                                              .userModel!
                                              .userDetails![0]
                                              .withdrawalAccount!
                                              .accountNumber,
                                          bankName: userController
                                              .userModel!
                                              .userDetails![0]
                                              .withdrawalAccount!
                                              .bankName,
                                          accountHolderName: userController
                                              .userModel!
                                              .userDetails![0]
                                              .withdrawalAccount!
                                              .accountHolderName,
                                          amount: rentController
                                              .rentModel!
                                              .rents![widget.current]
                                              .paidAmount,
                                          narration: rentController.rentModel!
                                              .rents![widget.current].rentName,
                                        ),
                                      );

                                // forfeitInterestModal(context, widget.current);
                              },
                              child: Text(
                                'Withdraw',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 20.h,
                ),

                // ============= WITHDRAW NOTIFICATION ENDS ==============

                // ======== CREDIT SCORE BEGINS ==========

                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   // height: 92.h,
                //   padding: const EdgeInsets.all(17),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).canvasColor,
                //     borderRadius: BorderRadius.circular(10.r),
                //   ),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Flexible(
                //         flex: 4,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               'Credit Score',
                //               style: GoogleFonts.lato(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w600,
                //                 color: Theme.of(context).colorScheme.primary,
                //               ),
                //             ),
                //             SizedBox(
                //               height: 3.h,
                //             ),
                //             Text(
                //               'Your credit score result is ready. Click view to see your score. ',
                //               style: GoogleFonts.lato(
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.w400,
                //                 color: Theme.of(context).colorScheme.primary,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       const Spacer(),
                //       Flexible(
                //         flex: 2,
                //         child: Align(
                //           alignment: Alignment.bottomCenter,
                //           child: ElevatedButton(
                //             style: ElevatedButton.styleFrom(
                //               minimumSize: Size(
                //                   MediaQuery.of(context).size.width - 50, 40),
                //               backgroundColor: brandTwo,
                //               elevation: 0,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(
                //                   10,
                //                 ),
                //               ),
                //             ),
                //             onPressed: () {
                //               Get.to(const CreditScorePage());
                //             },
                //             child: Text(
                //               'View',
                //               textAlign: TextAlign.center,
                //               style: GoogleFonts.lato(
                //                 color: Colors.white,
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.w500,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 20.h,
                // ),

                // ======== CREDIT SCORE END =========

                // ============ LOAN IN PROGRESS BEGINS =============

                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   // height: 92.h,
                //   padding: const EdgeInsets.all(17),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).canvasColor,
                //     borderRadius: BorderRadius.circular(10.r),
                //   ),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Flexible(
                //         flex: 10,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               'Loan in Progress',
                //               style: GoogleFonts.lato(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w600,
                //                 color: Theme.of(context).colorScheme.primary,
                //               ),
                //             ),
                //             SizedBox(
                //               height: 3.h,
                //             ),
                //             Text(
                //               'Your loan is being processed and will be disbursed shortly. ',
                //               style: GoogleFonts.lato(
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.w400,
                //                 color: Theme.of(context).colorScheme.primary,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       const Spacer(),
                //       const Flexible(
                //         flex: 1,
                //         child: SizedBox(),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 20.h,
                // ),

                // =========== LOAN IN PROGRESS ENDS ===============

                // ======== LOAN REPAYMENT SCHEDULE END =========
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   // height: 92.h,
                //   padding: const EdgeInsets.all(17),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).canvasColor,
                //     borderRadius: BorderRadius.circular(10.r),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'Loan Payment Schedule',
                //             style: GoogleFonts.lato(
                //               fontSize: 14,
                //               fontWeight: FontWeight.w600,
                //               color: Theme.of(context).colorScheme.primary,
                //             ),
                //           ),
                //           SizedBox(
                //             height: 9.h,
                //           ),
                //           Text(
                //             '${ch8t.format(15000)}/${'monthly'.toLowerCase()}',
                //             style: GoogleFonts.roboto(
                //               fontSize: 12,
                //               fontWeight: FontWeight.w400,
                //               color: Theme.of(context).colorScheme.primary,
                //             ),
                //           ),
                //         ],
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             '',
                //             style: GoogleFonts.lato(
                //               fontSize: 12,
                //               fontWeight: FontWeight.w400,
                //               color: Theme.of(context).primaryColorLight,
                //             ),
                //           ),
                //           SizedBox(
                //             height: 8.h,
                //           ),
                //           RichText(
                //             text: TextSpan(
                //                 style: GoogleFonts.lato(
                //                   // fontWeight: FontWeight.w700,
                //                   color: Theme.of(context).colorScheme.primary,
                //                   fontSize: 12,
                //                 ),
                //                 children: <TextSpan>[
                //                   TextSpan(
                //                     text: 'Next Payment: ',
                //                     style: GoogleFonts.lato(
                //                       fontWeight: FontWeight.w400,
                //                     ),
                //                   ),
                //                   TextSpan(
                //                     text: '28/4/2024',
                //                     style: GoogleFonts.lato(
                //                       fontWeight: FontWeight.w700,
                //                     ),
                //                   ),
                //                 ]),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 20.h,
                // ),

                // ======== LOAN REPAYMENT SCHEDULE END =========
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'History',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
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
                (rentController.rentModel!.rents![widget.current].rentHistories
                        .isEmpty)
                    ? SizedBox(
                        height: 240,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              'assets/icons/history_icon.png',
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(0xffffffff)
                                  : null,
                              height: 33.5.h,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: SizedBox(
                                width: 180,
                                child: Text(
                                  "Your transactions will be displayed here",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
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
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: (rentController
                                      .rentModel!
                                      .rents![widget.current]
                                      .rentHistories
                                      .length <
                                  3)
                              ? rentController.rentModel!.rents![widget.current]
                                  .rentHistories.length
                              : 3,
                          itemBuilder: (BuildContext context, int index) {
                            final item = rentController.rentModel!
                                .rents![widget.current].rentHistories[index];
                            final itemLength = item.length;

                            bool showDivider = true;

                            if (index <
                                rentController.rentModel!.rents![widget.current]
                                        .rentHistories.length -
                                    1) {
                              if ((itemLength == 1 && index % 2 == 0) ||
                                  (itemLength == 2 && (index + 1) % 2 == 0) ||
                                  (itemLength >= 3 && (index + 1) % 3 == 0)) {
                                showDivider = false;
                              }
                            } else {
                              showDivider = false;
                            }
                            // Access the activities in reverse order
                            final history = rentController.rentModel!
                                .rents![widget.current].rentHistories[index];
                            return GestureDetector(
                              onTap: () {
                                // print('index');
                                // print(history);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TransactionReceipt(),
                                    settings: RouteSettings(
                                      arguments: history,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 7,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment
                                            //         .spaceBetween,
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: brandTwo,
                                                  ),
                                                  child: (history[
                                                              'transactionType'] ==
                                                          'Credit')
                                                      ? Icon(
                                                          Icons
                                                              .arrow_outward_sharp,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        )
                                                      : const Icon(
                                                          Icons.call_received,
                                                          color:
                                                              Color(0xff80FF00),
                                                        ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Flexible(
                                                flex: 8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${history['message']} "
                                                          .capitalize!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      formatDateTime(
                                                          history['createdAt']),
                                                      style: GoogleFonts.lato(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Theme.of(context)
                                                            .primaryColorLight,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: (history['transactionType'] ==
                                                  'Credit')
                                              ? Text(
                                                  "+ ${nairaFormaet.format(double.parse(history['amount'].toString()))}",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xff56AB00),
                                                  ),
                                                )
                                              : Text(
                                                  nairaFormaet.format(
                                                      double.parse(
                                                          history['amount']
                                                              .toString())),
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (showDivider)
                                    Divider(
                                      thickness: 1,
                                      color: Theme.of(context).dividerColor,
                                      indent: 17,
                                      endIndent: 17,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          )),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
