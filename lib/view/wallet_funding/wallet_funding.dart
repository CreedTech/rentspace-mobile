// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rentspace/widgets/custom_loader.dart';
import 'dart:convert';
import 'dart:math';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import '../../api/global_services.dart';
import '../../controller/wallet/wallet_controller.dart';
import '../../widgets/custom_dialogs/index.dart';

class WalletFunding extends StatefulWidget {
  int amount, numPayment;
  String savingsID, date, interval;
  WalletFunding({
    super.key,
    required this.amount,
    required this.date,
    required this.interval,
    required this.numPayment,
    required this.savingsID,
  });

  @override
  _WalletFundingState createState() => _WalletFundingState();
}

class _WalletFundingState extends State<WalletFunding> {
  late WebViewController webViewController;
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  String userFirst = '';
  String userLast = '';
  String userMail = '';
  String cardCvv = '';
  String cardDigit = '';
  String cardExpire = '';
  String userPhone = '';
  String walletBalance = '0';
  int intWalletBalance = 0;
  String walletID = '';
  bool canGoBack = false;
  bool hasCreatedPayment = false;
  bool hasDoneWebview = false;
  final _chars = '1234567890';
  final Random _rnd = Random();
  String _payUrl = "";
  String _mssg = "Initiating payment...";
  String _mssgBody = "";

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
        "payment_methods": "card",
      }),
    );
    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final checkoutUrl = jsonResponse['message']['data']["url"];

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
      if (kDebugMode) {
        print(
            'Request failed with status: ${response.statusCode}, ${response.body}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      canGoBack = false;
      hasCreatedPayment = false;
      _payUrl = "";
      _mssgBody = "";
      _mssg = "Initiating payment...";
    });
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
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
            context.pop();
          },
          child: Icon(
            Icons.close,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          'Top Up With Card',
          style: GoogleFonts.lato(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
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
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                const CustomLoader(),
              ],
            )
          : WebView(
              javascriptMode: JavascriptMode.unrestricted,
              debuggingEnabled: true,
              onWebResourceError: (e) {
                if (context.mounted) {
                  customErrorDialog(context, 'Error', e.toString());
                }
              },
              userAgent: 'random',
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
