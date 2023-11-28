import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:readmore/readmore.dart';

class FaqsPage extends StatefulWidget {
  const FaqsPage({Key? key}) : super(key: key);

  @override
  _FaqsPageState createState() => _FaqsPageState();
}

class _FaqsPageState extends State<FaqsPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
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
          'FAQs',
          style: TextStyle(
            fontFamily: "DefaultFontFamily",
            color: Theme.of(context).primaryColor,
            fontSize: 16,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/icons/RentSpace-icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            children: [
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                child: ReadMoreText(
                  'What is RentSpace?\nRentSpace is a very secure online savings platform that helps to simplify savings. RentSpace makes saving possible by combining discipline plus flexibility to make you grow your savings.',
                  trimLines: 2,
                  style: TextStyle(
                    fontFamily: "DefaultFontFamily",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    height: 1.5,
                    color: Theme.of(context).primaryColor,
                  ),
                  colorClickableText: brandTwo,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...View more',
                  trimExpandedText: ' Hide',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                child: ReadMoreText(
                  'How do I Sign Up?\n1. To sign-up you will need to download the RentSpace App from the Google Play Store or the Apple App store. Here are the steps to follow:\n2. Open the app store on your device (Google Play Store for Android, App Store for iOS)\n3. Search for "RentSpace" in the app store.\n4. Locate the app and select "Download" or "Install"\n5. Wait for the app to download and install on your device\n6. Once the installation is complete, you can open the app and create an account by selecting the ‘Become a RentSpace User’ button',
                  trimLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: "DefaultFontFamily",
                    color: Theme.of(context).primaryColor,
                  ),
                  colorClickableText: brandTwo,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...View more',
                  trimExpandedText: ' Hide',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                child: ReadMoreText(
                  "What do I need to verify my account on the RentSpace App?\nTo get verified on RentSpace you will need to do the following;\nUploads clear photos of documents proving your identity i.e. International passport, Digital NIN Slip, NIN ID Card, NIN Slip or Voter's Card.\nRecord a short selfie video of yourself\nProvide your Phone number.",
                  trimLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: "DefaultFontFamily",
                    color: Theme.of(context).primaryColor,
                  ),
                  colorClickableText: brandTwo,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...View more',
                  trimExpandedText: ' Hide',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                child: ReadMoreText(
                  "What Products or services does RentSpace offer?\nRentSpace currently offers 5 unique savings plans and they are listed below;\n1. Space Rent allows you to save for rent. Save 70% of your rent for a minimum of 90 days at an interest of  14% and get 100%.\n2. Safe Tank - Savings is kept for a specific period, and interest is paid to your wallet upfront at 12% per annum.\n3. Safe Box - A savings towards a specific desired financial objective at your  own desired pace and frequency i.e. daily, weekly, or monthly.\n4. Space Deposit - Fix your money for a specific period and earn up to  14% interest per annum.\n5. Space Auto - Save for a minimum of 10 months at an interest of 14% per annum and  qualify for a car loan.",
                  trimLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: "DefaultFontFamily",
                    color: Theme.of(context).primaryColor,
                  ),
                  colorClickableText: brandTwo,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...View more',
                  trimExpandedText: ' Hide',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                child: ReadMoreText(
                  "Is there a limit to the number of savings plans i can have at a particular time?\n There is no limit to the number of plans you can have on Rent space",
                  trimLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: "DefaultFontFamily",
                    color: Theme.of(context).primaryColor,
                  ),
                  colorClickableText: brandTwo,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...View more',
                  trimExpandedText: ' Hide',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                child: ReadMoreText(
                  "I can't sign into my account / I forgot my password?\nFirst you need to verify that the email and password you entered are both correct. If the email is correct but you cannot remember the password then you can reset the password by clicking on 'forgot password' from the sign-in page, then go to your email inbox to view the reset password email and click on the reset password link.\nIf you do not receive an email to reset your password,\n- Check your spam folder.\n- Confirm the right email was inputted.\n- If the email is wrong, go back and update.",
                  trimLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: "DefaultFontFamily",
                    color: Theme.of(context).primaryColor,
                  ),
                  colorClickableText: brandTwo,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...View more',
                  trimExpandedText: ' Hide',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                child: ReadMoreText(
                  "How safe is my personal data on the RentSpace App?\nAll information shared with RentSpace is safe and secured. Our Customer Data is encrypted and securely stored.",
                  trimLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: "DefaultFontFamily",
                    color: Theme.of(context).primaryColor,
                  ),
                  colorClickableText: brandTwo,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...View more',
                  trimExpandedText: ' Hide',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                child: ReadMoreText(
                  "How do I qualify for interest on the RentSpace App?\nYour savings will need to exist for a minimum of 30 days to qualify for interest.",
                  trimLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: "DefaultFontFamily",
                    color: Theme.of(context).primaryColor,
                  ),
                  colorClickableText: brandTwo,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...View more',
                  trimExpandedText: ' Hide',
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
