import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/auth/registration/login_page.dart';
import 'package:rentspace/view/auth/registration/signup_page.dart';

import 'onboarding_contents.dart';

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
        color: _currentPage == index
            ? Theme.of(context).colorScheme.secondary
            : const Color(0xffB6E0FF),
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
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                contents[i].desc,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  height: 1.5714,
                                  color: Theme.of(context).primaryColorLight,
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
                                        context.push('/signup');
                                        // Get.to(const SignupPage());
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          // const SizedBox(
                                          //   width: 10,
                                          // ),
                                          GestureDetector(
                                            onTap: () {
                                              context.push('/login');
                                              // Get.to(
                                              //   LoginPage(),
                                              // );
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
    );
  }
}
