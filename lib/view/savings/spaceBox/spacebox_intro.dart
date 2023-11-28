import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/savings/spaceBox/spacebox_subscription.dart';

class SpaceBoxIntro extends StatefulWidget {
  const SpaceBoxIntro({Key? key}) : super(key: key);

  @override
  _SpaceBoxIntroState createState() => _SpaceBoxIntroState();
}

class _SpaceBoxIntroState extends State<SpaceBoxIntro> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Create Savings Plans',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
            fontFamily: "DefaultFontFamily",
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/icons/iconset/save_one.png",
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "SpaceBox",
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: "DefaultFontFamily",
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "No more wishing and waiting.  Set a goal. Save at your own pace, earn up to 14% interest rate, and reach your financial goals",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "DefaultFontFamily",
                letterSpacing: 0.5,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/icons/box_intro_one.png",
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: 40,
            ),
            GFButton(
              onPressed: () {
                Get.to(SpaceBoxSubscription());
              },
              icon: Icon(
                Icons.add_circle_outline_outlined,
                size: 30,
                color: Colors.white,
              ),
              color: brandOne,
              text: "Create new SpaceBox",
              shape: GFButtonShape.square,
              fullWidthButton: true,
            ),
          ],
        ),
      ),
    );
  }
}
