import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/controller/utility_controller.dart';
import 'package:intl/intl.dart';

class UtilitiesHistory extends StatefulWidget {
  const UtilitiesHistory({Key? key}) : super(key: key);

  @override
  _UtilitiesHistoryState createState() => _UtilitiesHistoryState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');

class _UtilitiesHistoryState extends State<UtilitiesHistory> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isRefresh = false;
  final UtilityController utilityController = Get.find();

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
    utilityController.fetchUtilityHistories();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      height: 100,
      animSpeedFactor: 2,
      color: brandOne,
      backgroundColor: Colors.white,
      showChildOpacityTransition: false,
      onRefresh: onRefresh,
      child: Scaffold(
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
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Utility History',
            style: GoogleFonts.nunito(
              color: Theme.of(context).primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Stack(
          children: [
            (utilityController.utilityHistoryModel!.utilityHistories!.isEmpty)
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
                          style: GoogleFonts.nunito(
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
                    itemCount: utilityController
                        .utilityHistoryModel!.utilityHistories!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10),
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
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${utilityController.utilityHistoryModel!.utilityHistories![index].biller} ",
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            formatDateTime(utilityController
                                .utilityHistoryModel!
                                .utilityHistories![index]
                                .createdAt),
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          trailing: Text(
                            "- ${nairaFormaet.format(double.parse(utilityController.utilityHistoryModel!.utilityHistories![index].amount.toString()))}",
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  String formatDateTime(String dateTimeString) {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Define the date format you want
    final DateFormat formatter = DateFormat('MMMM dd, yyyy hh:mm a');

    // Format the DateTime object into a string
    String formattedDateTime = formatter.format(dateTime);

    return formattedDateTime;
  }
}
