import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/widgets/custom_button.dart';
import 'package:rentspace/view/credit_score/contest_result_page.dart';
import 'package:rentspace/view/credit_score/rating_breakdown_page.dart';
import 'package:rentspace/view/loan/available_loans_page.dart';

import '../dashboard/dashboard.dart';

class CreditScorePage extends StatefulWidget {
  const CreditScorePage({super.key});

  @override
  State<CreditScorePage> createState() => _CreditScorePageState();
}

class _CreditScorePageState extends State<CreditScorePage> {
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
              Text(
                'Hi ${userController.userModel!.userDetails![0].firstName.capitalize}',
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
          vertical: 0.h,
          horizontal: 24.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Here is your credit score',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 16.h, bottom: 22.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "820",
                                          style: GoogleFonts.lato(
                                            fontSize: 52,
                                            color: brandTwo,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '/1000',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Excellent',
                                          style: GoogleFonts.lato(
                                            color: const Color(0xff327232),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.info_outline,
                                          size: 17,
                                          color: Color(0xff327232),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/donwload_icon.png',
                                width: 24.w,
                                height: 24.h,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                'Download Report',
                                style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: Text(
                        'Generated: 28/04/2024',
                        style: GoogleFonts.lato(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 17, top: 10, right: 17, bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).canvasColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 0,
                            // horizontalTitleGap: 0,
                            minLeadingWidth: 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ContestResultPage(),
                                ),
                              );
                            },
                            title: Text(
                              "Contest Result",
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            subtitle: Text(
                              'Not satisfied with your credit score?',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),

                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          Divider(
                            color: Theme.of(context).dividerColor,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 0,
                            // horizontalTitleGap: 0,
                            minLeadingWidth: 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RatingbreakdownPage(),
                                ),
                              );
                            },
                            title: Text(
                              'See Breakdown',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            subtitle: Text(
                              'Know the factors that affect your credit score',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  text: 'See Available Loans',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AvailableLoansPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
