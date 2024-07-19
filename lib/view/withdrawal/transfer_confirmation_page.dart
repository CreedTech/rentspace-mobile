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

import '../../constants/colors.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../../widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet/wallet_controller.dart';

class TransferConfirmationPage extends ConsumerStatefulWidget {
  const TransferConfirmationPage(
      {super.key,
      required this.bankName,
      required this.accountNumber,
      required this.bankCode,
      required this.accountName,
      required this.amount,
      required this.narration});
  final String bankName,
      accountNumber,
      bankCode,
      accountName,
      amount,
      narration;

  @override
  ConsumerState<TransferConfirmationPage> createState() =>
      _TransferConfirmationPageState();
}

var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');

class _TransferConfirmationPageState
    extends ConsumerState<TransferConfirmationPage> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
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
    // fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(
                width: 4,
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Stack(
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
                      'Confirm the following details to complete your withdrawal.',
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
                            'Amount',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            currencyFormat.format(double.parse(
                                widget.amount.trim().replaceAll(',', ''))),
                            style: GoogleFonts.roboto(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
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
                        SizedBox(
                          height: 10.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recipient Name',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Text(
                              widget.accountName.capitalize!,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bank',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Text(
                              widget.bankName,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Narration',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Text(
                              widget.narration,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
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
              Padding(
                padding: EdgeInsets.only(bottom: 25.h),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 50, 50),
                      backgroundColor: brandTwo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      _aPinController.clear();
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
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                  ),
                                  // padding:
                                  //     const EdgeInsets.fromLTRB(24, 0, 24, 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            color:
                                                Theme.of(context).canvasColor,
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
                                                      .symmetric(horizontal: 5),
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
                                                      .symmetric(horizontal: 5),
                                                  textStyle: GoogleFonts.lato(
                                                    fontSize: 25,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
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
                                                      .symmetric(horizontal: 5),
                                                  textStyle: GoogleFonts.lato(
                                                    fontSize: 25,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
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
                                                      .symmetric(horizontal: 5),
                                                  textStyle: GoogleFonts.lato(
                                                    fontSize: 25,
                                                    color: brandOne,
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
                                                      walletController
                                                          .walletWithdrawal(
                                                              context,
                                                              widget
                                                                  .accountName,
                                                              widget.amount,
                                                              widget.narration,
                                                              userController
                                                                  .userModel!
                                                                  .userDetails![
                                                                      0]
                                                                  .dvaName,
                                                              widget
                                                                  .accountNumber,
                                                              widget.bankCode,
                                                              _aPinController
                                                                  .text
                                                                  .trim(),
                                                              widget.bankName);
                                                    }).catchError(
                                                      (error) {
                                                        setState(() {
                                                          isFilled = false;
                                                        });

                                                        customErrorDialog(
                                                            context,
                                                            'Oops',
                                                            'Something went wrong. Try again later');
                                                        _aPinController.clear();
                                                      },
                                                    );
                                                  } else {
                                                    if (context.mounted) {
                                                      setState(() {
                                                        isFilled = false;
                                                      });
                                                      customErrorDialog(
                                                          context,
                                                          "Invalid Transaction Pin!",
                                                          'Please confirm your transaction pin.');
                                                      _aPinController.clear();
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
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                  .text.isEmpty) {
                                                return;
                                              }
                                              setState(() {
                                                _aPinController.text =
                                                    _aPinController.text
                                                        .substring(
                                                            0,
                                                            _aPinController.text
                                                                    .length -
                                                                1);
                                              });
                                            },
                                            rightButtonLongPressFn: () {
                                              if (_aPinController
                                                  .text.isEmpty) {
                                                return;
                                              }
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
                    child: Text(
                      'Withdraw',
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
    );
  }
}
