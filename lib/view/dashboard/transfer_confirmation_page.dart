import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/app_controller.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet_controller.dart';

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

var currencyFormat = NumberFormat.simpleCurrency(name: 'N');

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
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: colorWhite,
              ),
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
                      color: colorBlack,
                    ),
                  ),
                  SizedBox(
                    width: 280.w,
                    child: Text(
                      'Confirm the following details to complete your transaction.',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: brandOne,
                            ),
                          ),
                          Text(
                            currencyFormat.format(double.parse(
                                widget.amount.trim().replaceAll(',', ''))),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recipient Name',
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
                              widget.accountName.capitalize!,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorBlack,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.h),
                          child: const Divider(
                            thickness: 1,
                            color: Color(0xffC9C9C9),
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
                                color: const Color(0xff4B4B4B),
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
                                color: colorBlack,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.h),
                          child: const Divider(
                            thickness: 1,
                            color: Color(0xffC9C9C9),
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
                                color: const Color(0xff4B4B4B),
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
                                color: colorBlack,
                              ),
                            ),
                          ],
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
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: const Color(0xffF6F6F8),
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
                              child: Container(
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
                                              color: colorBlack,
                                            ),
                                            Text(
                                              'Cancel',
                                              style: GoogleFonts.lato(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: colorBlack,
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
                                          color: colorWhite,
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
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
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
                                                  color: brandOne,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: brandOne,
                                                      width: 2.0),
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
                                                  color: brandOne,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: brandOne,
                                                      width: 2.0),
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
                                                  color: brandOne,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffBDBDBD),
                                                      width: 2.0),
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
                                                  await fetchUserData()
                                                      .then((value) {
                                                    appState.transferMoney(
                                                        context,
                                                        widget.bankCode,
                                                        double.parse(widget
                                                            .amount
                                                            .trim()
                                                            .replaceAll(
                                                                ',', '')),
                                                        widget.accountNumber
                                                            .toString(),
                                                        _aPinController.text
                                                            .trim()
                                                            .toString(),
                                                        widget.accountName,
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
                                          color: colorWhite,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: NumericKeyboard(
                                          onKeyboardTap: onKeyboardTap,
                                          textStyle: GoogleFonts.lato(
                                              color: brandOne,
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
                            );
                          });
                    },
                    child: Text(
                      'Send Money',
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
