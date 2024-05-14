import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:rentspace/controller/rent_controller.dart';
// import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/view/kyc/kyc_intro.dart';
import 'package:rentspace/view/loan/loan_page.dart';
import 'package:rentspace/view/portfolio/finance_health.dart';
//import 'package:rentspace/view/savings/spaceRent/spacerent_history.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_creation.dart';
// import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/widgets/separator.dart';
// import '../kyc/kyc_form_page.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'N');
double _totalInterest = 0;
String _loanAmount = "0";
dynamic _totalSavings = 0;
double _totalDebts = 0;
double _totalInvestments = 0;
var changeOne = 6.obs();

class _PortfolioPageState extends State<PortfolioPage> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isRefresh = false;
  final UserController userController = Get.find();
  final RentController rentController = Get.find();
  getUser() async {
    setState(() {
      // _totalInterest =
      //     userController.userModel!.userDetails![0].totalInterests;
      _loanAmount =
          userController.userModel!.userDetails![0].loanAmount.toString();
      _totalSavings = userController.userModel!.userDetails![0].totalSavings;
      // _totalDebts =
      //     userController.userModel!.userDetails![0].totalDebts;
      // _totalInvestments = userController.userModel!.userDetails![0].tot.toString();
    });
  }

  late ValueNotifier<double> valueNotifier;
  @override
  initState() {
    super.initState();
    // userController.fetchData();
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
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffF6F6F8),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            Text(
              'Portfolio',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 23.w),
            child: Image.asset(
              'assets/icons/message_icon.png',
              height: 30.h,
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
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 24),
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
                            const Icon(
                              Iconsax.clock,
                              color: colorWhite,
                              size: 24,
                              weight: 100,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
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
                          style: GoogleFonts.lato(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            // letterSpacing: 0.5,
                            color: colorWhite,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                                      Text(
                                        nairaFormaet.format(_totalInterest),
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
                                onPressed: () async {},
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
                      color: colorBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        (rentController.rentModel!.rents!.isNotEmpty)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: ListTile(
                                  minLeadingWidth: 0,
                                  // shape: ShapeBorder,
                                  leading:
                                      Image.asset('assets/icons/money_box.png'),
                                  title: Text(
                                    'Ask for Loan',
                                    style: GoogleFonts.lato(
                                      color: colorBlack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "See available loans",
                                    style: GoogleFonts.lato(
                                      fontSize: 12.0,
                                      // letterSpacing: 0.5,

                                      color: const Color(0xff4B4B4B),
                                    ),
                                  ),
                                  onTap: () {
                                    ((rentController.rentModel!.rents![0]
                                                .paidAmount) <=
                                            (rentController.rentModel!.rents![0]
                                                    .amount *
                                                0.7))
                                        ? showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
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
                                                        alignment: WrapAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        // mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .info_outline_rounded,
                                                            color: colorBlack,
                                                            size: 24,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            'Oops!',
                                                            style: GoogleFonts
                                                                .lato(
                                                              color: colorBlack,
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 14,
                                                      ),
                                                      Text(
                                                        'You currently do not qualify for a rent loan\n.Please continue to save consistently up to 70% of your Space Rent to qualify.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                          color: colorBlack,
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Ok',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .lato(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })
                                        : (rentController
                                                .rentModel!.rents!.isNotEmpty)
                                            ? showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    title: null,
                                                    scrollable: true,
                                                    elevation: 0,
                                                    content: SizedBox(
                                                      // height: 220.h,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Column(
                                                        children: [
                                                          Wrap(
                                                            alignment:
                                                                WrapAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .center,
                                                            // mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .info_outline_rounded,
                                                                color:
                                                                    colorBlack,
                                                                size: 24,
                                                              ),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                'Oops!',
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  color:
                                                                      colorBlack,
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 14,
                                                          ),
                                                          Text(
                                                            'You are yet to create a Space Rent plan.\nPlease create a Space Rent plan to have access to our loan service.',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .lato(
                                                              color: colorBlack,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 29,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                minimumSize: Size(
                                                                    MediaQuery.of(context)
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
                                                                Get.to(
                                                                    const SpaceRentCreation());
                                                              },
                                                              child: Text(
                                                                'Create Space Rent',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
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
                                                                      color:
                                                                          brandTwo),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10,
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                'Ok',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  color:
                                                                      brandTwo,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
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
                                                ? Get.to(const KYCIntroPage())
                                                : Get.to(const LoanPage());
                                    // Get.to(const ProfilePage());
                                    // Navigator.pushNamed(context, RouteList.profile);
                                  },
                                  trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: colorBlack,
                                    size: 20,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const Divider(
                          thickness: 1,
                          color: Color(0xffC9C9C9),
                          indent: 17,
                          endIndent: 17,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: brandThree,
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set border radius
                            ),
                            child: ListTile(
                              // shape: ShapeBorder,
                              leading:
                                  Image.asset('assets/icons/wallet_box.png'),
                              title: Text(
                                'Make Loan Payment',
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Pay an outstanding loan",
                                style: GoogleFonts.lato(
                                  fontSize: 12.0,
                                  // letterSpacing: 0.5,

                                  color: const Color(0xff4B4B4B),
                                ),
                              ),
                              onTap: () {
                                (double.parse(_loanAmount) == 0)
                                    ? showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
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
                                                      const Icon(
                                                        Icons
                                                            .info_outline_rounded,
                                                        color: colorBlack,
                                                        size: 24,
                                                      ),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        'Oops!',
                                                        style: GoogleFonts.lato(
                                                          color: colorBlack,
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
                                                      color: colorBlack,
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
                              trailing: const Icon(
                                Icons.keyboard_arrow_right,
                                color: colorBlack,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xffC9C9C9),
                          indent: 17,
                          endIndent: 17,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: brandThree,
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set border radius
                            ),
                            child: ListTile(
                              // shape: ShapeBorder,
                              leading:
                                  Image.asset('assets/icons/portfolio_box.png'),
                              title: Text(
                                'Make Loan Payment',
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Pay an outstanding loan",
                                style: GoogleFonts.lato(
                                  fontSize: 12.0,
                                  // letterSpacing: 0.5,

                                  color: const Color(0xff4B4B4B),
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
                              trailing: const Icon(
                                Icons.keyboard_arrow_right,
                                color: colorBlack,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xffC9C9C9),
                          indent: 17,
                          endIndent: 17,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: brandThree,
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set border radius
                            ),
                            child: ListTile(
                              // shape: ShapeBorder,
                              leading:
                                  Image.asset('assets/icons/credit_check.png'),
                              title: Text(
                                'Make Loan Payment',
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Pay an outstanding loan",
                                style: GoogleFonts.lato(
                                  fontSize: 12.0,
                                  // letterSpacing: 0.5,

                                  color: const Color(0xff4B4B4B),
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
                                      color: brandTwo.withOpacity(0.2),
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
