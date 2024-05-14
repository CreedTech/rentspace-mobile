import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../FirstPage.dart';
import 'wallet_funding.dart';

class CardTopUp extends StatefulWidget {
  const CardTopUp({super.key});

  @override
  State<CardTopUp> createState() => _CardTopUpState();
}

var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);

class _CardTopUpState extends State<CardTopUp> {
  TextEditingController _amountController = TextEditingController();
  final fundWalletFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    validateAmount(amountValue) {
      if (amountValue.isEmpty) {
        return 'minimum amount is ₦500.00 and maximum is ₦9,999.00';
      }
      if (int.tryParse(_amountController.text.trim().replaceAll(',', '')) ==
          null) {
        return 'enter valid number';
      }
      if ((int.tryParse(_amountController.text.trim().replaceAll(',', '')) ==
              0) ||
          (int.tryParse(_amountController.text.trim().replaceAll(',', ''))! <
              100)) {
        return 'minimum amount is ₦500.00';
      }
      if ((int.tryParse(_amountController.text.trim().replaceAll(',', '')) ==
              0) ||
          (int.tryParse(_amountController.text.trim().replaceAll(',', ''))! >
              9999.99)) {
        return 'maximum amount is ₦9,999.00';
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
      style: GoogleFonts.lato(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.number,
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
          color: brandOne,
          fontSize: 18,
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
        hintText: 'amount in Naira',
        hintStyle: GoogleFonts.lato(
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
            Icons.arrow_back_ios,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Top Up With Card',
          style: GoogleFonts.lato(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                10,
                16,
                10,
              ),
              child: ListView(
                children: [
                  Form(
                    key: fundWalletFormKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              child: Text(
                                'Amount',
                                style: GoogleFonts.lato(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  // fontFamily: "DefaultFontFamily",
                                ),
                              ),
                            ),
                            amount,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              child: Text(
                                'Use Bank Transfer if amount exceeds ₦9,999.99',
                                style: GoogleFonts.lato(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  // fontFamily: "DefaultFontFamily",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(350, 50),
                            backgroundColor: brandOne,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10.r,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (fundWalletFormKey.currentState!.validate()) {
                              Get.to(WalletFunding(
                                amount: int.tryParse(_amountController.text
                                    .trim()
                                    .replaceAll(',', ''))!,
                                date: formattedDate,
                                interval: "",
                                numPayment: 1,
                                savingsID: userController
                                    .userModel!.userDetails![0].id,
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
