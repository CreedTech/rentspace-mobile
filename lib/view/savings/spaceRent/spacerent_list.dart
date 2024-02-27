import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
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

double rentBalance = 0;
double totalSavings = 0;
double targetBalance = 0;
bool hideBalance = false;
bool _isLoading = false.obs();

class _RentSpaceListState extends State<RentSpaceList> {
  final RentController rentController = Get.find();

  getSavings() {
    print("rentController.rent");

    if (rentController.rentModel!.rents!.isNotEmpty) {
      for (int j = 0; j < rentController.rentModel!.rents!.length; j++) {
        rentBalance += rentController.rentModel!.rents![j].paidAmount;
        targetBalance += rentController.rentModel!.rents![j].amount;
      }
    } else {
      setState(() {
        rentBalance = 0;
        targetBalance = 0;
      });
    }

    setState(() {
      totalSavings = rentBalance;
    });
    print(totalSavings);
  }

  @override
  initState() {
    super.initState();
    rentBalance = 0;
    targetBalance = 0;
    totalSavings = 0;
    fetchRentData();
    getSavings();
  }

  Future<void> fetchRentData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Your code to fetch rent data
      // Assuming you have a RentController instance called rentController
      await rentController.fetchRent();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching rent: $e');
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_sharp,
              size: 30, color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
        title: Text(
          'Your Space Rents',
          style: GoogleFonts.nunito(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(
        () => (_isLoading.obs() == true)
            ? const Center(
                child: CustomLoader(),
              )
            : SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   height: 20.h,
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Total Rent Balance',
                                style: GoogleFonts.nunito(
                                  color: brandOne,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
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
                                  hideBalance ? Iconsax.eye : Iconsax.eye_slash,
                                  color: brandOne,
                                  size: 20.h,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Text(
                            " ${hideBalance ? ch8t.format(totalSavings) : "****"}",
                            style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w900,
                                fontSize: 24.sp,
                                color: brandOne),
                          ),
                          SizedBox(
                            height: 10.sp,
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount:
                            rentController.rentModel!.rents!.length.obs(),
                        itemBuilder: (context, int index) {
                          return (rentController.rentModel!.rents!.isNotEmpty)
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  padding: EdgeInsets.all(15.w),
                                  decoration: BoxDecoration(
                                    color: brandTwo.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatDateTime(rentController
                                            .rentModel!.rents![index].date),
                                        style: GoogleFonts.nunito(
                                          color: brandOne,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Row(
                                        children: [
                                          // Flexible(
                                          //   flex: 2,
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.only(
                                          //         left: 10, right: 30),
                                          //     child: Container(
                                          //       padding:
                                          //           const EdgeInsets.all(10),
                                          //       decoration: BoxDecoration(
                                          //         shape: BoxShape.circle,
                                          //         color:
                                          //             brandTwo.withOpacity(0.2),
                                          //       ),
                                          //       child: Image.asset(
                                          //         'assets/icons/space_rent.png',
                                          //         scale: 4,
                                          //         color: brandTwo,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          Flexible(
                                              // flex: 6,
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    rentController.rentModel!
                                                        .rents![index].rentName,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: brandOne),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  (rentController
                                                              .rentModel!
                                                              .rents![index]
                                                              .hasPaid ==
                                                          true)
                                                      ? const Icon(
                                                          Iconsax.verify5,
                                                          color: Colors.green,
                                                          size: 20,
                                                        )
                                                      : const Icon(
                                                          Iconsax.info_circle5,
                                                          color: Colors.red,
                                                          size: 20,
                                                        ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4,
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            AutoSizeText(
                                                              'Target Amount: ',
                                                              maxLines: 2,
                                                              minFontSize: 2.0,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            // Text(
                                                            //   'Target Amount: ',
                                                            //   style:
                                                            //       GoogleFonts
                                                            //           .nunito(
                                                            //     color:
                                                            //         brandOne,
                                                            //     fontSize:
                                                            //         13.sp,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .w600,
                                                            //   ),
                                                            // ),

                                                            AutoSizeText(
                                                              hideBalance
                                                                  ? ch8t.format(rentController
                                                                      .rentModel!
                                                                      .rents![
                                                                          index]
                                                                      .amount)
                                                                  : "****",
                                                              maxLines: 2,
                                                              minFontSize: 2.0,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            // Text(
                                                            //   hideBalance
                                                            //       ? ch8t.format(rentController
                                                            //           .rentModel!
                                                            //           .rents![
                                                            //               index]
                                                            //           .amount)
                                                            //       : "****",
                                                            //   style:
                                                            //       GoogleFonts
                                                            //           .nunito(
                                                            //     color:
                                                            //         brandOne,
                                                            //     fontSize:
                                                            //         15.sp,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .w700,
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4,
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            AutoSizeText(
                                                              'Target Amount: ',
                                                              maxLines: 2,
                                                              minFontSize: 2.0,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            // Text(
                                                            //   'Target Amount: ',
                                                            //   style:
                                                            //       GoogleFonts
                                                            //           .nunito(
                                                            //     color:
                                                            //         brandOne,
                                                            //     fontSize:
                                                            //         13.sp,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .w600,
                                                            //   ),
                                                            // ),

                                                            AutoSizeText(
                                                              hideBalance
                                                                  ? ch8t.format(rentController
                                                                      .rentModel!
                                                                      .rents![
                                                                          index]
                                                                      .amount)
                                                                  : "****",
                                                              maxLines: 2,
                                                              minFontSize: 2.0,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            // Text(
                                                            //   hideBalance
                                                            //       ? ch8t.format(rentController
                                                            //           .rentModel!
                                                            //           .rents![
                                                            //               index]
                                                            //           .amount)
                                                            //       : "****",
                                                            //   style:
                                                            //       GoogleFonts
                                                            //           .nunito(
                                                            //     color:
                                                            //         brandOne,
                                                            //     fontSize:
                                                            //         15.sp,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .w700,
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4,
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            AutoSizeText(
                                                              'Target Amount: ',
                                                              maxLines: 2,
                                                              minFontSize: 2.0,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            // Text(
                                                            //   'Target Amount: ',
                                                            //   style:
                                                            //       GoogleFonts
                                                            //           .nunito(
                                                            //     color:
                                                            //         brandOne,
                                                            //     fontSize:
                                                            //         13.sp,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .w600,
                                                            //   ),
                                                            // ),

                                                            AutoSizeText(
                                                              hideBalance
                                                                  ? ch8t.format(rentController
                                                                      .rentModel!
                                                                      .rents![
                                                                          index]
                                                                      .amount)
                                                                  : "****",
                                                              maxLines: 2,
                                                              minFontSize: 2.0,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            // Text(
                                                            //   hideBalance
                                                            //       ? ch8t.format(rentController
                                                            //           .rentModel!
                                                            //           .rents![
                                                            //               index]
                                                            //           .amount)
                                                            //       : "****",
                                                            //   style:
                                                            //       GoogleFonts
                                                            //           .nunito(
                                                            //     color:
                                                            //         brandOne,
                                                            //     fontSize:
                                                            //         15.sp,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .w700,
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              LinearPercentIndicator(
                                                animateFromLastPercent: true,
                                                backgroundColor: Colors.white,
                                                trailing: Text(
                                                  ' ${((rentController.rentModel!.rents![index].paidAmount / rentController.rentModel!.rents![index].amount) * 100).toInt()}%',
                                                  style: GoogleFonts.nunito(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            30,
                                                    fontWeight: FontWeight.w700,
                                                    color: brandOne,
                                                  ),
                                                ),
                                                percent: ((rentController
                                                            .rentModel!
                                                            .rents![index]
                                                            .paidAmount /
                                                        rentController
                                                            .rentModel!
                                                            .rents![index]
                                                            .amount))
                                                    .toDouble(),
                                                animation: true,
                                                barRadius:
                                                    const Radius.circular(10.0),
                                                lineHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        40,
                                                fillColor: Colors.transparent,
                                                progressColor: brandTwo,
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  String formatDateTime(String dateTimeString) {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Define the date format you want
    final DateFormat formatter = DateFormat('MMMM dd, yyyy hh:mm a');

    // Format the DateTime object into a string
    String formattedDateTime = formatter.format(dateTime);

    return formattedDateTime;
  }
}
