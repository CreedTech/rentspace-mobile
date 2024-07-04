import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';

import '../../controller/auth/user_controller.dart';

class PortfolioOverview extends StatefulWidget {
  const PortfolioOverview({super.key});

  @override
  State<PortfolioOverview> createState() => _PortfolioOverviewState();
}

class _PortfolioOverviewState extends State<PortfolioOverview> {
  final UserController userController = Get.find();

  final RentController rentController = Get.find();

  var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');

  num totalInterest = 0.0;

  @override
  void initState() {
    super.initState();
    getInterest();
  }

  getInterest() {
    if (rentController.rentModel!.rents!.isNotEmpty) {
      for (int j = 0; j < rentController.rentModel!.rents!.length; j++) {
        totalInterest += rentController.rentModel!.rents![j].spaceRentInterest;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Portfolio Overview',
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
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 24.w,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 16, top: 21, right: 16, bottom: 23),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1), // Shadow color
                    spreadRadius: 0.5, // Spread radius
                    blurRadius: 2, // Blur radius
                    offset: const Offset(0, 3), // Offset
                  ),
                ],
                color: Theme.of(context).canvasColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Savings',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        nairaFormaet.format(
                          userController
                              .userModel!.userDetails![0].totalSavings,
                        ),
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Interests',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        nairaFormaet.format(
                          totalInterest,
                        ),
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total loans collected',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              '0',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total loan amount',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              nairaFormaet.format(
                                userController
                                    .userModel!.userDetails![0].loanAmount,
                              ),
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total outstanding loans',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              '0',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Total outstanding loan amount',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              nairaFormaet.format(
                                userController
                                    .userModel!.userDetails![0].loanAmount,
                              ),
                              textAlign: TextAlign.end,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
