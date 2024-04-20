import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/login_page.dart';
import 'package:rentspace/view/signup_page.dart';

import 'onboarding_contents.dart';
import 'slider_done.dart';

class OnboardingSlider extends StatefulWidget {
  const OnboardingSlider({super.key});

  @override
  State<OnboardingSlider> createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlider> {
  late PageController _controller;
  final sessionStateStream = StreamController<SessionState>();

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;
  List colors = const [
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
        color: _currentPage == index ? brandFive : const Color(0xffD9D9D9),
      ),
      // margin: const EdgeInsets.only(right: 5),
      height: 13,
      curve: Curves.easeIn,
      width: 13,
    );
  }

  // void _onIntroEnd(context) {
  //   Navigator.of(context).pushAndRemoveUntil(
  //     MaterialPageRoute(
  //       builder: (context) => const SliderDone(),
  //     ),
  //     (route) => false,
  //   );
  //   // Get.offAll(() => const SliderDone());
  // }

  Widget _buildFullscreenImage(String name) {
    return Image.asset(
      name,
      //color: Colors.lightBlue.shade300.withOpacity(0.8),
      colorBlendMode: BlendMode.modulate,
      fit: BoxFit.fitHeight,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: contents.length,
              itemBuilder: (context, i) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(contents[i].image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Image.asset(
                            'assets/icons/RentSpaceWhite.png',
                            // width: 140,
                            height: 53,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _currentPage + 1 == contents.length
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Navigator.of(context).pushNamed(getStarted);
                                              Get.to(const SignupPage());
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff40AAD9),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              minimumSize: Size(300.w, 50.h),
                                              // padding:
                                              //      EdgeInsets.symmetric(
                                              //         horizontal: (MediaQuery.of(context).size.width <= 550) ? 70.w :100.w,
                                              //         vertical: 15.h),
                                              // textStyle: const TextStyle(
                                              //     color: brandFour,
                                              //     fontSize: 13),
                                            ),
                                            child: AutoSizeText(
                                              maxLines: 1,
                                              "Create an account",
                                              minFontSize: 10,
                                              maxFontSize: 14,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  // fontSize: 14.sp,
                                                  fontSize: 14.sp),
                                              // ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 3, bottom: 10),
                                          //                            ElevatedButton(
                                          //   style: ElevatedButton.styleFrom(
                                          //     minimumSize: Size(400.w, 50.h),
                                          //     backgroundColor: colorPrimary,
                                          //     elevation: 0,
                                          //     shape: RoundedRectangleBorder(
                                          //       borderRadius: BorderRadius.circular(
                                          //           88), // Adjust the radius as needed
                                          //     ),
                                          //   ),
                                          //   onPressed: () {
                                          //     Navigator.of(context).pushNamed(login);
                                          //   },
                                          //   child: const Text(
                                          //     'Sign in',
                                          //     textAlign: TextAlign.center,
                                          //   ).normalSized(16).colors(colorWhite),
                                          // ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Navigator.of(context).push(Material);
                                              Get.to(
                                                LoginPage(
                                                  sessionStateStream:
                                                      sessionStateStream,
                                                  // loggedOutReason: "Logged out because of user inactivity",
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              minimumSize: Size(300.w, 50.h),
                                            ),
                                            child: AutoSizeText(
                                              maxLines: 1,
                                              "Sign In",
                                              minFontSize: 10,
                                              maxFontSize: 14,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  // fontSize: 14.sp,
                                                  fontSize: 14.sp),
                                              // ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _controller.nextPage(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.easeIn,
                                          );
                                          // Navigator.of(context).pushNamed(getStarted);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          minimumSize: Size(300.w, 50.h),
                                        ),
                                        child: AutoSizeText(
                                          maxLines: 1,
                                          "Get Started",
                                          minFontSize: 10,
                                          maxFontSize: 14,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    contents.length,
                                    (int index) => _buildDots(
                                      index: index,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
