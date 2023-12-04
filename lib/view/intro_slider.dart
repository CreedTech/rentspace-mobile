import 'package:rentspace/view/slider_done.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:flutter/foundation.dart';

const String slide1 =
    'https://firebasestorage.googleapis.com/v0/b/fewsure-351c8.appspot.com/o/assets%2Fintro%2Fintro1.jpg?alt=media&token=61817591-a969-4766-b6c2-f08fec27a2d4';
const String slide2 =
    'https://firebasestorage.googleapis.com/v0/b/fewsure-351c8.appspot.com/o/assets%2Fintro%2Fintro2.png?alt=media&token=bd1379f9-333c-4934-85e7-2eec4c2e4266';
const String slide3 =
    'https://firebasestorage.googleapis.com/v0/b/fewsure-351c8.appspot.com/o/assets%2Fintro%2Fintro3.jpg?alt=media&token=63b60821-c32c-4253-8723-5afa633ba2a8';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Get.offAll(() => SliderDone());
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
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      pageColor: Colors.transparent,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,

      pages: [
        PageViewModel(
          title: "Save. Earn. Repeat",
          body: "",
          image: _buildFullscreenImage('assets/slider1.png'),
          decoration: pageDecoration.copyWith(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: "DefaultFontFamily",
              fontWeight: FontWeight.bold,
            ),
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 1,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          title: "Set Goals, Stay Focused, Make Money, Save Money!",
          body: "",
          image: _buildFullscreenImage('assets/slider2.png'),
          decoration: pageDecoration.copyWith(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: "DefaultFontFamily",
              fontWeight: FontWeight.bold,
            ),
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 1,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          title: "Save & Earn. Build Your Savings With Us Today!",
          body: "",
          image: _buildFullscreenImage('assets/slider3.png'),
          decoration: pageDecoration.copyWith(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: "DefaultFontFamily",
              fontWeight: FontWeight.bold,
            ),
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 1,
            imageFlex: 3,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),

      skip: const Text(
        'Skip',
        style: TextStyle(
          color: Colors.white,
          fontFamily: "DefaultFontFamily",
        ),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
      done: const Text(
        'Get started',
        style: TextStyle(
          color: Colors.white,
          fontFamily: "DefaultFontFamily",
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
