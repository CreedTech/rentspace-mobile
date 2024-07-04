import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/widgets/custom_loader.dart';

import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../widgets/copy_widget.dart';
import '../../widgets/custom_dialogs/index.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

launchEmail(
  BuildContext context, {
  required String toEmail,
  required String subject,
  required String message,
}) async {
  final url =
      "mailto: $toEmail?subject=${Uri.encodeFull(subject)}body=${Uri.encodeFull(message)}";
  try {
    await launchUrl(Uri.parse(url));
  } catch (error) {
    if (context.mounted) {
      customErrorDialog(
          context, "Invalid!", "Please fill the form properly to proceed");
    }
    // Get.snackbar(
    //   "Oops",
    //   "Something went wrong, try again later",
    //   animationDuration: const Duration(seconds: 1),
    //   backgroundColor: Colors.red,
    //   colorText: Colors.white,
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
}

class _ContactUsPageState extends State<ContactUsPage> {
  String facebookLink =
      'https://m.facebook.com/people/Rentspacetech/100083035015197/';
  String linkedinLink = 'https://www.linkedin.com/company/rentspace.tech/';
  String instagramLink =
      'https://instagram.com/rentspacetech?igshid=YmMyMTA2M2Y=';
  String twitterLink = 'https://x.com/rentspacetech?s=20';
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: 4.h,
              ),
              Text(
                'Contact Us',
                style: GoogleFonts.lato(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                // SizedBox(
                //   height: 50,
                // ),
                //bvn value
                ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Text(
                      "Hey there, need a hand or have something exciting to share? We'd love to hear from you! Get in touch and let's make finance fun together!",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Container(
                            // width: 450,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.1), // Shadow color
                                  spreadRadius: 0.5, // Spread radius
                                  blurRadius: 2, // Blur radius
                                  offset: const Offset(0, 3), // Offset
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email address",
                                    style: GoogleFonts.lato(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            launchEmail(
                                              context,
                                              toEmail: 'support@rentspace.tech',
                                              subject: 'Help & support',
                                              message:
                                                  'Hi, could you assist me with..... in the RentSpace app?\nThanks.',
                                            );
                                          },
                                          child: Text(
                                            'support@rentspace.tech',
                                            style: GoogleFonts.lato(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const CopyWidget(
                                          text: 'support@rentspace.tech',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

////Social webview
class SocialPagesWeb extends StatefulWidget {
  String initialUrl;
  SocialPagesWeb({super.key, required this.initialUrl});

  @override
  _SocialPagesWebState createState() => _SocialPagesWebState();
}

class _SocialPagesWebState extends State<SocialPagesWeb> {
  late WebViewController webViewController;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.close,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          'RentSpace',
          style: GoogleFonts.lato(
            color: brandOne,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: WebView(
              userAgent: "random",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (webViewController) {
                this.webViewController = webViewController;
              },
              onPageFinished: (val) {
                setState(() {
                  _isLoading = false;
                });
              },
              initialUrl: widget.initialUrl,
            ),
          ),
          if (_isLoading)
            const Center(
              child: CustomLoader(),
            ),
        ],
      ),
    );
  }
}
