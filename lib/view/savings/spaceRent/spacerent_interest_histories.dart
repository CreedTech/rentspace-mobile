import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants/colors.dart';
import '../../../constants/utils/formatDateTime.dart';
import '../../../controller/rent/rent_controller.dart';
import 'spacerent_page.dart';

class SpaceRentInterestHistoryPage extends StatefulWidget {
  const SpaceRentInterestHistoryPage({super.key, required this.current});
  final int current;

  @override
  State<SpaceRentInterestHistoryPage> createState() =>
      _SpaceRentInterestHistoryPageState();
}

class _SpaceRentInterestHistoryPageState
    extends State<SpaceRentInterestHistoryPage> {
  final RentController rentController = Get.find();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isRefresh = false;

  List _interests = [];

  Future<void> onRefresh() async {
    refreshController.refreshCompleted();
    // if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
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
      _interests = rentController
          .rentModel!.rents![widget.current].spaceRentInterestHistories!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var groupedByMonth = {};

    for (var item in _interests) {
      DateTime createdAt = DateTime.parse(item['createdAt']);

      String monthKey =
          "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}";

      if (!groupedByMonth.containsKey(monthKey)) {
        groupedByMonth[monthKey] = [];
      }
      groupedByMonth[monthKey]!.add(item);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            Get.back();
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
                  'Interest History',
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        .rentModel!.rents![widget.current].spaceRentInterest),
                    style: GoogleFonts.roboto(
                      color: const Color(0xff278210),
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            // if (_interests.isEmpty)
            const SizedBox(
              height: 20,
            ),
            (_interests.isEmpty)
                ? Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/history_icon.png',
                          color: Theme.of(context).brightness == Brightness.dark
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
                              "Your interest history will be displayed here",
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
                : Expanded(
                    child: LiquidPullToRefresh(
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
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey
                                    //         .withOpacity(0.5), // Shadow color
                                    //     spreadRadius: 0.5, // Spread radius
                                    //     blurRadius: 2, // Blur radius
                                    //     offset: const Offset(0, 3), // Offset
                                    //   ),
                                    // ],
                                    color: Theme.of(context).canvasColor,
                                  ),
                                  child: Column(
                                    children: [
                                      ...entry.value
                                          .map<Widget>((item) {
                                            return Column(
                                              children: [
                                                Column(
                                                  children: [
                                                    // const SizedBox(
                                                    //   height: 24,
                                                    // ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
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
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment
                                                              //         .spaceBetween,
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
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .call_received,
                                                                      color: Color(
                                                                          0xff80FF00),
                                                                      size: 20,
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
                                                                        "${item['interestAmount']} Space Rent Interest "
                                                                            .capitalize!,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
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
                                                                            item['createdAt']),
                                                                        style: GoogleFonts
                                                                            .lato(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              const Color(0xff4B4B4B),
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
                                                            child: Text(
                                                              "+ ₦${item['interestAmount']}",
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: const Color(
                                                                    0xff56AB00),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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
    );
  }

  String formatAsPercentage(double value) {
    int percentage = (value * 100).round();
    return '$percentage%';
  }
}
