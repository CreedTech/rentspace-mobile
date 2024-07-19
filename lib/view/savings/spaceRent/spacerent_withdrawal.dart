import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_list.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_withdrawal_continuation_page.dart';

import '../../../controller/auth/user_controller.dart';
import '../../../controller/rent/rent_controller.dart';
import '../../withdrawal/withdraw_page.dart';

class SpaceRentWithdrawal extends StatefulWidget {
  const SpaceRentWithdrawal({super.key});

  @override
  State<SpaceRentWithdrawal> createState() => _SpaceRentWithdrawalState();
}

class _SpaceRentWithdrawalState extends State<SpaceRentWithdrawal> {
  final UserController userController = Get.find();
  final RentController rentController = Get.find();
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
                'Space Rent Withdrawal',
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
            horizontal: 20.w,
          ),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please select which completed Space Rent to withdraw from.',
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: rentController.rentModel!.rents!.length,
                    itemBuilder: (context, int index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              (userController.userModel!.userDetails![0]
                                          .withdrawalAccount ==
                                      null)
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const WithdrawalPage(
                                          withdrawalType: 'space rent',
                                        ),
                                      ),
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SpaceRentWithdrawalContinuationPage(
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
                                          amount: rentController.rentModel!
                                              .rents![index].paidAmount,
                                          narration: rentController.rentModel!
                                              .rents![index].rentName,
                                        ),
                                      ),
                                    );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).canvasColor),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 7,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 17, vertical: 10),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5.51),
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? const Color(0xffEAEAEA)
                                                      .withAlpha(6)
                                                  : const Color(0xffEAEAEA),
                                            ),
                                            child: Image.asset(
                                              'assets/icons/house.png',
                                              width: 24.8,
                                              height: 24.8,
                                              // scale: 4,
                                              // color: brandOne,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Flexible(
                                          flex: 7,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                rentController
                                                    .rentModel!
                                                    .rents![index]
                                                    .rentName
                                                    .capitalize!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                'Completed ${rentController.rentModel!.rents![index].date}',
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context)
                                                        .primaryColorLight),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          nairaFormaet.format(rentController
                                              .rentModel!
                                              .rents![index]
                                              .paidAmount),
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          "Rent",
                                          style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
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
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      );
                    },
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 14, vertical: 16),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Theme.of(context).canvasColor),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Flexible(
                  //         flex: 7,
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Flexible(
                  //               flex: 4,
                  //               child: Container(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 17, vertical: 10),
                  //                 decoration: BoxDecoration(
                  //                   shape: BoxShape.rectangle,
                  //                   borderRadius: BorderRadius.circular(5.51),
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? const Color(0xffEAEAEA).withAlpha(6)
                  //                       : const Color(0xffEAEAEA),
                  //                 ),
                  //                 child: Image.asset(
                  //                   'assets/icons/house.png',
                  //                   width: 24.8,
                  //                   height: 24.8,
                  //                   // scale: 4,
                  //                   // color: brandOne,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(width: 12.w),
                  //             Flexible(
                  //               flex: 7,
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Text(
                  //                     "Beta Rent".capitalize!,
                  //                     maxLines: 1,
                  //                     overflow: TextOverflow.ellipsis,
                  //                     style: GoogleFonts.lato(
                  //                       fontSize: 14,
                  //                       fontWeight: FontWeight.w500,
                  //                       color: Theme.of(context)
                  //                           .colorScheme
                  //                           .primary,
                  //                     ),
                  //                   ),
                  //                   SizedBox(height: 5.h),
                  //                   Text(
                  //                     'Completed 12/09/2024',
                  //                     style: GoogleFonts.lato(
                  //                         fontSize: 12,
                  //                         fontWeight: FontWeight.w400,
                  //                         color: Theme.of(context)
                  //                             .primaryColorLight),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Flexible(
                  //         flex: 4,
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             Text(
                  //               "N152,463",
                  //               style: GoogleFonts.roboto(
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.w700,
                  //                 color: Theme.of(context).colorScheme.primary,
                  //               ),
                  //             ),
                  //             SizedBox(height: 5.h),
                  //             Text(
                  //               "Rent",
                  //               style: GoogleFonts.roboto(
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.w400,
                  //                 color: Theme.of(context).primaryColorLight,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20.h,
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 14, vertical: 16),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Theme.of(context).canvasColor),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Flexible(
                  //         flex: 7,
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Flexible(
                  //               flex: 4,
                  //               child: Container(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 17, vertical: 10),
                  //                 decoration: BoxDecoration(
                  //                   shape: BoxShape.rectangle,
                  //                   borderRadius: BorderRadius.circular(5.51),
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? const Color(0xffEAEAEA).withAlpha(6)
                  //                       : const Color(0xffEAEAEA),
                  //                 ),
                  //                 child: Image.asset(
                  //                   'assets/icons/house.png',
                  //                   width: 24.8,
                  //                   height: 24.8,
                  //                   // scale: 4,
                  //                   // color: brandOne,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(width: 12.w),
                  //             Flexible(
                  //               flex: 7,
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Text(
                  //                     "Beta Rent".capitalize!,
                  //                     maxLines: 1,
                  //                     overflow: TextOverflow.ellipsis,
                  //                     style: GoogleFonts.lato(
                  //                       fontSize: 14,
                  //                       fontWeight: FontWeight.w500,
                  //                       color: Theme.of(context)
                  //                           .colorScheme
                  //                           .primary,
                  //                     ),
                  //                   ),
                  //                   SizedBox(height: 5.h),
                  //                   Text(
                  //                     'Completed 12/09/2024',
                  //                     style: GoogleFonts.lato(
                  //                         fontSize: 12,
                  //                         fontWeight: FontWeight.w400,
                  //                         color: Theme.of(context)
                  //                             .primaryColorLight),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Flexible(
                  //         flex: 4,
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             Text(
                  //               "N152,463",
                  //               style: GoogleFonts.roboto(
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.w700,
                  //                 color: Theme.of(context).colorScheme.primary,
                  //               ),
                  //             ),
                  //             SizedBox(height: 5.h),
                  //             Text(
                  //               "Rent",
                  //               style: GoogleFonts.roboto(
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.w400,
                  //                 color: Theme.of(context).primaryColorLight,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
