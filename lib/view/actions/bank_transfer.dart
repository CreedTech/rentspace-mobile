import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/controller/auth/user_controller.dart';

class BankTransfer extends StatefulWidget {
  BankTransfer({
    super.key,
  });

  @override
  _BankTransferState createState() => _BankTransferState();
}

class _BankTransferState extends State<BankTransfer> {
  final UserController userController = Get.find();
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
              'Bank Transfer',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              // height: 240,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Account Number',
                        style: GoogleFonts.lato(
                          color: colorBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userController.userModel!.userDetails![0].dvaNumber,
                            style: GoogleFonts.lato(
                              color: brandOne,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: userController.userModel!.userDetails![0].dvaNumber,
                                    ),
                                  );
                                  Fluttertoast.showToast(
                                    msg: "Copied to clipboard!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: brandOne,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                },
                                child: Image.asset(
                                  'assets/icons/copy_icon.png',
                                  width: 24,
                                  height: 24,
                                  color: colorBlack,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Copy',
                                style: GoogleFonts.lato(
                                  color: brandTwo,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bank',
                        style: GoogleFonts.lato(
                          color: colorBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Providus Bank',
                        style: GoogleFonts.lato(
                          color: colorBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Account Name',
                        style: GoogleFonts.lato(
                          color: colorBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        userController.userModel!.userDetails![0].dvaName,
                        style: GoogleFonts.lato(
                          color: colorBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
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
      // body: CustomScrollView(
      //   slivers: [
      //     SliverAppBar(
      //       pinned: true,
      //       floating: false,
      //       snap: false,
      //       stretch: true,
      //       iconTheme: const IconThemeData(color: Colors.white),
      //       expandedHeight: MediaQuery.of(context).size.height / 3.5,
      //       flexibleSpace: FlexibleSpaceBar(
      //         background: Container(
      //           color: brandOne,
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.end,
      //             children: [
      //               Image.asset(
      //                 'assets/icons/logo.png',
      //                 height: 80,
      //               ),
      //               const Text(
      //                 "Bank transfer",
      //                 style: TextStyle(
      //                   fontSize: 40.0,
      //                   letterSpacing: 4.0,
      //                   color: brandTwo,
      //                 ),
      //                 textAlign: TextAlign.center,
      //               ),
      //               const SizedBox(
      //                 height: 20,
      //               ),
      //               const Text(
      //                 "Transfer to the account details below. make sure to include you user ID in the description/narration. Note that it might take few minutes for your wallet to reflect the fund.",
      //                 style: TextStyle(
      //                   fontSize: 10.0,
      //                   letterSpacing: 1.5,
      //                   color: Colors.white,
      //                 ),
      //                 textAlign: TextAlign.center,
      //               ),
      //               const SizedBox(
      //                 height: 40,
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //     SliverList(
      //       delegate: SliverChildListDelegate(
      //         [
      //           const SizedBox(
      //             height: 30,
      //           ),
      //           //bvn value
      //           Container(
      //             decoration: BoxDecoration(
      //               color: Theme.of(context).canvasColor,
      //               borderRadius: BorderRadius.circular(10),
      //             ),
      //             width: MediaQuery.of(context).size.width,
      //             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      //             child: Column(
      //               children: [
      //                 const SizedBox(
      //                   height: 20,
      //                 ),
      //                 InkWell(
      //                   onTap: () {
      //                     Clipboard.setData(
      //                       const ClipboardData(
      //                           text: "RENTSPACE TECHNOLOGIES LTD"),
      //                     );
      //                     Fluttertoast.showToast(
      //                         msg: "copied to clipboard!",
      //                         toastLength: Toast.LENGTH_SHORT,
      //                         gravity: ToastGravity.CENTER,
      //                         timeInSecForIosWeb: 1,
      //                         backgroundColor: brandTwo,
      //                         textColor: Colors.black,
      //                         fontSize: 16.0);
      //                   },
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       SizedBox(
      //                         width: MediaQuery.of(context).size.width / 1.5,
      //                         child: Text(
      //                           "Account name:\nRENTSPACE TECHNOLOGIES LTDhthththththth",
      //                           style: TextStyle(
      //                             fontSize: 18,
      //                             color: Theme.of(context).primaryColor,
      //                           ),
      //                           overflow: TextOverflow.ellipsis,
      //                         ),
      //                       ),
      //                       const SizedBox(
      //                         width: 20,
      //                       ),
      //                       Container(
      //                         decoration: BoxDecoration(
      //                           color: Colors.black,
      //                           borderRadius: BorderRadius.circular(20.0),
      //                         ),
      //                         padding: const EdgeInsets.all(4),
      //                         child: const Icon(
      //                           Icons.copy,
      //                           size: 14,
      //                           color: Colors.white,
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 10,
      //                 ),
      //                 InkWell(
      //                   onTap: () {
      //                     Clipboard.setData(
      //                       const ClipboardData(text: "5401254162"),
      //                     );
      //                     Fluttertoast.showToast(
      //                         msg: "copied to clipboard!",
      //                         toastLength: Toast.LENGTH_SHORT,
      //                         gravity: ToastGravity.CENTER,
      //                         timeInSecForIosWeb: 1,
      //                         backgroundColor: brandTwo,
      //                         textColor: Colors.black,
      //                         fontSize: 16.0);
      //                   },
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Text(
      //                         "Account number: 5401254162",
      //                         style: TextStyle(
      //                           fontSize: 18,
      //                           color: Theme.of(context).primaryColor,
      //                         ),
      //                       ),
      //                       const SizedBox(
      //                         width: 20,
      //                       ),
      //                       Container(
      //                         decoration: BoxDecoration(
      //                           color: Colors.black,
      //                           borderRadius: BorderRadius.circular(20.0),
      //                         ),
      //                         padding: const EdgeInsets.all(4),
      //                         child: const Icon(
      //                           Icons.copy,
      //                           size: 14,
      //                           color: Colors.white,
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 10,
      //                 ),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.start,
      //                   children: [
      //                     Text(
      //                       "Bank name: PROVIDUS BANK",
      //                       style: TextStyle(
      //                         fontSize: 18,
      //                         color: Theme.of(context).primaryColor,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 const SizedBox(
      //                   height: 10,
      //                 ),
      //                 InkWell(
      //                   onTap: () {
      //                     Clipboard.setData(
      //                       ClipboardData(
      //                         text: "${widget.userId} + Space Wallet top-up",
      //                       ),
      //                     );
      //                     Fluttertoast.showToast(
      //                         msg: "copied to clipboard!",
      //                         toastLength: Toast.LENGTH_SHORT,
      //                         gravity: ToastGravity.CENTER,
      //                         timeInSecForIosWeb: 1,
      //                         backgroundColor: brandTwo,
      //                         textColor: Colors.black,
      //                         fontSize: 16.0);
      //                   },
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Text(
      //                         "Naration/Description: Click to copy",
      //                         style: TextStyle(
      //                           fontSize: 18,
      //                           color: Theme.of(context).primaryColor,
      //                         ),
      //                       ),
      //                       const SizedBox(
      //                         width: 20,
      //                       ),
      //                       Container(
      //                         decoration: BoxDecoration(
      //                           color: Colors.black,
      //                           borderRadius: BorderRadius.circular(20.0),
      //                         ),
      //                         padding: const EdgeInsets.all(4),
      //                         child: const Icon(
      //                           Icons.copy,
      //                           size: 14,
      //                           color: Colors.white,
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
