import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/login_page.dart';
import 'package:rentspace/view/signup_page.dart';

import 'onboarding_contents.dart';
import 'slider_done.dart';

const String slide1 =
    'https://firebasestorage.googleapis.com/v0/b/fewsure-351c8.appspot.com/o/assets%2Fintro%2Fintro1.jpg?alt=media&token=61817591-a969-4766-b6c2-f08fec27a2d4';
const String slide2 =
    'https://firebasestorage.googleapis.com/v0/b/fewsure-351c8.appspot.com/o/assets%2Fintro%2Fintro2.png?alt=media&token=bd1379f9-333c-4934-85e7-2eec4c2e4266';
const String slide3 =
    'https://firebasestorage.googleapis.com/v0/b/fewsure-351c8.appspot.com/o/assets%2Fintro%2Fintro3.jpg?alt=media&token=63b60821-c32c-4253-8723-5afa633ba2a8';

class OnboardingSlider extends StatefulWidget {
  const OnboardingSlider({super.key});

  @override
  State<OnboardingSlider> createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlider> {
  late PageController _controller;

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

  void _onIntroEnd(context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => SliderDone(),
      ),
      (route) => false,
    );
    // Get.offAll(() => const SliderDone());
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
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: brandFour,
      //   centerTitle: true,
      //   title: Image.asset(
      //     'assets/icons/RentSpaceWhite.png',
      //     height: 120,
      //   ),
      // ),
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
                    padding: const EdgeInsets.all(0.0),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 106,
                                                      vertical: 15),
                                              textStyle: const TextStyle(
                                                  color: brandFour,
                                                  fontSize: 13),
                                            ),
                                            child: Text(
                                              "Create an account",
                                              style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 3, bottom: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Navigator.of(context).push(Material);
                                              Get.to(const LoginPage());
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 140,
                                                      vertical: 15),
                                              textStyle: const TextStyle(
                                                  color: brandFour,
                                                  fontSize: 13),
                                            ),
                                            child: Text(
                                              "Sign In",
                                              style: GoogleFonts.nunito(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.sp,
                                              ),
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 130, vertical: 15),
                                          textStyle: const TextStyle(
                                              color: brandFour, fontSize: 13),
                                        ),
                                        child: Text(
                                          "Get Started",
                                          style: GoogleFonts.nunito(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14.sp,
                                          ),
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
