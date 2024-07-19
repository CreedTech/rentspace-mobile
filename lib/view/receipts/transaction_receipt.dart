import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/bank_constants.dart';
import 'package:rentspace/view/receipts/receipt.dart';

import '../../constants/colors.dart';
import '../../constants/utils/formatDateTime.dart';

class TransactionReceipt extends StatefulWidget {
  const TransactionReceipt({
    super.key,
  });

  @override
  State<TransactionReceipt> createState() => _TransactionReceiptState();
}

var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');

class _TransactionReceiptState extends State<TransactionReceipt> {
  String? bankName;
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    Map<String, dynamic>? transactionData;

    // Check if arguments are not null and of the correct type
    if (arguments != null && arguments is Map<String, dynamic>) {
      transactionData = arguments;
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            context.pop();
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
                'Transaction Details',
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
      body: SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
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
                                  color: Theme.of(context).colorScheme.primary),
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
                          color: Theme.of(context).canvasColor,
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
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Text(
                              '${(transactionData['transactionType'] == 'Credit') ? '+' : '-'} ${currencyFormat.format((transactionData['amount']))}',
                              style: GoogleFonts.roboto(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
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
                        color: Theme.of(context).canvasColor,
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
                                        color:
                                            Theme.of(context).primaryColorLight,
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
                                                      'userUtilityNumber'] ??
                                                  '00000000'
                                              : '${transactionData['accountName'] ?? 'Rentspace'}'
                                                  .capitalize!,
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        Text(
                                          (transactionData['transactionGroup']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'bill')
                                              ? transactionData['biller'] ??
                                                  'Bill'
                                              : '${bankName ?? transactionData['bankName'] ?? ''}'
                                                  .toString()
                                                  .toUpperCase()
                                                  .capitalize!,
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Divider(
                              thickness: 1,
                              color: Theme.of(context).dividerColor,
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
                                  color: Theme.of(context).primaryColorLight,
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
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Divider(
                              thickness: 1,
                              color: Theme.of(context).dividerColor,
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
                                      color:
                                          Theme.of(context).primaryColorLight,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    currencyFormat.format(
                                        double.parse(transactionData['fees'])),
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Divider(
                              thickness: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 8,
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
                                        color:
                                            Theme.of(context).primaryColorLight,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: GestureDetector(
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const SizedBox(),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Image.asset(
                                            'assets/icons/copy_icon.png',
                                            width: 24,
                                            height: 24,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Divider(
                              thickness: 1,
                              color: Theme.of(context).dividerColor,
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
                                  color: Theme.of(context).primaryColorLight,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
