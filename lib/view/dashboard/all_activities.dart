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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
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
              Text(
                'Space Wallet History',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15.h,
              horizontal: 24.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Space Wallet: ',
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        nairaFormaet.format(walletController
                            .walletModel!.wallet![0].mainBalance),
                        style: GoogleFonts.roboto(
                          color: Theme.of(context).colorScheme.secondary,
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
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 1,
          ),
          Expanded(
            child:
                (userController
                        .userModel!.userDetails![0].walletHistories.isEmpty)
                    ? Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/history_icon.png',
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(0xffffffff)
                                  : const Color(0xffEEF8FF),
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                          children:
                              groupedByMonth.entries.toList().map((entry) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 15.h,
                                horizontal: 24.w,
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat.MMMM().format(
                                          DateTime.parse('${entry.key}-01')),
                                      style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                            color: Colors.grey.withOpacity(
                                                0.5), // Shadow color
                                            spreadRadius: 0.5, // Spread radius
                                            blurRadius: 2, // Blur radius
                                            offset:
                                                const Offset(0, 3), // Offset
                                          ),
                                        ],
                                        color: Theme.of(context).canvasColor,
                                      ),
                                      child: Column(
                                        children: [
                                          ...entry.value.map<Widget>((item) {
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
                                                            // mainAxisAlignment:
                                                            //     MainAxisAlignment
                                                            //         .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                flex: 2,
                                                                child: (item['transactionGroup']
                                                                            .toString()
                                                                            .toLowerCase() ==
                                                                        'bill')
                                                                    ? ClipOval(
                                                                        child: Image
                                                                            .asset(
                                                                          (item['biller'].toString().toLowerCase() == 'mtnng')
                                                                              ? 'assets/utility/mtn.jpg'
                                                                              : (item['biller'].toString().toLowerCase() == 'airng')
                                                                                  ? 'assets/utility/airtel.jpg'
                                                                                  : (item['biller'].toString().toLowerCase() == 'glo_vbank')
                                                                                      ? 'assets/utility/glo.jpg'
                                                                                      : (item['biller'].toString().toLowerCase() == '9mobile_nigeria')
                                                                                          ? 'assets/utility/9mobile.jpg'
                                                                                          : 'assets/icons/RentSpace-icon.jpg',
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
                                                                          fit: BoxFit
                                                                              .fitWidth, // Ensure the image fits inside the circle
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            12),
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          color:
                                                                              brandTwo,
                                                                        ),
                                                                        child: item['transactionType'] ==
                                                                                'Credit'
                                                                            ? const Icon(
                                                                                Icons.call_received,
                                                                                color: Color(0xff80FF00),
                                                                                size: 20,
                                                                              )
                                                                            : const Icon(
                                                                                Icons.arrow_outward_sharp,
                                                                                color: colorWhite,
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
                                                                        color: const Color(
                                                                            0xff4B4B4B),
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
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ]),
                            );
                          }).toList(),
                        ),
                      ),
          ),
        ],
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
