import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';

class UtilityTransactionReceipt extends StatefulWidget {
  const UtilityTransactionReceipt({super.key});

  @override
  State<UtilityTransactionReceipt> createState() =>
      _UtilityTransactionReceiptState();
}

var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');

class _UtilityTransactionReceiptState extends State<UtilityTransactionReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: true,
        title: Text(
          'Transaction Details',
          style: GoogleFonts.nunito(
            color: brandOne,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 20.w,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Image.asset(
                    //       'assets/icons/RentSpace-icon.png',
                    //       width: 50,
                    //     ),
                    //     Text('Transaction Receipt',
                    //     style: GoogleFonts.nunito(
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: 14.sp,
                    //       color: brandOne,
                    //     ),),
                    //   ],
                    // ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '- ${currencyFormat.format(10000)}',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w800,
                              fontSize: 28.sp,
                              // letterSpacing: 2,
                              color: brandOne,
                            ),
                          ),
                          Text(
                            'Successful',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: const Color.fromARGB(255, 1, 197, 8),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 50),
                      backgroundColor: brandOne,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Share Receipt',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
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
