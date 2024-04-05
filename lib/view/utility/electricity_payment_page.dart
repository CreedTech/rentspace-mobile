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
import '../actions/fund_wallet.dart';

class ElectricityPaymentPage extends ConsumerStatefulWidget {
  const ElectricityPaymentPage(
      {super.key,
      required this.electricity,
      required this.electricityCode,
      required this.electricityImage,
      required this.electricityName,
      required this.electricityDescription,
      required this.minmumAmount,
      required this.meterNumber});
  final String electricity,
      electricityCode,
      electricityImage,
      electricityName,
      electricityDescription,
      minmumAmount,
      meterNumber;

  @override
  ConsumerState<ElectricityPaymentPage> createState() =>
      _ElectricityPaymentPageState();
}

class _ElectricityPaymentPageState
    extends ConsumerState<ElectricityPaymentPage> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _aPinController = TextEditingController();
  final electricPaymentFormKey = GlobalKey<FormState>();
  bool _isTyping = false;
  bool isTextFieldEmpty = false;
  void validateUsersInput() {
    if (electricPaymentFormKey.currentState!.validate()) {
      double amount =
          double.parse(_amountController.text.trim().replaceAll(',', ''));
      String electricity = widget.electricity;
      String electricityName = widget.electricityName;
      String electricityImage = widget.electricityImage;
      String electricityCode = widget.electricityCode;
      String meterNumber = widget.meterNumber;
      double transactionFee = 0;

      confirmPayment(context, amount, electricity, electricityName,
          electricityImage, electricityCode, meterNumber, transactionFee);
    }
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

  onKeyboardTap(String value) {
    setState(() {
      _aPinController.text = _aPinController.text + value;
    });
  }

  @override
  Widget build(BuildContext context) {
    validateAmount(amountValue) {
      if (amountValue.isEmpty) {
        return 'amount cannot be empty';
      }
      if (int.tryParse(amountValue.trim().replaceAll(',', '')) == null) {
        return 'enter valid number';
      }
      if (int.tryParse(amountValue)!.isNegative) {
        return 'enter valid number';
      }
      if (int.tryParse(amountValue.trim().replaceAll(',', '')) == 0) {
        return 'amount cannot be zero';
      }
      if (int.tryParse(amountValue)! < int.parse(widget.minmumAmount)) {
        return 'minimum amount is ₦${widget.minmumAmount}';
      }
      // if (double.tryParse(amountValue + 20)! >
      //     walletController.walletModel!.wallet![0].mainBalance) {
      //   return 'you cannot transfer more than your balance';
      // }
      return null;
    }

    final amount = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _amountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          // Check if the text field is empty
          isTextFieldEmpty = value.isNotEmpty &&
              int.tryParse(value) != null &&
              int.parse(value) >= 10 &&
              !(int.tryParse(value)!.isNegative) &&
              int.tryParse(value.trim().replaceAll(',', '')) != 0;
        });
      },
      decoration: InputDecoration(
        label: Text(
          "Enter amount",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        prefixText: "₦ ",
        prefixStyle: GoogleFonts.nunito(
          color: Theme.of(context).primaryColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Amount in Naira',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 20.sp,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Electricity Payment',
          style: GoogleFonts.nunito(
            color: brandOne,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 20.w,
        ),
        child: ListView(
          children: [
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: brandTwo.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Pay your your electricity bills and earn spacepoints!!!',
                  style: GoogleFonts.nunito(
                    color: brandOne.withOpacity(0.7),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30.h, bottom: 20.h
                      // horizontal: 20.w,
                      ),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Container(
                      width: 50,
                      height: 50,
                      // padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // border: Border.all(color: brandOne,width: 2),
                        // color: brandOne,
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          // colorFilter: ColorFilter.mode(
                          //   brandThree,
                          //   BlendMode.darken,
                          // ),
                          fit: BoxFit.cover,
                          image: AssetImage(widget.electricityImage),
                        ),
                      ),
                      // ),
                    ),
                  ),
                ),
                Text(
                  widget.electricityName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 14.sp,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.electricity,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 12.sp,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.meterNumber,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 12.sp,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Text(
                //   widget.electricityDescription,
                //   textAlign: TextAlign.center,
                //   style: GoogleFonts.nunito(
                //     fontSize: 10.sp,
                //     color: Theme.of(context).primaryColor,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
              ],
            ),
            Form(
              key: electricPaymentFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 0.0, 0),
                    child: Text(
                      "Amount",
                      style: GoogleFonts.nunito(
                        fontSize: 14.sp,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 5, 0.0, 5),
                    child: amount,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 50),
                  backgroundColor: (isTextFieldEmpty) ? brandOne : Colors.grey,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                ),
                onPressed: () async {
                  if (electricPaymentFormKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    await fetchUserData()
                        .then((value) => validateUsersInput())
                        .catchError(
                          (error) => {
                            customErrorDialog(context, 'Oops',
                                'Something went wrong. Try again later'),
                          },
                        );
                  }
                }
                //  withdrawPaymentFormKey.currentState != null &&
                //         withdrawPaymentFormKey.currentState!.validate()
                //     ? () async {
                //         FocusScope.of(context).unfocus();
                //         // validateUsersInput();
                //         await fetchUserData()
                //             .then((value) => validateUsersInput())
                //             .catchError(
                //               (error) => {
                //                 customErrorDialog(context, 'Oops',
                //                     'Something went wrong. Try again later'),
                //               },
                //             );
                //       }
                // : null
                ,
                child: Text(
                  'Confirm',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> confirmPayment(
      BuildContext context,
      double amount,
      String electricity,
      String electricityName,
      String electricityImage,
      String electricityCode,
      String meterNumber,
      double transactionFee) async {
    final appState = ref.watch(appControllerProvider.notifier);
    validatePinOne(pinOneValue) {
      // if (pinOneValue.isEmpty) {
      //   return 'pin cannot be empty';
      // }
      if (pinOneValue.length < 4) {
        return 'pin is incomplete';
      }
      if (int.tryParse(pinOneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    final totalAmount = amount + transactionFee;
    // print(bill);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          alignment: Alignment.bottomCenter,
          insetPadding: const EdgeInsets.all(0),
          title: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Text(
                  NumberFormat.simpleCurrency(
                    name: 'NGN',
                  ).format(totalAmount),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800,
                    fontSize: 30.sp,
                    color: brandOne,
                  ),
                ),
                alert(context),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(20.0.r),
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          )),
          content: SizedBox(
            height: 400.h,
            // width: 390.h,
            child: SizedBox(
              width: 400.w,
              child: Column(
                children: [
                  Stack(children: [
                    SizedBox(
                      height: 18.h,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.h, horizontal: 15.h),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Electricity',
                                  style: GoogleFonts.nunito(
                                    color: brandTwo,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Image.asset(
                                        electricityImage,
                                        height: 20.h,
                                        width: 20.w,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 9.w,
                                    ),
                                    Text(
                                      electricity,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        color: brandOne,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 11.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Meter Number',
                                  style: GoogleFonts.nunito(
                                    color: brandTwo,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  meterNumber,
                                  style: GoogleFonts.nunito(
                                    color: brandOne,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Amount',
                                  style: GoogleFonts.nunito(
                                    color: brandTwo,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  NumberFormat.simpleCurrency(
                                    name: 'NGN',
                                  ).format(amount),
                                  style: GoogleFonts.nunito(
                                    color: brandOne,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 11.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Transaction Fee',
                                  style: GoogleFonts.nunito(
                                    color: brandTwo,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  NumberFormat.simpleCurrency(
                                    name: 'NGN',
                                  ).format(transactionFee),
                                  style: GoogleFonts.nunito(
                                    color: brandOne,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment Method',
                                  style: GoogleFonts.nunito(
                                    color: brandOne,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 11.h,
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              decoration: BoxDecoration(
                                color: brandTwo.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  Icons.wallet,
                                  color: ((amount + transactionFee) >
                                          walletController.walletModel!
                                              .wallet![0].mainBalance)
                                      ? Colors.grey
                                      : brandOne,
                                  size: 25.sp,
                                ),
                                title: RichText(
                                  // textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Balance",
                                        style: GoogleFonts.nunito(
                                          color: ((amount + transactionFee) >
                                                  walletController.walletModel!
                                                      .wallet![0].mainBalance)
                                              ? Colors.grey
                                              : brandOne,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '(${NumberFormat.simpleCurrency(
                                          name: 'NGN',
                                        ).format(walletController.walletModel!.wallet![0].mainBalance)})',
                                        style: GoogleFonts.nunito(
                                          color: ((amount + transactionFee) >
                                                  walletController.walletModel!
                                                      .wallet![0].mainBalance)
                                              ? Colors.grey
                                              : brandOne,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: ((amount + transactionFee) >
                                        walletController.walletModel!.wallet![0]
                                            .mainBalance)
                                    ? Text(
                                        'Insufficient Balance',
                                        style: GoogleFonts.nunito(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                        ),
                                      )
                                    : null,
                                trailing: ((amount + transactionFee) >
                                        walletController.walletModel!.wallet![0]
                                            .mainBalance)
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(const FundWallet());
                                        },
                                        child: Wrap(
                                          alignment: WrapAlignment.end,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.end,
                                          children: [
                                            Text(
                                              'Top up',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.nunito(
                                                color: brandOne,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: brandOne,
                                              size: 20.sp,
                                            )
                                          ],
                                        ),
                                      )
                                    : Icon(
                                        Icons.check,
                                        color: brandOne,
                                        size: 20.sp,
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 35.h,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(250, 50),
                                backgroundColor: (((amount + transactionFee) >
                                        walletController.walletModel!.wallet![0]
                                            .mainBalance))
                                    ? Colors.grey
                                    : brandOne,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    50,
                                  ),
                                ),
                              ),
                              onPressed: ((amount + transactionFee) >
                                      walletController
                                          .walletModel!.wallet![0].mainBalance)
                                  ? null
                                  : () async {
                                      FocusScope.of(context).unfocus();
                                      Get.bottomSheet(
                                        isDismissible: true,
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 400.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(30.0),
                                              topRight: Radius.circular(30.0),
                                            ),
                                            child: Container(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 20.h,
                                                  ),
                                                  Pinput(
                                                    // obscuringCharacter: '*',
                                                    useNativeKeyboard: false,
                                                    obscureText: true,
                                                    defaultPinTheme: PinTheme(
                                                      width: 50,
                                                      height: 50,
                                                      textStyle: TextStyle(
                                                        fontSize: 25.sp,
                                                        color: brandOne,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    focusedPinTheme: PinTheme(
                                                      width: 50,
                                                      height: 50,
                                                      textStyle: TextStyle(
                                                        fontSize: 25.sp,
                                                        color: brandOne,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: brandOne,
                                                            width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    submittedPinTheme: PinTheme(
                                                      width: 50,
                                                      height: 50,
                                                      textStyle: TextStyle(
                                                        fontSize: 25.sp,
                                                        color: brandOne,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: brandOne,
                                                            width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    followingPinTheme: PinTheme(
                                                      width: 50,
                                                      height: 50,
                                                      textStyle: TextStyle(
                                                        fontSize: 25.sp,
                                                        color: brandOne,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: brandTwo,
                                                            width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    onCompleted: (String val) {
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
                                                        // _aPinController.clear();
                                                        Get.back();
                                                      
                                                        // _doWallet(;
                                                        appState.buyElectricity(
                                                          context,
                                                          amount,
                                                          userController
                                                              .userModel!
                                                              .userDetails![0]
                                                              .phoneNumber,
                                                          meterNumber,
                                                          electricityCode,
                                                          userController
                                                              .userModel!
                                                              .userDetails![0]
                                                              .email,
                                                          electricityName,
                                                        );
                                                      } else {
                                                        _aPinController.clear();
                                                        if (context.mounted) {
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
                                                  NumericKeyboard(
                                                    onKeyboardTap:
                                                        onKeyboardTap,
                                                    textStyle:
                                                        GoogleFonts.nunito(
                                                      color: brandOne,
                                                      fontSize: 24.sp,
                                                    ),
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
                                                        _aPinController.text =
                                                            '';
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
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                              child: Text(
                                'Pay',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  GestureDetector alert(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: null,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.h),
                ),
                content: SizedBox(
                  height: 200.h,
                  width: 400.h,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.of(context).pop();
                      //   },
                      //   child: Align(
                      //     alignment: Alignment.topRight,
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(30.h),
                      //         color: Colors.red,
                      //       ),
                      //       child: Padding(
                      //         padding: EdgeInsets.all(10.h),
                      //         child: Icon(
                      //           Iconsax.close_circle,
                      //           color: Colors.red,
                      //           size: 20.sp,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Payment Not completed',
                        style: GoogleFonts.nunito(
                          color: brandOne,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        'Do you want to cancel this payment?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 50),
                              backgroundColor: brandOne,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ),
                              ),
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Proceed to Pay',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 50),
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ),
                                side:
                                    const BorderSide(color: brandOne, width: 1),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                color: brandOne,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
              );
            });
      },
      child: Icon(
        Icons.close,
        color: brandOne,
        size: 20.sp,
      ),
    );
  }
}
