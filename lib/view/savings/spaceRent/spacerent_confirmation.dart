import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';

import '../../../constants/colors.dart';
import '../../../widgets/custom_dialogs/index.dart';
import '../../../widgets/custom_loader.dart';
import '../../../controller/app/app_controller.dart';
import '../../../controller/auth/user_controller.dart';
import '../../../controller/wallet/wallet_controller.dart';

class SpaceRentConfirmationPage extends ConsumerStatefulWidget {
  const SpaceRentConfirmationPage({
    super.key,
    required this.rentValue,
    required this.savingsValue,
    required this.startDate,
    required this.receivalDate,
    required this.durationType,
    required this.paymentCount,
    required this.rentName,
    required this.duration,
    this.fromPopup = false,
  });
  final num rentValue, savingsValue;
  final String startDate, durationType, paymentCount, rentName;
  final int duration;
  final DateTime receivalDate;
  final bool fromPopup;

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
      await walletController.fetchWallet();
    }
    EasyLoading.dismiss();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final rentState = ref.watch(appControllerProvider.notifier);
    final currentDate = DateTime.now();

    final formattedCurrentDate = DateFormat('dd/MM/yyyy').format(currentDate);

    return Scaffold(
      backgroundColor: brandOne,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: brandOne,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            context.pop();
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
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(
                          width: 280.w,
                          child: Text(
                            'Confirm the following details to create your Space Rent plan.',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.primary,
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
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rent Amount',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  currencyFormat.format(widget.rentValue),
                                  style: GoogleFonts.roboto(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Space Rent Name',
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Theme.of(context).primaryColorLight,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 17.h),
                                child: Divider(
                                  thickness: 1,
                                  color: Theme.of(context).dividerColor,
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
                                          color: Theme.of(context)
                                              .primaryColorLight,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Days',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        _calculateDaysDifference(
                                                DateFormat('dd/MM/yyyy').format(
                                                    widget.receivalDate),
                                                widget.startDate)
                                            .toString(),
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 17.h),
                                child: Divider(
                                  thickness: 1,
                                  color: Theme.of(context).dividerColor,
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
                                        'Start Date',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .primaryColorLight,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'End Date',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .primaryColorLight,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                padding: EdgeInsets.symmetric(vertical: 17.h),
                                child: Divider(
                                  thickness: 1,
                                  color: Theme.of(context).dividerColor,
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
                                          color: Theme.of(context)
                                              .primaryColorLight,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        '${currencyFormat.format(widget.savingsValue)}/${widget.durationType.toLowerCase() == 'weekly' ? 'wk' : 'mth'}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                // showDragHandle: true,
                                isDismissible: false,
                                enableDrag: true,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height /
                                        1.5,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
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
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                Text(
                                                  'Cancel',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h, horizontal: 24.w),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 22, horizontal: 27),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).canvasColor,
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
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
                                                    textStyle: GoogleFonts.lato(
                                                      fontSize: 25,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffBDBDBD),
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  focusedPinTheme: PinTheme(
                                                    width: 67,
                                                    height: 60,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    textStyle: GoogleFonts.lato(
                                                      fontSize: 25,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffBDBDBD),
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  submittedPinTheme: PinTheme(
                                                    width: 67,
                                                    height: 60,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    textStyle: GoogleFonts.lato(
                                                      fontSize: 25,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffBDBDBD),
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  followingPinTheme: PinTheme(
                                                    width: 67,
                                                    height: 60,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    textStyle: GoogleFonts.lato(
                                                      fontSize: 25,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffBDBDBD),
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                                                ? rentState
                                                                    .createRent(
                                                                    context,
                                                                    widget
                                                                        .rentName,
                                                                    DateFormat(
                                                                            'dd/MM/yyyy')
                                                                        .format(
                                                                            widget.receivalDate),
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
                                                                        .duration,
                                                                    widget
                                                                        .fromPopup,
                                                                  )
                                                                : insufficientFundsDialog(
                                                                    context)
                                                            : rentState
                                                                .createRent(
                                                                context,
                                                                widget.rentName,
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
                                                                widget.duration,
                                                                widget
                                                                    .fromPopup,
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 7),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: NumericKeyboard(
                                              onKeyboardTap: onKeyboardTap,
                                              textStyle: GoogleFonts.lato(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w500),
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
