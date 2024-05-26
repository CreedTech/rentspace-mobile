import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../constants/utils/formatDateTime.dart';
import '../../constants/widgets/separator.dart';

class TransactionReceiptDVA extends StatefulWidget {
  const TransactionReceiptDVA(
      {super.key,
      required this.amount,
      required this.status,
      required this.fees,
      required this.transactionType,
      required this.description,
      required this.transactionGroup,
      required this.transactionDate,
      required this.transactionRef,
      required this.merchantRef,
      required this.remarks});
  final num amount;
  final String status,
      fees,
      transactionType,
      description,
      transactionGroup,
      transactionDate,
      transactionRef,
      remarks,
      merchantRef;

  @override
  State<TransactionReceiptDVA> createState() => _TransactionReceiptDVAState();
}

var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');

class _TransactionReceiptDVAState extends State<TransactionReceiptDVA> {
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
          style: GoogleFonts.lato(
            color: brandOne,
            fontSize: 16,
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
                child: ListView(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '+ ${currencyFormat.format(widget.amount)}',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                              // letterSpacing: 2,
                              color: brandOne,
                            ),
                          ),
                          (widget.status.toLowerCase() == 'completed')
                              ? Text(
                                  'Successful',
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                )
                              : (widget.status.toLowerCase() == 'failed')
                                  ? Text(
                                      'Failed',
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    )
                                  : Text(
                                      'Pending',
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.yellow[800],
                                      ),
                                    ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: brandTwo.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'The Recipient Account is to be credited within 5 minutes, subject to notification by the bank.',
                        style: GoogleFonts.lato(
                          color: brandOne.withOpacity(0.7),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    const MySeparator(),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                // fontSize: 16,
                                color: brandOne,
                              ),
                            ),
                            Text(
                              currencyFormat.format(widget.amount),
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                // fontSize: 16,
                                color: brandOne,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fee',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                // fontSize: 16,
                                color: brandOne,
                              ),
                            ),
                            Text(
                              currencyFormat.format(double.parse(widget.fees)),
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                // fontSize: 16,
                                color: brandOne,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const MySeparator(),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Transaction Details',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: brandOne,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Description',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: brandTwo,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Text(
                                widget.remarks,
                                textAlign: TextAlign.end,
                                // maxLines: 2,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: brandOne,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Transaction Type',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: brandTwo,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Text(
                                'Wallet Funding Through Virtual Account'
                                    .capitalize!,
                                textAlign: TextAlign.end,
                                // maxLines: 2,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: brandOne,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Payment Method',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: brandTwo,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Text(
                                'Space Wallet'.capitalizeFirst!,
                                textAlign: TextAlign.end,
                                // maxLines: 2,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: brandOne,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                'Transaction Reference',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: brandTwo,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                children: [
                                  Text(
                                    widget.transactionRef,
                                    textAlign: TextAlign.end,
                                    // maxLines: 2,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: brandOne,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: widget.transactionRef,
                                        ),
                                      );
                                      Fluttertoast.showToast(
                                        msg: "Copied to clipboard!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: brandOne,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    },
                                    child: const Icon(
                                      Icons.copy,
                                      size: 16,
                                      color: brandOne,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Merchant Reference',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: brandTwo,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Text(
                                widget.merchantRef,
                                textAlign: TextAlign.end,
                                // maxLines: 2,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: brandOne,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Transaction Date',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: brandTwo,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Text(
                                formatDateTime(widget.transactionDate),
                                textAlign: TextAlign.end,
                                // maxLines: 2,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: brandOne,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Flexible(
                        //       flex: 1,
                        //       child: Text(
                        //         'Session ID',
                        //         style: GoogleFonts.lato(
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: 14,
                        //           color: brandTwo,
                        //         ),
                        //       ),
                        //     ),
                        //     Flexible(
                        //       flex: 3,
                        //       child: Wrap(
                        //         alignment: WrapAlignment.end,
                        //         crossAxisAlignment: WrapCrossAlignment.end,
                        //         children: [
                        //           Text(
                        //             widget.remarks.split('/').last,
                        //             textAlign: TextAlign.end,
                        //             // maxLines: 2,
                        //             style: GoogleFonts.lato(
                        //               fontWeight: FontWeight.w600,
                        //               fontSize: 14,
                        //               color: brandOne,
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 5,
                        //           ),
                        //           InkWell(
                        //             onTap: () {
                        //               Clipboard.setData(
                        //                 ClipboardData(
                        //                   text: widget.remarks.split('/').last,
                        //                 ),
                        //               );
                        //               Fluttertoast.showToast(
                        //                 msg: "Copied to clipboard!",
                        //                 toastLength: Toast.LENGTH_SHORT,
                        //                 gravity: ToastGravity.CENTER,
                        //                 timeInSecForIosWeb: 1,
                        //                 backgroundColor: brandOne,
                        //                 textColor: Colors.white,
                        //                 fontSize: 16.0,
                        //               );
                        //             },
                        //             child: const Icon(
                        //               Icons.copy,
                        //               size: 16,
                        //               color: brandOne,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    )
                  ],
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         minimumSize: const Size(300, 50),
              //         backgroundColor: brandOne,
              //         elevation: 0,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(
              //             10,
              //           ),
              //         ),
              //       ),
              //       onPressed: () {},
              //       child: Text(
              //         'Share Receipt',
              //         textAlign: TextAlign.center,
              //         style: GoogleFonts.lato(
              //             fontSize: 16, fontWeight: FontWeight.w600),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
