import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';

import 'package:rentspace/view/wallet_funding/bank_transfer.dart';

class FundWallet extends StatefulWidget {
  const FundWallet({super.key});

  @override
  State<FundWallet> createState() => _FundWalletState();
}

class _FundWalletState extends State<FundWallet> {
  @override
  Widget build(BuildContext context) {
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
                'Add Money',
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            child: ListView(
              children: [
                Text(
                  'Choose how you want to fund your wallet',
                  style: GoogleFonts.lato(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Get.to(const BankTransfer());
                  },
                  contentPadding: const EdgeInsets.only(left: 15, right: 11),
                  tileColor: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  leading: Image.asset(
                    'assets/icons/send_box_icon.png',
                    width: 42,
                    height: 42,
                  ),
                  title: Text(
                    'Bank Transfer',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'From your bank app or internet bank',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing:  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 15, right: 11),
                  tileColor: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  leading: Image.asset(
                    'assets/icons/ussd_box_icon.png',
                    width: 42,
                    height: 42,
                  ),
                  title: Text(
                    'USSD',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Use your banks ussd code',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xffEEF8FF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Coming Soon",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: brandOne,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // trailing: const Icon(
                  //   Icons.keyboard_arrow_right_outlined,
                  //   size: 20,
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 15, right: 11),
                  tileColor: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  leading: Image.asset(
                    'assets/icons/card_box_icon.png',
                    width: 42,
                    height: 42,
                  ),
                  title: Text(
                    'Card',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'From your debit card',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xffEEF8FF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Coming Soon",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: brandOne,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
