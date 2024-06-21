import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../api/global_services.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/widgets/custom_dialog.dart';
import '../../onboarding/FirstPage.dart';

String fundedAmount = "0";
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
bool _isLoading = true;

bool hasCreatedPayment = false;
bool hasDoneWebview = false;
const _chars = '1234567890';
Random _rnd = Random();
String _payUrl = "";
String _mssg = "Initiating payment...";
String _mssgBody = "";

var ch8t = NumberFormat.simpleCurrency(name: 'NGN');

class SpaceRentFunding extends StatefulWidget {
  double amount;
  // , numPayment;
  String
      // refId,
      // userID,
      //  date,
      interval;
  SpaceRentFunding({
    Key? key,
    required this.amount,
    // required this.date,
    required this.interval,
    // required this.numPayment,
    // required this.refId,
    // required this.userID,
  }) : super(key: key);

  @override
  _SpaceRentFundingState createState() => _SpaceRentFundingState();
}

class _SpaceRentFundingState extends State<SpaceRentFunding> {
  late WebViewController webViewController;
  String userFirst = '';
  String userLast = '';
  String userMail = '';
  String cardCvv = '';
  String cardDigit = '';
  String cardExpire = '';
  String userPhone = '';
  String walletID = '';

  bool canGoBack = false;

  String getRandom(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  createPayment() async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    // const String apiUrl = AppConstants.CREATE_PAYMENT;
    // const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';
    final response = await http.post(
      Uri.parse(AppConstants.BASE_URL + AppConstants.CREATE_PAYMENT),
      headers: {
        'Authorization': 'Bearer $authToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "amount": widget.amount,
        "email": userController.userModel!.userDetails![0].email.toString(),
        "country": "NG",
        "currency": "NGN",
        // "initiate_type": "inline",
        "payment_methods": "card",
      }),
    );
    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final checkoutUrl = jsonResponse['message']['data']["url"];
      print(checkoutUrl);
      setState(() {
        _payUrl = checkoutUrl;
        hasCreatedPayment = true;
        _mssg = "Loading payment modal...";
      });
    } else {
      // Error handling
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
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    setState(() {
      hasCreatedPayment = false;
      _isLoading = true;
      _payUrl = "";
      _mssgBody = "";
      _mssg = "Initiating payment...";
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
          onTap: () async {
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
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _mssg,
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _mssgBody,
                    style: GoogleFonts.lato(
                      fontSize: 15,
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
                if (context.mounted) {
                  customErrorDialog(
                    context,
                    'Error',
                    e.toString(),
                  );
                }
                showTopSnackBar(
                  Overlay.of(context),
                  CustomSnackBar.error(
                    // backgroundColor: brandOne,
                    message: e.toString(),
                    textStyle: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
                // Get.snackbar(
                //   "Error",
                //   e.toString(),
                //   animationDuration: const Duration(seconds: 2),
                //   backgroundColor: Colors.red,
                //   colorText: Colors.white,
                //   snackPosition: SnackPosition.BOTTOM,
                // );
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
