import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/core/helper/helper_route_path.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_list.dart';

class SpaceRentSuccessPage extends StatefulWidget {
  const SpaceRentSuccessPage(
      {super.key,
      required this.rentValue,
      required this.savingsValue,
      required this.startDate,
      required this.durationType,
      required this.paymentCount,
      required this.rentName,
      required this.duration,
      required this.receivalDate});
  final num rentValue, savingsValue;
  final String startDate, durationType, paymentCount, rentName, receivalDate;
  final int duration;

  @override
  State<SpaceRentSuccessPage> createState() => _SpaceRentSuccessPageState();
}

class _SpaceRentSuccessPageState extends State<SpaceRentSuccessPage> {
  var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
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
          child: SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    right: -100,
                    child: Image.asset(
                      'assets/logo_transparent.png',
                      width: 349.w,
                      height: 497.h,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/house.png',
                          height: 56.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 24.5.h, bottom: 12.h),
                          child: Text(
                            widget.rentName.capitalize!,
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
                            currencyFormat.format(widget.rentValue),
                            style: GoogleFonts.lato(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: colorWhite,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Text(
                            '${currencyFormat.format(widget.savingsValue)}/${widget.durationType.toLowerCase() == 'weekly' ? 'wk' : 'mth'}',
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
                            '${widget.duration} months',
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
                            'Next Payment Date: ${widget.startDate}',
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
                    top: MediaQuery.of(context).size.height - 490,
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
                                top: 34.h, left: 81.w, right: 81.w),
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
                                  'Congrats! Your Space Rent Plan has been successfully created',
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
                          Align(
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
                                Get.close(3);
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
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height - 520,
                    child: Image.asset(
                      'assets/icons/success_glow_icon.png',
                      width: 74.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
