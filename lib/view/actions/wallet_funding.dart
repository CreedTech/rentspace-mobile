import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:rentspace/constants/theme_services.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:rentspace/view/savings/spaceRent/spacerent_payment.dart';

import '../../constants/widgets/custom_dialog.dart';

class WalletFunding extends StatefulWidget {
  int amount, numPayment;
  String savingsID, date, interval;
  WalletFunding({
    Key? key,
    required this.amount,
    required this.date,
    required this.interval,
    required this.numPayment,
    required this.savingsID,
  }) : super(key: key);

  @override
  _WalletFundingState createState() => _WalletFundingState();
}

class _WalletFundingState extends State<WalletFunding> {
  late WebViewController webViewController;
  final UserController userController = Get.find();
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
  bool _isLoading = true;
  bool canGoBack = false;
  bool hasCreatedPayment = false;
  bool hasDoneWebview = false;
  var _chars = '1234567890';
  Random _rnd = Random();
  String _payUrl = "";
  String _mssg = "Initiating payment...";
  String _mssgBody = "";

  getCurrentUser() async {
    var collection = FirebaseFirestore.instance.collection('accounts');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        userFirst = data?['firstname'];
        userLast = data?['lastname'];
        userMail = data?['email'];
        userPhone = data?['phone'];
        walletID = data?['wallet_id'];
        cardCvv = data?['card_cvv'];
        cardDigit = data?['card_digit'];
        cardExpire = data?['card_expire'];
        walletBalance = data?['wallet_balance'];
        intWalletBalance = int.tryParse(walletBalance)!;
      });
    }
  }

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
        "transaction_ref":
            "WAL" + getRandom(4) + userController.user[0].userWalletNumber,
        "callback_url": "https://rentspace.tech/payment-notice/",
        "is_recurring": "false"
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
    getCurrentUser();
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
        actions: [
          GestureDetector(
            onTap: () {
              (cardCvv == '' || cardDigit == '' || cardExpire == '')
                  ? customErrorDialog(context, 'Card not found!',
                      "You need to add a card to suggest details during in-app payment.")

                  // Get.snackbar(
                  //     "Card not found!",
                  //     'You need to add a card to suggest details during in-app payment.',
                  //     animationDuration: const Duration(seconds: 1),
                  //     backgroundColor: Colors.red,
                  //     colorText: Colors.white,
                  //     snackPosition: SnackPosition.BOTTOM,
                  //   )
                  : Get.bottomSheet(
                      SizedBox(
                        height: 180,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          child: Container(
                            color: Theme.of(context).canvasColor,
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  'Copy card details',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GFButton(
                                      onPressed: (() {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: cardDigit,
                                          ),
                                        );
                                        Get.back();
                                        Fluttertoast.showToast(
                                          msg:
                                              "Card digits copied to clipboard!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: brandOne,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }),
                                      color: Colors.cyan,
                                      text: "Digits",
                                      icon: const Icon(
                                        Icons.copy_outlined,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 4, 10, 4),
                                      shape: GFButtonShape.pills,
                                      size: 26,
                                    ),
                                    GFButton(
                                      onPressed: (() {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: cardCvv,
                                          ),
                                        );
                                        Get.back();
                                        Fluttertoast.showToast(
                                          msg: "Card cvv copied to clipboard!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: brandOne,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }),
                                      color: Colors.pink,
                                      text: "cvv",
                                      icon: const Icon(
                                        Icons.copy_outlined,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 4, 10, 4),
                                      shape: GFButtonShape.pills,
                                      size: 26,
                                    ),
                                    GFButton(
                                      onPressed: (() {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: cardExpire,
                                          ),
                                        );
                                        Get.back();
                                        Fluttertoast.showToast(
                                          msg:
                                              "Card expiry date copied to clipboard!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: brandOne,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }),
                                      color: Colors.amber,
                                      text: "Expiry date",
                                      icon: const Icon(
                                        Icons.copy_outlined,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 4, 10, 4),
                                      shape: GFButtonShape.pills,
                                      size: 26,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 2, 10, 2),
              child: Row(
                children: [
                  Text(
                    "Copy card details",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: "DefaultFontFamily",
                      letterSpacing: 0.5,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.copy_outlined,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
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
                      style: GoogleFonts.nunito(
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
                const CircularProgressIndicator(
                  color: brandOne,
                ),
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
