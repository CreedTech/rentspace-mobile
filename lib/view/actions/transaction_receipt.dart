import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/bank_constants.dart';
import 'package:rentspace/view/actions/receipt.dart';

import '../../constants/colors.dart';
import '../../constants/utils/formatDateTime.dart';

class TransactionReceipt extends StatefulWidget {
  const TransactionReceipt({
    super.key,
  });
  // final num amount;
  // final String status,
  //     fees,
  //     transactionType,
  //     description,
  //     transactionGroup,
  //     transactionDate,
  //     transactionRef,
  //     merchantRef;

  @override
  State<TransactionReceipt> createState() => _TransactionReceiptState();
}

var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');

class _TransactionReceiptState extends State<TransactionReceipt> {
  String? bankName;
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    print('arguments ==========================');
    print(arguments);
    Map<String, dynamic>? transactionData;

    // Check if arguments are not null and of the correct type
    if (arguments != null && arguments is Map<String, dynamic>) {
      transactionData = arguments;
      print('transactionData ==========================');
      print(transactionData);
    }

    final bankCode = transactionData!['bankName'] ??
        ''; // Extract bank code from the response

// Check if the bank code exists in your bank data map
    if (BankConstants.bankData.containsKey(bankCode)) {
      // Bank details found, you can now use them
      bankName = BankConstants.bankData[bankCode];
      // print('Bank Name: $bankName');
    } else {
      // No matching bank found for the given code
      // print('No bank found for code: $bankCode');
    }
    // print(bankName!);

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffF6F6F8),
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
                color: colorBlack,
              ),
            ),
            SizedBox(
              width: 4.h,
            ),
            Text(
              'Transaction Details',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: colorWhite,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 18.h,
              horizontal: 24.w,
            ),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.swap_horizontal_circle,
                                  color: brandTwo,
                                  size: 26,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  (() {
                                    final transactionGroup =
                                        transactionData!['transactionGroup']
                                            .toString()
                                            .toLowerCase();
                                    final merchantRef =
                                        transactionData['merchantReference']
                                            .toString()
                                            .toLowerCase();
                                    print(transactionGroup);
                                    if (transactionGroup ==
                                            'virtual-account'.toLowerCase() ||
                                        transactionGroup ==
                                            'virtual-account'.toLowerCase() ||
                                        transactionGroup ==
                                            'static-account-transfer'
                                                .toLowerCase() ||
                                        transactionGroup ==
                                            'Payment'.toLowerCase()) {
                                      return 'Account Funding';
                                    } else if (merchantRef
                                        .startsWith('ren'.toLowerCase())) {
                                      return 'Space Rent';
                                    } else if (transactionGroup ==
                                            'transfer'.toLowerCase() ||
                                        merchantRef
                                            .startsWith('trf'.toLowerCase())) {
                                      return 'Transfer';
                                    } else if (transactionGroup ==
                                        'bill'.toLowerCase()) {
                                      return 'Bill';
                                    } else {
                                      return 'Payment'; // Default to 'Successful' if status doesn't match any condition
                                    }
                                  })(),
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: colorBlack),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              formatDateTime(transactionData['createdAt']),
                              style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: colorBlack),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFFFFFFFF),
                            minimumSize: const Size(0, 40),
                            backgroundColor: brandTwo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Receipt(type: 'share'),
                                settings:
                                    RouteSettings(arguments: transactionData),
                              ),
                            );
                          },
                          child: Text(
                            'Share',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.h,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height: 92.h,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 14),
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
                              '${(transactionData['transactionType'] == 'Credit') ? '+' : '-'} ${currencyFormat.format((transactionData['amount']))}',
                              style: GoogleFonts.lato(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: colorBlack,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'To',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff4B4B4B),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (transactionData['transactionGroup']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'bill')
                                              ? transactionData[
                                                  'userUtilityNumber']
                                              : '${transactionData['accountName'] ?? 'Rentspace'}'
                                                  .capitalize!,
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: colorBlack,
                                          ),
                                        ),
                                        Text(
                                          (transactionData['transactionGroup']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'bill')
                                              ? transactionData['biller']
                                                  .toString()
                                                  .toUpperCase()
                                              : '${bankName ?? transactionData['bankName'] ?? ''}'
                                                  .capitalize!,
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: colorBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  // GLO_VBANK
                                  // 9MOBILE_NIGERIA
                                  // airng
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: ClipOval(
                                  child: Image.asset(
                                    (transactionData['transactionGroup']
                                                .toString()
                                                .toLowerCase() ==
                                            'bill')
                                        ? (transactionData['biller']
                                                    .toString()
                                                    .toLowerCase() ==
                                                'mtnng')
                                            ? 'assets/utility/mtn.jpg'
                                            : (transactionData['biller']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'airng')
                                                ? 'assets/utility/airtel.jpg'
                                                : (transactionData['biller']
                                                            .toString()
                                                            .toLowerCase() ==
                                                        'glo_vbank')
                                                    ? 'assets/utility/glo.jpg'
                                                    : (transactionData['biller']
                                                                .toString()
                                                                .toLowerCase() ==
                                                            '9mobile_nigeria')
                                                        ? 'assets/utility/9mobile.jpg'
                                                        : 'assets/icons/RentSpace-icon.jpg'
                                        : 'assets/icons/bank_icon.png',
                                    height: 31,
                                    width: 31,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 7),
                            child: Divider(
                              thickness: 1,
                              color: Color(0xffC9C9C9),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Description',
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
                                (transactionData['transactionGroup']
                                            .toString()
                                            .toLowerCase() ==
                                        'bill')
                                    ? transactionData['message']
                                    : transactionData['narration'] ??
                                        transactionData['description'] ??
                                        transactionData['message'],
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: colorBlack,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 7),
                            child: Divider(
                              thickness: 1,
                              color: Color(0xffC9C9C9),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment Method',
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
                                    (transactionData['transactionGroup']
                                                .toString()
                                                .toLowerCase() ==
                                            'bill')
                                        ? 'Space Points'
                                        : 'Space Wallet',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: colorBlack,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Fees',
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
                                    currencyFormat.format(
                                        double.parse(transactionData['fees'])),
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
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 7),
                            child: Divider(
                              thickness: 1,
                              color: Color(0xffC9C9C9),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 9,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Transaction Reference',
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
                                      transactionData['transactionReference'],
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: colorBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: transactionData![
                                                'transactionReference'],
                                          ),
                                        );
                                        Fluttertoast.showToast(
                                          msg: "Copied to clipboard!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.SNACKBAR,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: brandOne,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Image.asset(
                                            'assets/icons/copy_icon.png',
                                            width: 24,
                                            height: 24,
                                            color: colorBlack,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Copy',
                                            style: GoogleFonts.lato(
                                              color: brandTwo,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
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
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 7),
                            child: Divider(
                              thickness: 1,
                              color: Color(0xffC9C9C9),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff4B4B4B),
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: (() {
                                        final status =
                                            transactionData!['status']
                                                .toString()
                                                .toLowerCase();
                                        if (status == 'success' ||
                                            status == 'completed' ||
                                            status == 'successful') {
                                          return Colors.green;
                                        } else if (status == 'failed') {
                                          return Colors.red;
                                        } else if (status == 'pending') {
                                          return Colors.yellow;
                                        } else if (status == 'reversed' ||
                                            status == 'reversal') {
                                          return brandTwo;
                                        } else {
                                          return Colors.green; // Default color
                                        }
                                      })(),
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    (() {
                                      final status = transactionData!['status']
                                          .toString()
                                          .toLowerCase();
                                      if (status == 'success' ||
                                          status == 'completed' ||
                                          status == 'successful') {
                                        return 'Successful';
                                      } else if (status == 'failed') {
                                        return 'Failed';
                                      } else if (status == 'pending') {
                                        return 'Pending';
                                      } else if (status == 'reversed' ||
                                          status == 'reversal') {
                                        return 'Reversed';
                                      } else {
                                        return 'Successful'; // Default to 'Successful' if status doesn't match any condition
                                      }
                                    })(),
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
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding:
                    //       EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                    //   child: Column(
                    //     children: [
                    //       Center(
                    //         child: Column(
                    //           children: [
                    //             Text(
                    //               '+ ${currencyFormat.format(widget.amount)}',
                    //               style: GoogleFonts.lato(
                    //                 fontWeight: FontWeight.w700,
                    //                 fontSize: 28,
                    //                 // letterSpacing: 2,
                    //                 color: brandOne,
                    //               ),
                    //             ),
                    //             (transactionData['status'].toLowerCase() == 'completed')
                    //                 ? Text(
                    //                     'Successful',
                    //                     style: GoogleFonts.lato(
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: 16,
                    //                       color: Colors.green,
                    //                     ),
                    //                   )
                    //                 : (transactionData['status'].toLowerCase() == 'failed')
                    //                     ? Text(
                    //                         'Failed',
                    //                         style: GoogleFonts.lato(
                    //                           fontWeight: FontWeight.w600,
                    //                           fontSize: 16,
                    //                           color: Colors.red,
                    //                         ),
                    //                       )
                    //                     : Text(
                    //                         'Pending',
                    //                         style: GoogleFonts.lato(
                    //                           fontWeight: FontWeight.w600,
                    //                           fontSize: 16,
                    //                           color: Colors.yellow[800],
                    //                         ),
                    //                       ),
                    //           ],
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 15,
                    //       ),
                    //       Container(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 15, vertical: 10),
                    //         decoration: BoxDecoration(
                    //           color: brandTwo.withOpacity(0.2),
                    //           borderRadius: BorderRadius.circular(20),
                    //         ),
                    //         child: Text(
                    //           'The Recipient Account is to be credited within 5 minutes, subject to notification by the bank.',
                    //           style: GoogleFonts.lato(
                    //             color: brandOne.withOpacity(0.7),
                    //             fontSize: 10,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 15,
                    //       ),
                    //       const MySeparator(),
                    //       const SizedBox(
                    //         height: 5,
                    //       ),
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Text(
                    //                 'Amount',
                    //                 style: GoogleFonts.lato(
                    //                   fontWeight: FontWeight.w600,
                    //                   // fontSize: 16,
                    //                   color: brandOne,
                    //                 ),
                    //               ),
                    //               Text(
                    //                 currencyFormat.format(widget.amount),
                    //                 style: GoogleFonts.lato(
                    //                   fontWeight: FontWeight.w600,
                    //                   // fontSize: 16,
                    //                   color: brandOne,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Text(
                    //                 'Fee',
                    //                 style: GoogleFonts.lato(
                    //                   fontWeight: FontWeight.w600,
                    //                   // fontSize: 16,
                    //                   color: brandOne,
                    //                 ),
                    //               ),
                    //               Text(
                    //                 currencyFormat
                    //                     .format(double.parse(widget.fees)),
                    //                 style: GoogleFonts.lato(
                    //                   fontWeight: FontWeight.w600,
                    //                   // fontSize: 16,
                    //                   color: brandOne,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       const MySeparator(),
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       Column(
                    //         children: [
                    //           Row(
                    //             children: [
                    //               Text(
                    //                 'Transaction Details',
                    //                 style: GoogleFonts.lato(
                    //                   fontWeight: FontWeight.w700,
                    //                   fontSize: 16,
                    //                   color: brandOne,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Flexible(
                    //                 flex: 2,
                    //                 child: Text(
                    //                   'Description',
                    //                   style: GoogleFonts.lato(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14,
                    //                     color: brandTwo,
                    //                   ),
                    //                 ),
                    //               ),
                    //               Flexible(
                    //                 flex: 4,
                    //                 child: Text(
                    //                   widget.description,
                    //                   textAlign: TextAlign.end,
                    //                   // maxLines: 2,
                    //                   style: GoogleFonts.lato(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 13,
                    //                     color: brandOne,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Flexible(
                    //                 flex: 2,
                    //                 child: Text(
                    //                   'Transaction Type',
                    //                   style: GoogleFonts.lato(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14,
                    //                     color: brandTwo,
                    //                   ),
                    //                 ),
                    //               ),
                    //               Flexible(
                    //                 flex: 3,
                    //                 child: Text(
                    //                   'Wallet Funding Through ${widget.transactionGroup}',
                    //                   textAlign: TextAlign.end,
                    //                   // maxLines: 2,
                    //                   style: GoogleFonts.lato(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14,
                    //                     color: brandOne,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Flexible(
                    //                 flex: 2,
                    //                 child: Text(
                    //                   'Payment Method',
                    //                   style: GoogleFonts.lato(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14,
                    //                     color: brandTwo,
                    //                   ),
                    //                 ),
                    //               ),
                    //               Flexible(
                    //                 flex: 3,
                    //                 child: Text(
                    //                   'Space Wallet'.capitalizeFirst!,
                    //                   textAlign: TextAlign.end,
                    //                   // maxLines: 2,
                    //                   style: GoogleFonts.lato(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14,
                    //                     color: brandOne,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Flexible(
                    //                 flex: 3,
                    //                 child: Text(
                    //                   'Transaction Reference',
                    //                   style: GoogleFonts.lato(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14,
                    //                     color: brandTwo,
                    //                   ),
                    //                 ),
                    //               ),
                    //               Flexible(
                    //                 flex: 3,
                    //                 child: Wrap(
                    //                   alignment: WrapAlignment.end,
                    //                   crossAxisAlignment: WrapCrossAlignment.end,
                    //                   children: [
                    //                     Text(
                    //                       widget.transactionRef,
                    //                       textAlign: TextAlign.end,
                    //                       // maxLines: 2,
                    //                       style: GoogleFonts.lato(
                    //                         fontWeight: FontWeight.w600,
                    //                         fontSize: 14,
                    //                         color: brandOne,
                    //                       ),
                    //                     ),
                    //                     const SizedBox(
                    //                       width: 5,
                    //                     ),
                    //                     InkWell(
                    //                       onTap: () {
                    //                         Clipboard.setData(
                    //                           ClipboardData(
                    //                             text: widget.transactionRef,
                    //                           ),
                    //                         );
                    //                         Fluttertoast.showToast(
                    //                           msg: "Copied to clipboard!",
                    //                           toastLength: Toast.LENGTH_SHORT,
                    //                           gravity: ToastGravity.CENTER,
                    //                           timeInSecForIosWeb: 1,
                    //                           backgroundColor: brandOne,
                    //                           textColor: Colors.white,
                    //                           fontSize: 16.0,
                    //                         );
                    //                       },
                    //                       child: const Icon(
                    //                         Icons.copy,
                    //                         size: 16,
                    //                         color: brandOne,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Flexible(
                    //                 flex: 2,
                    //                 child: Text(
                    //                   'Merchant Reference',
                    //                   style: GoogleFonts.lato(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14,
                    //                     color: brandTwo,
                    //                   ),
                    //                 ),
                    //               ),
                    //               Flexible(
                    //                 flex: 3,
                    //                 child: Text(
                    //                   widget.merchantRef,
                    //                   textAlign: TextAlign.end,
                    //                   // maxLines: 2,
                    //                   style: GoogleFonts.lato(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14,
                    //                     color: brandOne,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Flexible(
                    //                 flex: 2,
                    //                 child: Text(
                    //                   'Transaction Date',
                    //                   style: GoogleFonts.lato(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14,
                    //                     color: brandTwo,
                    //                   ),
                    //                 ),
                    //               ),
                    //               Flexible(
                    //                 flex: 3,
                    //                 child: Text(
                    //                   formatDateTime(widget.transactionDate),
                    //                   textAlign: TextAlign.end,
                    //                   // maxLines: 2,
                    //                   style: GoogleFonts.lato(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14,
                    //                     color: brandOne,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
