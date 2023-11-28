import 'dart:async';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rentspace/controller/user_controller.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/view/actions/fund_wallet.dart';
import 'package:rentspace/view/actions/onboarding_page.dart' as nt;
import 'package:rentspace/view/utility/utilities_history.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'dart:math';
import 'package:share_plus/share_plus.dart';

class DataList {
  final String amount;
  final String name;
  final String allowance;
  final String validity;

  DataList({
    required this.amount,
    required this.name,
    required this.allowance,
    required this.validity,
  });

  factory DataList.fromJson(Map<String, dynamic> json) {
    return DataList(
      amount: json['amount'],
      name: json['name'],
      allowance: json['allowance'],
      validity: json['validity'],
    );
  }
}

class Bill {
  final String id;
  final String name;
  final String icon;

  Bill({required this.id, required this.name, required this.icon});

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}

class TvList {
  final int amount;
  final String name;
  final String productCode;
  final int invoicePeriod;
  final int validity;

  TvList({
    required this.amount,
    required this.name,
    required this.invoicePeriod,
    required this.productCode,
    required this.validity,
  });

  factory TvList.fromJson(Map<String, dynamic> json) {
    return TvList(
      amount: json['amount'],
      name: json['name'],
      validity: json['validity'],
      invoicePeriod: json['invoice_period'],
      productCode: json['product_code'],
    );
  }
}

class UtilitiesPage extends StatefulWidget {
  UtilitiesPage({Key? key}) : super(key: key);

  @override
  _UtilitiesPageState createState() => _UtilitiesPageState();
}

//API endpoints
var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
//variables
bool canLoad = false;
bool showLoading = false;
bool showTvLoading = false;
String loadMssg = "Loading services...";
var varValue = "".obs;
const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
Random _rnd = Random();
String dataBillId = "";
String dataPlanName = "";
String tvPlanName = "";

String tvFirst = "";
String tvLast = "";
String tvStatus = "";
String tvAmount = "";
String tvValidity = "";
String tvInvoicePeriod = "";
String tvProductCode = "";
String electricName = "";

String userElectricName = "";
String userElectricAddress = "";
String userElectricStatus = "";

String userBetName = "";
String userBetAddress = "";
String userBetStatus = "";

String betId = "";
String betBiller = "";

String electricToken = "";

String getRandom(int length) => String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );

final RoundedLoadingButtonController _airtimeController =
    RoundedLoadingButtonController();
final TextEditingController _airtimeAmountController = TextEditingController();
final TextEditingController _airtimeNumberController = TextEditingController();
final TextEditingController _pinController = TextEditingController();
final TextEditingController _dataNumberController = TextEditingController();
final TextEditingController _tvNumberController = TextEditingController();
final TextEditingController _dataPinController = TextEditingController();
final TextEditingController _tvPinController = TextEditingController();
final TextEditingController _electricNumberController = TextEditingController();
final TextEditingController _electricPinController = TextEditingController();
final TextEditingController _electricAmountController = TextEditingController();
final TextEditingController _betNumberController = TextEditingController();
final TextEditingController _betPinController = TextEditingController();
final TextEditingController _betAmountController = TextEditingController();

class _UtilitiesPageState extends State<UtilitiesPage> {
  List<DataList> dataList = [];
  List<TvList> tvList = [];
  List<Bill> betList = [];
  final UserController userController = Get.find();
//bet

  firstBetFund(String bId, bBiller) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 500,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    "Fund your account and earn 1 SpacePoint!",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "(₦50 charges applies)",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    " ${userBetName}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    enableSuggestions: true,
                    cursorColor: Colors.black,
                    controller: _betAmountController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.phone,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 11,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      prefix: Text(
                        "" + varValue.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      label: Text(
                        "Amount in naira",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: brandOne, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandOne, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandOne, width: 2.0),
                      ),
                      filled: true,
                      fillColor: brandThree,
                      hintText: '',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Pinput(
                    defaultPinTheme: PinTheme(
                      width: 30,
                      height: 30,
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: brandOne, width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: _betPinController,
                    length: 4,
                    closeKeyboardWhenCompleted: true,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GFButton(
                    onPressed: () async {
                      if ((((int.tryParse(
                              userController.user[0].userWalletBalance))!) <
                          ((int.tryParse(_betAmountController.text
                                  .trim()
                                  .toString()))! +
                              50))) {
                        Get.back();
                        Get.snackbar(
                          "Insufficient fund",
                          "You do not have sufficient fund to perform the transaction. Fund your Space Wallet and retry",
                          animationDuration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        setState(() {
                          canLoad = true;
                        });
                      } else {
                        Get.back();

                        setState(() {
                          canLoad = false;
                          loadMssg = "Funding...";
                        });
                        vendBet(bId, bBiller);
                      }
                    },
                    text: "  Fund Account  ",
                    fullWidthButton: true,
                    color: brandOne,
                    shape: GFButtonShape.pills,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      elevation: 2,
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  vendBet(String billId, biller) async {
    const String apiUrl = 'https://api.watupay.com/v1/watubill/vend';
    const String bearerToken = 'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "amount": _betAmountController.text.toString(),
        "channel": billId,
        "business_signature": "a390960dfa37469d824ffe6cb80472f6",
        "account_number": _betNumberController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      var walletUpdate = FirebaseFirestore.instance.collection('accounts');
      await walletUpdate.doc(userId).update({
        'wallet_balance':
            (((int.tryParse(userController.user[0].userWalletBalance))!) -
                    ((int.tryParse(_betAmountController.text.trim()))! + 70))
                .toString(),
        'utility_points':
            (((int.tryParse(userController.user[0].utilityPoints)!)) + 1)
                .toString(),
      }).then((value) async {
        var addUtility = FirebaseFirestore.instance.collection('utility');
        await addUtility.add({
          'user_id': userController.user[0].rentspaceID,
          'timestamp': FieldValue.serverTimestamp(),
          'id': userController.user[0].id,
          'amount': _betAmountController.text.toString(),
          'charge': '70',
          'biller': biller,
          'transaction_id': getRandom(8),
          'date': formattedDate,
          'description': 'Funded Betting Account',
        });
      });
      _betAmountController.clear();
      _betPinController.clear();
      setState(() {
        canLoad = true;
      });
      Get.snackbar(
        "Success!",
        "You just earned a Space point!",
        animationDuration: Duration(seconds: 2),
        backgroundColor: brandOne,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } else {
      // Error handling
      _betAmountController.clear();
      _betPinController.clear();
      setState(() {
        canLoad = true;
      });
      Get.snackbar(
        "Error",
        "Try again later",
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  vendTv(String billId) async {
    const String apiUrl = 'https://api.watupay.com/v1/watubill/vend';
    const String bearerToken = 'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "amount": tvAmount,
        "channel": billId,
        "business_signature": "a390960dfa37469d824ffe6cb80472f6",
        "smart_card_number": _tvNumberController.text.trim(),
        "months_paid_for": "1",
        "invoice_period": tvInvoicePeriod,
        "product_code": tvProductCode
      }),
    );

    if (response.statusCode == 200) {
      var walletUpdate = FirebaseFirestore.instance.collection('accounts');
      await walletUpdate.doc(userId).update({
        'wallet_balance':
            (((int.tryParse(userController.user[0].userWalletBalance))!) -
                    ((int.tryParse(tvAmount))! + 20))
                .toString(),
        'utility_points':
            (((int.tryParse(userController.user[0].utilityPoints)!)) + 1)
                .toString(),
      }).then((value) async {
        var addUtility = FirebaseFirestore.instance.collection('utility');
        await addUtility.add({
          'user_id': userController.user[0].rentspaceID,
          'id': userController.user[0].id,
          'amount': tvAmount,
          'timestamp': FieldValue.serverTimestamp(),
          'charge': '20',
          'biller': tvPlanName,
          'transaction_id': getRandom(8),
          'date': formattedDate,
          'description': 'Subscribed for Tv',
        });
      });
      _tvNumberController.clear();
      _tvPinController.clear();
      setState(() {
        canLoad = true;
      });
      Get.snackbar(
        "Success!",
        "You just earned a Space point!",
        animationDuration: Duration(seconds: 2),
        backgroundColor: brandOne,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } else {
      // Error handling
      _tvNumberController.clear();
      _tvPinController.clear();
      setState(() {
        canLoad = true;
      });
      Get.snackbar(
        "Error",
        "Try again later",
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  vendElectric(String billId) async {
    const String apiUrl = 'https://api.watupay.com/v1/watubill/vend';
    const String bearerToken = 'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "amount": _electricAmountController.text.trim().toString(),
        "channel": billId,
        "email": userController.user[0].email,
        "phone_number":
            ("0" + userController.user[0].userPhone.substring(4)).toString(),
        "request_time": formattedDate,
        "contact_type": "phone",
        "business_signature": "a390960dfa37469d824ffe6cb80472f6",
        "meter_number": _electricNumberController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = jsonDecode(response.body);
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> data = jsonResponse['data'];
      final Map<String, dynamic> billData = data['bill_data'];
      final String token = billData['Token'];
      setState(() {
        electricToken = token;
      });
      var walletUpdate = FirebaseFirestore.instance.collection('accounts');
      await walletUpdate.doc(userId).update({
        'wallet_balance': (((int.tryParse(
                    userController.user[0].userWalletBalance))!) -
                ((int.tryParse(
                        _electricAmountController.text.trim().toString()))! +
                    20))
            .toString(),
        'utility_points':
            (((int.tryParse(userController.user[0].utilityPoints)!)) + 1)
                .toString(),
      }).then((value) async {
        var addUtility = FirebaseFirestore.instance.collection('utility');
        await addUtility.add({
          'user_id': userController.user[0].rentspaceID,
          'id': userController.user[0].id,
          'amount': _electricAmountController.text.trim().toString(),
          'charge': '20',
          'timestamp': FieldValue.serverTimestamp(),
          'biller': "Electricity Subscription",
          'transaction_id': getRandom(8),
          'date': formattedDate,
          'description': 'Subscribed for Electricity',
        });
      });
      _electricNumberController.clear();
      _electricPinController.clear();
      setState(() {
        canLoad = true;
      });
      Get.bottomSheet(
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 500,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "Success! You just earned a Space point!",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Here is your Token: ${electricToken}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GFButton(
                      onPressed: () async {
                        Get.back();
                        Share.share("Token: $electricToken");
                      },
                      text: "  Copy to clipboard  ",
                      fullWidthButton: true,
                      color: brandOne,
                      shape: GFButtonShape.pills,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        elevation: 2,
        backgroundColor: Theme.of(context).canvasColor,
      );
    } else {
      // Error handling
      _electricNumberController.clear();
      _electricPinController.clear();
      setState(() {
        canLoad = true;
      });
      print(response.body);
      Get.snackbar(
        "Error",
        "Try again later",
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  validateTv(String billId) async {
    const String apiUrl = 'https://api.watupay.com/v1/watubill/validate';
    const String bearerToken = 'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "channel": billId,
        "smart_card_number": _tvNumberController.text.trim().toString()
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = jsonDecode(response.body);

      setState(() {
        tvFirst = apiResponse['data']['first_name'];
        tvLast = apiResponse['data']['last_name'];
        tvStatus = apiResponse['data']['account_status'];
        canLoad = true;
      });
      Get.bottomSheet(
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 500,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "Subscribe to ${tvPlanName} and earn 1 SpacePoint!",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "(₦20 charges applies)",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      " ${tvFirst} ${tvLast}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      " ${tvStatus}",
                      style: TextStyle(
                        color: (tvStatus == "Open")
                            ? Colors.greenAccent
                            : Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Pinput(
                      defaultPinTheme: PinTheme(
                        width: 30,
                        height: 30,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: brandOne, width: 2.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: _tvPinController,
                      length: 4,
                      closeKeyboardWhenCompleted: true,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GFButton(
                      onPressed: () async {
                        if ((((int.tryParse(userController
                                    .user[0].userWalletBalance))!) >
                                ((int.tryParse(tvAmount))! + 50)) &&
                            (tvStatus == "Open")) {
                          Get.back();
                          setState(() {
                            canLoad = false;
                            loadMssg = "Subscribing...";
                          });
                          vendTv(billId);
                        } else {
                          Get.back();
                          Get.snackbar(
                            "Insufficient fund",
                            "You do not have sufficient fund to perform the transaction. Fund your Space Wallet and retry",
                            animationDuration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          setState(() {
                            canLoad = true;
                          });
                        }
                      },
                      text: "  Subscribe  ",
                      fullWidthButton: true,
                      color: brandOne,
                      shape: GFButtonShape.pills,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        elevation: 2,
        backgroundColor: Theme.of(context).canvasColor,
      );
    } else {
      setState(() {
        canLoad = true;
      });
      Get.snackbar(
        "Failed!",
        "The request failed. Check that the Smart Card Number is valid and retry.",
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  validateElectric(String billId) async {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 500,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    electricName,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    enableSuggestions: true,
                    cursorColor: Colors.black,
                    controller: _electricNumberController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.phone,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 11,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      prefix: Text(
                        "" + varValue.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      label: Text(
                        "Enter valid Meter number",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: brandOne, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandOne, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandOne, width: 2.0),
                      ),
                      filled: true,
                      fillColor: brandThree,
                      hintText: '',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GFButton(
                    onPressed: () async {
                      if (_electricNumberController.text.trim() != "") {
                        Get.back();
                        setState(() {
                          canLoad = false;
                          loadMssg = "Validating...";
                        });
                        const String apiUrl =
                            'https://api.watupay.com/v1/watubill/validate';
                        const String bearerToken =
                            'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
                        final response = await http.post(
                          Uri.parse(apiUrl),
                          headers: {
                            'Authorization': 'Bearer $bearerToken',
                            "Content-Type": "application/json"
                          },
                          body: jsonEncode(<String, String>{
                            "channel": billId,
                            "meter_number":
                                _electricNumberController.text.trim().toString()
                          }),
                        );

                        if (response.statusCode == 200) {
                          Map<String, dynamic> apiResponse =
                              jsonDecode(response.body);
                          print(apiResponse);
                          setState(() {
                            userElectricName =
                                apiResponse['data']['customer_name'];
                            userElectricAddress =
                                apiResponse['data']['customer_address'];
                            userElectricStatus =
                                apiResponse['data']['can_vend'].toString();
                            canLoad = true;
                          });
                          Get.bottomSheet(
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 500,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 0, 20, 0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 100,
                                        ),
                                        Text(
                                          "Buy Electricity and earn 1 SpacePoint!",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "(₦20 charges applies)",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          " ${userElectricName}",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          " ${userElectricAddress}",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        TextFormField(
                                          enableSuggestions: true,
                                          cursorColor: Colors.black,
                                          controller: _electricAmountController,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          keyboardType: TextInputType.phone,
                                          maxLengthEnforcement:
                                              MaxLengthEnforcement.enforced,
                                          maxLength: 11,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            prefix: Text(
                                              "" + varValue.toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            label: Text(
                                              "Amount in naira",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  color: brandOne, width: 2.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: brandOne, width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: brandOne, width: 2.0),
                                            ),
                                            filled: true,
                                            fillColor: brandThree,
                                            hintText: '',
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Pinput(
                                          defaultPinTheme: PinTheme(
                                            width: 30,
                                            height: 30,
                                            textStyle: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: brandOne, width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          controller: _electricPinController,
                                          length: 4,
                                          closeKeyboardWhenCompleted: true,
                                          keyboardType: TextInputType.number,
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                        GFButton(
                                          onPressed: () async {
                                            if ((((int.tryParse(userController
                                                    .user[0]
                                                    .userWalletBalance))!) <
                                                ((int.tryParse(
                                                        _electricAmountController
                                                            .text
                                                            .trim()
                                                            .toString()))! +
                                                    50))) {
                                              Get.back();
                                              Get.snackbar(
                                                "Insufficient fund",
                                                "You do not have sufficient fund to perform the transaction. Fund your Space Wallet and retry",
                                                animationDuration:
                                                    Duration(seconds: 2),
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                              setState(() {
                                                canLoad = true;
                                              });
                                            } else {
                                              Get.back();

                                              setState(() {
                                                canLoad = false;
                                                loadMssg = "Subscribing...";
                                              });
                                              vendElectric(billId);
                                            }
                                          },
                                          text: "  Subscribe  ",
                                          fullWidthButton: true,
                                          color: brandOne,
                                          shape: GFButtonShape.pills,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            elevation: 2,
                            backgroundColor: Theme.of(context).canvasColor,
                          );
                        } else {
                          setState(() {
                            canLoad = true;
                          });
                          Get.snackbar(
                            "Failed!",
                            "The request failed. Check that the meter Number is valid and retry.",
                            animationDuration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      }
                    },
                    text: "  Validate  ",
                    fullWidthButton: true,
                    color: brandOne,
                    shape: GFButtonShape.pills,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      elevation: 2,
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

//Utility calls - Get Data
  getData(String billId) async {
    const String apiUrl = 'https://api.watupay.com/v1/watubill/bill-types';
    const String bearerToken = 'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "channel": billId,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = jsonDecode(response.body);
      List<dynamic> listField = apiResponse['data'];
      setState(() {
        dataList = listField.map((item) => DataList.fromJson(item)).toList();
        showLoading = false;
      });
      Get.bottomSheet(
        Container(
          height: 500,
          child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    dataPlanName = dataList[index].name;
                  });
                  Get.back();
                  Get.bottomSheet(
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 500,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                Text(
                                  "Subscribe to ${dataPlanName} and earn 1 SpacePoint!",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "(₦20 charges applies)",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  enableSuggestions: true,
                                  cursorColor: Colors.black,
                                  controller: _dataNumberController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.phone,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  maxLength: 11,

                                  // update the state variable when the text changes

                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    prefix: Text(
                                      "" + varValue.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    label: Text(
                                      "Enter valid number",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: brandOne, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: brandOne, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: brandOne, width: 2.0),
                                    ),
                                    filled: true,
                                    fillColor: brandThree,
                                    hintText: '',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Pinput(
                                  defaultPinTheme: PinTheme(
                                    width: 30,
                                    height: 30,
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: brandOne, width: 2.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  controller: _dataPinController,
                                  length: 4,
                                  closeKeyboardWhenCompleted: true,
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                GFButton(
                                  onPressed: () async {
                                    if (_dataNumberController.text.trim() !=
                                            "" &&
                                        (_dataPinController.text.trim() ==
                                            userController
                                                .user[0].transactionPIN) &&
                                        (((int.tryParse(
                                                    dataList[index].amount)! +
                                                50) <
                                            (int.tryParse(userController.user[0]
                                                .userWalletBalance)!)))) {
                                      Get.back();
                                      setState(() {
                                        loadMssg = "Processing...";
                                        canLoad = false;
                                      });
                                      const String apiUrl =
                                          'https://api.watupay.com/v1/watubill/vend';
                                      const String bearerToken =
                                          'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                      final response = await http.post(
                                        Uri.parse(apiUrl),
                                        headers: {
                                          'Authorization':
                                              'Bearer $bearerToken',
                                          "Content-Type": "application/json"
                                        },
                                        body: jsonEncode(<String, String>{
                                          "channel": billId,
                                          "business_signature":
                                              "a390960dfa37469d824ffe6cb80472f6",
                                          'phone_number': _dataNumberController
                                              .text
                                              .trim()
                                              .toString(),
                                          'validity': dataList[index].validity,
                                          "name": dataList[index].name,
                                          "amount": dataList[index].amount
                                        }),
                                      );

                                      if (response.statusCode == 200) {
                                        var walletUpdate = FirebaseFirestore
                                            .instance
                                            .collection('accounts');
                                        await walletUpdate.doc(userId).update({
                                          'wallet_balance': (((int.tryParse(
                                                      userController.user[0]
                                                          .userWalletBalance))!) -
                                                  ((int.tryParse(dataList[index]
                                                          .amount))! +
                                                      20))
                                              .toString(),
                                          'utility_points': (((int.tryParse(
                                                      userController.user[0]
                                                          .utilityPoints)!)) +
                                                  1)
                                              .toString(),
                                        }).then((value) async {
                                          var addUtility = FirebaseFirestore
                                              .instance
                                              .collection('utility');
                                          await addUtility.add({
                                            'user_id': userController
                                                .user[0].rentspaceID,
                                            'id': userController.user[0].id,
                                            'amount': dataList[index].amount,
                                            'biller': dataList[index].name,
                                            'transaction_id': getRandom(8),
                                            'timestamp':
                                                FieldValue.serverTimestamp(),
                                            'date': formattedDate,
                                            'description': 'subscribed to data',
                                            'charge': '20'
                                          });
                                        });
                                        _dataPinController.clear();
                                        _dataNumberController.clear();
                                        setState(() {
                                          canLoad = true;
                                        });
                                        Get.snackbar(
                                          "Success!",
                                          "You just earned a Space point!",
                                          animationDuration:
                                              Duration(seconds: 2),
                                          backgroundColor: brandOne,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                        );
                                      } else {
                                        setState(() {
                                          canLoad = true;
                                        });
                                        // Error handling
                                        _dataPinController.clear();
                                        _dataNumberController.clear();

                                        Get.snackbar(
                                          "Error",
                                          "Try again later",
                                          animationDuration:
                                              Duration(seconds: 2),
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    } else {
                                      setState(() {
                                        canLoad = true;
                                      });
                                      Get.snackbar(
                                        "Error",
                                        "Fill the field correctly to proceed",
                                        animationDuration: Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  },
                                  text: "  Subscribe  ",
                                  fullWidthButton: true,
                                  color: brandOne,
                                  shape: GFButtonShape.pills,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    elevation: 2,
                    backgroundColor: Theme.of(context).canvasColor,
                  );
                },
                child: ListTile(
                  title: Text(dataList[index].name,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      )),
                  subtitle: Text(
                    'Amount: ${nairaFormaet.format(int.tryParse(dataList[index].amount.toString()))}, Validity: ${dataList[index].validity}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_right_alt_outlined,
                      color: Theme.of(context).primaryColor),
                ),
              );
            },
          ),
        ),
        elevation: 2,
        backgroundColor: Theme.of(context).canvasColor,
      );
    } else {
      throw Exception('Failed to load data');
    }
  }

  //Utility calls - Get Tv
  getTv(String billId) async {
    const String apiUrl = 'https://api.watupay.com/v1/watubill/bill-types';
    const String bearerToken = 'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "channel": billId,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = jsonDecode(response.body);
      List<dynamic> listTvField = apiResponse['data'];
      setState(() {
        tvList = listTvField.map((item) => TvList.fromJson(item)).toList();
        showTvLoading = false;
      });
      Get.bottomSheet(
        Container(
          height: 500,
          child: ListView.builder(
            itemCount: tvList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    tvPlanName = tvList[index].name;
                    tvAmount = tvList[index].amount.toString();
                    tvValidity = tvList[index].validity.toString();
                    tvInvoicePeriod = tvList[index].invoicePeriod.toString();
                    tvProductCode = tvList[index].productCode;
                  });
                  Get.back();
                  Get.bottomSheet(
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 500,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                Text(
                                  "Subscribe to ${tvPlanName} and earn 1 SpacePoint!",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "(₦20 charges applies)",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  enableSuggestions: true,
                                  cursorColor: Colors.black,
                                  controller: _tvNumberController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.phone,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  maxLength: 10,

                                  // update the state variable when the text changes

                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    prefix: Text(
                                      "" + varValue.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    label: Text(
                                      "Enter valid Smart card number",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: brandOne, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: brandOne, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: brandOne, width: 2.0),
                                    ),
                                    filled: true,
                                    fillColor: brandThree,
                                    hintText: '',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                GFButton(
                                  onPressed: () async {
                                    if (_tvNumberController.text.trim() != "") {
                                      Get.back();
                                      setState(() {
                                        canLoad = false;
                                        loadMssg = "Validating...";
                                      });
                                      validateTv(billId);
                                    }
                                  },
                                  text: "  Validate  ",
                                  fullWidthButton: true,
                                  color: brandOne,
                                  shape: GFButtonShape.pills,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    elevation: 2,
                    backgroundColor: Theme.of(context).canvasColor,
                  );
                },
                child: ListTile(
                  title: Text(tvList[index].name,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      )),
                  subtitle: Text(
                    'Amount: ${nairaFormaet.format(int.tryParse(tvList[index].amount.toString()))}, Validity: ${tvList[index].validity}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_right_alt_outlined,
                      color: Theme.of(context).primaryColor),
                ),
              );
            },
          ),
        ),
        elevation: 2,
        backgroundColor: Theme.of(context).canvasColor,
      );
    } else {
      throw Exception('Failed to load data');
    }
  }

  //Utility calls - Get Tv
  getBet() async {
    const String apiUrl =
        'https://api.watupay.com/v1/watubill/channels?is_favourite=0&should_paginate=0&country=NG&group=betting';
    const String bearerToken = 'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
    final responseRef = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
    );

    if (responseRef.statusCode == 200) {
      final jsonResponse = jsonDecode(responseRef.body);
      final bills = (jsonResponse['data'] as List)
          .map((billData) => Bill.fromJson(billData))
          .toList();
      setState(() {
        betList = bills;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  initState() {
    super.initState();
    setState(() {
      canLoad = false;
      showLoading = false;
      showTvLoading = false;
      dataPlanName = "";

      loadMssg = "Loading services...";
      _airtimeAmountController.clear();
      _airtimeNumberController.clear();
      _pinController.clear();
    });
    betList.clear();
    getBet();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        canLoad = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //validation function
    validatePin(pinOneValue) {
      if (pinOneValue.isEmpty) {
        return 'pin cannot be empty';
      }
      if (pinOneValue.length < 4) {
        return 'pin is incomplete';
      }
      if (int.tryParse(pinOneValue).toString() !=
          userController.user[0].transactionPIN) {
        return 'incorrect PIN';
      }
      if (int.tryParse(pinOneValue) == null) {
        return 'enter valid number';
      }
      return '';
    }

    validateAmount(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if ((int.tryParse(text.replaceAll(',', ''))! >= 1) &&
          (int.tryParse(text.replaceAll(',', ''))! < 100)) {
        return 'minimum amount is ₦100';
      }
      if (((int.tryParse(text.replaceAll(',', ''))! + 50) >
          int.tryParse(userController.user[0].userWalletBalance)!)) {
        return 'Insufficient fund';
      }
      if (int.tryParse(text.replaceAll(',', '')) == null) {
        return 'enter valid number';
      }
      if (int.tryParse(text.replaceAll(',', '')) == 0) {
        return 'number cannot be zero';
      }
      if (int.tryParse(text.replaceAll(',', ''))!.isNegative) {
        return 'enter positive number';
      }
      return '';
    }

    validateNumber(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (int.tryParse(text.replaceAll(',', '')) == null) {
        return 'enter valid value';
      }
      if (int.tryParse(text.replaceAll(',', '')) == 0) {
        return 'number cannot be zero';
      }
      if (int.tryParse(text.replaceAll(',', ''))!.isNegative) {
        return 'enter positive value';
      }
      return '';
    }

    //pin theme
    final defaultPinTheme = PinTheme(
      width: 30,
      height: 30,
      textStyle: TextStyle(
        fontSize: 20,
        color: Theme.of(context).primaryColor,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: brandOne, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
    );
    //widget build --airtime purchase
    final airtimeAmount = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _airtimeAmountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,

      // update the state variable when the text changes

      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsFormatter()],
      decoration: InputDecoration(
        prefix: Text(
          "₦" + varValue.toString(),
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        label: Text(
          "How much do you want to recharge?",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        filled: true,
        fillColor: brandThree,
        hintText: 'Amount in Naira',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
    final airtimePhone = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _airtimeNumberController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateNumber,
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,

      // update the state variable when the text changes

      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        prefix: Text(
          "" + varValue.toString(),
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        label: Text(
          "Enter valid number",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        filled: true,
        fillColor: brandThree,
        hintText: '',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
    //Pin
    final pinInput = Pinput(
      defaultPinTheme: defaultPinTheme,
      controller: _pinController,
      length: 4,
      validator: validatePin,
      onChanged: validatePin,
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );
    return (int.tryParse(userController.user[0].userWalletBalance)! > 0)
        ? Obx(
            () => Scaffold(
                backgroundColor: Theme.of(context).canvasColor,
                body: (canLoad)
                    ? SizedBox(
                        child: (userController.user[0].status == "verified")
                            ? Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/icons/RentSpace-icon.png"),
                                    fit: BoxFit.cover,
                                    opacity: 0.1,
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(2.0, 5, 2.0, 5),
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            userController.user[0].utilityPoints
                                                .toString(),
                                            style: TextStyle(
                                              fontFamily: "DefaultFontFamily",
                                              fontWeight: FontWeight.w100,
                                              fontSize: 40,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          Text(
                                            'SpacePoints',
                                            style: TextStyle(
                                              fontFamily: "DefaultFontFamily",
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    InkWell(
                                      onTap: () {
                                        Get.to(UtilitiesHistory());
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "History" + varValue.toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "DefaultFontFamily",
                                                decoration:
                                                    TextDecoration.underline,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.history_outlined,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 16,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        "Pay for your bills and earn one SpacePoint!",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "DefaultFontFamily",
                                          letterSpacing: 0.5,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        "Get access to a wide range of utilities and earn a SpacePoint when you make payment from your SpaceWallet!",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "DefaultFontFamily",
                                          letterSpacing: 0.5,
                                          //height: 0.5,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Wallet balance: ${nairaFormaet.format(double.parse(userController.user[0].userWalletBalance.toString()))} ',
                                            style: TextStyle(
                                              fontFamily: "DefaultFontFamily",
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'Available services:',
                                        style: TextStyle(
                                          fontFamily: "DefaultFontFamily",
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GFAccordion(
                                      expandedIcon: Container(
                                        decoration: BoxDecoration(
                                          color: brandThree,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.remove,
                                          color: brandOne,
                                        ),
                                      ),
                                      collapsedIcon: Container(
                                        decoration: BoxDecoration(
                                          color: brandThree,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.add,
                                          color: brandOne,
                                        ),
                                      ),
                                      title: "Airtime Top-up",
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "DefaultFontFamily",
                                      ),
                                      contentBackgroundColor:
                                          Colors.transparent,
                                      expandedTitleBackgroundColor: brandThree,
                                      collapsedTitleBackgroundColor: brandThree,
                                      onToggleCollapsed: (e) {},
                                      contentChild: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              Get.bottomSheet(
                                                isDismissible: true,
                                                SingleChildScrollView(
                                                  child: SizedBox(
                                                    height: 500,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                30.0),
                                                        topRight:
                                                            Radius.circular(
                                                                30.0),
                                                      ),
                                                      child: Container(
                                                        color: Theme.of(context)
                                                            .canvasColor,
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                50, 5, 50, 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Image.asset(
                                                              "assets/utility/mtn.jpg",
                                                              height: 80,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              'Recharge and get 1 SpacePoint!',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              "(₦20 charges applies)",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Text(
                                                              "Valid MTN Phone number",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                              ),
                                                            ),
                                                            airtimePhone,
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            airtimeAmount,
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              "4 digit transaction PIN",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            pinInput,
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            RoundedLoadingButton(
                                                              controller:
                                                                  _airtimeController,
                                                              onPressed:
                                                                  () async {
                                                                Timer(
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                    () {
                                                                  _airtimeController
                                                                      .stop();
                                                                });
                                                                Get.back();
                                                                setState(() {
                                                                  loadMssg =
                                                                      "Processing...";
                                                                  canLoad =
                                                                      false;
                                                                });

                                                                if (validateAmount(_airtimeAmountController.text.trim()) == "" &&
                                                                    validateNumber(_airtimeNumberController
                                                                            .text
                                                                            .trim()) ==
                                                                        "" &&
                                                                    validatePin(_pinController
                                                                            .text
                                                                            .trim()) ==
                                                                        "") {
                                                                  const String
                                                                      apiUrl =
                                                                      'https://api.watupay.com/v1/watubill/vend';
                                                                  const String
                                                                      bearerToken =
                                                                      'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                                                  final response =
                                                                      await http
                                                                          .post(
                                                                    Uri.parse(
                                                                        apiUrl),
                                                                    headers: {
                                                                      'Authorization':
                                                                          'Bearer $bearerToken',
                                                                      "Content-Type":
                                                                          "application/json"
                                                                    },
                                                                    body: jsonEncode(<
                                                                        String,
                                                                        String>{
                                                                      "amount": _airtimeAmountController
                                                                          .text
                                                                          .trim()
                                                                          .toString(),
                                                                      "channel":
                                                                          "bill-25",
                                                                      "business_signature":
                                                                          "a390960dfa37469d824ffe6cb80472f6",
                                                                      "phone_number": _airtimeNumberController
                                                                          .text
                                                                          .trim()
                                                                          .toString()
                                                                    }),
                                                                  );

                                                                  if (response
                                                                          .statusCode ==
                                                                      200) {
                                                                    var walletUpdate = FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'accounts');
                                                                    await walletUpdate
                                                                        .doc(
                                                                            userId)
                                                                        .update({
                                                                      'wallet_balance':
                                                                          (((int.tryParse(userController.user[0].userWalletBalance))!) - ((int.tryParse(_airtimeAmountController.text.trim().toString()))! + 20))
                                                                              .toString(),
                                                                      'utility_points':
                                                                          (((int.tryParse(userController.user[0].utilityPoints)!)) + 1)
                                                                              .toString(),
                                                                    }).then((value) async {
                                                                      var addUtility = FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'utility');
                                                                      await addUtility
                                                                          .add({
                                                                        'user_id': userController
                                                                            .user[0]
                                                                            .rentspaceID,
                                                                        'id': userController
                                                                            .user[0]
                                                                            .id,
                                                                        'amount': _airtimeAmountController
                                                                            .text
                                                                            .trim()
                                                                            .toString(),
                                                                        'charge':
                                                                            '20',
                                                                        'timestamp':
                                                                            FieldValue.serverTimestamp(),
                                                                        'biller':
                                                                            "MTN AIRTIME",
                                                                        'transaction_id':
                                                                            getRandom(8),
                                                                        'date':
                                                                            formattedDate,
                                                                        'description':
                                                                            'bought airtime',
                                                                      });
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      canLoad =
                                                                          true;
                                                                    });
                                                                    _airtimeAmountController
                                                                        .clear();
                                                                    _airtimeNumberController
                                                                        .clear();
                                                                    _pinController
                                                                        .clear();
                                                                    Get.snackbar(
                                                                      "Success!",
                                                                      "You just earned a Space point!",
                                                                      animationDuration:
                                                                          Duration(
                                                                              seconds: 2),
                                                                      backgroundColor:
                                                                          brandOne,
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .TOP,
                                                                    );
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      canLoad =
                                                                          true;
                                                                    });
                                                                    // Error handling
                                                                    _airtimeAmountController
                                                                        .clear();
                                                                    _airtimeNumberController
                                                                        .clear();
                                                                    _pinController
                                                                        .clear();
                                                                    Get.snackbar(
                                                                      "Error",
                                                                      "Try again later",
                                                                      animationDuration:
                                                                          Duration(
                                                                              seconds: 2),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .BOTTOM,
                                                                    );
                                                                  }
                                                                } else {
                                                                  setState(() {
                                                                    canLoad =
                                                                        true;
                                                                  });
                                                                  Get.snackbar(
                                                                    "Incomplete",
                                                                    "Fill the field correctly to proceed",
                                                                    animationDuration:
                                                                        Duration(
                                                                            seconds:
                                                                                2),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    colorText:
                                                                        Colors
                                                                            .white,
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .BOTTOM,
                                                                  );
                                                                }
                                                              },
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2,
                                                              child: Text(
                                                                'Proceed to payment',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      "DefaultFontFamily",
                                                                ),
                                                              ),
                                                              color: brandOne,
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'MTN airtime',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/mtn.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Get.bottomSheet(
                                                isDismissible: true,
                                                SingleChildScrollView(
                                                  child: SizedBox(
                                                    height: 500,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                30.0),
                                                        topRight:
                                                            Radius.circular(
                                                                30.0),
                                                      ),
                                                      child: Container(
                                                        color: Theme.of(context)
                                                            .canvasColor,
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                50, 5, 50, 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Image.asset(
                                                              "assets/utility/glo.jpg",
                                                              height: 80,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              'Recharge and get 1 SpacePoint!',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              "(₦20 charges applies)",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Text(
                                                              "Valid GLO Phone number",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            airtimePhone,
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            airtimeAmount,
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              "4 digit transaction PIN",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            pinInput,
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            RoundedLoadingButton(
                                                              controller:
                                                                  _airtimeController,
                                                              onPressed:
                                                                  () async {
                                                                Timer(
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                    () {
                                                                  _airtimeController
                                                                      .stop();
                                                                });
                                                                Get.back();
                                                                setState(() {
                                                                  loadMssg =
                                                                      "Processing...";
                                                                  canLoad =
                                                                      false;
                                                                });
                                                                if (validateAmount(_airtimeAmountController.text.trim()) == "" &&
                                                                    validateNumber(_airtimeNumberController
                                                                            .text
                                                                            .trim()) ==
                                                                        "" &&
                                                                    validatePin(_pinController
                                                                            .text
                                                                            .trim()) ==
                                                                        "") {
                                                                  const String
                                                                      apiUrl =
                                                                      'https://api.watupay.com/v1/watubill/vend';
                                                                  const String
                                                                      bearerToken =
                                                                      'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                                                  final response =
                                                                      await http
                                                                          .post(
                                                                    Uri.parse(
                                                                        apiUrl),
                                                                    headers: {
                                                                      'Authorization':
                                                                          'Bearer $bearerToken',
                                                                      "Content-Type":
                                                                          "application/json"
                                                                    },
                                                                    body: jsonEncode(<
                                                                        String,
                                                                        String>{
                                                                      "amount": _airtimeAmountController
                                                                          .text
                                                                          .trim()
                                                                          .toString(),
                                                                      "channel":
                                                                          "bill-27",
                                                                      "business_signature":
                                                                          "a390960dfa37469d824ffe6cb80472f6",
                                                                      "phone_number": _airtimeNumberController
                                                                          .text
                                                                          .trim()
                                                                          .toString()
                                                                    }),
                                                                  );

                                                                  if (response
                                                                          .statusCode ==
                                                                      200) {
                                                                    var walletUpdate = FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'accounts');
                                                                    await walletUpdate
                                                                        .doc(
                                                                            userId)
                                                                        .update({
                                                                      'wallet_balance':
                                                                          (((int.tryParse(userController.user[0].userWalletBalance))!) - ((int.tryParse(_airtimeAmountController.text.trim().toString()))! + 20))
                                                                              .toString(),
                                                                      'utility_points':
                                                                          (((int.tryParse(userController.user[0].utilityPoints)!)) + 1)
                                                                              .toString(),
                                                                    }).then((value) async {
                                                                      var addUtility = FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'utility');
                                                                      await addUtility
                                                                          .add({
                                                                        'user_id': userController
                                                                            .user[0]
                                                                            .rentspaceID,
                                                                        'id': userController
                                                                            .user[0]
                                                                            .id,
                                                                        'amount': _airtimeAmountController
                                                                            .text
                                                                            .trim()
                                                                            .toString(),
                                                                        'charge':
                                                                            '20',
                                                                        'timestamp':
                                                                            FieldValue.serverTimestamp(),
                                                                        'biller':
                                                                            "GLO AIRTIME",
                                                                        'transaction_id':
                                                                            getRandom(8),
                                                                        'date':
                                                                            formattedDate,
                                                                        'description':
                                                                            'bought airtime',
                                                                      });
                                                                    });
                                                                    _airtimeAmountController
                                                                        .clear();
                                                                    _airtimeNumberController
                                                                        .clear();
                                                                    _pinController
                                                                        .clear();
                                                                    setState(
                                                                        () {
                                                                      canLoad =
                                                                          true;
                                                                    });
                                                                    Get.snackbar(
                                                                      "Success!",
                                                                      "You just earned a Space point!",
                                                                      animationDuration:
                                                                          Duration(
                                                                              seconds: 2),
                                                                      backgroundColor:
                                                                          brandOne,
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .TOP,
                                                                    );
                                                                  } else {
                                                                    // Error handling
                                                                    _airtimeAmountController
                                                                        .clear();
                                                                    _airtimeNumberController
                                                                        .clear();
                                                                    _pinController
                                                                        .clear();
                                                                    setState(
                                                                        () {
                                                                      canLoad =
                                                                          true;
                                                                    });
                                                                    Get.snackbar(
                                                                      "Error",
                                                                      "Try again later",
                                                                      animationDuration:
                                                                          Duration(
                                                                              seconds: 2),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .BOTTOM,
                                                                    );
                                                                  }
                                                                } else {
                                                                  setState(() {
                                                                    canLoad =
                                                                        true;
                                                                  });
                                                                  Get.snackbar(
                                                                    "Incomplete",
                                                                    "Fill the field correctly to proceed",
                                                                    animationDuration:
                                                                        Duration(
                                                                            seconds:
                                                                                2),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    colorText:
                                                                        Colors
                                                                            .white,
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .BOTTOM,
                                                                  );
                                                                }
                                                              },
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2,
                                                              child: Text(
                                                                'Proceed to payment',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "DefaultFontFamily",
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                              color: brandOne,
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            tileColor: brandSix,
                                            trailing: Image.asset(
                                              "assets/utility/glo.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                            leading: Text(
                                              'GLO airtime',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Get.bottomSheet(
                                                isDismissible: true,
                                                SingleChildScrollView(
                                                  child: SizedBox(
                                                    height: 500,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                30.0),
                                                        topRight:
                                                            Radius.circular(
                                                                30.0),
                                                      ),
                                                      child: Container(
                                                        color: Theme.of(context)
                                                            .canvasColor,
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                50, 5, 50, 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Image.asset(
                                                              "assets/utility/airtel.jpg",
                                                              height: 80,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              'Recharge and get 1 SpacePoint!',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              "(₦20 charges applies)",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Text(
                                                              "Valid AIRTEL Phone number",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            airtimePhone,
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            airtimeAmount,
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              "4 digit transaction PIN",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            pinInput,
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            RoundedLoadingButton(
                                                              controller:
                                                                  _airtimeController,
                                                              onPressed:
                                                                  () async {
                                                                Timer(
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                    () {
                                                                  _airtimeController
                                                                      .stop();
                                                                });
                                                                Get.back();
                                                                setState(() {
                                                                  loadMssg =
                                                                      "Processing...";
                                                                  canLoad =
                                                                      false;
                                                                });
                                                                if (validateAmount(_airtimeAmountController.text.trim()) == "" &&
                                                                    validateNumber(_airtimeNumberController
                                                                            .text
                                                                            .trim()) ==
                                                                        "" &&
                                                                    validatePin(_pinController
                                                                            .text
                                                                            .trim()) ==
                                                                        "") {
                                                                  const String
                                                                      apiUrl =
                                                                      'https://api.watupay.com/v1/watubill/vend';
                                                                  const String
                                                                      bearerToken =
                                                                      'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                                                  final response =
                                                                      await http
                                                                          .post(
                                                                    Uri.parse(
                                                                        apiUrl),
                                                                    headers: {
                                                                      'Authorization':
                                                                          'Bearer $bearerToken',
                                                                      "Content-Type":
                                                                          "application/json"
                                                                    },
                                                                    body: jsonEncode(<
                                                                        String,
                                                                        String>{
                                                                      "amount": _airtimeAmountController
                                                                          .text
                                                                          .trim()
                                                                          .toString(),
                                                                      "channel":
                                                                          "bill-28",
                                                                      "business_signature":
                                                                          "a390960dfa37469d824ffe6cb80472f6",
                                                                      "phone_number": _airtimeNumberController
                                                                          .text
                                                                          .trim()
                                                                          .toString()
                                                                    }),
                                                                  );

                                                                  if (response
                                                                          .statusCode ==
                                                                      200) {
                                                                    var walletUpdate = FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'accounts');
                                                                    await walletUpdate
                                                                        .doc(
                                                                            userId)
                                                                        .update({
                                                                      'wallet_balance':
                                                                          (((int.tryParse(userController.user[0].userWalletBalance))!) - ((int.tryParse(_airtimeAmountController.text.trim().toString()))! + 20))
                                                                              .toString(),
                                                                      'utility_points':
                                                                          (((int.tryParse(userController.user[0].utilityPoints)!)) + 1)
                                                                              .toString(),
                                                                    }).then((value) async {
                                                                      var addUtility = FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'utility');
                                                                      await addUtility
                                                                          .add({
                                                                        'user_id': userController
                                                                            .user[0]
                                                                            .rentspaceID,
                                                                        'id': userController
                                                                            .user[0]
                                                                            .id,
                                                                        'amount': _airtimeAmountController
                                                                            .text
                                                                            .trim()
                                                                            .toString(),
                                                                        'charge':
                                                                            '20',
                                                                        'timestamp':
                                                                            FieldValue.serverTimestamp(),
                                                                        'biller':
                                                                            "AIRTEL AIRTIME",
                                                                        'transaction_id':
                                                                            getRandom(8),
                                                                        'date':
                                                                            formattedDate,
                                                                        'description':
                                                                            'bought airtime',
                                                                      });
                                                                    });
                                                                    _airtimeAmountController
                                                                        .clear();
                                                                    _airtimeNumberController
                                                                        .clear();
                                                                    _pinController
                                                                        .clear();
                                                                    setState(
                                                                        () {
                                                                      canLoad =
                                                                          true;
                                                                    });
                                                                    Get.snackbar(
                                                                      "Success!",
                                                                      "You just earned a Space point!",
                                                                      animationDuration:
                                                                          Duration(
                                                                              seconds: 2),
                                                                      backgroundColor:
                                                                          brandOne,
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .TOP,
                                                                    );
                                                                  } else {
                                                                    // Error handling
                                                                    _airtimeAmountController
                                                                        .clear();
                                                                    _airtimeNumberController
                                                                        .clear();
                                                                    _pinController
                                                                        .clear();
                                                                    setState(
                                                                        () {
                                                                      canLoad =
                                                                          true;
                                                                    });
                                                                    Get.snackbar(
                                                                      "Error",
                                                                      "Try again later",
                                                                      animationDuration:
                                                                          Duration(
                                                                              seconds: 2),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .BOTTOM,
                                                                    );
                                                                  }
                                                                } else {
                                                                  setState(() {
                                                                    canLoad =
                                                                        true;
                                                                  });
                                                                  Get.snackbar(
                                                                    "Incomplete",
                                                                    "Fill the field correctly to proceed",
                                                                    animationDuration:
                                                                        Duration(
                                                                            seconds:
                                                                                2),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    colorText:
                                                                        Colors
                                                                            .white,
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .BOTTOM,
                                                                  );
                                                                }
                                                              },
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2,
                                                              child: Text(
                                                                'Proceed to payment',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      "DefaultFontFamily",
                                                                ),
                                                              ),
                                                              color: brandOne,
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'Airtel airtime',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/airtel.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Get.bottomSheet(
                                                isDismissible: true,
                                                SingleChildScrollView(
                                                  child: SizedBox(
                                                    height: 500,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                30.0),
                                                        topRight:
                                                            Radius.circular(
                                                                30.0),
                                                      ),
                                                      child: Container(
                                                        color: Theme.of(context)
                                                            .canvasColor,
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                50, 5, 50, 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Image.asset(
                                                              "assets/utility/9mobile.jpg",
                                                              height: 80,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              'Recharge and get 1 SpacePoint!',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              "(₦20 charges applies)",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Text(
                                                              "Valid 9MOBILE Phone number",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            airtimePhone,
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            airtimeAmount,
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              "4 digit transaction PIN",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            pinInput,
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            RoundedLoadingButton(
                                                              controller:
                                                                  _airtimeController,
                                                              onPressed:
                                                                  () async {
                                                                Timer(
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                    () {
                                                                  _airtimeController
                                                                      .stop();
                                                                });
                                                                Get.back();
                                                                setState(() {
                                                                  loadMssg =
                                                                      "Processing...";
                                                                  canLoad =
                                                                      false;
                                                                });
                                                                if (validateAmount(_airtimeAmountController.text.trim()) == "" &&
                                                                    validateNumber(_airtimeNumberController
                                                                            .text
                                                                            .trim()) ==
                                                                        "" &&
                                                                    validatePin(_pinController
                                                                            .text
                                                                            .trim()) ==
                                                                        "") {
                                                                  const String
                                                                      apiUrl =
                                                                      'https://api.watupay.com/v1/watubill/vend';
                                                                  const String
                                                                      bearerToken =
                                                                      'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                                                  final response =
                                                                      await http
                                                                          .post(
                                                                    Uri.parse(
                                                                        apiUrl),
                                                                    headers: {
                                                                      'Authorization':
                                                                          'Bearer $bearerToken',
                                                                      "Content-Type":
                                                                          "application/json"
                                                                    },
                                                                    body: jsonEncode(<
                                                                        String,
                                                                        String>{
                                                                      "amount": _airtimeAmountController
                                                                          .text
                                                                          .trim()
                                                                          .toString(),
                                                                      "channel":
                                                                          "bill-26",
                                                                      "business_signature":
                                                                          "a390960dfa37469d824ffe6cb80472f6",
                                                                      "phone_number": _airtimeNumberController
                                                                          .text
                                                                          .trim()
                                                                          .toString()
                                                                    }),
                                                                  );

                                                                  if (response
                                                                          .statusCode ==
                                                                      200) {
                                                                    var walletUpdate = FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'accounts');
                                                                    await walletUpdate
                                                                        .doc(
                                                                            userId)
                                                                        .update({
                                                                      'wallet_balance':
                                                                          (((int.tryParse(userController.user[0].userWalletBalance))!) - ((int.tryParse(_airtimeAmountController.text.trim().toString()))! + 20))
                                                                              .toString(),
                                                                      'utility_points':
                                                                          (((int.tryParse(userController.user[0].utilityPoints)!)) + 1)
                                                                              .toString(),
                                                                    }).then((value) async {
                                                                      var addUtility = FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'utility');
                                                                      await addUtility
                                                                          .add({
                                                                        'user_id': userController
                                                                            .user[0]
                                                                            .rentspaceID,
                                                                        'id': userController
                                                                            .user[0]
                                                                            .id,
                                                                        'amount': _airtimeAmountController
                                                                            .text
                                                                            .trim()
                                                                            .toString(),
                                                                        'charge':
                                                                            '20',
                                                                        'timestamp':
                                                                            FieldValue.serverTimestamp(),
                                                                        'biller':
                                                                            "9MOBILE AIRTIME",
                                                                        'transaction_id':
                                                                            getRandom(8),
                                                                        'date':
                                                                            formattedDate,
                                                                        'description':
                                                                            'bought airtime',
                                                                      });
                                                                    });
                                                                    _airtimeAmountController
                                                                        .clear();
                                                                    _airtimeNumberController
                                                                        .clear();
                                                                    _pinController
                                                                        .clear();
                                                                    setState(
                                                                        () {
                                                                      canLoad =
                                                                          true;
                                                                    });
                                                                    Get.snackbar(
                                                                      "Success!",
                                                                      "You just earned a Space point!",
                                                                      animationDuration:
                                                                          Duration(
                                                                              seconds: 2),
                                                                      backgroundColor:
                                                                          brandOne,
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .TOP,
                                                                    );
                                                                  } else {
                                                                    // Error handling
                                                                    _airtimeAmountController
                                                                        .clear();
                                                                    _airtimeNumberController
                                                                        .clear();
                                                                    _pinController
                                                                        .clear();
                                                                    setState(
                                                                        () {
                                                                      canLoad =
                                                                          true;
                                                                    });
                                                                    Get.snackbar(
                                                                      "Error",
                                                                      "Try again later",
                                                                      animationDuration:
                                                                          Duration(
                                                                              seconds: 2),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .BOTTOM,
                                                                    );
                                                                  }
                                                                } else {
                                                                  setState(() {
                                                                    canLoad =
                                                                        true;
                                                                  });
                                                                  Get.snackbar(
                                                                    "Incomplete",
                                                                    "Fill the field correctly to proceed",
                                                                    animationDuration:
                                                                        Duration(
                                                                            seconds:
                                                                                2),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    colorText:
                                                                        Colors
                                                                            .white,
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .BOTTOM,
                                                                  );
                                                                }
                                                              },
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2,
                                                              child: Text(
                                                                'Proceed to payment',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      "DefaultFontFamily",
                                                                ),
                                                              ),
                                                              color: brandOne,
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              '9Mobile airtime',
                                              style: TextStyle(
                                                fontFamily: "DefaultFontFamily",
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/9mobile.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    GFAccordion(
                                      expandedIcon: Container(
                                        decoration: BoxDecoration(
                                          color: brandThree,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.remove,
                                          color: brandOne,
                                        ),
                                      ),
                                      collapsedIcon: Container(
                                        decoration: BoxDecoration(
                                          color: brandThree,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.add,
                                          color: brandOne,
                                        ),
                                      ),
                                      title: "Data Subscription",
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "DefaultFontFamily",
                                      ),
                                      contentBackgroundColor:
                                          Colors.transparent,
                                      expandedTitleBackgroundColor: brandThree,
                                      collapsedTitleBackgroundColor: brandThree,
                                      onToggleCollapsed: (e) {},
                                      contentChild: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                showLoading = true;
                                              });
                                              dataList.clear();
                                              getData("bill-18");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'MTN Data Plans',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/mtn.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                showLoading = true;
                                              });
                                              dataList.clear();
                                              getData("bill-07");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'GLO Data Plans',
                                              style: TextStyle(
                                                fontFamily: "DefaultFontFamily",
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/glo.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                showLoading = true;
                                              });
                                              dataList.clear();
                                              getData("bill-16");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'Airtel Data Plans',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/airtel.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                showLoading = true;
                                              });
                                              dataList.clear();

                                              getData("bill-19");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              '9Mobile Data Plans',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/9mobile.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    (showLoading)
                                        ? Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              "Loading data plans...",
                                              style: TextStyle(
                                                fontFamily: "DefaultFontFamily",
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : SizedBox(),

                                    GFAccordion(
                                      expandedIcon: Container(
                                        decoration: BoxDecoration(
                                          color: brandThree,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.remove,
                                          color: brandOne,
                                        ),
                                      ),
                                      collapsedIcon: Container(
                                        decoration: BoxDecoration(
                                          color: brandThree,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.add,
                                          color: brandOne,
                                        ),
                                      ),
                                      title: "Cable Tv",
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "DefaultFontFamily",
                                      ),
                                      contentBackgroundColor:
                                          Colors.transparent,
                                      expandedTitleBackgroundColor: brandThree,
                                      collapsedTitleBackgroundColor: brandThree,
                                      onToggleCollapsed: (e) {},
                                      contentChild: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                showTvLoading = true;
                                              });
                                              tvList.clear();

                                              getTv("bill-20");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'DSTV - Subscription',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/dstv.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                showTvLoading = true;
                                              });
                                              tvList.clear();

                                              getTv("bill-14");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'GOtv - Subscription',
                                              style: TextStyle(
                                                fontFamily: "DefaultFontFamily",
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/gotv.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                showTvLoading = true;
                                              });
                                              tvList.clear();

                                              getTv("bill-15");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'Startimes - Subscription',
                                              style: TextStyle(
                                                fontFamily: "DefaultFontFamily",
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/startimes.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    (showTvLoading)
                                        ? Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              "Loading Tv plans...",
                                              style: TextStyle(
                                                fontFamily: "DefaultFontFamily",
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : SizedBox(),

                                    GFAccordion(
                                      expandedIcon: Container(
                                        decoration: BoxDecoration(
                                          color: brandThree,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.remove,
                                          color: brandOne,
                                        ),
                                      ),
                                      collapsedIcon: Container(
                                        decoration: BoxDecoration(
                                          color: brandThree,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.add,
                                          color: brandOne,
                                        ),
                                      ),
                                      title: "Electricity - Prepaid",
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "DefaultFontFamily",
                                      ),
                                      contentBackgroundColor:
                                          Colors.transparent,
                                      expandedTitleBackgroundColor: brandThree,
                                      collapsedTitleBackgroundColor: brandThree,
                                      onToggleCollapsed: (e) {},
                                      contentChild: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                electricName =
                                                    "Areas in Lagos covered by Ikeja Electricity Distribution Company (IKEDC) inlcude Abule Egba, Akowonjo, Ikeja, Ikorodu, Oshodi & Shomolu.";
                                              });
                                              validateElectric("bill-11");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'Ikeja Electric',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/7.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                electricName =
                                                    "Places covered in Lagos by Eko Electricity Distribution Company (EKEDC) include Ojo, Festac,  Ijora, Mushin, Orile Apapa, Lekki, Ibeju, Lagos Island, Ajele & Agbara.";
                                              });
                                              validateElectric("bill-02");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'EKO Electric',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/9.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                electricName =
                                                    "States and Areas covered by Ibadan Electricity Distribution Plc (IBEDC) include Oyo, Ogun, Osun, Kwara and parts of Niger(Mokwa), Ekiti and Kogi states.";
                                              });
                                              validateElectric("bill-03");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'IBEDC',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/11.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                electricName =
                                                    "States and Areas covered by  Jos Electricity Distribution Plc (JEDC) include Bauchi, Benue, Gombe Plateau.";
                                              });
                                              validateElectric("bill-32");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'Jos Electricity',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/13.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                electricName =
                                                    "States and Areas covered by Abuja Electricity Distribution Plc (AEDC) include FCT, Kogi, Nasarawa  & most parts of Niger (Minna, Suleja) States.";
                                              });
                                              validateElectric("bill-05");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'Abuja Electricity',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/15.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                electricName =
                                                    "States covered by Kaduna Electricity Distribution Plc (KNEDC) include Kaduna, Kebbi, Sokoto, Zamfara.";
                                              });
                                              validateElectric("bill-31");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'Kaduna Electric',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/17.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                electricName =
                                                    "States and Areas covered by Kano Electricity Distribution Plc (KEDCO) include Kano, Katsina, Jigawa.";
                                              });
                                              validateElectric("bill-09");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'Kano Electric',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/19.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                electricName =
                                                    "PortHarcourt Prepaid";
                                              });
                                              validateElectric("bill-35");
                                            },
                                            tileColor: brandSix,
                                            leading: Text(
                                              'PH Electric',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontFamily: "DefaultFontFamily",
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            trailing: Image.asset(
                                              "assets/utility/21.jpg",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),

                                          //
                                        ],
                                      ),
                                    ),

                                    GFAccordion(
                                      expandedIcon: Container(
                                        decoration: BoxDecoration(
                                          color: brandThree,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.remove,
                                          color: brandOne,
                                        ),
                                      ),
                                      collapsedIcon: Container(
                                        decoration: BoxDecoration(
                                          color: brandThree,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.add,
                                          color: brandOne,
                                        ),
                                      ),
                                      title: "Betting",
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "DefaultFontFamily",
                                      ),
                                      contentBackgroundColor:
                                          Colors.transparent,
                                      expandedTitleBackgroundColor: brandThree,
                                      collapsedTitleBackgroundColor: brandThree,
                                      onToggleCollapsed: (e) {},
                                      contentChild: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //
                                          (betList.isNotEmpty)
                                              ? ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      ClampingScrollPhysics(),
                                                  itemCount: betList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final bill = betList[index];
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 6, 0, 6),
                                                      child: ListTile(
                                                        onTap: () {
                                                          Get.bottomSheet(
                                                            SingleChildScrollView(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: SizedBox(
                                                                  height: 500,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            20.0,
                                                                            0,
                                                                            20,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              100,
                                                                        ),
                                                                        Image
                                                                            .network(
                                                                          bill.icon,
                                                                          height:
                                                                              80,
                                                                          width:
                                                                              80,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          bill.name,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              30,
                                                                        ),
                                                                        TextFormField(
                                                                          enableSuggestions:
                                                                              true,
                                                                          cursorColor:
                                                                              Colors.black,
                                                                          controller:
                                                                              _betNumberController,
                                                                          autovalidateMode:
                                                                              AutovalidateMode.onUserInteraction,
                                                                          keyboardType:
                                                                              TextInputType.phone,
                                                                          maxLengthEnforcement:
                                                                              MaxLengthEnforcement.enforced,
                                                                          maxLength:
                                                                              11,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          decoration:
                                                                              InputDecoration(
                                                                            prefix:
                                                                                Text(
                                                                              "" + varValue.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 15,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            label:
                                                                                Text(
                                                                              "Enter valid ${bill.name} account number",
                                                                              style: TextStyle(
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                              borderSide: BorderSide(color: brandOne, width: 2.0),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(color: brandOne, width: 2.0),
                                                                            ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(color: brandOne, width: 2.0),
                                                                            ),
                                                                            filled:
                                                                                true,
                                                                            fillColor:
                                                                                brandThree,
                                                                            hintText:
                                                                                '',
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 13,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              50,
                                                                        ),
                                                                        GFButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (_betNumberController.text.trim() !=
                                                                                "") {
                                                                              Get.back();
                                                                              setState(() {
                                                                                canLoad = false;

                                                                                loadMssg = "Validating...";
                                                                              });
                                                                              const String apiUrl = 'https://api.watupay.com/v1/watubill/validate';
                                                                              const String bearerToken = 'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
                                                                              final response = await http.post(
                                                                                Uri.parse(apiUrl),
                                                                                headers: {
                                                                                  'Authorization': 'Bearer $bearerToken',
                                                                                  "Content-Type": "application/json"
                                                                                },
                                                                                body: jsonEncode(<String, String>{
                                                                                  "channel": bill.id,
                                                                                  "account_number": _betNumberController.text.trim().toString()
                                                                                }),
                                                                              );

                                                                              if (response.statusCode == 200) {
                                                                                Map<String, dynamic> apiResponse = jsonDecode(response.body);

                                                                                setState(() {
                                                                                  userBetName = apiResponse['data']['customer_name'];
                                                                                  userBetAddress = apiResponse['data']['account_number'];

                                                                                  canLoad = true;

                                                                                  print(userBetName);
                                                                                });

                                                                                firstBetFund(bill.id, bill.name);
                                                                              } else {
                                                                                setState(() {
                                                                                  canLoad = true;
                                                                                });
                                                                                Get.snackbar(
                                                                                  "Failed!",
                                                                                  "The request failed. Check that the Account Number is valid and retry.",
                                                                                  animationDuration: Duration(seconds: 2),
                                                                                  backgroundColor: Colors.red,
                                                                                  colorText: Colors.white,
                                                                                  snackPosition: SnackPosition.BOTTOM,
                                                                                );
                                                                              }
                                                                            }
                                                                          },
                                                                          text:
                                                                              "  Validate  ",
                                                                          fullWidthButton:
                                                                              true,
                                                                          color:
                                                                              brandOne,
                                                                          shape:
                                                                              GFButtonShape.pills,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            elevation: 2,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .canvasColor,
                                                          );
                                                        },
                                                        title: Text(
                                                          bill.name,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "DefaultFontFamily",
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        trailing: Image.network(
                                                          bill.icon,
                                                          height: 40,
                                                          width: 40,
                                                        ),
                                                        tileColor: brandSix,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      "Loading...",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "DefaultFontFamily",
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),

                                    //
                                    SizedBox(
                                      height: 80,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/icons/RentSpace-icon.png"),
                                    fit: BoxFit.cover,
                                    opacity: 0.1,
                                  ),
                                ),
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Flexible(
                                            child: Text(
                                              "kindly confirm your BVN to use this service.",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                letterSpacing: 0.5,
                                                fontFamily: "DefaultFontFamily",
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    GFButton(
                                      onPressed: () async {
                                        Get.to(nt.BvnPage());
                                      },
                                      text: "  Begin Verification  ",
                                      fullWidthButton: false,
                                      color: brandOne,
                                      shape: GFButtonShape.pills,
                                    ),
                                  ],
                                ),
                              ),
                      )
                    : Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/icons/RentSpace-icon.png"),
                              fit: BoxFit.cover,
                              opacity: 0.1),
                        ),
                        child: Column(
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
                                  "${loadMssg}" + varValue.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "DefaultFontFamily",
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            CircularProgressIndicator(
                              color: brandOne,
                            ),
                          ],
                        ),
                      )),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icons/RentSpace-icon.png"),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20.0, 200, 20, 0),
              child: Center(
                child: ListView(
                  children: [
                    Text(
                      "You need to fund your SpaceWallet to use this service.",
                      style: TextStyle(
                        fontSize: 16.0,
                        letterSpacing: 0.5,
                        fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GFButton(
                      onPressed: () async {
                        Get.to(FundWallet());
                      },
                      text: "  Fund SpaceWallet  ",
                      fullWidthButton: false,
                      color: brandOne,
                      shape: GFButtonShape.pills,
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
