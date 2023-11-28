import 'package:flutter/material.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';

import 'package:get/get.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rentspace/controller/user_controller.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class SpaceBoxPayment extends StatefulWidget {
  double amount;
  String refId;
  SpaceBoxPayment({Key? key, required this.amount, required this.refId})
      : super(key: key);

  @override
  _SpaceBoxPaymentState createState() => _SpaceBoxPaymentState();
}

bool hasCreatedPayment = false;
bool hasDoneWebview = false;
const _chars = '1234567890';
Random _rnd = Random();
String _payUrl = "";
String _mssg = "Initiating payment...";
String _mssgBody = "";

class _SpaceBoxPaymentState extends State<SpaceBoxPayment> {
  late WebViewController webViewController;
  final UserController userController = Get.find();

  String getRandom(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  createPayment() async {
    const String apiUrl = 'https://api-d.squadco.com/transaction/initiate';
    const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "amount": (widget.amount * 100).toString(),
        "email": userController.user[0].email.toString(),
        "currency": "NGN",
        "initiate_type": "inline",
        "transaction_ref": "BOX${widget.refId}",
        "callback_url": "https://rentspace.tech/payment-notice/",
        "is_recurring": "true"
      }),
    );

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final checkoutUrl = jsonResponse['data']["checkout_url"];
      print(checkoutUrl);
      setState(() {
        _payUrl = checkoutUrl;
        hasCreatedPayment = true;
        _mssg = "Loading payment modal...";
      });
    } else {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        _mssg = "Payment failed!";
        _mssgBody = jsonResponse["message"].toString();
      });
      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  @override
  initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    setState(() {
      hasCreatedPayment = false;
      _payUrl = "";
      _mssg = "Initiating payment...";
      _mssgBody = "";
    });
    createPayment();
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
            //resetCalculator();
            Get.back();
          },
          child: Icon(
            Icons.close,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: (!hasDoneWebview && !hasCreatedPayment)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _mssg,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _mssgBody,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "DefaultFontFamily",
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            )
          : WebView(
              javascriptMode: JavascriptMode.unrestricted,
              userAgent: 'random',
              debuggingEnabled: true,
              onWebResourceError: (e) {
                Get.snackbar(
                  "Error",
                  e.toString(),
                  animationDuration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              onPageFinished: (val) {
                webViewController.runJavascript(
                    "document.getElementsByClassName('name')[0].remove()");
                setState(() {
                  hasDoneWebview = true;
                });
              },
              initialUrl: _payUrl,
            ),
    );
  }
}
