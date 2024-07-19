import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';

import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
double _totalInterest = 0;
String _loanAmount = "0";
dynamic _totalSavings = 0;
var changeOne = 6.obs();

class _PortfolioPageState extends State<PortfolioPage> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isRefresh = false;
  final UserController userController = Get.find();
  final RentController rentController = Get.find();
  getUser() async {
    setState(() {
      _loanAmount =
          userController.userModel!.userDetails![0].loanAmount.toString();
      _totalSavings = userController.userModel!.userDetails![0].totalSavings;
    });
  }

  late ValueNotifier<double> valueNotifier;
  @override
  initState() {
    super.initState();
    userController.userModel!.userDetails!.isEmpty
        ? valueNotifier = ValueNotifier(0.0)
        : valueNotifier = ValueNotifier(double.tryParse(userController
            .userModel!.userDetails![0].financeHealth
            .toString())!);
    getUser();
  }

  Future<void> onRefresh() async {
    refreshController.refreshCompleted();
    // if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
    if (mounted) {
      setState(() {
        isRefresh = true;
      });
    }
    userController.fetchData();
    rentController.fetchRent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                'Portfolio',
                style: GoogleFonts.lato(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              context.push('/contactUs');
            },
            child: Padding(
              padding: EdgeInsets.only(right: 23.w),
              child: Image.asset(
                'assets/icons/message_icon.png',
                height: 30.h,
              ),
            ),
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        height: 100,
        animSpeedFactor: 2,
        color: brandOne,
        backgroundColor: Colors.white,
        showChildOpacityTransition: false,
        onRefresh: onRefresh,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 24),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // height: 300,
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          alignment: Alignment(2, 0),
                          scale: 0.5,
                          image:
                              AssetImage('assets/logo_colored_transparent.png'),
                        ),
                        borderRadius: BorderRadius.circular(15),
                        // color: brandOne,
                        color: brandOne),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total loan amount ${double.parse(_loanAmount) == 0 ? 'displayed here' : _loanAmount}",
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: (double.parse(_loanAmount) > 0)
                                  ? () {
                                      context.push('/loanPage');
                                    }
                                  : null,
                              child: const Icon(
                                Iconsax.clock,
                                color: colorWhite,
                                size: 24,
                                weight: 100,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Remained to pay",
                          style: GoogleFonts.lato(
                            fontSize: 12.0,
                            // letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          nairaFormaet.format(double.parse(_loanAmount)),
                          style: GoogleFonts.roboto(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            // letterSpacing: 0.5,
                            color: colorWhite,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(36.5, 20, 36.5, 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.11),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Next Payment Date",
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: colorWhite,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_rounded,
                                            color: colorWhite,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "-- / -- / --",
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: colorWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1,
                                    height: 51,
                                    decoration:
                                        const BoxDecoration(color: colorWhite),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Upcoming Payment',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: colorWhite,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        nairaFormaet.format(_totalInterest),
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: colorWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width - 50,
                                      50),
                                  backgroundColor: const Color(0xffD0D0D0),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (double.parse(_loanAmount) > 0) {
                                    context.push('/loanDetails');
                                  }
                                },
                                child: Text(
                                  'Payment Info',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    color: const Color(0xff515151),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Actions",
                    style: GoogleFonts.lato(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 1),
                          child: ListTile(
                            minLeadingWidth: 0,
                            // shape: ShapeBorder,
                            leading: Image.asset(
                              'assets/icons/money_box.png',
                              width: 42.5,
                              height: 42.5,
                            ),
                            title: Text(
                              'Ask for Loan',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "See available loans",
                              style: GoogleFonts.lato(
                                fontSize: 12.0,
                                // letterSpacing: 0.5,

                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                            onTap: () {
                              (rentController.rentModel!.rents!.isEmpty)
                                  ? showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          title: null,
                                          scrollable: true,
                                          elevation: 0,
                                          content: SizedBox(
                                            // height: 220.h,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              children: [
                                                Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .info_outline_rounded,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: 24,
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      'Oops!',
                                                      style: GoogleFonts.lato(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                Text(
                                                  'You are yet to create a Space Rent plan.\nPlease create a Space Rent plan to have access to our loan service.',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.lato(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 29,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize: Size(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                          50),
                                                      backgroundColor: brandTwo,
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
                                                      context.push(
                                                          '/rentCreation');
                                                    },
                                                    child: Text(
                                                      'Create Space Rent',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.lato(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize: Size(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                          50),
                                                      backgroundColor:
                                                          colorWhite,
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            color: brandTwo),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'Ok',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.lato(
                                                        color: brandTwo,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : ((rentController.rentModel!.rents![0]
                                              .paidAmount) <=
                                          (rentController
                                                  .rentModel!.rents![0].amount *
                                              0.7))
                                      ? showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              title: null,
                                              scrollable: true,
                                              elevation: 0,
                                              content: SizedBox(
                                                // height: 220.h,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Column(
                                                  children: [
                                                    Wrap(
                                                      alignment:
                                                          WrapAlignment.center,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .info_outline_rounded,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          size: 24,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          'Oops!',
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 14,
                                                    ),
                                                    Text(
                                                      'You currently do not qualify for a rent loan.\nPlease continue to save consistently up to 70% of your Space Rent to qualify.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.lato(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 29,
                                                    ),
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          minimumSize: Size(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  50,
                                                              50),
                                                          backgroundColor:
                                                              brandTwo,
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
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'Ok',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                      : (userController
                                                  .userModel!
                                                  .userDetails![0]
                                                  .hasVerifiedKyc ==
                                              false)
                                          ? null
                                          : context.push('/loanPage');
                            },
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).dividerColor,
                          indent: 17,
                          endIndent: 17,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: brandThree,
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set border radius
                            ),
                            child: ListTile(
                              // shape: ShapeBorder,
                              leading: Image.asset(
                                'assets/icons/wallet_box.png',
                                width: 42.5,
                                height: 42.5,
                              ),
                              title: Text(
                                'Make Loan Payment',
                                style: GoogleFonts.lato(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Pay an outstanding loan",
                                style: GoogleFonts.lato(
                                  fontSize: 12.0,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                              onTap: () {
                                (double.parse(_loanAmount) == 0)
                                    ? showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            title: null,
                                            scrollable: true,
                                            elevation: 0,
                                            content: SizedBox(
                                              // height: 220.h,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                children: [
                                                  Wrap(
                                                    alignment:
                                                        WrapAlignment.center,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .info_outline_rounded,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        size: 24,
                                                      ),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        'Oops!',
                                                        style: GoogleFonts.lato(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                  Text(
                                                    'No loan payment to be made.\nYou currently do not have any outstanding loan payments.',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 29,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        minimumSize: Size(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                50,
                                                            50),
                                                        backgroundColor:
                                                            brandTwo,
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'Ok',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                    : const SizedBox();
                              },
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).dividerColor,
                          indent: 17,
                          endIndent: 17,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: brandThree,
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set border radius
                            ),
                            child: ListTile(
                              // shape: ShapeBorder,
                              leading: Image.asset(
                                'assets/icons/portfolio_box.png',
                                width: 42.5,
                                height: 42.5,
                              ),
                              title: Text(
                                'Portfolio Overview',
                                style: GoogleFonts.lato(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Manage your account portfolio",
                                style: GoogleFonts.lato(
                                  fontSize: 12.0,
                                  // letterSpacing: 0.5,

                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                              onTap: () {
                                context.push('/portfolioOverview');
                              },
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).dividerColor,
                          indent: 17,
                          endIndent: 17,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1, bottom: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: brandThree,
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set border radius
                            ),
                            child: ListTile(
                              // shape: ShapeBorder,
                              leading: Image.asset(
                                'assets/icons/credit_box.png',
                                width: 42.5,
                                height: 42.5,
                              ),
                              title: Text(
                                'Credit Score',
                                style: GoogleFonts.lato(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Build your credit score",
                                style: GoogleFonts.lato(
                                  fontSize: 12.0,
                                  // letterSpacing: 0.5,

                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                              onTap: () {
                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.success(
                                    backgroundColor: brandOne,
                                    message: 'Coming soon !!',
                                    textStyle: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffEEF8FF),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "Coming Soon",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: brandOne,
                                      ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
