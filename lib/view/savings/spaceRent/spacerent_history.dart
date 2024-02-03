import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rentspace/controller/rent_controller.dart';

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
    DateTime dateTime = DateTime.parse(dateString);
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
      _payments = rentController.rent[0].history.reversed.toList();
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
          style: GoogleFonts.nunito(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            rentController.rent[widget.current].history.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/card_empty.png',
                        height: 500,
                      ),
                      Center(
                        child: Text(
                          "Nothing to show",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
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
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                            ),
                            child: Image.asset(
                              "assets/icons/savings/spacerent.png",
                              height: 20,
                              width: 20,
                              color: brandOne,
                            ),
                          ),
                          title: Text(
                            'Space Rent Saving',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            // _payments[index]
                            //     .split(" ")[0]
                            //     .substring(0,
                            //         _payments[index].split(" ")[0].length - 3)
                            // _formatTime(_formatedTime(_payments[index]
                            //     .split(" ")[0]
                            //     .substring(0,
                            //         _payments[index].split(" ")[0].length - 3))
                            // DateTime.parse(_payments[index]
                            //   .split(" ")[0]
                            //   .substring(0,
                            //       _payments[index].split(" ")[0].length - 3)))
                            // DateFormat.yMMMMd().add_jm().format(
                            //       DateTime.parse((_payments[index]
                            //           .split(" ")[0]
                            //           .substring(
                            //               0,
                            //               _payments[index]
                            //                       .split(" ")[0]
                            //                       .length -
                            //                   3)).toString()),
                            //     )
                            // _payments[index]
                            _formatTime(DateTime.parse((_payments[index]
                                    .split(" ")[0]
                                    .substring(
                                        0,
                                        _payments[index].split(" ")[0].length -
                                            4))))
                                .toString(),
                            style: GoogleFonts.nunito(
                              color: brandTwo,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // onTap: () {
                          //   Get.to(
                          //       CustomTransactionDetailsCard(current: index));
                          //   // Navigator.pushNamed(context, RouteList.profile);
                          // },
                          trailing: Text(
                            '+ ₦${extractAmount(rentController.rent[0].history.reversed.toList()[index])}',
                            // '+ ${_payments[index].split(" ").last}',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
