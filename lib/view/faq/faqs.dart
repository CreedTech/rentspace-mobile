import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/onboarding/FirstPage.dart';
import 'package:rentspace/view/contact/contact_us.dart';

class FaqsPage extends StatefulWidget {
  const FaqsPage({super.key});

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
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF105182),
                  Theme.of(context).canvasColor
                ],
                stops: const [0.0, 0.71],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50,top: 50),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios_sharp,
                                  size: 27,
                                  color: colorWhite,
                                ),
                              ),
                              SizedBox(
                                width: 4.h,
                              ),
                              Text(
                                'FAQs',
                                style: GoogleFonts.lato(
                                  color: colorWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            'assets/logo.png',
                            height: 35.7.h,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Hello ${userController.userModel!.userDetails![0].userName.capitalize},\nHow can we help you?',
                        style: GoogleFonts.lato(
                          color: colorWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                       
                        ExpansionTile(
                          
                          initiallyExpanded: true,
                          title: Text(
                            'What is RentSpace?',
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary),
                          ),
                          backgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          collapsedBackgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          iconColor:
                              Theme.of(context).colorScheme.primary,
                          collapsedIconColor:
                              Theme.of(context).colorScheme.primary,
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          childrenPadding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          children: [
                            Text(
                              "RentSpace is a very secure online savings platform that helps to simplify savings. RentSpace makes saving possible by combining discipline plus flexibility to make you grow your savings.",
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ExpansionTile(
                          initiallyExpanded: false,
                          title: Text(
                            'How do I Sign Up?',
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary),
                          ),
                          backgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          collapsedBackgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          iconColor:
                              Theme.of(context).colorScheme.primary,
                          collapsedIconColor:
                              Theme.of(context).colorScheme.primary,
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          childrenPadding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          children: [
                            Text(
                              ' To sign-up you will need to download the RentSpace App from the Google Play Store or the Apple App store.\n Here are the steps to follow:\nOpen the app store on your device (Google Play Store for Android, App Store for iOS). \nSearch for "RentSpace" in the app store.\n Locate the app and select "Download" or "Install". \nWait for the app to download and install on your device.\n Once the installation is complete, you can open the app and create an account by selecting the ‘Create Account’ button',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ExpansionTile(
                          initiallyExpanded: false,
                          title: Text(
                            'What do I need to verify my account on the RentSpace App?',
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary),
                          ),
                          backgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          collapsedBackgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          iconColor:
                              Theme.of(context).colorScheme.primary,
                          collapsedIconColor:
                              Theme.of(context).colorScheme.primary,
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          childrenPadding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          children: [
                            Text(
                              "To get verified on RentSpace you will need to do the following; Verify Email Address, Add BVN for verification.",
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ExpansionTile(
                          initiallyExpanded: false,
                          title: Text(
                            'What Products or services does RentSpace offer?',
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary),
                          ),
                          backgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          collapsedBackgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          iconColor:
                              Theme.of(context).colorScheme.primary,
                          collapsedIconColor:
                              Theme.of(context).colorScheme.primary,
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          childrenPadding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          children: [
                            Text(
                              "RentSpace currently offers \n1) . Space Rent  which allows you to save for rent - Save 70% of rent for a minimum of 6 months (maximum of 8 months) and get up to 30% loan. \n2). Virtual Accounts - To Send Money and receive money seamlessly . \n3). Bill Payments - Buy Airtime, Data Bundles, Cable Payments, Electricity Bills and earn spacepoints",
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ExpansionTile(
                          initiallyExpanded: false,
                          title: Text(
                            'Is there a limit to the number of savings plans i can have at a particular time?',
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary),
                          ),
                          backgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          collapsedBackgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          iconColor:
                              Theme.of(context).colorScheme.primary,
                          collapsedIconColor:
                              Theme.of(context).colorScheme.primary,
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          childrenPadding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          children: [
                            Text(
                              "There is no limit to the number of plans you can have on Rent space.",
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ExpansionTile(
                          initiallyExpanded: false,
                          title: Text(
                            "I can't sign into my account / I forgot my password?",
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary),
                          ),
                          backgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          collapsedBackgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          iconColor:
                              Theme.of(context).colorScheme.primary,
                          collapsedIconColor:
                              Theme.of(context).colorScheme.primary,
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          childrenPadding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          children: [
                            Text(
                              "irst you need to verify that the email and password you entered are both correct. If the email is correct but you cannot remember the password then you can reset the password by clicking on 'forgot password' from the sign-in page, it would take you to the forgot password page where you would be asked to input the email you using to sign-up and click send otp. Once you enter your mail , an otp would be sent to that mail. Enter the otp into the next screen, then enter a new password and confirm your password. Voila!!! You're good to go",
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ExpansionTile(
                          initiallyExpanded: false,
                          title: Text(
                            "How safe is my personal data on the RentSpace App?",
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary),
                          ),
                          backgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          collapsedBackgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          iconColor:
                              Theme.of(context).colorScheme.primary,
                          collapsedIconColor:
                              Theme.of(context).colorScheme.primary,
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          childrenPadding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          children: [
                            Text(
                              "All information shared with RentSpace is safe and secured. Our Customer Data is encrypted and securely stored.",
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ExpansionTile(
                          initiallyExpanded: false,
                          title: Text(
                            "How do I qualify for interest on the RentSpace App?",
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary),
                          ),
                          backgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          collapsedBackgroundColor:
                              (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(5, 255, 255, 255)
                                  : colorWhite,
                          iconColor:
                              Theme.of(context).colorScheme.primary,
                          collapsedIconColor:
                              Theme.of(context).colorScheme.primary,
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          childrenPadding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          expandedAlignment: Alignment.topLeft,
                          children: [
                            Text(
                              "By Saving Consistently ",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            left: 20,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width - 50, 50),
                  backgroundColor: brandTwo,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                onPressed: () {
                  Get.to(const ContactUsPage());
                },
                child: Text(
                  'Contact Us',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: colorWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
