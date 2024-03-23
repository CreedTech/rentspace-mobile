import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/kyc/kyc_form_page.dart';

class KYCIntroPage extends StatefulWidget {
  const KYCIntroPage({super.key});

  @override
  State<KYCIntroPage> createState() => _KYCIntroPageState();
}

class _KYCIntroPageState extends State<KYCIntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    Icon(
                      Icons.security,
                      color: brandOne,
                      size: 300.h,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      'KYC Verification',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: brandOne,
                        fontWeight: FontWeight.w800,
                        fontSize: 23.sp,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Start Your KYC Verification to get access to exclusive 30% loans on your rent",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: brandOne,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 2,
                        alignment: Alignment.center,
                        height: 110.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(300.w, 50.h),
                            backgroundColor: brandOne,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Get.to(const KYCFormPage());
                            // Navigator.of(context).pushNamedAndRemoveUntil(
                            //     route, (route) => false);
                          },
                          child: Text(
                            'Get Started',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          // Column(
          //   children: [
          //     // SizedBox(
          //     //   height: 28.h,
          //     // ),
          //     // Spacer(),
          //     Align(
          //       alignment: Alignment.center,
          //       child: Container(
          //         decoration: BoxDecoration(
          //           // color: brandOne,
          //           shape: BoxShape.circle,
          //         ),
          //         child: Padding(
          //           padding: EdgeInsets.all(15.h),
          //           child: Icon(
          //             Icons.security,
          //             color: brandOne,
          //             size: 100.sp,
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       height: 11.h,
          //     ),
          //     Align(
          //       alignment: Alignment.topLeft,
          //       child: Text(
          //         'Identity Verification',
          //         style: GoogleFonts.nunito(
          //           color: brandOne,
          //           fontWeight: FontWeight.w800,
          //           fontSize: 23.sp,
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       height: 3.h,
          //     ),
          //     Text(
          //       "Help us verify your account by choosing one of the below options below. Thank you for using swift",
          //       style: GoogleFonts.nunito(
          //         color: brandOne,
          //         fontSize: 15.sp,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),

          //     Spacer(),
          //     ElevatedButton(
          //             style: ElevatedButton.styleFrom(
          //               minimumSize: const Size(300, 50),
          //               backgroundColor: brandOne,
          //               elevation: 0,
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(
          //                   10,
          //                 ),
          //               ),
          //             ),
          //             onPressed: () {
          //               // Get.to(const LoanPage());
          //             },
          //             child: Text(
          //               'Take Loan',
          //               textAlign: TextAlign.center,
          //               style: GoogleFonts.nunito(
          //                 color: Colors.white,
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w700,
          //               ),
          //             ),
          //           ),
          //     // CurvedCustomButton(buttonText: 'Verify Identity', buttonColor: backgroundColor, onTap:() {
          //     //   Navigator.pushNamed(context, RouteList.home);

          //     // }, buttonTextColor: boldText)
          //   ],
          // ),
        ),
      ),
    );
  }
}
