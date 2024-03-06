import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../controller/activities_controller.dart';
import '../../controller/wallet_histories_controller.dart';
import 'dashboard.dart';

class AllActivities extends StatefulWidget {
  // List activities;
  // int activitiesLength;
  AllActivities({
    super.key,
    // required this.activitiesModel!.activities!,
    // required this.activitiesModel!.activities!Length,
  });

  @override
  _AllActivitiesState createState() => _AllActivitiesState();
}

class _AllActivitiesState extends State<AllActivities> {
  final WalletHistoriesController walletHistoriesController = Get.find();
  @override
  initState() {
    super.initState();
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
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Wallet Histories',
          style: GoogleFonts.nunito(
            color: brandOne,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 15),
        child: (walletHistoriesController
                .walletHistoriesModel!.walletHistories!.isEmpty)
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
                itemCount: walletHistoriesController
                    .walletHistoriesModel!.walletHistories!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0, 2.0, 10),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (walletHistoriesController
                                      .walletHistoriesModel!
                                      .walletHistories![index]
                                      .transactionType ==
                                  'Credit')
                              ? Theme.of(context).primaryColor
                              : Colors.red,
                        ),
                        child: (walletHistoriesController.walletHistoriesModel!
                                    .walletHistories![index].transactionType ==
                                'Credit')
                            ? Icon(
                                Icons.arrow_outward_sharp,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : Icon(
                                Icons.arrow_outward_sharp,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${walletHistoriesController.walletHistoriesModel!.walletHistories![index].description} ",
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        formatDateTime(walletHistoriesController
                            .walletHistoriesModel!
                            .walletHistories![index]
                            .activityDate),
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      trailing: (walletHistoriesController.walletHistoriesModel!
                                  .walletHistories![index].transactionType ==
                              'Credit')
                          ? Text(
                              "+ ${nairaFormaet.format(double.parse(walletHistoriesController.walletHistoriesModel!.walletHistories![index].amount.toString()))}",
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                              ),
                            )
                          : Text(
                              "- ${nairaFormaet.format(double.parse(walletHistoriesController.walletHistoriesModel!.walletHistories![index].amount.toString()))}",
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.red,
                              ),
                            ),
                    ),
                  );
                },
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
