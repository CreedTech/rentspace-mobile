import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/view/actions/fund_wallet.dart';

import '../../../constants/colors.dart';
import '../../../constants/widgets/custom_dialog.dart';
import '../../../constants/widgets/custom_loader.dart';
import '../../../controller/app_controller.dart';
import '../../../controller/auth/user_controller.dart';
import '../../../controller/wallet_controller.dart';

class SpaceRentConfirmationPage extends ConsumerStatefulWidget {
  const SpaceRentConfirmationPage(
      {super.key,
      required this.rentValue,
      required this.savingsValue,
      required this.startDate,
      required this.receivalDate,
      required this.durationType,
      required this.paymentCount,
      required this.rentName,
      required this.duration});
  final num rentValue, savingsValue;
  final String startDate, durationType, paymentCount, rentName;
  final int duration;
  final DateTime receivalDate;

  @override
  ConsumerState<SpaceRentConfirmationPage> createState() =>
      _SpaceRentConfirmationPageState();
}

var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');

class _SpaceRentConfirmationPageState
    extends ConsumerState<SpaceRentConfirmationPage> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController _aPinController = TextEditingController();
  bool isFilled = false;
  String interestRate = "0";

  onKeyboardTap(String value) {
    setState(() {
      _aPinController.text = _aPinController.text + value;
    });
  }

  Future<bool> fetchUserData({bool refresh = true}) async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    if (refresh) {
      await userController.fetchData();
      await walletController.fetchWallet();
      // setState(() {}); // Move setState inside fetchData
    }
    EasyLoading.dismiss();
    return true;
  }
  // @override
  // void initState() {
  //   super.initState();

  // }
  //    calculateInterest() {
  //   //50k to 1m, 7% interest
  //   if (((widget.rentValue) >= 1000) &&
  //       ((widget.rentValue) < 49999)) {
  //     setState(() {
  //       // showSaveButton = true;
  //       interestRate = "7";
  //     });
  //     // return interestValue = ((widget.rentValue) *
  //     //         0.07 *
  //     //         (int.parse(widget.dateDifference) / widget.durationVal))
  //     //     .toString();
  //   }
  //   //1m to 2m, 7.5% interest
  //   else if (((widget.rentValue) >= 1000000) &&
  //       ((widget.rentValue) < 2000000)) {
  //     setState(() {
  //       interestRate = "7.5";
  //     });
  //     // return interestValue = ((widget.rentValue) *
  //     //         0.075 *
  //     //         (int.parse(widget.dateDifference) / widget.durationVal))
  //     //     .toString();
  //   }
  //   //2m to 5m, 8.25% interest
  //   else if (((widget.rentValue) >= 2000000) &&
  //       ((widget.rentValue) < 5000000)) {
  //     setState(() {
  //       interestRate = "8.5";
  //     });
  //     // return interestValue = ((widget.rentValue) *
  //     //         0.0825 *
  //     //         (int.parse(widget.dateDifference) / widget.durationVal))
  //     //     .toString();
  //   }
  //   //5m to 10m, 9% interest
  //   else if (((widget.rentValue) >= 5000000) &&
  //       ((widget.rentValue) < 10000000)) {
  //     setState(() {
  //       interestRate = "9";
  //       // showSaveButton = true;
  //     });
  //     // return interestValue = ((widget.rentValue) *
  //     //         0.09 *
  //     //         (int.parse(widget.dateDifference) / widget.durationVal))
  //     //     .toString();
  //   }
  //   //10m to 20m, 10.25% interest
  //   else if (((widget.rentValue) >= 10000000) &&
  //       ((widget.rentValue) < 20000000)) {
  //     setState(() {
  //       interestRate = "10.25";
  //     });
  //     // return interestValue = ((widget.rentValue) *
  //     //         0.1025 *
  //     //         (int.parse(widget.dateDifference) / widget.durationVal))
  //     //     .toString();
  //   }
  //   //20m to 30m, 12% interest
  //   else if (((widget.rentValue) >= 20000000) &&
  //       ((widget.rentValue) < 30000000)) {
  //     setState(() {
  //       interestRate = "12";
  //     });
  //     // return interestValue = ((widget.rentValue) *
  //     //         0.12 *
  //     //         (int.parse(widget.dateDifference) / widget.durationVal))
  //     //     .toString();
  //   }
  //   //30m to 50m, 14% interest
  //   else if (((widget.rentValue) >= 30000000) &&
  //       ((widget.rentValue) < 50000000)) {
  //     setState(() {
  //       interestRate = "14";
  //     });
  //     // return interestValue = ((widget.rentValue) *
  //     //         0.14 *
  //     //         (int.parse(widget.dateDifference) / widget.durationVal))
  //     //     .toString();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final rentState = ref.watch(appControllerProvider.notifier);
    final currentDate = DateTime.now();
    final formattedReceivalDate =
        DateFormat('dd/MM/yyyy').format(widget.receivalDate);
    final formattedCurrentDate = DateFormat('dd/MM/yyyy').format(currentDate);
    // print('formattedCurrentDate');
    // print(formattedCurrentDate);
    // print(widget.startDate);
    // print('width');
    // print(MediaQuery.of(context).size.height -
    //     (MediaQuery.of(context).size.height / 3));
    return Scaffold(
      backgroundColor: brandOne,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: brandOne,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: colorWhite,
              ),
              SizedBox(
                width: 4.h,
              ),
              Text(
                'Confirmation',
                style: GoogleFonts.lato(
                  color: colorWhite,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 23.w),
            child: Image.asset(
              'assets/icons/house.png',
              height: 35.7.h,
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xffF6F6F8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Almost Done!',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colorBlack,
                          ),
                        ),
                        SizedBox(
                          width: 280.w,
                          child: Text(
                            'Confirm the following details to create your Space Rent plan.',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: colorBlack,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // height: 92.h,
                            padding: const EdgeInsets.all(17),
                            decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rent Amount',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: brandOne,
                                  ),
                                ),
                                Text(
                                  currencyFormat.format(widget.rentValue),
                                  style: GoogleFonts.lato(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: brandOne,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 92.h,
                          padding: const EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Space Rent Name',
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff4B4B4B),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    widget.rentName.capitalize!,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: colorBlack,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: 17.h),
                                child: const Divider(
                                  thickness: 1,
                                  color: Color(0xffC9C9C9),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Saving Duration',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff4B4B4B),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        '${widget.duration} months',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: colorBlack,
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 17.h,
                                      // ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // SizedBox(
                                      //   height: 17.h,
                                      // ),
                                      Text(
                                        'Days',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff4B4B4B),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        _calculateDaysDifference(
                                                DateFormat('dd/MM/yyyy')
                                                    .format(widget
                                                        .receivalDate),
                                                widget.startDate)
                                            .toString(),
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: colorBlack,
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 17.h,
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: 17.h),
                                child: const Divider(
                                  thickness: 1,
                                  color: Color(0xffC9C9C9),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // SizedBox(
                                      //   height: 17.h,
                                      // ),
                                      Text(
                                        'Start Date',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff4B4B4B),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        widget.startDate,
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: colorBlack,
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 17.h,
                                      // ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // SizedBox(
                                      //   height: 17.h,
                                      // ),
                                      Text(
                                        'End Date',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff4B4B4B),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        DateFormat('dd/MM/yyyy')
                                            .format(widget.receivalDate),
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: colorBlack,
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 17.h,
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: 17.h),
                                child: const Divider(
                                  thickness: 1,
                                  color: Color(0xffC9C9C9),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Frequency',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff4B4B4B),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        widget.durationType,
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: colorBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      Text(
                                        '${currencyFormat.format(widget.savingsValue)}/${widget.durationType.toLowerCase() == 'weekly' ? 'wk' : 'mth'}',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: colorBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0.h, top: 40),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width - 50, 50),
                            backgroundColor: brandTwo,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: const Color(0xffF6F6F8),
                                // showDragHandle: true,
                                isDismissible: false,
                                enableDrag: true,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height /1.5,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF6F6F8),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0),
                                      ),
                                    ),
                                    // padding:
                                    //     const EdgeInsets.fromLTRB(24, 0, 24, 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // SizedBox(
                                        //   height: 30.h,
                                        // ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 17.w, top: 28.h),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_back_ios,
                                                  size: 27.w,
                                                  color: colorBlack,
                                                ),
                                                Text(
                                                  'Cancel',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    color: colorBlack,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h,
                                              horizontal: 24.w),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 22,
                                                    horizontal: 27),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/icons/lock_filled.png',
                                                      width: 23.w,
                                                      color: brandOne,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text(
                                                      'Transaction Pin',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: colorDark,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 28.h,
                                                ),
                                                Pinput(
                                                  obscuringCharacter: '*',
                                                  useNativeKeyboard: false,
                                                  obscureText: true,
                                                  defaultPinTheme: PinTheme(
                                                    width: 67,
                                                    height: 60,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    textStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 25,
                                                      color: brandOne,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffBDBDBD),
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                    ),
                                                  ),
                                                  focusedPinTheme: PinTheme(
                                                    width: 67,
                                                    height: 60,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    textStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 25,
                                                      color: brandOne,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: brandOne,
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                    ),
                                                  ),
                                                  submittedPinTheme: PinTheme(
                                                    width: 67,
                                                    height: 60,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    textStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 25,
                                                      color: brandOne,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: brandOne,
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                    ),
                                                  ),
                                                  followingPinTheme: PinTheme(
                                                    width: 67,
                                                    height: 60,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    textStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 25,
                                                      color: brandOne,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffBDBDBD),
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                    ),
                                                  ),
                                                  onCompleted:
                                                      (String val) async {
                                                    setState(() {
                                                      isFilled = true;
                                                    });
                                                    if (BCrypt.checkpw(
                                                      _aPinController.text
                                                          .trim()
                                                          .toString(),
                                                      userController
                                                          .userModel!
                                                          .userDetails![0]
                                                          .wallet
                                                          .pin,
                                                    )) {
                                                      await fetchUserData()
                                                          .then((value) {
                                                        final hasSufficientBalance =
                                                            checkSufficientBalance();
                                                        (widget.startDate ==
                                                                formattedCurrentDate)
                                                            ? (hasSufficientBalance)
                                                                ? rentState.createRent(
                                                                    context,
                                                                    widget
                                                                        .rentName,
                                                                    DateFormat(
                                                                            'dd/MM/yyyy')
                                                                        .format(
                                                                            widget
                                                                                .receivalDate),
                                                                    widget
                                                                        .durationType,
                                                                    widget
                                                                        .savingsValue,
                                                                    widget
                                                                        .rentValue,
                                                                    widget
                                                                        .paymentCount,
                                                                    widget
                                                                        .startDate,
                                                                    widget
                                                                        .duration
                                                                    // fundingController.text,
                                                                    )
                                                                : showDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        true,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(16),
                                                                        ),
                                                                        title:
                                                                            null,
                                                                        scrollable:
                                                                            true,
                                                                        elevation:
                                                                            0,
                                                                        content:
                                                                            SizedBox(
                                                                          // height: 220.h,
                                                                          width:
                                                                              MediaQuery.of(context).size.width,
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                                                            child: Column(
                                                                              children: [
                                                                                Wrap(
                                                                                  alignment: WrapAlignment.center,
                                                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    const Icon(
                                                                                      Icons.info_outline_rounded,
                                                                                      color: colorBlack,
                                                                                      size: 24,
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 4,
                                                                                    ),
                                                                                    Text(
                                                                                      'Insufficient fund.',
                                                                                      style: GoogleFonts.lato(
                                                                                        color: colorBlack,
                                                                                        fontSize: 24,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 14,
                                                                                ),
                                                                                Text(
                                                                                  'You need to fund your wallet to perform this transaction.',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.lato(
                                                                                    color: colorBlack,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 29,
                                                                                ),
                                                                                Align(
                                                                                  alignment: Alignment.bottomCenter,
                                                                                  child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      minimumSize: Size(MediaQuery.of(context).size.width - 50, 50),
                                                                                      backgroundColor: brandTwo,
                                                                                      elevation: 0,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(
                                                                                          10,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).pop();
                                                                                      Get.to(const FundWallet());
                                                                                    },
                                                                                    child: Text(
                                                                                      'Ok',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: GoogleFonts.lato(
                                                                                        color: Colors.white,
                                                                                        fontSize: 14,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    })
                                                            : rentState.createRent(
                                                                context,
                                                                widget
                                                                    .rentName,
                                                                DateFormat(
                                                                        'dd/MM/yyyy')
                                                                    .format(widget
                                                                        .receivalDate),
                                                                widget
                                                                    .durationType,
                                                                widget
                                                                    .savingsValue,
                                                                widget
                                                                    .rentValue,
                                                                widget
                                                                    .paymentCount,
                                                                widget
                                                                    .startDate,
                                                                widget
                                                                    .duration
                                                                // fundingController.text,
                                                                );
                                                      }).catchError(
                                                        (error) {
                                                          setState(() {
                                                            isFilled = false;
                                                          });
                                                          customErrorDialog(
                                                              context,
                                                              'Oops',
                                                              'Something went wrong. Try again later');
                                                        },
                                                      );
                                                    } else {
                                                      _aPinController.clear();
                                                      if (context.mounted) {
                                                        setState(() {
                                                          isFilled = false;
                                                        });
                                                        customErrorDialog(
                                                            context,
                                                            "Invalid PIN",
                                                            'Enter correct PIN to proceed');
                                                      }
                                                    }
                                                  },
                                                  // validator: validatePinOne,
                                                  // onChanged: validatePinOne,
                                                  controller: _aPinController,
                                                  length: 4,
                                                  closeKeyboardWhenCompleted:
                                                      true,
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 24.w,
                                              right: 24.w,
                                              bottom: 30.h),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 2,
                                                    horizontal: 7),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: NumericKeyboard(
                                              onKeyboardTap: onKeyboardTap,
                                              textStyle: GoogleFonts.lato(
                                                  color: brandOne,
                                                  fontSize: 32,
                                                  fontWeight:
                                                      FontWeight.w500),
                                              rightButtonFn: () {
                                                if (_aPinController
                                                    .text.isEmpty) return;
                                                setState(() {
                                                  _aPinController.text =
                                                      _aPinController.text
                                                          .substring(
                                                              0,
                                                              _aPinController
                                                                      .text
                                                                      .length -
                                                                  1);
                                                });
                                              },
                                              rightButtonLongPressFn: () {
                                                if (_aPinController
                                                    .text.isEmpty) return;
                                                setState(() {
                                                  _aPinController.text = '';
                                                });
                                              },
                                              rightIcon: const Icon(
                                                Icons.backspace_outlined,
                                                color: Colors.red,
                                              ),
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            'Create Space Rent',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  bool checkSufficientBalance() {
    // Compare mainBalance with savingsValue and return true if mainBalance is greater or equal
    return walletController.walletModel!.wallet![0].mainBalance >=
        widget.savingsValue;
  }
}
