import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/view/onboarding/FirstPage.dart';

import '../../constants/colors.dart';
import '../../constants/utils/formatDateTime.dart';

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
                          style: GoogleFonts.roboto(
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
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                                  color: Theme.of(context).colorScheme.primary,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
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
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    textColor: Theme.of(context)
                                                        .canvasColor,
                                                    fontSize: 16.0,
                                                  );
                                                },
                                                child: Image.asset(
                                                  'assets/icons/copy_icon.png',
                                                  width: 24,
                                                  height: 24,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
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
                            : const SizedBox(),
                    

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
                                Get.offAll(const FirstPage());
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


}
