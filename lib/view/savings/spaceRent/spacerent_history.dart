import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../controller/rent/rent_controller.dart';
import '../../actions/transaction_receipt.dart';
import 'spacerent_list.dart';

class SpaceRentHistory extends StatefulWidget {
  int current;
  SpaceRentHistory({super.key, required this.current});

  @override
  _SpaceRentHistoryState createState() => _SpaceRentHistoryState();
}

doSomeThing() {
  String paymentInfo = "2023-09-26T18:19:21.676 New Payment Recorded ₦104";

// // Split the string by space
//   List<String> parts = paymentInfo.split(" ");

// // Extract date and time
//   String dateTimeString = "${parts[0]}";
//   DateTime dateTime = DateTime.parse(dateTimeString);
//   String formattedDateTime = DateFormat.yMMMMd().add_jm().format(dateTime);

// // Extract payment description
//   String paymentDescription = parts.sublist(1, parts.length - 1).join(" ");

// // Extract amount
//   String amount = parts.last;

//   print("Date and Time: $formattedDateTime");
//   print("Payment Description: $paymentDescription");
//   print("Amount: $amount");

  String dateString = (paymentInfo
      .split(" ")[0]
      .substring(0, paymentInfo.split(" ")[0].length - 4));

  try {
    DateTime dateTime =
        DateTime.parse(dateString).add(const Duration(hours: 1));
    print("Parsed DateTime: $dateTime");
  } catch (e) {
    print("Error parsing date: $e");
  }
}

class _SpaceRentHistoryState extends State<SpaceRentHistory> {
  final RentController rentController = Get.find();

  List _payments = [];

  @override
  initState() {
    super.initState();
    doSomeThing();
    setState(() {
      _payments =
          rentController.rentModel!.rents![widget.current].rentHistories;
    });
  }

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
            Icons.close,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Transaction History',
          style: GoogleFonts.poppins(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            rentController
                    .rentModel!.rents![widget.current].rentHistories.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/card_empty.png',
                        height: 500.h,
                      ),
                      Center(
                        child: Text(
                          "No Space Rent Transactions",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _payments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(TransactionReceipt(
                              amount: _payments[index]['amount'],
                              status: _payments[index]['status'],
                              fees: _payments[index]['fees'],
                              transactionType: _payments[index]['message'],
                              description: _payments[index]['description'],
                              transactionGroup: 'Wallet Payment',
                              transactionDate: _payments[index]['createdAt'],
                              transactionRef: _payments[index]
                                  ['transactionReference'],
                              merchantRef: _payments[index]
                                  ['merchantReference'],
                            ));
                          },
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: brandOne,
                              ),
                              child: Image.asset(
                                "assets/icons/savings/spacerent.png",
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              _payments[index]['message'],
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              _formatTime(DateTime.parse(
                                      (_payments[index]['createdAt']))
                                  .add(const Duration(hours: 1))),
                              style: GoogleFonts.poppins(
                                color: brandOne,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: Text(
                              '+ ${ch8t.format(_payments[index]['amount'])}',
                              style: GoogleFonts.roboto(
                                color: Colors.green,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  String extractAmount(String input) {
    final nairaIndex = input.indexOf('₦');
    if (nairaIndex != -1 && nairaIndex < input.length - 1) {
      return input.substring(nairaIndex + 1).trim();
    }
    return '';
  }
}
