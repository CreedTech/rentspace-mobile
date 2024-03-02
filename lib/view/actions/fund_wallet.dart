import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/constants/utils/snackbar.dart';
// import 'package:rentspace/controller/user_controller.dart';
// import 'package:rentspace/constants/theme_services.dart';
// import 'package:get_storage/get_storage.dart';
// import 'dart:io';
// import 'package:getwidget/getwidget.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/view/actions/wallet_funding.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

import '../../constants/widgets/custom_dialog.dart';

class FundWallet extends StatefulWidget {
  const FundWallet({Key? key}) : super(key: key);

  @override
  _FundWalletState createState() => _FundWalletState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
String _isSet = "false";
var dum1 = "".obs;

// CollectionReference users = FirebaseFirestore.instance.collection('accounts');
// CollectionReference allUsers =
//     FirebaseFirestore.instance.collection('accounts');

class _FundWalletState extends State<FundWallet> {
  final UserController userController = Get.find();
  final form = intl.NumberFormat.decimalPattern();

  TextEditingController _amountController = TextEditingController();
  final fundWalletFormKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    validateAmount(amountValue) {
      if (amountValue.isEmpty) {
        return 'amount cannot be empty';
      }
      if (int.tryParse(_amountController.text.trim().replaceAll(',', '')) ==
          null) {
        return 'enter valid number';
      }
      if ((int.tryParse(_amountController.text.trim().replaceAll(',', '')) ==
              0) ||
          (int.tryParse(_amountController.text.trim().replaceAll(',', ''))! <
              100)) {
        return 'minimum amount is ₦100';
      }
      if (int.tryParse(_amountController.text.trim().replaceAll(',', ''))!
          .isNegative) {
        return 'enter valid number';
      }
      return null;
    }

    final amount = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _amountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [ThousandsFormatter()],
      validator: validateAmount,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(
          "Enter amount",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        prefixText: "₦",
        prefixStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.w400,
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
        hintText: 'amount in Naira',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.close,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Fund Wallet',
          style: GoogleFonts.nunito(
              color: Theme.of(context).primaryColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: ListView(
              children: [
                Form(
                  key: fundWalletFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60.h,
                      ),
                      amount,
                      SizedBox(
                        height: 80.h,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 50),
                          backgroundColor: brandOne,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.r,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (fundWalletFormKey.currentState!.validate()) {
                            Get.to(WalletFunding(
                              amount: int.tryParse(_amountController.text
                                  .trim()
                                  .replaceAll(',', ''))!,
                              date: formattedDate,
                              interval: "",
                              numPayment: 1,
                              savingsID:
                                  userController.userModel!.userDetails![0].id,
                            ));
                          } else {
                            customErrorDialog(context, "Invalid!",
                                "Please fill the form properly to proceed");
                          }
                        },
                        child: const Text(
                          'Fund Now',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100.h,
                ),
                (userController.userModel!.userDetails![0].hasDva == true)
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 40.h, horizontal: 40.h),
                        decoration: BoxDecoration(
                          color: brandTwo.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Or use your Virtual Account to Fund your SpaceWallet',
                              style: GoogleFonts.nunito(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  'Account Name: ',
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  userController
                                      .userModel!.userDetails![0].dvaName,
                                  maxLines: 2,
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Account Number: ',
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                // userController.user[0].dvaNumber
                                Text(
                                  userController
                                      .userModel!.userDetails![0].dvaNumber,
                                  maxLines: 2,
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.sp,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: userController.userModel!
                                            .userDetails![0].dvaNumber,
                                      ),
                                    );

                                    Fluttertoast.showToast(
                                      msg: "Copied!!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: brandOne,
                                      textColor: Colors.white,
                                      fontSize: 12.0.sp,
                                    );
                                  },
                                  child: Icon(
                                    Icons.copy_outlined,
                                    size: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.sp,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Bank Name: ',
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Providus Bank',
                                  maxLines: 2,
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                             SizedBox(
                              height: 20.sp,
                            ),
                            Center(
                              child: Text(
                                '(Note that this can take few minutes for your transaction to be verified)',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Colors.red,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
