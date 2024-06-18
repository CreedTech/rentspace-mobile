import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
import 'package:convert/convert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class SpaceDepositHistory extends StatefulWidget {
  int current;
  SpaceDepositHistory({Key? key, required this.current}) : super(key: key);

  @override
  _SpaceDepositHistoryState createState() => _SpaceDepositHistoryState();
}

class _SpaceDepositHistoryState extends State<SpaceDepositHistory> {
  // final DepositController depositController = Get.find();
  List _payments = [];

  @override
  initState() {
    super.initState();
    setState(() {
      // _payments =
      // depositController.deposit[widget.current].history.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: Theme.of(context).canvasColor,
      //   leading: GestureDetector(
      //     onTap: () {
      //       Get.back();
      //     },
      //     child: Icon(
      //       Icons.close,
      //       size: 30,
      //       color: Theme.of(context).primaryColor,
      //     ),
      //   ),
      // ),
      // body: Container(
      //   height: double.infinity,
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage("assets/icons/RentSpace-icon.png"),
      //       fit: BoxFit.cover,
      //       opacity: 0.1,
      //     ),
      //   ),
      //   child: ListView(
      //     scrollDirection: Axis.vertical,
      //     shrinkWrap: true,
      //     physics: ClampingScrollPhysics(),
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Text(
      //               'Transaction history',
      //               style: GoogleFonts.lato(
      //                 color: Theme.of(context).primaryColor,
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: 16,
      //                 fontFamily: "DefaultFontFamily",
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       ListView.builder(
      //         scrollDirection: Axis.vertical,
      //         shrinkWrap: true,
      //         physics: ClampingScrollPhysics(),
      //         itemCount:
      //             depositController.deposit[widget.current].history.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           if (depositController.deposit[widget.current].history.isEmpty) {
      //             return Center(
      //               child: Text(
      //                 "Nothing to show",
      //                 style: GoogleFonts.lato(
      //                   fontSize: 20,
      //                   color: brandOne,
      //                   fontFamily: "DefaultFontFamily",
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             );
      //           } else {
      //             return Padding(
      //               padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10),
      //               child: Column(
      //                 children: [
      //                   Container(
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
      //                         SizedBox(
      //                           width: 10,
      //                         ),
      //                         Text(
      //                           _payments[index],
      //                           style: GoogleFonts.lato(
      //                             fontSize: 20,
      //                             fontFamily: "DefaultFontFamily",
      //                             color: Theme.of(context).primaryColor,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: 10,
      //                   ),
      //                 ],
      //               ),
      //             );
      //           }
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
