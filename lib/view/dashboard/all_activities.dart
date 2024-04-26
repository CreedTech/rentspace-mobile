import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/view/actions/transaction_receipt.dart';
import 'package:rentspace/view/actions/transaction_receipt_dva.dart';
import 'package:rentspace/view/actions/transaction_receipt_transfer.dart';

import '../../constants/colors.dart';
import 'dashboard.dart';

class AllActivities extends StatefulWidget {
  // List activities;
  // int activitiesLength;
  const AllActivities({
    super.key,
    // required this.activitiesModel!.activities!,
    // required this.activitiesModel!.activities!Length,
  });

  @override
  _AllActivitiesState createState() => _AllActivitiesState();
}

class _AllActivitiesState extends State<AllActivities> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isRefresh = false;
  // final WalletHistoriesController walletHistoriesController = Get.find();
  @override
  initState() {
    super.initState();
  }

  Future<void> onRefresh() async {
    refreshController.refreshCompleted();
    // if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
    if (mounted) {
      setState(() {
        isRefresh = true;
      });
    }
    userController.fetchData();
    walletController.fetchWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.close,
            size: 25.sp,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Wallet Histories',
          style: GoogleFonts.poppins(
            color: brandOne,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        child: (userController
                .userModel!.userDetails![0].walletHistories.isEmpty)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/card_empty.png',
                    height: 300.h,
                  ),
                  Center(
                    child: Text(
                      "No Transaction history",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            : LiquidPullToRefresh(
                height: 70,
                animSpeedFactor: 2,
                color: Colors.white,
                backgroundColor: brandOne,
                showChildOpacityTransition: false,
                onRefresh: onRefresh,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: userController
                      .userModel!.userDetails![0].walletHistories.length,
                  itemBuilder: (BuildContext context, int index) {
                    int reversedIndex = userController
                            .userModel!.userDetails![0].walletHistories.length -
                        1 -
                        index;
                    final history = userController.userModel!.userDetails![0]
                        .walletHistories[reversedIndex];
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          (history['transactionGroup']
                                      .toString()
                                      .toLowerCase() ==
                                  'transfer')
                              ? TransactionReceiptTransfer(
                                  amount: history['amount'],
                                  status: history['status'],
                                  fees: history['fees'] ?? 0,
                                  transactionType: history['transactionType'],
                                  description: history['description'],
                                  transactionGroup: history['transactionGroup'],
                                  transactionDate: history['createdAt'],
                                  transactionRef:
                                      history['transactionReference'] ?? '',
                                  merchantRef: history['merchantReference'],
                                  // sessionId: history['sessionId'] ?? '',
                                )
                              : (history['transactionGroup']
                                          .toString()
                                          .toLowerCase() ==
                                      'static-account-transfer')
                                  ? TransactionReceiptDVA(
                                      amount: history['amount'],
                                      status: history['status'],
                                      fees: history['fees'] ?? 0,
                                      transactionType:
                                          history['transactionType'],
                                      description: history['description'],
                                      transactionGroup:
                                          history['transactionGroup'],
                                      transactionDate: history['createdAt'],
                                      transactionRef:
                                          history['transactionReference'] ?? '',
                                      merchantRef: history['merchantReference'],
                                      remarks: history['remarks'],
                                    )
                                  : TransactionReceipt(
                                      amount: history['amount'],
                                      status: history['status'],
                                      fees: history['fees'] ?? 0,
                                      transactionType:
                                          history['transactionType'],
                                      description: history['description'],
                                      transactionGroup:
                                          history['transactionGroup'],
                                      transactionDate: history['createdAt'],
                                      transactionRef:
                                          history['transactionReference'] ?? '',
                                      merchantRef: history['merchantReference'],
                                    ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(2.sp, 0, 2.sp, 5.sp),
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(12.sp),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (history['transactionType'] == 'Credit')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            child: (history['transactionType'] == 'Credit')
                                ? Icon(
                                    Icons.call_received,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : Icon(
                                    Icons.arrow_outward_sharp,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${history['description']} ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            formatDateTime(history['createdAt']),
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              (history['transactionType'] == 'Credit')
                                  ? Text(
                                      "+ ${nairaFormaet.format(double.parse(history['amount'].toString()))}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: brandOne,
                                      ),
                                    )
                                  : Text(
                                      "- ${nairaFormaet.format(double.parse(history['amount'].toString()))}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: brandOne,
                                      ),
                                    ),
                              (history['status'].toString().toLowerCase() ==
                                      'completed')
                                  ? Text(
                                      'Successful',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    )
                                  : (history['status']
                                              .toString()
                                              .toLowerCase() ==
                                          'failed')
                                      ? Text(
                                          'Failed',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red,
                                          ),
                                        )
                                      : Text(
                                          'Pending',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.yellow[800],
                                          ),
                                        )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  String formatDateTime(String dateTimeString) {
    // Parse the date string into a DateTime object
    DateTime dateTime =
        DateTime.parse(dateTimeString).add(const Duration(hours: 1));

    // Define the date format you want
    final DateFormat formatter = DateFormat('MMMM dd, yyyy hh:mm a');

    // Format the DateTime object into a string
    String formattedDateTime = formatter.format(dateTime);

    return formattedDateTime;
  }
}
