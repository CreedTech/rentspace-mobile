import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_withdrawal.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/colors.dart';
import '../../constants/utils/formatDateTime.dart';
import '../dashboard/dashboard.dart';
import 'withdraw_continuation_page.dart';
import 'withdraw_page.dart';

class SelectAccount extends StatefulWidget {
  const SelectAccount({super.key});

  @override
  State<SelectAccount> createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
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
                'Select Account',
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 24.w,
          ),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please select where you want to withdraw from.',
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.primary),
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
                            (walletController.walletModel!.wallet![0].nextWithdrawalDate !=
                                    '')
                                ? ((DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
                                        .isBefore(DateTime(
                                            DateTime.parse(walletController
                                                    .walletModel!
                                                    .wallet![0]
                                                    .nextWithdrawalDate!)
                                                .add(const Duration(hours: 1))
                                                .year,
                                            DateTime.parse(walletController
                                                    .walletModel!
                                                    .wallet![0]
                                                    .nextWithdrawalDate!)
                                                .add(const Duration(hours: 1))
                                                .month,
                                            DateTime.parse(walletController
                                                    .walletModel!
                                                    .wallet![0]
                                                    .nextWithdrawalDate!)
                                                .add(const Duration(hours: 1))
                                                .day)))
                                    ? showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            title: null,
                                            scrollable: true,
                                            elevation: 0,
                                            content: SizedBox(
                                              // height: 220.h,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 0),
                                                child: Column(
                                                  children: [
                                                    Wrap(
                                                      alignment:
                                                          WrapAlignment.center,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .info_outline_rounded,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          size: 24,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          'Oops!',
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 14,
                                                    ),
                                                    Text(
                                                      'You have used up your withdrawal for this month.\nGreat job managing your funds! Your next withdrawal date is ${formatMongoDBDate(walletController.walletModel!.wallet![0].nextWithdrawalDate!)}.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.lato(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 29,
                                                    ),
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          minimumSize: Size(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  50,
                                                              50),
                                                          backgroundColor:
                                                              brandTwo,
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              10,
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'Ok',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                    : (userController.userModel!.userDetails![0]
                                                .withdrawalAccount ==
                                            null)
                                        ? Get.to(const WithdrawalPage(
                                            withdrawalType: 'space wallet',
                                          ))
                                        : Get.to(
                                            WithdrawContinuationPage(
                                              bankCode: userController
                                                  .userModel!
                                                  .userDetails![0]
                                                  .withdrawalAccount!
                                                  .bankCode,
                                              accountNumber: userController
                                                  .userModel!
                                                  .userDetails![0]
                                                  .withdrawalAccount!
                                                  .accountNumber,
                                              bankName: userController
                                                  .userModel!
                                                  .userDetails![0]
                                                  .withdrawalAccount!
                                                  .bankName,
                                              accountHolderName: userController
                                                  .userModel!
                                                  .userDetails![0]
                                                  .withdrawalAccount!
                                                  .accountHolderName,
                                            ),
                                          )
                                : (userController.userModel!.userDetails![0]
                                            .withdrawalAccount ==
                                        null)
                                    ? Get.to(const WithdrawalPage(
                                        withdrawalType: 'space wallet',
                                      ))
                                    : Get.to(WithdrawContinuationPage(
                                        bankCode: userController
                                            .userModel!
                                            .userDetails![0]
                                            .withdrawalAccount!
                                            .bankCode,
                                        accountNumber: userController
                                            .userModel!
                                            .userDetails![0]
                                            .withdrawalAccount!
                                            .accountNumber,
                                        bankName: userController
                                            .userModel!
                                            .userDetails![0]
                                            .withdrawalAccount!
                                            .bankName,
                                        accountHolderName: userController
                                            .userModel!
                                            .userDetails![0]
                                            .withdrawalAccount!
                                            .accountHolderName,
                                      ));
                          },
                          title: Text(
                            "Space Wallet",
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          subtitle: Text(
                            'Withdrawal once a month',
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
                            (rentController.rentModel!.rents!
                                    .any((rent) => rent.completed == false))
                                ? showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        title: null,
                                        scrollable: true,
                                        elevation: 0,
                                        content: SizedBox(
                                          // height: 220.h,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            children: [
                                              Wrap(
                                                alignment: WrapAlignment.center,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.info_outline_rounded,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    size: 24,
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    'Oops!',
                                                    style: GoogleFonts.lato(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              Text(
                                                'You currently do not have any completed Space Rent. Please continue saving consistently to reach your goal.',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 29,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    minimumSize: Size(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                        50),
                                                    backgroundColor: brandTwo,
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Ok',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : Get.to(const SpaceRentWithdrawal());
                          },
                          title: Text(
                            'Space Rent',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          subtitle: Text(
                            'Withdraw from a completed Space Rent',
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
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.success(
                                backgroundColor: brandOne,
                                message: 'Coming soon !!',
                                textStyle: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            'Space Deposit',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          subtitle: Text(
                            'Withdraw from a Space Deposit account',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xffEEF8FF),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "Coming Soon",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: brandOne,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
