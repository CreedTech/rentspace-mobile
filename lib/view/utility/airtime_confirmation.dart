import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/controller/airtime_controller.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_button.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/app_controller.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/utility_response_controller.dart';
import '../../controller/wallet_controller.dart';

class AirtimeConfirmation extends ConsumerStatefulWidget {
  const AirtimeConfirmation({
    super.key,
    required this.number,
    required this.billerId,
    required this.name,
    required this.image,
    required this.divisionId,
    required this.productId,
    required this.amount,
    required this.category,
    this.customerName,
  });
  final String number, billerId, name, image, divisionId, productId, category;
  final String? customerName;
  final num amount;

  @override
  ConsumerState<AirtimeConfirmation> createState() =>
      _AirtimeConfirmationState();
}

class _AirtimeConfirmationState extends ConsumerState<AirtimeConfirmation> {
  var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final AirtimesController airtimesController = Get.find();
  final UtilityResponseController utilityResponseController = Get.find();
  final TextEditingController _aPinController = TextEditingController();
  bool isFilled = false;

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

  @override
  void initState() {
    super.initState();
    utilityResponseController.fetchBillerItem(
        widget.billerId, widget.divisionId, widget.productId);
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appControllerProvider.notifier);
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                                'Confirm the following details to complete your transaction.',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Airtime Amount',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      currencyFormat.format(widget.amount),
                                      style: GoogleFonts.roboto(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
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
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'To',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        '${widget.customerName ?? ''} ${widget.number}',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 17.h,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 0.h),
                                    child: Divider(
                                      thickness: 1,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 17.h,
                                      ),
                                      Text(
                                        'Network',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9.h,
                                      ),
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: Image.asset(
                                              widget.image,
                                              height: 20.h,
                                              width: 20.h,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            widget.name,
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
                                      SizedBox(
                                        height: 17.h,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 0.h),
                                    child: Divider(
                                      thickness: 1,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 17.h,
                                      ),
                                      Text(
                                        'Description',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9.h,
                                      ),
                                      Text(
                                        widget.category.capitalize!,
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
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  text: 'Confirm',
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        // showDragHandle: true,
                        isDismissible: false,
                        enableDrag: true,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                            heightFactor: 0.64,
                            // constraints: BoxConstraints(
                            //   maxHeight: 900 // Adjust the value as needed
                            // ),
                            child: SingleChildScrollView(
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                // padding:
                                //     const EdgeInsets.fromLTRB(24, 0, 24, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 22, horizontal: 27),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 28.h,
                                            ),
                                            Pinput(
                                              // obscuringCharacter: '*',
                                              useNativeKeyboard: false,
                                              obscureText: true,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              obscuringWidget: Center(
                                                child: Text(
                                                  "*",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 44,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context).colorScheme.primary
                                                  ),
                                                ),
                                              ),
                                              hapticFeedbackType:
                                                  HapticFeedbackType
                                                      .heavyImpact,
                                              defaultPinTheme: PinTheme(
                                                width: 67,
                                                height: 60,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                textStyle: GoogleFonts.lato(
                                                  fontSize: 25,
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffBDBDBD),
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              focusedPinTheme: PinTheme(
                                                width: 67,
                                                height: 60,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                textStyle: GoogleFonts.lato(
                                                  fontSize: 25,
                                                  color:  Theme.of(context).colorScheme.primary,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffBDBDBD),
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              submittedPinTheme: PinTheme(
                                                width: 67,
                                                height: 60,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                textStyle: GoogleFonts.lato(
                                                  fontSize: 25,
                                                  color:  Theme.of(context).colorScheme.primary,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffBDBDBD),
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              followingPinTheme: PinTheme(
                                                width: 67,
                                                height: 60,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                textStyle: GoogleFonts.lato(
                                                  fontSize: 25,
                                                  color:  Theme.of(context).colorScheme.primary,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffBDBDBD),
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onCompleted: (String val) async {
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
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  var billerItems =
                                                      Hive.box(widget.billerId);
                                                  print(billerItems);
                                                  var storedData = billerItems
                                                      .get(widget.billerId);
                                                  print(widget.billerId);
                                                  //  storedData['data'];
                                                  var outputList =
                                                      storedData['data']
                                                          .where((o) =>
                                                              o['billerid'] ==
                                                              widget.billerId)
                                                          .toList();
                                                  print(
                                                      'output list ${outputList}');
                                                  await fetchUserData()
                                                      .then((value) {
                                                    airtimesController.payBill(
                                                      widget.number,
                                                      widget.amount.toString(),
                                                      outputList[0]['division'],
                                                      outputList[0]
                                                          ['paymentCode'],
                                                      widget.productId,
                                                      widget.billerId,
                                                      widget.category,
                                                      widget.name,
                                                    );
                                                  }).catchError(
                                                    (error) {
                                                      print(error);
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
                                                        "Invalid Transaction Pin!",
                                                        'Please confirm your transaction pin.');
                                                  }
                                                }
                                              },
                                              // validator: validatePinOne,
                                              // onChanged: validatePinOne,
                                              controller: _aPinController,
                                              length: 4,
                                              closeKeyboardWhenCompleted: true,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 7),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: NumericKeyboard(
                                          onKeyboardTap: onKeyboardTap,
                                          textStyle: GoogleFonts.lato(
                                              color:  Theme.of(context).colorScheme.secondary,
                                              fontSize: 32,
                                              fontWeight: FontWeight.w500),
                                          rightButtonFn: () {
                                            if (_aPinController.text.isEmpty)
                                              return;
                                            setState(() {
                                              _aPinController.text =
                                                  _aPinController
                                                      .text
                                                      .substring(
                                                          0,
                                                          _aPinController
                                                                  .text.length -
                                                              1);
                                            });
                                          },
                                          rightButtonLongPressFn: () {
                                            if (_aPinController.text.isEmpty)
                                              return;
                                            setState(() {
                                              _aPinController.text = '';
                                            });
                                          },
                                          rightIcon: const Icon(
                                            Icons.backspace_outlined,
                                            color: Colors.red,
                                          ),
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
