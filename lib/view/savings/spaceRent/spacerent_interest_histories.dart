import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
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
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Text(
                'Interest History',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  color: colorBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
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
                    '${rentController.rentModel!.rents![widget.current].rentName} balance',
                    style: GoogleFonts.lato(
                      color: colorBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    nairaFormaet.format(rentController
                        .rentModel!.rents![widget.current].spaceRentInterest),
                    style: GoogleFonts.lato(
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
            Expanded(
              child: (_interests.isEmpty)
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
                            "No Rent history",
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
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 12.75, top: 16, right: 12.75),
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
                                                  leading: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: brandTwo),
                                                    child: const Icon(
                                                      Icons.call_received,
                                                      color: Color(0xff80FF00),
                                                      size: 20,
                                                    ),
                                                  ),
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${item['interestAmount']} Space Rent Interest",
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
                                                      Text(
                                                        "+ ${nairaFormaet.format(double.parse(item['interestAmount'].toString()))}",
                                                        style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color(
                                                              0xff56AB00),
                                                        ),
                                                      ),
                                                      SizedBox(width: 15,),
                                                    ],
                                                  ),
                                                ),
                                                ((groupedByMonth.keys.length) !=
                                                        (item[entry.key]))
                                                    ? const Divider(
                                                        color:
                                                            Color(0xffC9C9C9),
                                                      )
                                                    : const Text(''),
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
