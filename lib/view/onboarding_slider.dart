import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/login_page.dart';
import 'package:rentspace/view/signup_page.dart';

import 'onboarding_contents.dart';

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
        color: _currentPage == index ? brandOne : const Color(0xffB6E0FF),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 5,
      curve: Curves.easeIn,
      width: _currentPage == index ? 26 : 9,
    );
  }

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
      backgroundColor: colors[_currentPage],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorWhite,
        centerTitle: true,
        title: Image.asset(
          'assets/logoColored.png',
          height: 35.7.h,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 60.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          contents[i].image,
                          height: 188.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35.w),
                          child: Column(
                            children: [
                              Text(
                                contents[i].title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: brandOne),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                contents[i].desc,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  height: 1.5714,
                                  color: const Color(0xff4E4B4B),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 85.h),
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
                        ),
                        SizedBox(height: 50.h),
                        _currentPage + 1 == contents.length
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width -
                                                50,
                                            50),
                                        backgroundColor: brandTwo,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.to(const SignupPage());
                                      },
                                      child: Text(
                                        "Sign up",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Already have an account? ',
                                            style: GoogleFonts.lato(
                                              color: const Color(0xff272727),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          // const SizedBox(
                                          //   width: 10,
                                          // ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                LoginPage(
                                                  sessionStateStream:
                                                      sessionStateStream,
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Sign In',
                                              style: GoogleFonts.lato(
                                                  color: brandTwo,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width - 50,
                                        50),
                                    backgroundColor: brandTwo,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    _controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  child: Text(
                                    "Continue",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                // Padding(
                                //   padding:
                                //       EdgeInsets.symmetric(horizontal: 20.w),
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       _controller.nextPage(
                                //         duration:
                                //             const Duration(milliseconds: 200),
                                //         curve: Curves.easeIn,
                                //       );
                                //     },
                                //     child: Container(
                                //       // width: MediaQuery.of(context).size.width,
                                //       height: 50,
                                //       padding:
                                //           EdgeInsets.symmetric(vertical: 15.h),
                                //       alignment: Alignment.center,
                                //       decoration: const BoxDecoration(
                                //         color: brandTwo,
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(10)),
                                //       ),
                                //       child: const Text(
                                //         'Continue',
                                //         style: TextStyle(
                                //             fontSize: 14, color: Colors.white),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // body: Column(
      //   children: [
      //     Expanded(
      //       flex: 3,
      //       child: PageView.builder(
      //         physics: const BouncingScrollPhysics(),
      //         controller: _controller,
      //         onPageChanged: (value) => setState(() => _currentPage = value),
      //         itemCount: contents.length,
      //         itemBuilder: (context, i) {
      //           return Container(
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                 image: AssetImage(contents[i].image),
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //             child: Padding(
      //               padding: EdgeInsets.symmetric(horizontal: 16),
      //               child: Column(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.only(top: 40),
      //                     child: Image.asset(
      //                       'assets/icons/RentSpaceWhite.png',
      //                       // width: 140,
      //                       height: 53,
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     height: 30,
      //                   ),
      //                   Expanded(
      //                     flex: 2,
      //                     child: Column(
      //                       mainAxisAlignment: MainAxisAlignment.end,
      //                       children: [
      //                         _currentPage + 1 == contents.length
      //                             ? Column(
      //                                 children: [
      //                                   Padding(
      //                                     padding: const EdgeInsets.all(3),
      //                                     child: ElevatedButton(
      //                                       onPressed: () {
      //                                         // Navigator.of(context).pushNamed(getStarted);
      //                                         Get.to(const SignupPage());
      //                                       },
      //                                       style: ElevatedButton.styleFrom(
      //                                         backgroundColor:
      //                                             const Color(0xff40AAD9),
      //                                         shape: RoundedRectangleBorder(
      //                                           borderRadius:
      //                                               BorderRadius.circular(8),
      //                                         ),
      //                                         minimumSize: Size(300.w, 50.h),
      //                                         // padding:
      //                                         //      EdgeInsets.symmetric(
      //                                         //         horizontal: (MediaQuery.of(context).size.width <= 550) ? 70.w :100.w,
      //                                         //         vertical: 15.h),
      //                                         // textStyle: const TextStyle(
      //                                         //     color: brandFour,
      //                                         //     fontSize: 13),
      //                                       ),
      //                                       child: AutoSizeText(
      //                                         maxLines: 1,
      //                                         "Create an account",
      //                                         minFontSize: 10,
      //                                         maxFontSize: 14,
      //                                         style: GoogleFonts.lato(
      //                                             color: Colors.white,
      //                                             fontWeight: FontWeight.w600,
      //                                             // fontSize: 14,
      //                                             fontSize: 14),
      //                                         // ),
      //                                       ),
      //                                     ),
      //                                   ),
      //                                   Padding(
      //                                     padding: const EdgeInsets.only(
      //                                         top: 3, bottom: 10),
      //                                     child: ElevatedButton(
      //                                       onPressed: () {
      //                                         // Navigator.of(context).push(Material);
      //                                         Get.to(
      //                                           LoginPage(
      //                                             sessionStateStream:
      //                                                 sessionStateStream,
      //                                             // loggedOutReason: "Logged out because of user inactivity",
      //                                           ),
      //                                         );
      //                                       },
      //                                       style: ElevatedButton.styleFrom(
      //                                         backgroundColor: Colors.white,
      //                                         shape: RoundedRectangleBorder(
      //                                           borderRadius:
      //                                               BorderRadius.circular(8),
      //                                         ),
      //                                         minimumSize: Size(300.w, 50.h),
      //                                       ),
      //                                       child: AutoSizeText(
      //                                         maxLines: 1,
      //                                         "Sign In",
      //                                         minFontSize: 10,
      //                                         maxFontSize: 14,
      //                                         style: GoogleFonts.lato(
      //                                             color: Colors.black,
      //                                             fontWeight: FontWeight.w600,
      //                                             // fontSize: 14,
      //                                             fontSize: 14),
      //                                         // ),
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 ],
      //                               )
      //                             : Padding(
      //                                 padding: const EdgeInsets.all(10),
      //                                 child: ElevatedButton(
      //                                   onPressed: () {
      //                                     _controller.nextPage(
      //                                       duration: const Duration(
      //                                           milliseconds: 200),
      //                                       curve: Curves.easeIn,
      //                                     );
      //                                     // Navigator.of(context).pushNamed(getStarted);
      //                                   },
      //                                   style: ElevatedButton.styleFrom(
      //                                     backgroundColor: Colors.white,
      //                                     shape: RoundedRectangleBorder(
      //                                       borderRadius:
      //                                           BorderRadius.circular(8),
      //                                     ),
      //                                     minimumSize: Size(300.w, 50.h),
      //                                   ),
      //                                   child: AutoSizeText(
      //                                     maxLines: 1,
      //                                     "Get Started",
      //                                     minFontSize: 10,
      //                                     maxFontSize: 14,
      //                                     style: GoogleFonts.lato(
      //                                         color: Colors.black,
      //                                         fontWeight: FontWeight.w600,
      //                                         fontSize: 14),
      //                                   ),
      //                                 ),
      //                               ),
      //                         Padding(
      //                           padding: const EdgeInsets.all(8.0),
      //                           child: Row(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: List.generate(
      //                               contents.length,
      //                               (int index) => _buildDots(
      //                                 index: index,
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
