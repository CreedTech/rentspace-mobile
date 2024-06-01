import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/view/FirstPage.dart';
import 'package:rentspace/view/dashboard/dashboard.dart';
import 'package:rentspace/view/loan/loan_page.dart';

import '../../constants/colors.dart';

class SuccessFulScreen extends StatefulWidget {
  const SuccessFulScreen(
      {super.key,
      required this.image,
      required this.name,
      required this.category,
      required this.amount,
      required this.billerId,
      required this.number,
      required this.date,
      this.token});
  final String image, category, amount, billerId, number, date, name;
  final String? token;

  @override
  State<SuccessFulScreen> createState() => _SuccessFulScreenState();
}

class _SuccessFulScreenState extends State<SuccessFulScreen> {
  var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.of(context).pop(returningValue);

        return false;
      },
      child: Scaffold(
        backgroundColor: brandOne,
        body: Container(
          decoration: const BoxDecoration(
            color: brandOne,
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  right: -110,
                  child: Image.asset(
                    'assets/logo_transparent.png',
                    width: 349.w,
                    height: 497.h,
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30, // Adjust the radius as needed
                        backgroundColor: Colors.transparent, //
                        child: ClipOval(
                          child: Image.asset(
                            'assets/utility/${widget.image.toLowerCase()}.jpg',
                            height: 50,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 6, bottom: 6.h),
                        child: Text(
                          widget.category.capitalize!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: colorWhite,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Text(
                          currencyFormat.format(int.parse(widget.amount)),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            color: colorWhite,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 13.h),
                        child: Text(
                          widget.name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colorWhite,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Text(
                          widget.number,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: colorWhite,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Text(
                          formatDateTime(widget.date),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colorWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 2.35,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(
                        //   height: 92,
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 34.h, left: 81.w, right: 81.w, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Success!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: brandOne,
                                ),
                              ),
                              SizedBox(
                                height: 13.h,
                              ),
                              Text(
                                'Congrats! Your ${widget.category} recharge was successful.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: colorDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        (widget.token != '')
                            ? Column(
                                children: [
                                  Text(
                                    'Token:',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: colorDark,
                                    ),
                                  ),
                                  Wrap(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        // alignment: WrapAlignment.center,
                                        // runAlignment: WrapAlignment.center,
                                        // crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            widget.token!.removeAllWhitespace,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: colorDark,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 14,
                                          ),
                                          Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(
                                                    ClipboardData(
                                                      text: widget.token!
                                                          .removeAllWhitespace,
                                                    ),
                                                  );
                                                  Fluttertoast.showToast(
                                                    msg: "Copied to clipboard!",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.SNACKBAR,
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
                                ],
                              )
                            : SizedBox(),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 24),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       ElevatedButton(
                        //         style: ElevatedButton.styleFrom(
                        //           elevation: 0,
                        //           minimumSize: const Size(180, 45),
                        //           backgroundColor: Colors.transparent,
                        //           shape: RoundedRectangleBorder(
                        //             side: const BorderSide(
                        //                 color: Color(0xffCCCCCC), width: 1),
                        //             borderRadius: BorderRadius.circular(10),
                        //           ),
                        //         ),
                        //         onPressed: () {
                        //           // Get.offAll(
                        //           //     LoginPage(sessionStateStream: sessionStateStream));
                        //         },
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             const Icon(
                        //               Icons.share_outlined,
                        //               color: colorBlack,
                        //               size: 26,
                        //             ),
                        //             const SizedBox(
                        //               width: 10,
                        //             ),
                        //             Text(
                        //               'Share',
                        //               textAlign: TextAlign.center,
                        //               style: GoogleFonts.lato(
                        //                 color: colorBlack,
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.w500,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       ElevatedButton(
                        //         style: ElevatedButton.styleFrom(
                        //           elevation: 0,
                        //           minimumSize: const Size(180, 45),
                        //           backgroundColor: Colors.transparent,
                        //           shape: RoundedRectangleBorder(
                        //             side: const BorderSide(
                        //                 color: Color(0xffCCCCCC), width: 1),
                        //             borderRadius: BorderRadius.circular(10),
                        //           ),
                        //         ),
                        //         onPressed: () {
                        //           // Get.offAll(
                        //           //     LoginPage(sessionStateStream: sessionStateStream));
                        //         },
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             const Icon(
                        //               Icons.file_download_outlined,
                        //               color: colorBlack,
                        //               size: 26,
                        //             ),
                        //             const SizedBox(
                        //               width: 10,
                        //             ),
                        //             Text(
                        //               'Download',
                        //               textAlign: TextAlign.center,
                        //               style: GoogleFonts.lato(
                        //                 color: colorBlack,
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.w500,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                           
                        //     ],
                        //   ),
                        // ),
                       
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width - 50, 50),
                                backgroundColor: brandTwo,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(
                                //       builder: (_) => const RentSpaceList(),
                                //     ),
                                //     (route) => false);
                                // Get.until((route) => Get.currentRoute == rentList);
                                Get.offAll(const FirstPage());
                                // Get.until((route) => false);
                                // Get.offNamedUntil(rentList, (route) => false);
                                // Navigator.popUntil(
                                //     context, ModalRoute.withName(rentList));
                                // Get.to(const RentSpaceList());
                              },
                              child: Text(
                                'Continue',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 14,
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
                Positioned(
                  top: MediaQuery.of(context).size.height / 2.55,
                  child: Image.asset(
                    'assets/icons/success_glow_icon.png',
                    width: 74,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDateTime(String dateTimeString) {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Define the date format you want
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    // Format the DateTime object into a string
    String formattedDateTime = formatter.format(dateTime);

    return formattedDateTime;
  }
}
