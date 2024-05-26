import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/app_constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rentspace/constants/widgets/custom_loader.dart';
import 'dart:convert';
// import 'package:rentspace/controller/user_controller.dart';
import 'dart:math';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
// import 'package:rentspace/constants/theme_services.dart';
// import 'package:get_storage/get_storage.dart';
// import 'dart:io';
// import 'package:rentspace/view/savings/spaceRent/spacerent_payment.dart';

import '../../api/global_services.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../controller/wallet_controller.dart';

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
  // bool _isLoading = true;
  bool canGoBack = false;
  bool hasCreatedPayment = false;
  bool hasDoneWebview = false;
  var _chars = '1234567890';
  Random _rnd = Random();
  String _payUrl = "";
  String _mssg = "Initiating payment...";
  String _mssgBody = "";

  // getCurrentUser() async {
  //   var collection = FirebaseFirestore.instance.collection('accounts');
  //   var docSnapshot = await collection.doc(userId).get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     setState(() {
  //       userFirst = data?['firstname'];
  //       userLast = data?['lastname'];
  //       userMail = data?['email'];
  //       userPhone = data?['phone'];
  //       walletID = data?['wallet_id'];
  //       cardCvv = data?['card_cvv'];
  //       cardDigit = data?['card_digit'];
  //       cardExpire = data?['card_expire'];
  //       walletBalance = data?['wallet_balance'];
  //       intWalletBalance = int.tryParse(walletBalance)!;
  //     });
  //   }
  // }

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
    const String apiUrl = AppConstants.CREATE_PAYMENT;
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
    // getCurrentUser();
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
            Get.back();
          },
          child: Icon(
            Icons.close,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Top Up With Card',
          style: GoogleFonts.lato(
            color: Theme.of(context).primaryColor,
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
                        color: Theme.of(context).primaryColor,
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
                // Get.snackbar(
                //   "Error",
                //   e.toString(),
                //   animationDuration: const Duration(seconds: 2),
                //   backgroundColor: Colors.red,
                //   colorText: Colors.white,
                //   snackPosition: SnackPosition.BOTTOM,
                // );
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
