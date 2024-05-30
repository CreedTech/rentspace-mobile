import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_creation.dart';
// import 'package:rentspace/controller/rent_controller.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_page.dart';

import '../../../controller/rent/rent_controller.dart';

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
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isRefresh = false;
  final RentController rentController = Get.find();

  getSavings() {

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
    // print(totalSavings);
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

  Future<void> fetchRentData({bool refresh = true}) async {
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
      // print('Error fetching rent: $e');
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> onRefresh() async {
    refreshController.refreshCompleted();
    // if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
    if (mounted) {
      setState(() {
        isRefresh = true;
      });
    }
    rentController.fetchRent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),
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
              child: const Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: colorBlack,
              ),
            ),
            SizedBox(
              width: 4.h,
            ),
            Text(
              'Space Rent',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Obx(
        () => (_isLoading.obs() == true)
            ? const Center(
                child: CustomLoader(),
              )
            : LiquidPullToRefresh(
                height: 100,
                animSpeedFactor: 2,
                color: brandTwo,
                backgroundColor: Colors.white,
                showChildOpacityTransition: false,
                onRefresh: onRefresh,
                child: SafeArea(
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24.w, top: 0, right: 24.w, bottom: 20.h),
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
                                  right: -10.w,
                                  child: Transform.scale(
                                    scale: MediaQuery.of(context).size.width /
                                        300, // Adjust the reference width as needed
                                    child: Image.asset(
                                      'assets/logo_blue.png',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total Space Rent',
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: colorWhite,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              child: Text(
                                                nairaFormaet
                                                    .format(rentBalance),
                                                style: GoogleFonts.lato(
                                                  fontSize: 30,
                                                  color: colorWhite,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 14.h),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        200,
                                                    50),
                                                backgroundColor: colorWhite,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                Get.to(
                                                    const SpaceRentCreation());
                                              },
                                              child: Text(
                                                'Create New Space Rent',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    color: brandTwo,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
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
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24.w,
                          right: 24.w,
                        ),
                        child: Text(
                          'Ongoing Space Rent',
                          style: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      (rentController.rentModel!.rents!.isEmpty)
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 15.w, right: 15.w, top: 150),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/spacerent_img.png',
                                      height: 51.4,
                                      width: 73,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    SizedBox(
                                      width: 147,
                                      child: Center(
                                        child: Text(
                                          "Your ongoing Space Rents will be displayed here",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: colorBlack,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                left: 24.w,
                                right: 24.w,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: rentController
                                    .rentModel!.rents!.length
                                    .obs(),
                                itemBuilder: (context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(SpaceRentPage(
                                        current: index,
                                      ));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 14.w, vertical: 11.h),
                                      decoration: BoxDecoration(
                                        color: colorWhite,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                flex: 3,
                                                child: Image.asset(
                                                  'assets/spacerent_img.png',
                                                  // scale: 2,
                                                  width: 98.w,
                                                  height: 69.h,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Flexible(
                                                flex: 8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                            // flex: 6,
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AutoSizeText(
                                                              rentController
                                                                  .rentModel!
                                                                  .rents![index]
                                                                  .rentName
                                                                  .capitalize!,
                                                              maxLines: 2,
                                                              // minFontSize: 2.0,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    colorDark,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        AutoSizeText(
                                                                          formatMoney(rentController
                                                                              .rentModel!
                                                                              .rents![index]
                                                                              .amount
                                                                              .toDouble()),
                                                                          maxLines:
                                                                              2,
                                                                          minFontSize:
                                                                              2.0,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                colorDark,
                                                                          ),
                                                                        ),
                                                                        AutoSizeText(
                                                                          'Rent',
                                                                          maxLines:
                                                                              2,
                                                                          minFontSize:
                                                                              2.0,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                const Color(0xff4B4B4B),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        AutoSizeText(
                                                                          formatMoney(rentController
                                                                              .rentModel!
                                                                              .rents![index]
                                                                              .paidAmount
                                                                              .toDouble()),
                                                                          maxLines:
                                                                              2,
                                                                          minFontSize:
                                                                              2.0,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                colorDark,
                                                                          ),
                                                                        ),
                                                                        AutoSizeText(
                                                                          'Saved',
                                                                          maxLines:
                                                                              2,
                                                                          minFontSize:
                                                                              2.0,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                const Color(0xff4B4B4B),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        AutoSizeText(
                                                                          _calculateDaysDifference(rentController.rentModel!.rents![index].dueDate, rentController.rentModel!.rents![index].date)
                                                                              .toString(),
                                                                          maxLines:
                                                                              2,
                                                                          minFontSize:
                                                                              2.0,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                colorDark,
                                                                          ),
                                                                        ),
                                                                        AutoSizeText(
                                                                          'Days Left',
                                                                          maxLines:
                                                                              2,
                                                                          minFontSize:
                                                                              2.0,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                const Color(0xff4B4B4B),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            // const MySeparator(),
                                                            // SizedBox(
                                                            //   height: 5.h,
                                                            // ),
                                                            // LinearPercentIndicator(
                                                            //   animateFromLastPercent:
                                                            //       true,
                                                            //   backgroundColor:
                                                            //       const Color(
                                                            //           0xffDDFFD4),
                                                            //   trailing:
                                                            //       Container(
                                                            //     padding: const EdgeInsets
                                                            //         .symmetric(
                                                            //         horizontal:
                                                            //             20,
                                                            //         vertical:
                                                            //             5),
                                                            //     decoration:
                                                            //         BoxDecoration(
                                                            //       color: const Color(
                                                            //           0xff278210),
                                                            //       borderRadius:
                                                            //           BorderRadius
                                                            //               .circular(
                                                            //                   6),
                                                            //     ),
                                                            //     child: Text(
                                                            //       ' ${((rentController.rentModel!.rents![index].paidAmount / rentController.rentModel!.rents![index].amount) * 100).toInt()}%',
                                                            //       style: GoogleFonts
                                                            //           .lato(
                                                            //         color: Colors
                                                            //             .white,
                                                            //       ),
                                                            //     ),
                                                            //   ),
                                                            //   percent: ((rentController
                                                            //               .rentModel!
                                                            //               .rents![
                                                            //                   index]
                                                            //               .paidAmount /
                                                            //           rentController
                                                            //               .rentModel!
                                                            //               .rents![
                                                            //                   index]
                                                            //               .amount))
                                                            //       .toDouble(),
                                                            //   animation: true,
                                                            //   barRadius:
                                                            //       const Radius
                                                            //           .circular(
                                                            //           2.0),
                                                            //   lineHeight:
                                                            //       MediaQuery.of(
                                                            //                   context)
                                                            //               .size
                                                            //               .width /
                                                            //           40,
                                                            //   fillColor: Colors
                                                            //       .transparent,
                                                            //   progressColor:
                                                            //       const Color(
                                                            //           0xff278210),
                                                            // ),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          LinearPercentIndicator(
                                            animateFromLastPercent: true,
                                            backgroundColor:
                                                const Color(0xffDDFFD4),
                                            trailing: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff278210),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                ' ${((rentController.rentModel!.rents![index].paidAmount / rentController.rentModel!.rents![index].amount) * 100).toInt()}%',
                                                style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            percent: ((rentController
                                                        .rentModel!
                                                        .rents![index]
                                                        .paidAmount /
                                                    rentController.rentModel!
                                                        .rents![index].amount))
                                                .toDouble(),
                                            animation: true,
                                            barRadius:
                                                const Radius.circular(2.0),
                                            lineHeight: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                40,
                                            fillColor: Colors.transparent,
                                            progressColor:
                                                const Color(0xff278210),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Created: ',
                                                style: GoogleFonts.lato(
                                                  color:
                                                      const Color(0xff4B4B4B),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                rentController.rentModel!
                                                    .rents![index].date,
                                                style: GoogleFonts.lato(
                                                  color:
                                                      const Color(0xff4B4B4B),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
    );
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

  String formatEndDate(String dateTimeString) {
    // Parse the date string into a DateTime object
    DateTime dateTime =
        DateTime.parse(dateTimeString).add(const Duration(hours: 1));

    // Define the date format you want
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');

    // Format the DateTime object into a string
    String formattedDateTime = formatter.format(dateTime);

    return formattedDateTime;
  }

  // int _calculateDaysDifference(String providedDateString) {
  //   DateFormat('dd/MM/yyyy').format(picked)
  //   final differenceDays =
  //       providedDateString.add(const Duration(days: 1)).difference(DateTime.now()).inDays;

  //   return differenceDays.abs();
  // }

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

  String formatMoney(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      // Check if the amount is an exact multiple of 1000
      if (amount % 1000 == 0) {
        return '${amount ~/ 1000}K'; // Remove decimal places
      } else {
        return '${(amount / 1000).toStringAsFixed(2)}K'; // Keep decimal places
      }
    } else {
      return amount.toStringAsFixed(2);
    }
  }

  String calculateDifferenceInDays(String providedDateString) {
    // Extract the date components from the provided date string
    List<String> parts = providedDateString.split(' ');
    int day = int.parse(parts[2]);
    int year = int.parse(parts[3]);
    Map<String, int> months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };
    int month = months[parts[1]]!;

    // Construct a DateTime object
    DateTime providedDate = DateTime.utc(year, month, day);

    // Get today's date
    DateTime today = DateTime.now();

    // Calculate the difference in days
    Duration difference = providedDate.difference(today);

    // Convert the difference to days
    int differenceInDays = difference.inDays.abs();

    return '$differenceInDays';
  }
}
