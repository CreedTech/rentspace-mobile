import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
import 'package:rentspace/controller/auth/user_controller.dart';

import '../../../constants/utils/formatDateTime.dart';
import '../../../controller/rent/rent_controller.dart';
import '../../receipts/transaction_receipt.dart';
import 'spacerent_list.dart';

class SpaceRentHistory extends StatefulWidget {
  int current;
  SpaceRentHistory({super.key, required this.current});

  @override
  _SpaceRentHistoryState createState() => _SpaceRentHistoryState();
}

class _SpaceRentHistoryState extends State<SpaceRentHistory> {
  final RentController rentController = Get.find();
  final UserController userController = Get.find();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isRefresh = false;

  List _payments = [];

  Future<void> onRefresh() async {
    refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        isRefresh = true;
      });
    }
    rentController.fetchRent();
  }

  @override
  initState() {
    super.initState();
    setState(() {
      _payments =
          rentController.rentModel!.rents![widget.current].rentHistories;
    });
  }

  @override
  Widget build(BuildContext context) {
    var groupedByMonth = {};

    for (var item in _payments) {
      DateTime createdAt = DateTime.parse(item['createdAt']);

      String monthKey =
          "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}";

      if (!groupedByMonth.containsKey(monthKey)) {
        groupedByMonth[monthKey] = [];
      }
      groupedByMonth[monthKey]!.add(item);
    }
    return Scaffold(
      appBar: AppBar(
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
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  rentController.rentModel!.rents![widget.current].rentName
                      .capitalizeFirst!,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
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
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${rentController.rentModel!.rents![widget.current].rentName} balance',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    nairaFormaet.format(rentController
                        .rentModel!.rents![widget.current].paidAmount),
                    style: GoogleFonts.roboto(
                      color: const Color(0xff278210),
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
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: 1,
            ),
            Expanded(
              child: (_payments.isEmpty)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/history_icon.png',
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xffffffff)
                                    : null,
                            height: 33.5.h,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: SizedBox(
                              width: 180,
                              child: Text(
                                "Your rent history will be displayed here",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 12.75, top: 16, right: 12.75),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).canvasColor),
                                  child: Column(
                                    children: [
                                      ...entry.value
                                          .map<Widget>((item) {
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const TransactionReceipt(),
                                                        settings: RouteSettings(
                                                          arguments: item,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          flex: 7,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Flexible(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          12),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color:
                                                                        brandTwo,
                                                                  ),
                                                                  child: (item[
                                                                              'transactionType'] ==
                                                                          'Credit')
                                                                      ? const Icon(
                                                                          Icons
                                                                              .call_received,
                                                                          color:
                                                                              Color(0xff80FF00),
                                                                          size:
                                                                              20,
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .arrow_outward_sharp,
                                                                          color:
                                                                              colorWhite,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 12),
                                                              Flexible(
                                                                flex: 8,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "${item['description'] ?? item['message'] ?? 'No Description Found'} "
                                                                          .capitalize!,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts
                                                                          .lato(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      formatDateTime(
                                                                          item[
                                                                              'createdAt']),
                                                                      style: GoogleFonts
                                                                          .lato(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: Theme.of(context)
                                                                            .primaryColorLight,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Flexible(
                                                          flex: 3,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              (item['transactionType'] ==
                                                                      'Credit')
                                                                  ? Text(
                                                                      "+ ${nairaFormaet.format(double.parse(item['amount'].toString()))}",
                                                                      style: GoogleFonts
                                                                          .roboto(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: const Color(
                                                                            0xff56AB00),
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      nairaFormaet
                                                                          .format(
                                                                              double.parse(item['amount'].toString())),
                                                                      style: GoogleFonts
                                                                          .roboto(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  color: Theme.of(context)
                                                      .dividerColor,
                                                  indent: 17,
                                                  endIndent: 17,
                                                ),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
