import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ShareAndEarn extends StatefulWidget {
  const ShareAndEarn({Key? key}) : super(key: key);

  @override
  _ShareAndEarnState createState() => _ShareAndEarnState();
}

class _ShareAndEarnState extends State<ShareAndEarn> {
  final UserController userController = Get.find();
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
            Icons.close,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.1,
          //     child: Image.asset(
          //       'assets/icons/RentSpace-icon.png',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      userController.user[0].referals.toString(),
                      style: TextStyle(
                        fontSize: 40.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'REFERRAL CODE: ${userController.user[0].referalCode}',
                      style: TextStyle(
                        fontSize: 14.0,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/share.png",
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Participate in our exclusive program and seize the opportunity to earn ₦1,000 simply by referring friends through your unique code . As you introduce more friends to our platform, your earnings increase – and the best part is that the money is paid directly to your space wallet.",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "DefaultFontFamily",
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: GFButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            "Sign up with my code: ${userController.user[0].referalCode} to earn a free point!",
                      ),
                    );
                    Fluttertoast.showToast(
                      msg: "Your referal code has been copied to clipboard!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: brandOne,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Share.share(
                        "Hello, click this link https://play.google.com/store/apps/details?id=com.rentspace.app.android to download RentSpace and use my referal code, ${userController.user[0].referalCode} to sign up and earn a point!");
                  },
                  icon: Icon(
                    Icons.share_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  color: brandOne,
                  shape: GFButtonShape.pills,
                  padding: EdgeInsets.all(5),
                  text: "Share now!",
                  fullWidthButton: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
