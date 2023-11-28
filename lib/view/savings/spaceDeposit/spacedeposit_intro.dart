import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_subscription.dart';

class SpaceDepositIntro extends StatefulWidget {
  const SpaceDepositIntro({Key? key}) : super(key: key);

  @override
  _SpaceDepositIntroState createState() => _SpaceDepositIntroState();
}

class _SpaceDepositIntroState extends State<SpaceDepositIntro> {
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
              "assets/icons/savings/spacedeposit.png",
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "SpaceDeposit",
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: "DefaultFontFamily",
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Earn up to 14% interest and watch your money grow without stress. Start saving today!",
              style: TextStyle(
                fontSize: 14.0,
                letterSpacing: 0.5,
                fontFamily: "DefaultFontFamily",
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/icons/iconset/depositimg.png",
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: 40,
            ),
            GFButton(
              onPressed: () {
                Get.to(SpaceDepositSubscription());
              },
              icon: Icon(
                Icons.add_circle_outline_outlined,
                size: 30,
                color: Colors.white,
              ),
              color: brandOne,
              text: "Create new SpaceDeposit",
              shape: GFButtonShape.square,
              fullWidthButton: true,
            ),
          ],
        ),
      ),
    );
  }
}
