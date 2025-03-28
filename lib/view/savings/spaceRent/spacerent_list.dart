import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:rentspace/widgets/custom_loader.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_creation.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_page.dart';

import '../../../constants/utils/calulate_difference_in_days.dart';
import '../../../constants/utils/format_money.dart';
import '../../../controller/rent/rent_controller.dart';

class RentSpaceList extends StatefulWidget {
  const RentSpaceList({
    super.key,
  });
  @override
  _RentSpaceListState createState() => _RentSpaceListState();
}

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

  // State variable to track selected status
  String selectedStatus = 'Active';

  void _handleStatusChange(String status) {
    setState(() {
      selectedStatus = status;
    });
  }

  bool _hasActiveRents() {
    return rentController.rentModel!.rents!
        .any((rent) => rent.completed == false);
  }

  bool _hasCompletedRents() {
    return rentController.rentModel!.rents!
        .any((rent) => rent.completed == true);
  }

  Future<void> fetchRentData({bool refresh = true}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Your code to fetch rent data
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            context.pop();
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
              Text(
                'Space Rent',
                style: GoogleFonts.lato(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ],
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
                color: brandTwo,
                backgroundColor: Colors.white,
                showChildOpacityTransition: false,
                onRefresh: onRefresh,
                child: SafeArea(
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24.w, top: 0, right: 24.w, bottom: 20.h),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              IntrinsicHeight(
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
                                          scale: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              300, // Adjust the reference width as needed
                                          child: Image.asset(
                                            'assets/logo_blue.png',
                                            width:
                                                103.91, // Width without scaling
                                            height:
                                                144.17, // Height without scaling
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.5,
                                                    child: Text(
                                                      nairaFormaet
                                                          .format(rentBalance),
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 30,
                                                        color: colorWhite,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize: Size(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              200,
                                                          50),
                                                      backgroundColor:
                                                          colorWhite,
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SpaceRentCreation(),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'Create New Space Rent',
                                                      textAlign:
                                                          TextAlign.center,
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
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          _handleStatusChange('Active'),
                                      child: Text(
                                        'Active',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: selectedStatus != 'Completed'
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? const Color(0xffD6D6D6)
                                                  : const Color(0xff4B4B4B),
                                          fontWeight:
                                              selectedStatus != 'Completed'
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          _handleStatusChange('Completed'),
                                      child: Text(
                                        'Completed',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: selectedStatus == 'Completed'
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? const Color(0xffD6D6D6)
                                                  : const Color(0xff4B4B4B),
                                          fontWeight:
                                              selectedStatus == 'Completed'
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Conditionally render content based on selected status
                      if (selectedStatus == 'Active')
                        _buildActiveContent()
                      else if (selectedStatus == 'Completed')
                        _buildCompletedContent(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // Method to build active content
  Widget _buildActiveContent() {
    return _hasActiveRents()
        ? Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: rentController.rentModel!.rents!.length.obs(),
              itemBuilder: (context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpaceRentPage(
                          current: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 27, vertical: 12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color.fromRGBO(240, 255, 238, 100)
                                      : const Color.fromRGBO(240, 255, 238, 10),
                                ),
                                // child: const Icon(
                                //   Iconsax.security,
                                //   color: brandOne,
                                // ),
                                child: Image.asset(
                                  'assets/icons/house.png',
                                  width: 45,
                                  height: 45,
                                  // scale: 4,
                                  // color: brandOne,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Flexible(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                          // flex: 6,
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            rentController
                                                .rentModel!
                                                .rents![index]
                                                .rentName
                                                .capitalize!,
                                            maxLines: 1,
                                            // minFontSize: 2.0,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      AutoSizeText(
                                                        formatMoney(
                                                            rentController
                                                                .rentModel!
                                                                .rents![index]
                                                                .amount
                                                                .toDouble()),
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                      AutoSizeText(
                                                        'Rent',
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
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
                                                        formatMoney(
                                                            rentController
                                                                .rentModel!
                                                                .rents![index]
                                                                .paidAmount
                                                                .toDouble()),
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                      AutoSizeText(
                                                        'Saved',
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
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
                                                        calculateDaysDifference(
                                                                rentController
                                                                    .rentModel!
                                                                    .rents![
                                                                        index]
                                                                    .dueDate,
                                                                rentController
                                                                    .rentModel!
                                                                    .rents![
                                                                        index]
                                                                    .date)
                                                            .toString(),
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                      AutoSizeText(
                                                        'Days Left',
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
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
                          backgroundColor: const Color(0xffDDFFD4),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xff278210),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              ' ${((rentController.rentModel!.rents![index].paidAmount / rentController.rentModel!.rents![index].amount) * 100).toInt()}%',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          percent: ((rentController
                                      .rentModel!.rents![index].paidAmount /
                                  rentController
                                      .rentModel!.rents![index].amount))
                              .toDouble(),
                          animation: true,
                          barRadius: const Radius.circular(2.0),
                          lineHeight: MediaQuery.of(context).size.width / 40,
                          fillColor: Colors.transparent,
                          progressColor: const Color(0xff278210),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Created: ',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              rentController.rentModel!.rents![index].date,
                              style: GoogleFonts.lato(
                                color: Theme.of(context).primaryColorLight,
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
          )
        : Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 150),
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
                    width: 170,
                    child: Center(
                      child: Text(
                        "Your ongoing Space Rents will be displayed here",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  // Method to build completed content
  Widget _buildCompletedContent() {
    return _hasCompletedRents()
        ? Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: rentController.rentModel!.rents!.length.obs(),
              itemBuilder: (context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpaceRentPage(
                          current: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 27, vertical: 12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xffEAEAEA).withAlpha(6)
                                      : const Color(0xffEAEAEA),
                                ),
                                // child: const Icon(
                                //   Iconsax.security,
                                //   color: brandOne,
                                // ),
                                child: Image.asset(
                                  'assets/icons/house.png',
                                  width: 45,
                                  height: 45,
                                  // scale: 4,
                                  // color: brandOne,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Flexible(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                          // flex: 6,
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            rentController
                                                .rentModel!
                                                .rents![index]
                                                .rentName
                                                .capitalize!,
                                            maxLines: 1,
                                            // minFontSize: 2.0,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      AutoSizeText(
                                                        formatMoney(
                                                            rentController
                                                                .rentModel!
                                                                .rents![index]
                                                                .amount
                                                                .toDouble()),
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                      AutoSizeText(
                                                        'Rent',
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
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
                                                        '',
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                      AutoSizeText(
                                                        '',
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
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
                                                        '',
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                      AutoSizeText(
                                                        '',
                                                        maxLines: 2,
                                                        minFontSize: 2.0,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
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
                          backgroundColor: const Color(0xff556750),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xff556750),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              ' ${((rentController.rentModel!.rents![index].paidAmount / rentController.rentModel!.rents![index].amount) * 100).toInt()}%',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          percent: ((rentController
                                      .rentModel!.rents![index].paidAmount /
                                  rentController
                                      .rentModel!.rents![index].amount))
                              .toDouble(),
                          animation: true,
                          barRadius: const Radius.circular(2.0),
                          lineHeight: MediaQuery.of(context).size.width / 40,
                          fillColor: Colors.transparent,
                          progressColor: const Color(0xff278210),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Created: ',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              rentController.rentModel!.rents![index].date,
                              style: GoogleFonts.lato(
                                color: Theme.of(context).primaryColorLight,
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
          )
        : Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 150),
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
                    width: 170,
                    child: Center(
                      child: Text(
                        "Your Completed Space Rents will be displayed here",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
