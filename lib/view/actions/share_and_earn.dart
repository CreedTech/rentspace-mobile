import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
// import 'package:rentspace/controller/user_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/auth/user_controller.dart';

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
                      userController.users[0].referals.toString(),
                      style: GoogleFonts.nunito(
                        fontSize: 40.0,
                        // letterSpacing: 1.0,
                        fontWeight: FontWeight.w700,
                        // fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    // Todo: work on this part ==========
                    // Text(
                    //   'REFERRAL CODE: ${userController.users[0].referalCode}',
                    //   style: GoogleFonts.nunito(
                    //     fontSize: 14.0,
                    //     // letterSpacing: 0.5,
                    //     fontWeight: FontWeight.w700,
                    //     // fontFamily: "DefaultFontFamily",
                    //     color: Theme.of(context).primaryColor,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/share.png",
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Participate in our exclusive program and seize the opportunity to earn ₦1,000 simply by referring friends through your unique code . As you introduce more friends to our platform, your earnings increase – and the best part is that the money is paid directly to your space wallet.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 16.0,
                    // fontFamily: "DefaultFontFamily",
                    fontWeight: FontWeight.w600,
                    // letterSpacing: 0.5,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // width: MediaQuery.of(context).size.width * 2,
                    alignment: Alignment.center,
                    // height: 110.h,
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 50),
                            backgroundColor: brandOne,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text:
                                    "Sign up with my code: userController.users[0].referalCode to earn a free point!",
                              ),
                            );
                            Fluttertoast.showToast(
                              msg:
                                  "Your referal code has been copied to clipboard!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: brandOne,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Share.share(
                                "Hello, click this link https://play.google.com/store/apps/details?id=com.rentspace.app.android to download RentSpace and use my referal code, userController.users[0].referalCode to sign up and earn a point!");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.share_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Share now!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
