import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/view/actions/transaction_receipt.dart';

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
    var groupedByMonth = {};

    for (var item
        in userController.userModel!.userDetails![0].walletHistories) {
      DateTime createdAt = DateTime.parse(item['createdAt']);

      String monthKey =
          "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}";

      if (!groupedByMonth.containsKey(monthKey)) {
        groupedByMonth[monthKey] = [];
      }
      groupedByMonth[monthKey]!.add(item);
    }
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
              'Space Wallet History',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 24.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Space Wallet: ',
                    style: GoogleFonts.lato(
                      color: colorBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    nairaFormaet.format(
                        walletController.walletModel!.wallet![0].mainBalance),
                    style: GoogleFonts.lato(
                      color: brandOne,
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Transactions',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const Divider(
              color: Color(0xffC9C9C9),
              thickness: 1,
            ),
            Expanded(
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
                            style: GoogleFonts.lato(
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
                      color: brandOne,
                      backgroundColor: colorWhite,
                      showChildOpacityTransition: false,
                      onRefresh: onRefresh,
                      child: ListView(
                        children: groupedByMonth.entries
                            .toList()
                            .reversed
                            .map((entry) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat.MMMM().format(
                                      DateTime.parse('${entry.key}-01')),
                                  style: GoogleFonts.lato(
                                      color: colorBlack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 12.75, top: 20, right: 12.75),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.5), // Shadow color
                                          spreadRadius: 0.5, // Spread radius
                                          blurRadius: 2, // Blur radius
                                          offset: const Offset(0, 3), // Offset
                                        ),
                                      ],
                                      color: colorWhite),
                                  child: Column(
                                    children: [
                                      ...entry.value
                                          .map<Widget>((item) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 0),
                                                  minLeadingWidth: 0,
                                                  onTap: () {
                                                    print('item');
                                                    print(item);
                                                    // print(userController
                                                    //     .userModel!
                                                    //     .userDetails![0]
                                                    //     .walletHistories[item]);
                                                       Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const TransactionReceipt(),
                                                        settings: RouteSettings(
                                                            arguments:item,

                                                        ),
                                                      ),
                                                    );

                                                    // Get.to(TransactionReceipt(
                                                    //   amount: item['amount'],
                                                    //   status: item['status'],
                                                    //   fees: item['fees'] ?? 0,
                                                    //   transactionType: item[
                                                    //       'transactionType'],
                                                    //   description:
                                                    //       item['description'] ??
                                                    //           '',
                                                    //   transactionGroup: item[
                                                    //       'transactionGroup'],
                                                    //   transactionDate:
                                                    //       item['createdAt'],
                                                    //   transactionRef: item[
                                                    //           'transactionReference'] ??
                                                    //       '',
                                                    //   merchantRef: item[
                                                    //           'merchantReference'] ??
                                                    //       '',
                                                    //   // sessionId: item['sessionId'] ?? '',
                                                    // ));
                                                  },
                                                  leading: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          (item['transactionType'] ==
                                                                  'Credit')
                                                              ? brandTwo
                                                              : brandTwo,
                                                    ),
                                                    child:
                                                        (item['transactionType'] ==
                                                                'Credit')
                                                            ? const Icon(
                                                                Icons
                                                                    .call_received,
                                                                color: Color(
                                                                    0xff80FF00),
                                                                size: 20,
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .arrow_outward_sharp,
                                                                color:
                                                                    colorWhite,
                                                                size: 20,
                                                              ),
                                                  ),
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${item['description'] ?? item['message']  ?? 'No Description Found'} ",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: colorBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 9,
                                                      ),
                                                      Text(
                                                        formatDateTime(
                                                            item['createdAt']),
                                                        style: GoogleFonts.lato(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: const Color(
                                                              0xff4B4B4B),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      (item['transactionType'] ==
                                                              'Credit')
                                                          ? Text(
                                                              "+ ${nairaFormaet.format(double.parse(item['amount'].toString()))}",
                                                              style: GoogleFonts
                                                                  .lato(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: const Color(
                                                                    0xff56AB00),
                                                              ),
                                                            )
                                                          : Text(
                                                              nairaFormaet.format(
                                                                  double.parse(item[
                                                                          'amount']
                                                                      .toString())),
                                                              style: GoogleFonts
                                                                  .lato(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    colorBlack,
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                                ((groupedByMonth.keys.length) !=
                                                        (item[entry.key]))
                                                    ? const Divider(
                                                        color:
                                                            Color(0xffC9C9C9),
                                                      )
                                                    : const Text('yo'),
                                              ],
                                            );
                                          })
                                          .toList()
                                          .reversed,
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ]);
                        }).toList(),
                      ),
                    ),
            ),
          ],
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
