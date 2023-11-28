import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_subscription.dart';
import 'package:rentspace/view/terms_and_conditions.dart';

class SpaceRentIntro extends StatefulWidget {
  const SpaceRentIntro({Key? key}) : super(key: key);

  @override
  _SpaceRentIntroState createState() => _SpaceRentIntroState();
}

class _SpaceRentIntroState extends State<SpaceRentIntro> {
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
              "assets/icons/savings/spacerent.png",
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "SpaceRent",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontFamily: "DefaultFontFamily",
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Save 70% of rent for a minimum of 90 days at an interest up to 14% and get 100% (Terms and conditions apply)",
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
              "assets/icons/rent_intro_one.png",
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: 40,
            ),
            GFButton(
              onPressed: () {
                Get.to(RentSpaceSubscription());
              },
              icon: Icon(
                Icons.add_circle_outline_outlined,
                size: 30,
                color: Colors.white,
              ),
              color: brandOne,
              text: "Create new SpaceRent",
              shape: GFButtonShape.square,
              fullWidthButton: true,
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Get.to(TermsAndConditions());
              },
              child: Text(
                "By proceeding, you agree with our terms and conditions",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.red,
                  fontFamily: "DefaultFontFamily",
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
