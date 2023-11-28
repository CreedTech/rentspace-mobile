import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:settings_ui/settings_ui.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

////Social webview
class TermsAndConditions extends StatefulWidget {
  TermsAndConditions({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
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
              initialUrl: "https://rentspace.tech/terms/",
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}
