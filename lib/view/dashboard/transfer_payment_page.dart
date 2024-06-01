import 'dart:async';

import 'package:bcrypt/bcrypt.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/view/actions/fund_wallet.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/app_controller.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet_controller.dart';
import '../savings/spaceRent/spacerent_list.dart';

class TransferPaymentPage extends ConsumerStatefulWidget {
  const TransferPaymentPage(
      {super.key,
      required this.bankName,
      required this.accountNumber,
      required this.bankCode,
      required this.accountName});
  final String bankName, accountNumber, bankCode, accountName;

  @override
  ConsumerState<TransferPaymentPage> createState() =>
      _TransferPaymentPageState();
}

final withdrawPaymentFormKey = GlobalKey<FormState>();
String _amountQuery = '';

class _TransferPaymentPageState extends ConsumerState<TransferPaymentPage> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _aPinController = TextEditingController();
  bool _isTyping = false;
  bool isTextFieldEmpty = false;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  late StreamSubscription subscription;

  void validateUsersInput() {
    if (withdrawPaymentFormKey.currentState!.validate()) {
      double amount =
          double.parse(_amountController.text.trim().replaceAll(',', ''));
      String bankName = widget.bankName;
      String accountNumber = widget.accountNumber;
      String accountName = widget.accountName;
      String bankCode = widget.bankCode;
      double transactionFee = 20;

      confirmPayment(context, amount, bankName, accountNumber, accountName,
          bankCode, transactionFee);
    }
  }

  @override
  initState() {
    super.initState();
    getConnectivity();
    // _amountController = TextEditingController();
    // _amountController.addListener(_onAmountChanged);
  }

  onKeyboardTap(String value) {
    setState(() {
      _aPinController.text = _aPinController.text + value;
    });
  }

  // @override
  // void dispose() {
  //   _amountController.dispose();
  //   super.dispose();
  // }

  void _onAmountChanged() {
    setState(() {
      _amountQuery = _amountController.text;
      _isTyping = _amountQuery.isNotEmpty;
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

  void getConnectivity() {
    print('checking internet...');
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && !isAlertSet) {
          noInternetConnectionScreen(context);
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  noInternetConnectionScreen(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
            elevation: 0.0,
            alignment: Alignment.bottomCenter,
            insetPadding: const EdgeInsets.all(0),
            title: null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            content: SizedBox(
              height: 170.h,
              child: Container(
                width: 400.w,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Text(
                      'No internet Connection',
                      style: GoogleFonts.lato(
                          color: brandOne,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: brandOne,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width - 50, 50),
                          backgroundColor: brandTwo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          // EasyLoading.dismiss();
                          setState(() => isAlertSet = false);
                          isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!isDeviceConnected && isAlertSet == false) {
                            // showDialogBox();
                            noInternetConnectionScreen(context);
                            setState(() => isAlertSet = true);
                          }
                          // fetchUserData();
                        },
                        child: Text(
                          "Try Again",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 12,
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
        return 'number cannot be zero';
      }
      if (int.tryParse(amountValue)! < 10) {
        return 'minimum amount is ₦10.00';
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
      style: GoogleFonts.lato(
        color: Theme.of(context).primaryColor,
        fontSize: 14,
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
          style: GoogleFonts.lato(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        prefixText: "₦ ",
        prefixStyle: GoogleFonts.lato(
          color: Theme.of(context).primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        // suffixIcon: _isTyping // Show clear button only when typing
        //     ? IconButton(
        //         icon: Icon(
        //           Iconsax.close_circle5,
        //           size: 18,
        //           color: brandOne,
        //         ),
        //         onPressed: () {
        //           _amountController.clear(); // Clear the text field
        //         },
        //       )
        //     : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
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
              color: Colors.red, width: 1.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Amount in Naira',
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 12,
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
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Transfer to Bank Account',
          style: GoogleFonts.lato(
            color: brandOne,
            fontSize: 16,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xffEEF8FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Please note that charging of ₦20.00 on all  transfers will be according to our Terms of use',
                style: GoogleFonts.lato(
                  color: brandOne.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
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
                        image: const DecorationImage(
                          // colorFilter: ColorFilter.mode(
                          //   brandThree,
                          //   BlendMode.darken,
                          // ),
                          fit: BoxFit.cover,
                          image: AssetImage('assets/icons/RentSpace-icon.jpg'),
                        ),
                      ),
                      // ),
                    ),
                  ),
                ),
                Text(
                  widget.accountName,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.bankName,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.accountNumber,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Form(
              key: withdrawPaymentFormKey,
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
                      style: GoogleFonts.lato(
                        fontSize: 14,
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
                  minimumSize: Size(MediaQuery.of(context).size.width - 50, 50),
                  backgroundColor: (isTextFieldEmpty) ? brandOne : Colors.grey,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                ),
                onPressed: () async {
                  if (withdrawPaymentFormKey.currentState!.validate()) {
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
                },
                child: Text(
                  'Confirm',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
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
      String bankName,
      String accountNumber,
      String accountName,
      String bankCode,
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
                  ch8t.format(totalAmount),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
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
                                  'Bank',
                                  style: GoogleFonts.lato(
                                    color: brandTwo,
                                    fontSize: 12,
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
                                        'assets/icons/RentSpace-icon.jpg',
                                        height: 20.h,
                                        width: 20.w,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 9.w,
                                    ),
                                    Text(
                                      bankName,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        color: brandOne,
                                        fontSize: 12,
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
                                  'Account Number',
                                  style: GoogleFonts.lato(
                                    color: brandTwo,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  accountNumber,
                                  style: GoogleFonts.lato(
                                    color: brandOne,
                                    fontSize: 12,
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
                                  style: GoogleFonts.lato(
                                    color: brandTwo,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ch8t.format(amount),
                                  style: GoogleFonts.roboto(
                                    color: brandOne,
                                    fontSize: 12,
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
                                  style: GoogleFonts.lato(
                                    color: brandTwo,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ch8t.format(transactionFee),
                                  style: GoogleFonts.roboto(
                                    color: brandOne,
                                    fontSize: 12,
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
                                  style: GoogleFonts.lato(
                                    color: brandOne,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.end,
                                //   children: [
                                //     Text(
                                //       'Space Wallet',
                                //       style: GoogleFonts.lato(
                                //         color: brandOne,
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //     Text(
                                //       ch8t.format(userController.userModel!
                                //           .userDetails![0].wallet.mainBalance),
                                //       style: GoogleFonts.lato(
                                //         color: brandOne,
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //   ],
                                // )
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
                                  size: 25,
                                ),
                                title: RichText(
                                  // textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Balance",
                                        style: GoogleFonts.lato(
                                          color: ((amount + transactionFee) >
                                                  walletController.walletModel!
                                                      .wallet![0].mainBalance)
                                              ? Colors.grey
                                              : brandOne,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '(${ch8t.format(walletController.walletModel!.wallet![0].mainBalance)})',
                                        style: GoogleFonts.roboto(
                                          color: ((amount + transactionFee) >
                                                  walletController.walletModel!
                                                      .wallet![0].mainBalance)
                                              ? Colors.grey
                                              : brandOne,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
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
                                        style: GoogleFonts.lato(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
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
                                              style: GoogleFonts.lato(
                                                color: brandOne,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              color: brandOne,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      )
                                    : const Icon(
                                        Icons.check,
                                        color: brandOne,
                                        size: 20,
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 35.h,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width - 50, 50),
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
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 25,
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
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 25,
                                                        color: brandOne,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: brandOne,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    submittedPinTheme: PinTheme(
                                                      width: 50,
                                                      height: 50,
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 25,
                                                        color: brandOne,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: brandOne,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    followingPinTheme: PinTheme(
                                                      width: 50,
                                                      height: 50,
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 25,
                                                        color: brandOne,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: brandTwo,
                                                            width: 1.0),
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
                                                        // _doWallet();
                                                        appState.transferMoney(
                                                            context,
                                                            bankCode,
                                                            amount,
                                                            accountNumber
                                                                .toString(),
                                                            _aPinController.text
                                                                .trim()
                                                                .toString(),
                                                            accountName,
                                                            bankName);
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
                                                    textStyle: GoogleFonts.lato(
                                                      color: brandOne,
                                                      fontSize: 24,
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
                                style: GoogleFonts.lato(
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
                      //           size: 20,
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
                        style: GoogleFonts.lato(
                          color: brandOne,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        'Do you want to cancel this payment?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            color: brandOne,
                            fontSize: 12,
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
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width - 50, 50),
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
                              style: GoogleFonts.lato(
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
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width - 50, 50),
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
                              style: GoogleFonts.lato(
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
      child: const Icon(
        Icons.close,
        color: brandOne,
        size: 20,
      ),
    );
  }
}
