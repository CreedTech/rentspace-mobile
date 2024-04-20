import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
import 'package:rentspace/constants/widgets/separator.dart';
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
      print('Error fetching rent: $e');
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
          style: GoogleFonts.poppins(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
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
                color: brandOne,
                backgroundColor: Colors.white,
                showChildOpacityTransition: false,
                onRefresh: onRefresh,
                child: SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Total Rent Balance',
                                  style: GoogleFonts.poppins(
                                    color: brandOne,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
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
                                        ? Iconsax.eye
                                        : Iconsax.eye_slash,
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
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.sp,
                                  color: brandOne),
                            ),
                            SizedBox(
                              height: 10.sp,
                            ),
                          ],
                        ),
                        Expanded(
                          child: (rentController.rentModel!.rents!.isEmpty)
                              ? Column(
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
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
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
                                        padding: EdgeInsets.all(30.w),
                                        decoration: BoxDecoration(
                                          color: brandTwo.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                        ),
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
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    AutoSizeText(
                                                      rentController
                                                          .rentModel!
                                                          .rents![index]
                                                          .rentName,
                                                      maxLines: 2,
                                                      minFontSize: 2.0,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts
                                                          .poppins(
                                                              fontSize:
                                                                  15.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  brandOne),
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
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                AutoSizeText(
                                                                  hideBalance
                                                                      ? ch8t.format(rentController
                                                                          .rentModel!
                                                                          .rents![
                                                                              index]
                                                                          .amount)
                                                                      : "****",
                                                                  maxLines: 2,
                                                                  minFontSize:
                                                                      2.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                AutoSizeText(
                                                                  'Target Amount',
                                                                  maxLines: 2,
                                                                  minFontSize:
                                                                      2.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
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
                                                                  hideBalance
                                                                      ? ch8t.format(rentController
                                                                          .rentModel!
                                                                          .rents![
                                                                              index]
                                                                          .paidAmount)
                                                                      : "****",
                                                                  maxLines: 2,
                                                                  minFontSize:
                                                                      2.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                AutoSizeText(
                                                                  'Saved',
                                                                  maxLines: 2,
                                                                  minFontSize:
                                                                      2.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
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
                                                                  _calculateDaysDifference(rentController
                                                                          .rentModel!
                                                                          .rents![
                                                                              index]
                                                                          .dueDate)
                                                                      .toString(),
                                                                  maxLines: 2,
                                                                  minFontSize:
                                                                      2.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                AutoSizeText(
                                                                  'Days Left',
                                                                  maxLines: 2,
                                                                  minFontSize:
                                                                      2.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    const MySeparator(),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    LinearPercentIndicator(
                                                      animateFromLastPercent:
                                                          true,
                                                      backgroundColor:
                                                          Colors.white,
                                                      trailing: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                        ),
                                                        child: Text(
                                                          ' ${((rentController.rentModel!.rents![index].paidAmount / rentController.rentModel!.rents![index].amount) * 100).toInt()}%',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),

                                                      // Text(
                                                      //   ' ${((rentController.rentModel!.rents![index].paidAmount / rentController.rentModel!.rents![index].amount) * 100).toInt()}%',
                                                      //   style: GoogleFonts.poppins(
                                                      //     fontSize:
                                                      //         MediaQuery.of(context)
                                                      //                 .size
                                                      //                 .width /
                                                      //             30,
                                                      //     fontWeight: FontWeight.w600,
                                                      //     color: brandOne,
                                                      //   ),
                                                      // ),

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
                                                          const Radius.circular(
                                                              10.0),
                                                      lineHeight:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              40,
                                                      fillColor:
                                                          Colors.transparent,
                                                      progressColor: brandTwo,
                                                    ),
                                                  ],
                                                )),
                                              ],
                                            ),
                                            // SizedBox(
                                            //   height: 15.h,
                                            // ),
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.end,
                                            //   children: [
                                            //     Text(
                                            //       formatDateTime(rentController
                                            //           .rentModel!.rents![index].date),
                                            //       style: GoogleFonts.poppins(
                                            //         color: brandOne,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(350, 50),
                                backgroundColor: brandOne,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Get.to(SpaceRentCreation());
                              },
                              child: Text(
                                'Create New Space rent',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  int _calculateDaysDifference(String endDateString) {
    // Parse the provided date strings into DateTime objects
    DateFormat format = DateFormat('dd/MM/yyyy');
    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    DateTime startDate = format.parse(today);
    DateTime endDate = format.parse(endDateString);

    // Calculate the difference in days
    Duration difference = endDate.difference(startDate);

    // Convert the difference to days
    int differenceInDays = difference.inDays.abs();

    return differenceInDays;
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
