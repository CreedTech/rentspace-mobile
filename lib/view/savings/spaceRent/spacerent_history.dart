import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
import 'package:convert/convert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/widgets/custom_transaction_details_card.dart';
import 'package:rentspace/controller/rent_controller.dart';

class SpaceRentHistory extends StatefulWidget {
  int current;
  SpaceRentHistory({super.key, required this.current});

  @override
  _SpaceRentHistoryState createState() => _SpaceRentHistoryState();
}

doSomeThing() {
//   String paymentInfo = "2023-09-26T18:19:21.676 New Payment Recorded ₦104";

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
}

class _SpaceRentHistoryState extends State<SpaceRentHistory> {
  final RentController rentController = Get.find();
  // List _payments = [
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  //   "2023-09-26T18:19:21.676 New Payment Recorded ₦104",
  // ];
  List _payments = [];

  @override
  initState() {
    super.initState();
    print(_payments.length);
    // doSomeThing();
    setState(() {
      _payments = rentController.rent[widget.current].history.reversed.toList();
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
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: brandOne,
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
                        'assets/empty_state.png',
                        height: 500,
                      ),
                      const Center(
                        child: Text(
                          "Nothing to show",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "DefaultFontFamily",
                            color: brandOne,
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
                              color: brandTwo.withOpacity(0.2),
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
                              color: brandOne,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat.yMMMMd().add_jm().format(
                                  DateTime.parse(
                                      _payments[index].split(" ")[0]),
                                ),
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
                            '+ ${_payments[index].split(" ").last}',
                            style: GoogleFonts.nunito(
                              color: brandOne,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                      // return Padding(
                      //   padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10),
                      //   child: Container(
                      //     color: Colors.transparent,
                      //     padding: const EdgeInsets.fromLTRB(10.0, 2, 10.0, 2),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         Icon(
                      //           Icons.radio_button_checked_outlined,
                      //           color: Theme.of(context).primaryColor,
                      //           size: 20,
                      //         ),
                      //         const SizedBox(
                      //           width: 10,
                      //         ),
                      //         Text(
                      //           _payments[index],
                      //           style: TextStyle(
                      //             fontSize: 20,
                      //             color: Theme.of(context).primaryColor,
                      //             fontFamily: "DefaultFontFamily",
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // );
                    },
                  ),
          ],
        ),
      ),
      //  Container(
      //   height: double.infinity,
      //   width: double.infinity,
      //   // decoration: const BoxDecoration(
      //   //   image: DecorationImage(
      //   //     image: AssetImage("assets/icons/RentSpace-icon.png"),
      //   //     fit: BoxFit.cover,
      //   //     opacity: 0.1,
      //   //   ),
      //   // ),
      //   child: ListView(
      //     scrollDirection: Axis.vertical,
      //     shrinkWrap: true,
      //     physics: const ClampingScrollPhysics(),
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Text(
      //               'Transaction history',
      //               style: TextStyle(
      //                 fontFamily: "DefaultFontFamily",
      //                 color: Theme.of(context).primaryColor,
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: 16,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 10,
      //       ),
      //       rentController.rent[widget.current].history.isEmpty
      //           ? const Center(
      //               child: Text(
      //                 "Nothing to show",
      //                 style: TextStyle(
      //                   fontSize: 20,
      //                   fontFamily: "DefaultFontFamily",
      //                   color: brandOne,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             )
      //           : ListView.builder(
      //               scrollDirection: Axis.vertical,
      //               shrinkWrap: true,
      //               physics: const ClampingScrollPhysics(),
      //               itemCount: 20,
      //               itemBuilder: (BuildContext context, int index) {
      //                 return Padding(
      //                   padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10),
      //                   child: Container(
      //                     color: Colors.transparent,
      //                     padding: const EdgeInsets.fromLTRB(10.0, 2, 10.0, 2),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.start,
      //                       children: [
      //                         Icon(
      //                           Icons.radio_button_checked_outlined,
      //                           color: Theme.of(context).primaryColor,
      //                           size: 20,
      //                         ),
      //                         const SizedBox(
      //                           width: 10,
      //                         ),
      //                         Text(
      //                           'yo',
      //                           style: TextStyle(
      //                             fontSize: 20,
      //                             color: Theme.of(context).primaryColor,
      //                             fontFamily: "DefaultFontFamily",
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               },
      //             ),
      //     ],
      //   ),
      // ),

      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
