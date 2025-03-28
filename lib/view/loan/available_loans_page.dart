import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/loan/loan_success_page.dart';

import '../../constants/constants.dart';

class AvailableLoansPage extends StatefulWidget {
  const AvailableLoansPage({super.key});

  @override
  State<AvailableLoansPage> createState() => _AvailableLoansPageState();
}

class _AvailableLoansPageState extends State<AvailableLoansPage> {
  bool isSelected = false;
  int _selectedIndex = -1;
  bool agreeToTerms = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Set the selected index
      isSelected = true;
    });
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
                'Available Loans',
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
                      'Please select from the list of loans you qualify for.',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(0),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.sp, vertical: 6.sp),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.h),
                              decoration: BoxDecoration(
                                color: (_selectedIndex == 0)
                                    ? brandOne
                                    : Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '10% of your rent',
                                            style: GoogleFonts.lato(
                                              color: ((_selectedIndex == 0) &&
                                                      Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light)
                                                  ? colorWhite
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            'N30000',
                                            style: GoogleFonts.lato(
                                              color: brandTwo,
                                              fontSize: 26,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        'assets/icons/tier_one_icon.png',
                                        width: 43.w,
                                        height: 43.h,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'with 5% interest',
                                        style: GoogleFonts.lato(
                                          color: ((_selectedIndex == 0) &&
                                                  Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light)
                                              ? colorWhite
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Due in 2weeks',
                                        style: GoogleFonts.lato(
                                          color: ((_selectedIndex == 0) &&
                                                  Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light)
                                              ? colorWhite
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_selectedIndex == 0)
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2.5),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: brandOne,
                                  radius: 6,
                                  child: Icon(
                                    Icons.check,
                                    color: colorWhite,
                                    size: 10,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(1),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.sp, vertical: 6.sp),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.h),
                              decoration: BoxDecoration(
                                color: (_selectedIndex == 1)
                                    ? brandOne
                                    : Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '20% of your rent',
                                            style: GoogleFonts.lato(
                                              color: ((_selectedIndex == 1) &&
                                                      Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light)
                                                  ? colorWhite
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            'N60000',
                                            style: GoogleFonts.lato(
                                              color: brandTwo,
                                              fontSize: 26,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        'assets/icons/tier_two_icon.png',
                                        width: 43.w,
                                        height: 43.h,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'with 5% interest',
                                        style: GoogleFonts.lato(
                                          color: ((_selectedIndex == 1) &&
                                                  Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light)
                                              ? colorWhite
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Due in 2weeks',
                                        style: GoogleFonts.lato(
                                          color: ((_selectedIndex == 1) &&
                                                  Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light)
                                              ? colorWhite
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_selectedIndex == 1)
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2.5),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: brandOne,
                                  radius: 6,
                                  child: Icon(
                                    Icons.check,
                                    color: colorWhite,
                                    size: 10,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(2),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.sp, vertical: 6.sp),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.h),
                              decoration: BoxDecoration(
                                color: (_selectedIndex == 2)
                                    ? brandOne
                                    : Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '30% of your rent',
                                            style: GoogleFonts.lato(
                                              color: ((_selectedIndex == 2) &&
                                                      Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light)
                                                  ? colorWhite
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            'N90000',
                                            style: GoogleFonts.lato(
                                              color: brandTwo,
                                              fontSize: 26,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        'assets/icons/tier_three_icon.png',
                                        width: 43.w,
                                        height: 43.h,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'with 9% interest',
                                        style: GoogleFonts.lato(
                                          color: ((_selectedIndex == 2) &&
                                                  Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light)
                                              ? colorWhite
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Due in 2weeks',
                                        style: GoogleFonts.lato(
                                          color: ((_selectedIndex == 2) &&
                                                  Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light)
                                              ? colorWhite
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_selectedIndex == 2)
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2.5),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: brandOne,
                                  radius: 6,
                                  child: Icon(
                                    Icons.check,
                                    color: colorWhite,
                                    size: 10,
                                  ),
                                ),
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width - 50, 50),
                    backgroundColor: (isSelected == true)
                        ? brandTwo
                        : const Color(0xffD0D0D0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (isSelected == true) {
                      showModalBottomSheet(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        isDismissible: false,
                        enableDrag: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return FractionallySizedBox(
                              heightFactor: 0.9,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 26, horizontal: 24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'RentSpace Loan Terms of Service',
                                                style: GoogleFonts.lato(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    agreeToTerms = false;
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  size: 24,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 24.h,
                                      ),
                                      Expanded(
                                        child: ListView(
                                          children: [
                                            Text(
                                              loansTermsText,
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.zero,
                                                      margin: EdgeInsets.zero,
                                                      // alignment: Alignment.centerLeft,
                                                      child: Checkbox.adaptive(
                                                        visualDensity: VisualDensity
                                                            .adaptivePlatformDensity,
                                                        value: agreeToTerms,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            agreeToTerms =
                                                                value!;
                                                          });
                                                        },
                                                        overlayColor:
                                                            MaterialStateColor
                                                                .resolveWith(
                                                          (states) => brandTwo,
                                                        ),
                                                        fillColor:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color>((Set<
                                                                        MaterialState>
                                                                    states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .selected)) {
                                                            return brandTwo;
                                                          }
                                                          return const Color(
                                                              0xffF2F2F2);
                                                        }),
                                                        focusColor:
                                                            MaterialStateColor
                                                                .resolveWith(
                                                          (states) => brandTwo,
                                                        ),
                                                        activeColor:
                                                            MaterialStateColor
                                                                .resolveWith(
                                                          (states) => brandTwo,
                                                        ),
                                                        side: const BorderSide(
                                                          color:
                                                              Color(0xffBDBDBD),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'I have read & accept the loan terms',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 20, top: 20),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50,
                                                  50),
                                              backgroundColor:
                                                  (agreeToTerms == true)
                                                      ? brandTwo
                                                      : const Color(0xffD0D0D0),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (agreeToTerms == true) {
                                                context.pop();
                                                context
                                                    .push('/loanSuccessPage');
                                              }
                                            },
                                            child: Text(
                                              'Continue',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lato(
                                                color: (agreeToTerms == true)
                                                    ? Colors.white
                                                    : const Color(0xff515151),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                        // },
                      );
                    }
                  },
                  child: Text(
                    'Continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: (isSelected == true)
                          ? Colors.white
                          : const Color(0xff515151),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
