import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';

import 'package:rentspace/view/actions/bank_transfer.dart';


class FundWallet extends StatefulWidget {
  const FundWallet({super.key});

  @override
  _FundWalletState createState() => _FundWalletState();
}



class _FundWalletState extends State<FundWallet> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(
        elevation: 0.0,
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
            Text(
              'Add Money',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            child: ListView(
              children: [
                Text(
                  'Choose how you want to fund your wallet',
                  style: GoogleFonts.lato(
                    color: colorBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Get.to(BankTransfer());
                  },
                  contentPadding: const EdgeInsets.only(left: 15, right: 11),
                  tileColor: colorWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  leading: Image.asset(
                    'assets/icons/send_box_icon.png',
                    width: 42,
                    height: 42,
                  ),
                  title: Text(
                    'Bank Transfer',
                    style: GoogleFonts.lato(
                      color: colorBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'From your bank app or internet bank',
                    style: GoogleFonts.lato(
                      color: colorBlack,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 20,
                    color: colorBlack,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 15, right: 11),
                  tileColor: colorWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  leading: Image.asset(
                    'assets/icons/ussd_box_icon.png',
                    width: 42,
                    height: 42,
                  ),
                  title: Text(
                    'USSD',
                    style: GoogleFonts.lato(
                      color: colorBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Use your banks ussd code',
                    style: GoogleFonts.lato(
                      color: colorBlack,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 20,
                    color: colorBlack,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 15, right: 11),
                  tileColor: colorWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  leading: Image.asset(
                    'assets/icons/card_box_icon.png',
                    width: 42,
                    height: 42,
                  ),
                  title: Text(
                    'Card',
                    style: GoogleFonts.lato(
                      color: colorBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'From your debit card',
                    style: GoogleFonts.lato(
                      color: colorBlack,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 20,
                    color: colorBlack,
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Padding(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Rentspace Account Number',
                //             style: GoogleFonts.lato(
                //               color: brandTwo,
                //               fontSize: 12,
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //           Row(
                //             children: [
                //               Text(
                //                 userController
                //                     .userModel!.userDetails![0].dvaNumber,
                //                 style: GoogleFonts.lato(
                //                   color: brandOne,
                //                   fontSize: 25,
                //                   letterSpacing: 4,
                //                   fontWeight: FontWeight.w600,
                //                 ),
                //               ),
                //               const SizedBox(
                //                 width: 10,
                //               ),
                //               InkWell(
                //                 onTap: () {
                //                   Clipboard.setData(
                //                     ClipboardData(
                //                       text: userController
                //                           .userModel!.userDetails![0].dvaNumber
                //                           .obs()
                //                           .toString(),
                //                     ),
                //                   );

                //                   Fluttertoast.showToast(
                //                     msg: "Copied",
                //                     toastLength: Toast.LENGTH_SHORT,
                //                     gravity: ToastGravity.BOTTOM,
                //                     timeInSecForIosWeb: 1,
                //                     backgroundColor: brandOne,
                //                     textColor: Colors.white,
                //                     fontSize: 16.0,
                //                   );
                //                 },
                //                 child: const Icon(
                //                   Icons.copy,
                //                   size: 16,
                //                   color: brandOne,
                //                 ),
                //               )
                //             ],
                //           ),
                //         ],
                //       ),
                //       SizedBox(
                //         height: 5.h,
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Bank',
                //             style: GoogleFonts.lato(
                //               color: brandTwo,
                //               fontSize: 12,
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //           Text(
                //             'Providus Bank',
                //             style: GoogleFonts.lato(
                //               color: brandOne,
                //               fontSize: 16,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //         ],
                //       ),
                //       SizedBox(
                //         height: 5.h,
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Account Name',
                //             style: GoogleFonts.lato(
                //               color: brandTwo,
                //               fontSize: 12,
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //           Text(
                //             userController.userModel!.userDetails![0].dvaName,
                //             style: GoogleFonts.lato(
                //               color: brandOne,
                //               fontSize: 16,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: MySeparator(
                //     height: 1,
                //     color: Theme.of(context).cardColor,
                //   ),
                // ),
                // ListTile(
                //   leading: Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: const BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: brandOne,
                //     ),
                //     child: const Icon(
                //       Iconsax.card,
                //       color: Colors.white,
                //     ),
                //   ),
                //   title: Text(
                //     'Top-up with Card',
                //     style: GoogleFonts.lato(
                //       color: Theme.of(context).primaryColor,
                //       fontSize: 13,
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
                //   subtitle: Text(
                //     'Add money via your bank card',
                //     style: GoogleFonts.lato(
                //       color: brandOne,
                //       fontSize: 12,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                //   onTap: () {
                //     Get.to(const CardTopUp());
                //   },
                //   trailing: Icon(
                //     Iconsax.arrow_right_3,
                //     color: Theme.of(context).primaryColor,
                //   ),
                // ),
             
              ],
            ),
          ),
        ],
      ),
    );
  }
}
