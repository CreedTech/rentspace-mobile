import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet/wallet_controller.dart';
import 'transfer_confirmation_page.dart';

class WithdrawContinuationPage extends StatefulWidget {
  const WithdrawContinuationPage(
      {super.key,
      required this.bankCode,
      required this.accountNumber,
      required this.bankName,
      required this.accountHolderName});
  final String bankCode, accountNumber, bankName, accountHolderName;

  @override
  State<WithdrawContinuationPage> createState() =>
      _WithdrawContinuationPageState();
}

class _WithdrawContinuationPageState extends State<WithdrawContinuationPage> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _narrationController = TextEditingController();
  final withdrawalContdFormKey = GlobalKey<FormState>();
  var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  Future<bool> fetchUserData({bool refresh = true}) async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    if (refresh) {
      // print('fetching');
      await userController.fetchData();
      // await userController.fetchRecentTransfers();
      await walletController.fetchWallet();
      // print('fetched');
    }
    EasyLoading.dismiss();
    return true;
  }

  @override
  void initState() {
    super.initState();
    getConnectivity();
    _bankController.text = widget.bankName.toUpperCase();
    _accountNumberController.text = widget.accountNumber.toString();
    fetchUserData();
  }

  void getConnectivity() {
    // print('checking internet...');
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
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                          color: Theme.of(context).colorScheme.primary,
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
                          color: Theme.of(context).colorScheme.primary,
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
    double? mainBalanceDouble = double.tryParse(
        walletController.walletModel!.wallet![0].mainBalance.toString());

    validateAmount(amountValue) {
      double? amountValueDouble = double.tryParse(amountValue);
      if (amountValue.isEmpty) {
        return '';
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
      if ((amountValueDouble! + 20) > mainBalanceDouble!) {
        return 'Insufficient balance';
      }
      return null;
    }

    final amount = TextFormField(
      enableSuggestions: true,
      controller: _amountController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      cursorColor: Theme.of(context).colorScheme.primary,
      inputFormatters: [ThousandsFormatter()],
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      keyboardType: TextInputType.number,
      // onChanged: (String) {
      //   // setState(() {});
      // },
      // onChanged: (value) {
      //   setState(() {
      //     // Check if the text field is empty
      //     isTextFieldEmpty = value.isNotEmpty &&
      //         int.tryParse(value) != null &&
      //         int.parse(value) >= 10 &&
      //         !(int.tryParse(value)!.isNegative) &&
      //         int.tryParse(value.trim().replaceAll(',', '')) != 0;
      //   });
      // },
      decoration: InputDecoration(
        // label: Text(
        //   "Enter amount",
        //   style: GoogleFonts.lato(
        //     color: Colors.grey,
        //     fontSize: 12,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        prefixText: "₦ ",
        prefixStyle: GoogleFonts.roboto(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Colors.red, width: 1.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
    );

    final narration = TextFormField(
      enableSuggestions: true,
      controller: _narrationController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      keyboardType: TextInputType.text,
      onChanged: (String) {
        setState(() {});
      },
      maxLength: 35,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Colors.red, width: 1.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
    );

    final accountNumber = TextFormField(
      // enabled: false,
      readOnly: true,
      autovalidateMode: AutovalidateMode.disabled,
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),

      controller: _accountNumberController,
      textAlignVertical: TextAlignVertical.center,
      // textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromRGBO(189, 189, 189, 30)
                  : const Color.fromRGBO(189, 189, 189, 100),
              width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.all(14),
      ),
      maxLines: 1,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            Get.back();
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
                'Withdraw',
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15.h,
              horizontal: 24.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? colorWhite.withOpacity(0.2)
                                  : colorWhite,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.lato(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Space Wallet: ',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      )),
                                  TextSpan(
                                    text: currencyFormat.format(walletController
                                        .walletModel!.wallet![0].mainBalance),
                                    style: GoogleFonts.roboto(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 24,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.4,
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.lato(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 14,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Please note that there is a',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ₦20',
                                        style: GoogleFonts.roboto(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' charge on all transfer.',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Withdrawal Account',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: withdrawalContdFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Opacity(
                                      opacity: 0.6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.h, horizontal: 3.w),
                                            child: Text(
                                              'Select Bank',
                                              style: GoogleFonts.lato(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          TextFormField(
                                            // enabled: false,
                                            readOnly: true,
                                            autovalidateMode:
                                                AutovalidateMode.disabled,
                                            enableSuggestions: true,
                                            cursorColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            style: GoogleFonts.lato(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 14),

                                            controller: _bankController,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            // textCapitalization: TextCapitalization.sentences,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? const Color.fromRGBO(
                                                          189, 189, 189, 30)
                                                      : const Color.fromRGBO(
                                                          189, 189, 189, 100),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? const Color.fromRGBO(
                                                            189, 189, 189, 30)
                                                        : const Color.fromRGBO(
                                                            189, 189, 189, 100),
                                                    width: 1.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? const Color.fromRGBO(
                                                          189, 189, 189, 30)
                                                      : const Color.fromRGBO(
                                                          189, 189, 189, 100),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.red,
                                                    width:
                                                        2.0), // Change color to yellow
                                              ),
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 18,
                                                        vertical: 12),
                                                child: Image.asset(
                                                  'assets/icons/bank_icon.png',
                                                  width: 26,
                                                  // Ensure the image fits inside the circle
                                                ),
                                              ),
                                              // label: Text(
                                              //   widget.bankName.toUpperCase(),
                                              //   style: GoogleFonts.lato(
                                              //     fontSize: 14,
                                              //     fontWeight: FontWeight.w400,
                                              //   ),
                                              // ),
                                              filled: false,
                                              fillColor: Colors.transparent,
                                              contentPadding:
                                                  const EdgeInsets.all(14),
                                            ),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Opacity(
                                      opacity: 0.6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.h, horizontal: 3.w),
                                            child: Text(
                                              'Account Number',
                                              style: GoogleFonts.lato(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          accountNumber
                                        ],
                                      ),
                                    ),
                                    Opacity(
                                      opacity: 0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffEEF8FF),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            widget.accountHolderName,
                                            style: GoogleFonts.lato(
                                              color: brandOne,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        'Amount',
                                        style: GoogleFonts.lato(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ),
                                    ),
                                    amount
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        'Narration',
                                        style: GoogleFonts.lato(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ),
                                    ),
                                    narration
                                  ],
                                ),
                                SizedBox(
                                  height: 140.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
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
                      onPressed: withdrawalContdFormKey.currentState != null &&
                              withdrawalContdFormKey.currentState!.validate()
                          ? () async {
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TransferConfirmationPage(
                                    bankName: widget.bankName,
                                    accountNumber: widget.accountNumber,
                                    bankCode: widget.bankCode,
                                    accountName: widget.accountHolderName,
                                    amount: _amountController.text,
                                    narration: _narrationController.text ?? '',
                                  ),
                                ),
                              );
                              // Proceed with the action
                            }
                          : null,
                      child: Text(
                        'Proceed',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          color: colorWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
