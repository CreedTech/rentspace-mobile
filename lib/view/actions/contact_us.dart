import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:settings_ui/settings_ui.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

launchEmail({
  required String toEmail,
  required String subject,
  required String message,
}) async {
  final url =
      "mailto: $toEmail?subject=${Uri.encodeFull(subject)}body=${Uri.encodeFull(message)}";
  try {
    await launchUrl(Uri.parse(url));
  } catch (error) {
    Get.snackbar(
      "Oops",
      "Something went wrong, try again later",
      animationDuration: const Duration(seconds: 1),
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class _ContactUsPageState extends State<ContactUsPage> {
  String facebookLink =
      'https://m.facebook.com/people/Rentspacetech/100083035015197/';
  String linkedinLink = 'https://www.linkedin.com/company/rentspace.tech/';
  String instagramLink =
      'https://instagram.com/rentspacetech?igshid=YmMyMTA2M2Y=';
  String twitterLink =
      'https://twitter.com/rentspacetech?s=21&t=CjagU14HMYI6fNIamEOpEw';
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: brandOne,
          ),
        ),
        title: Text(
          'Contact Us',
          style: GoogleFonts.nunito(
              color: brandOne, fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.05,
          //     child: Image.asset(
          //       'assets/icons/RentSpace-icon.png',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        "Hey there, need a hand or have something exciting to share? We'd love to hear from you! Get in touch and let's make finance fun together!",
                        style: GoogleFonts.nunito(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          // fontFamily: "DefaultFontFamily",
                          // letterSpacing: 1.0,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 350,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: brandTwo.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number",
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            '+234 (1) 344 4012',
                                            style: GoogleFonts.nunito(
                                              color: brandOne,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            child: Text(
                                              'Copy',
                                              style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            launchUrl(Uri.parse("tel://013444012"));
                          },
                          leading: const Icon(
                            Icons.phone_outlined,
                            color: brandOne,
                          ),
                          title: Text(
                            'Phone',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "DefaultFontFamily",
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'click to call: +23413444012',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: "DefaultFontFamily",
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_right_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            launchEmail(
                                toEmail: 'support@rentspace.tech',
                                subject: 'Help & support',
                                message:
                                    'Hi, could you assist me with..... in the RentSpace app?\nThanks.');
                          },
                          leading: const Icon(
                            Icons.email_outlined,
                            color: brandOne,
                          ),
                          title: Text(
                            'E-mail',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "DefaultFontFamily",
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'click to send us a mail: support@rentspace.tech',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: "DefaultFontFamily",
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_right_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      onTap: () {
                        Get.to(SocialPagesWeb(
                          initialUrl: facebookLink,
                        ));
                      },
                      leading: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: brandOne,
                      ),
                      title: Text(
                        'Facebook',
                        style: TextStyle(
                            fontFamily: "DefaultFontFamily",
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Like us on Facebook',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DefaultFontFamily",
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Get.to(SocialPagesWeb(
                          initialUrl: twitterLink,
                        ));
                      },
                      leading: const FaIcon(
                        FontAwesomeIcons.twitter,
                        color: brandTwo,
                      ),
                      title: Text(
                        'Twitter',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DefaultFontFamily",
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Follow us on Twitter',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DefaultFontFamily",
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Get.to(SocialPagesWeb(
                          initialUrl: instagramLink,
                        ));
                      },
                      leading: const FaIcon(
                        FontAwesomeIcons.instagram,
                        color: Colors.redAccent,
                      ),
                      title: Text(
                        'Instagram',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DefaultFontFamily",
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'follow us on Instagram',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DefaultFontFamily",
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Get.to(SocialPagesWeb(
                          initialUrl: linkedinLink,
                        ));
                      },
                      leading: const FaIcon(
                        FontAwesomeIcons.linkedin,
                        color: Colors.lightBlue,
                      ),
                      title: Text(
                        'linkedIn',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DefaultFontFamily",
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'join us on LinkedIn',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DefaultFontFamily",
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
  SocialPagesWeb({Key? key, required this.initialUrl}) : super(key: key);

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
        elevation: 0.0,
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
          Container(
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
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}
