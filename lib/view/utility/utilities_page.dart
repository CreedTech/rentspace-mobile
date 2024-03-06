// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pinput/pinput.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/constants/app_constants.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:rentspace/controller/user_controller.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
import 'package:rentspace/view/FirstPage.dart';
import 'package:rentspace/view/actions/fund_wallet.dart';
import 'package:rentspace/view/actions/onboarding_page.dart' as nt;
import 'package:rentspace/view/utility/data_screen.dart';
import 'package:rentspace/view/utility/electricity_screen.dart';
import 'package:rentspace/view/utility/tv_screen.dart';
import 'package:rentspace/view/utility/utilities_history.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'dart:math';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../api/global_services.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/utility_controller.dart';

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
  final String? productCode;
  final int? invoicePeriod;
  final int? validity;

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
      validity: json['validity'] ?? '',
      invoicePeriod: json['invoice_period'] ?? 0,
      productCode: json['product_code'] ?? 0,
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
bool hideBalance = false;
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
final airtimeFormKey = GlobalKey<FormState>();
final dataFormKey = GlobalKey<FormState>();

class _UtilitiesPageState extends State<UtilitiesPage> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isRefresh = false;
  List<DataList> dataList = [];
  List<TvList> tvList = [];
  List<Bill> betList = [];
  final UtilityController utilityController = Get.find();
  final UserController userController = Get.find();
//bet

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
    if (text.length != 11) {
      return 'Recipient Number must be 11 Digit';
    }
    if (int.tryParse(text.replaceAll(',', ''))!.isNegative) {
      return 'enter positive value';
    }
    return null;
  }

  validatePin(pinOneValue) {
    if (pinOneValue.isEmpty) {
      return 'pin cannot be empty';
    }
    if (pinOneValue.length < 4) {
      return 'pin is incomplete';
    }

    if (!BCrypt.checkpw(
      int.tryParse(pinOneValue).toString(),
      userController.userModel!.userDetails![0].wallet.pin,
    )) {
      return 'incorrect PIN';
    }
    if (int.tryParse(pinOneValue) == null) {
      return 'enter valid number';
    }
    return null;
  }

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
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    "Fund your account and earn 1 SpacePoint!",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "(₦50 charges applies)",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    " $userBetName",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
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
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      prefix: Text(
                        "$varValue",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      label: const Text(
                        "Amount in naira",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: brandOne, width: 2.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: brandOne, width: 2.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: brandOne, width: 2.0),
                      ),
                      filled: true,
                      fillColor: brandThree,
                      hintText: '',
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(
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
                  const SizedBox(
                    height: 50,
                  ),
                  GFButton(
                    onPressed: () async {
                      if (((userController
                              .userModel!.userDetails![0].wallet.mainBalance) <
                          ((int.tryParse(_betAmountController.text
                                  .trim()
                                  .toString()))! +
                              50))) {
                        Get.back();
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AlertDialog(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        30, 30, 30, 20),
                                    elevation: 0,
                                    alignment: Alignment.bottomCenter,
                                    insetPadding: const EdgeInsets.all(0),
                                    scrollable: true,
                                    title: null,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 40),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 15),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Text(
                                                      'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.nunito(
                                                        color: brandOne,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                            Get.to(
                                                                const FundWallet());
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        60,
                                                                    vertical:
                                                                        15),
                                                            textStyle:
                                                                const TextStyle(
                                                                    color:
                                                                        brandFour,
                                                                    fontSize:
                                                                        13),
                                                          ),
                                                          child: const Text(
                                                            "Fund Wallet",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            });

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
      // var walletUpdate = FirebaseFirestore.instance.collection('accounts');
      // await walletUpdate.doc(userId).update({
      //   'wallet_balance':
      //       (((int.tryParse(userController.user[0].userWalletBalance))!) -
      //               ((int.tryParse(_betAmountController.text.trim()))! + 70))
      //           .toString(),
      //   'utility_points':
      //       (((int.tryParse(userController.user[0].utilityPoints)!)) + 1)
      //           .toString(),
      // }).then((value) async {
      //   var addUtility = FirebaseFirestore.instance.collection('utility');
      //   await addUtility.add({
      //     'user_id': userController.user[0].rentspaceID,
      //     'timestamp': FieldValue.serverTimestamp(),
      //     'id': userController.user[0].id,
      //     'amount': _betAmountController.text.toString(),
      //     'charge': '70',
      //     'biller': biller,
      //     'transaction_id': getRandom(8),
      //     'date': formattedDate,
      //     'description': 'Funded Betting Account',
      //   });
      // });
      _betAmountController.clear();
      _betPinController.clear();
      setState(() {
        canLoad = true;
      });
      Get.to(FirstPage());
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          backgroundColor: brandOne,
          message: 'You just earned a Space point!',
          textStyle: GoogleFonts.nunito(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else {
      // Error handling
      _betAmountController.clear();
      _betPinController.clear();
      setState(() {
        canLoad = true;
      });
      customErrorDialog(context, "Error", "Try again later");
      // Get.snackbar(
      //   "Error",
      //   "Try again later",
      //   animationDuration: const Duration(seconds: 2),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
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
      // var walletUpdate = FirebaseFirestore.instance.collection('accounts');
      // await walletUpdate.doc(userId).update({
      //   'wallet_balance':
      //       (((int.tryParse(userController.user[0].userWalletBalance))!) -
      //               ((int.tryParse(tvAmount))! + 20))
      //           .toString(),
      //   'utility_points':
      //       (((int.tryParse(userController.user[0].utilityPoints)!)) + 1)
      //           .toString(),
      // }).then((value) async {
      //   var addUtility = FirebaseFirestore.instance.collection('utility');
      //   await addUtility.add({
      //     'user_id': userController.user[0].rentspaceID,
      //     'id': userController.user[0].id,
      //     'amount': tvAmount,
      //     'timestamp': FieldValue.serverTimestamp(),
      //     'charge': '20',
      //     'biller': tvPlanName,
      //     'transaction_id': getRandom(8),
      //     'date': formattedDate,
      //     'description': 'Subscribed for Tv',
      //   });
      // });
      _tvNumberController.clear();
      _tvPinController.clear();
      setState(() {
        canLoad = true;
      });

      Get.to(FirstPage());
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          backgroundColor: brandOne,
          message: 'You just earned a Space point!',
          textStyle: GoogleFonts.nunito(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else {
      // Error handling
      _tvNumberController.clear();
      _tvPinController.clear();
      setState(() {
        canLoad = true;
      });
      customErrorDialog(context, "Error", "Try again later");
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
        "email": userController.userModel!.userDetails![0].email,
        "phone_number":
            userController.userModel!.userDetails![0].phoneNumber.toString(),
        "request_time": formattedDate,
        "contact_type": "phone",
        "business_signature": "a390960dfa37469d824ffe6cb80472f6",
        "meter_number": _electricNumberController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      // Map<String, dynamic> apiResponse = jsonDecode(response.body);
      // final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // final Map<String, dynamic> data = jsonResponse['data'];
      // final Map<String, dynamic> billData = data['bill_data'];
      // final String token = billData['Token'];
      // setState(() {
      //   electricToken = token;
      // });
      // var walletUpdate = FirebaseFirestore.instance.collection('accounts');
      // await walletUpdate.doc(userId).update({
      //   'wallet_balance': (((int.tryParse(
      //               userController.user[0].userWalletBalance))!) -
      //           ((int.tryParse(
      //                   _electricAmountController.text.trim().toString()))! +
      //               20))
      //       .toString(),
      //   'utility_points':
      //       (((int.tryParse(userController.user[0].utilityPoints)!)) + 1)
      //           .toString(),
      // }).then((value) async {
      //   var addUtility = FirebaseFirestore.instance.collection('utility');
      //   await addUtility.add({
      //     'user_id': userController.user[0].rentspaceID,
      //     'id': userController.user[0].id,
      //     'amount': _electricAmountController.text.trim().toString(),
      //     'charge': '20',
      //     'timestamp': FieldValue.serverTimestamp(),
      //     'biller': "Electricity Subscription",
      //     'transaction_id': getRandom(8),
      //     'date': formattedDate,
      //     'description': 'Subscribed for Electricity',
      //   });
      // });
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
                    const SizedBox(
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Here is your Token: $electricToken",
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
                    const SizedBox(
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
      customErrorDialog(context, "Error", "Try again later");
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
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              height: 500,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      "Subscribe to $tvPlanName and earn 1 SpacePoint!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      " $tvFirst $tvLast",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      " $tvStatus",
                      style: GoogleFonts.nunito(
                          color:
                              (tvStatus == "Open") ? Colors.green : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Pinput(
                    //   defaultPinTheme: PinTheme(
                    //     width: 30,
                    //     height: 30,
                    //     textStyle: TextStyle(
                    //       fontSize: 20,
                    //       color: Theme.of(context).primaryColor,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: brandOne, width: 2.0),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    //   controller: _tvPinController,
                    //   length: 4,
                    //   closeKeyboardWhenCompleted: true,
                    //   keyboardType: TextInputType.number,
                    // ),
                    const SizedBox(
                      height: 50,
                    ),
                    // GFButton(
                    //   onPressed: () async {
                    //     if (((userController.userModel!.userDetails![0].wallet
                    //                 .mainBalance) >
                    //             ((int.tryParse(tvAmount))! + 50)) &&
                    //         (tvStatus == "Open")) {
                    //       Get.back();
                    //       setState(() {
                    //         canLoad = false;
                    //         loadMssg = "Subscribing...";
                    //       });
                    //       vendTv(billId);
                    //     } else {
                    //       Get.back();
                    //       Get.snackbar(
                    //         "Insufficient fund",
                    //         "You do not have sufficient fund to perform the transaction. Fund your Space Wallet and retry",
                    //         animationDuration: const Duration(seconds: 2),
                    //         backgroundColor: Colors.red,
                    //         colorText: Colors.white,
                    //         snackPosition: SnackPosition.BOTTOM,
                    //       );
                    //       setState(() {
                    //         canLoad = true;
                    //       });
                    //     }
                    //   },
                    //   text: "  Subscribe  ",
                    //   fullWidthButton: true,
                    //   color: brandOne,
                    //   shape: GFButtonShape.pills,
                    // ),

                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                        // Get.to(DataScreen(
                        //     validity: dataList[index].validity,
                        //     name: dataList[index].name,
                        //     amount: dataList[index].amount,
                        //     userPin: userController
                        //         .userModel!.userDetails![0].wallet.pin,
                        //     number:
                        //         _dataNumberController.text.trim().toString(),
                        //     billId: billId));
                        Get.to(
                          TvScreen(
                            tvAmount: tvAmount,
                            userPin: userController
                                .userModel!.userDetails![0].wallet.pin,
                            tvNumber: _tvNumberController.text.trim(),
                            billId: billId,
                            tvPlanName: tvPlanName,
                            tvInvoicePeriod: tvInvoicePeriod,
                            tvProductCode: tvProductCode,
                            mainBalance: userController
                                .userModel!.userDetails![0].wallet.mainBalance,
                            tvStatus: tvStatus,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: brandOne,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Align(
                            child: Text(
                              'Subscribe',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
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

      customErrorDialog(context, "Failed!",
          "The request failed. Check that the Smart Card Number is valid and retry.");
    }
  }

  validateElectric(String billId) async {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            height: 500,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    electricName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      TextFormField(
                        enableSuggestions: true,
                        cursorColor: Theme.of(context).primaryColor,
                        controller: _electricNumberController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: validateNumber,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        keyboardType: TextInputType.phone,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        maxLength: 11,
                        decoration: InputDecoration(
                          prefix: Text(
                            "$varValue",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          label: Text(
                            "Enter valid Meter number",
                            style: GoogleFonts.nunito(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Color(0xffE0E0E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: brandOne, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffE0E0E0),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0), // Change color to yellow
                          ),
                          filled: false,
                          contentPadding: const EdgeInsets.all(14),
                          fillColor: brandThree,
                          hintText: '',
                          hintStyle: GoogleFonts.nunito(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () async {
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
                                child: Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  height: 500,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 0, 20, 0),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 100,
                                        ),
                                        Text(
                                          "Buy Electricity and earn 1 SpacePoint!",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          " $userElectricName",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.nunito(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          " $userElectricAddress",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Column(
                                          children: [
                                            TextFormField(
                                              enableSuggestions: true,
                                              cursorColor: Theme.of(context)
                                                  .primaryColor,
                                              controller:
                                                  _electricAmountController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              // validator: validateNumber,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              keyboardType: TextInputType.phone,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement.enforced,
                                              maxLength: 11,
                                              decoration: InputDecoration(
                                                prefix: Text(
                                                  "$varValue",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                label: Text(
                                                  "Amount in naira",
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xffE0E0E0),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                      color: brandOne,
                                                      width: 2.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xffE0E0E0),
                                                  ),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                      color: Colors.red,
                                                      width:
                                                          2.0), // Change color to yellow
                                                ),
                                                filled: false,
                                                contentPadding:
                                                    const EdgeInsets.all(14),
                                                fillColor: brandThree,
                                                hintText: '',
                                                hintStyle: GoogleFonts.nunito(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
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
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (((userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .wallet
                                                    .mainBalance) <
                                                ((int.tryParse(
                                                    _electricAmountController
                                                        .text
                                                        .trim()
                                                        .toString()))!))) {
                                              Get.back();
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        AlertDialog(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .fromLTRB(30,
                                                                  30, 30, 20),
                                                          elevation: 0,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          scrollable: true,
                                                          title: null,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              topRight: Radius
                                                                  .circular(30),
                                                            ),
                                                          ),
                                                          content: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          40),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                15),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                          child:
                                                                              Text(
                                                                            'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              color: brandOne,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(3),
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  Get.back();
                                                                                  Get.to(const FundWallet());
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                                                                  textStyle: const TextStyle(color: brandFour, fontSize: 13),
                                                                                ),
                                                                                child: const Text(
                                                                                  "Fund Wallet",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });

                                              setState(() {
                                                canLoad = true;
                                              });
                                            } else {
                                              // Navigator.pop(context);
                                              Get.to(ElectricityScreen(
                                                  electricName: electricName,
                                                  userElectricName:
                                                      userElectricName,
                                                  email: userController
                                                      .userModel!
                                                      .userDetails![0]
                                                      .email,
                                                  electricAmount:
                                                      _electricAmountController
                                                          .text
                                                          .trim()
                                                          .toString(),
                                                  userPin: userController
                                                      .userModel!
                                                      .userDetails![0]
                                                      .wallet
                                                      .pin,
                                                  electricNumber:
                                                      _electricNumberController
                                                          .text
                                                          .trim(),
                                                  billId: billId,
                                                  phoneNumber: userController
                                                      .userModel!
                                                      .userDetails![0]
                                                      .phoneNumber,
                                                  formattedDate: formattedDate,
                                                  mainBalance: userController
                                                      .userModel!
                                                      .userDetails![0]
                                                      .wallet
                                                      .mainBalance));
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: brandOne,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(13),
                                              child: Align(
                                                child: Text(
                                                  'Subscribe',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                    fontSize: 19.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GFButton(
                                          onPressed: () async {
                                            if (((userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .wallet
                                                    .mainBalance) <
                                                ((int.tryParse(
                                                        _electricAmountController
                                                            .text
                                                            .trim()
                                                            .toString()))! +
                                                    50))) {
                                              Get.back();
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        AlertDialog(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .fromLTRB(30,
                                                                  30, 30, 20),
                                                          elevation: 0,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          scrollable: true,
                                                          title: null,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              topRight: Radius
                                                                  .circular(30),
                                                            ),
                                                          ),
                                                          content: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          40),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                15),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                          child:
                                                                              Text(
                                                                            'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              color: brandOne,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(3),
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  Get.back();
                                                                                  Get.to(const FundWallet());
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                                                                  textStyle: const TextStyle(color: brandFour, fontSize: 13),
                                                                                ),
                                                                                child: const Text(
                                                                                  "Fund Wallet",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });

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
                          customErrorDialog(context, "Failed!",
                              "The request failed. Check that the meter Number is valid and retry.");
                        }
                      } else {
                        customErrorDialog(context, "Incomplete",
                            "Fill the field correctly to proceed");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: brandOne,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Align(
                          child: Text(
                            'Validate',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
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
  getData(String billId, String dataName) async {
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
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return SizedBox(
              height: 500,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            dataPlanName = dataList[index].name;
                          });
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    height: 500,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20.0, 0, 20, 0),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 100,
                                          ),
                                          Text(
                                            "Subscribe to $dataPlanName and earn 1 SpacePoint!",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.nunito(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Column(
                                            children: [
                                              TextFormField(
                                                enableSuggestions: true,
                                                cursorColor: Theme.of(context)
                                                    .primaryColor,
                                                controller:
                                                    _dataNumberController,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                // validator: validateNumber,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                keyboardType:
                                                    TextInputType.phone,
                                                maxLengthEnforcement:
                                                    MaxLengthEnforcement
                                                        .enforced,
                                                maxLength: 11,
                                                decoration: InputDecoration(
                                                  prefix: Text(
                                                    "$varValue",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  label: Text(
                                                    "Enter valid number",
                                                    style: GoogleFonts.nunito(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xffE0E0E0),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: brandOne,
                                                            width: 2.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xffE0E0E0),
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide: const BorderSide(
                                                        color: Colors.red,
                                                        width:
                                                            2.0), // Change color to yellow
                                                  ),
                                                  filled: false,
                                                  contentPadding:
                                                      const EdgeInsets.all(14),
                                                  fillColor: brandThree,
                                                  hintText:
                                                      'e.g 080 123 456 789 ',
                                                  hintStyle: GoogleFonts.nunito(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Navigator.pop(context);
                                              Get.to(DataScreen(
                                                dataName: dataName,
                                                validity:
                                                    dataList[index].validity,
                                                name: dataList[index].name,
                                                amount: dataList[index].amount,
                                                userPin: userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .wallet
                                                    .pin,
                                                number: _dataNumberController
                                                    .text
                                                    .trim()
                                                    .toString(),
                                                billId: billId,
                                                mainBalance: userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .wallet
                                                    .mainBalance,
                                              ));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: brandOne,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13),
                                                child: Align(
                                                  child: Text(
                                                    'Pay',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.nunito(
                                                      color: Colors.white,
                                                      fontSize: 19.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            tileColor: Colors.white,
                            title: Text(dataList[index].name,
                                style: GoogleFonts.nunito(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700)),
                            subtitle: Text(
                              'Amount: ${nairaFormaet.format(int.tryParse(dataList[index].amount.toString()))}, ',
                              style: GoogleFonts.nunito(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            // trailing: Icon(Icons.arrow_right_alt_outlined,
                            //     color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          });
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
      print(listTvField);
      setState(() {
        tvList = listTvField.map((item) => TvList.fromJson(item)).toList();
        showTvLoading = false;
      });
      Get.bottomSheet(
        SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: ListView.builder(
              itemCount: tvList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        tvPlanName = tvList[index].name;
                        tvAmount = tvList[index].amount.toString();
                        tvValidity = tvList[index].validity!.toString();
                        tvInvoicePeriod =
                            tvList[index].invoicePeriod!.toString();
                        tvProductCode = tvList[index].productCode!;
                      });
                      Get.back();
                      Get.bottomSheet(
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              height: 500,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 100,
                                    ),
                                    Text(
                                      "Subscribe to $tvPlanName and earn 1 SpacePoint!",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Column(
                                      children: [
                                        TextFormField(
                                          enableSuggestions: true,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          controller: _tvNumberController,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          // validator: validateNumber,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          keyboardType: TextInputType.phone,
                                          maxLengthEnforcement:
                                              MaxLengthEnforcement.enforced,
                                          maxLength: 11,
                                          decoration: InputDecoration(
                                            prefix: Text(
                                              "$varValue",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            label: Text(
                                              "Enter valid Smart card number",
                                              style: GoogleFonts.nunito(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: const BorderSide(
                                                color: Color(0xffE0E0E0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: brandOne, width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                color: Color(0xffE0E0E0),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width:
                                                      2.0), // Change color to yellow
                                            ),
                                            filled: false,
                                            contentPadding:
                                                const EdgeInsets.all(14),
                                            fillColor: brandThree,
                                            hintText: '',
                                            hintStyle: GoogleFonts.nunito(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        //
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (_tvNumberController.text.trim() !=
                                                "" ||
                                            _tvNumberController.text
                                                    .trim()
                                                    .length <
                                                10) {
                                          Get.back();
                                          setState(() {
                                            canLoad = false;
                                            loadMssg = "Validating...";
                                          });
                                          validateTv(billId);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: brandOne,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(13),
                                          child: Align(
                                            child: Text(
                                              'Validate',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontSize: 19.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        tileColor: Colors.white,
                        title: Text(
                          tvList[index].name,
                          style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          'Amount: ${nairaFormaet.format(int.tryParse(tvList[index].amount.toString()))}, Validity: ${tvList[index].validity}',
                          style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
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
  // getBet() async {
  //   const String apiUrl =
  //       'https://api.watupay.com/v1/watubill/channels?is_favourite=0&should_paginate=0&country=NG&group=betting';
  //   const String bearerToken = 'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
  //   final responseRef = await http.get(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       'Authorization': 'Bearer $bearerToken',
  //       "Content-Type": "application/json"
  //     },
  //   );

  //   if (responseRef.statusCode == 200) {
  //     final jsonResponse = jsonDecode(responseRef.body);
  //     final bills = (jsonResponse['data'] as List)
  //         .map((billData) => Bill.fromJson(billData))
  //         .toList();
  //     setState(() {
  //       betList = bills;
  //     });
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  @override
  initState() {
    super.initState();
    setState(() {
      canLoad = true;
      showLoading = false;
      showTvLoading = false;
      dataPlanName = "";
      hideBalance = false;
      loadMssg = "Loading services...";
      _airtimeAmountController.clear();
      _airtimeNumberController.clear();
      _pinController.clear();
    });
    betList.clear();
    // getBet();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        canLoad = true;
      });
    });
  }

  Future<void> onRefresh() async {
    refreshController.refreshCompleted();
    // if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
    if (mounted) {
      setState(() {
        isRefresh = true;
      });
    }
    userController.fetchData();
    rentController.fetchRent();
    utilityController.fetchUtilityHistories();
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

      if (!BCrypt.checkpw(
        int.tryParse(pinOneValue).toString(),
        userController.userModel!.userDetails![0].wallet.pin,
      )) {
        return 'incorrect PIN';
      }
      if (int.tryParse(pinOneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    validateAmount(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if ((int.tryParse(text.replaceAll(',', ''))! >= 1) &&
          (int.tryParse(text.replaceAll(',', ''))! < 50)) {
        return 'minimum amount is ₦50';
      }
      if (((int.tryParse(text.replaceAll(',', ''))!) >
          userController.userModel!.userDetails![0].wallet.mainBalance)) {
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
      return null;
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
      if (text.length != 11) {
        return 'Recipient Number must be 11 Digit';
      }
      if (int.tryParse(text.replaceAll(',', ''))!.isNegative) {
        return 'enter positive value';
      }
      return null;
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
      cursorColor: Theme.of(context).primaryColor,
      controller: _airtimeAmountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      // update the state variable when the text changes

      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsFormatter()],
      decoration: InputDecoration(
        label: Text(
          "How much do you want to recharge?",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        prefixText: "₦ ",
        prefixStyle: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Amount in Naira',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    final airtimePhone = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _airtimeNumberController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateNumber,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "Enter valid number",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        fillColor: brandThree,
        hintText: 'e.g 080 123 456 789 ',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
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
    return (userController.userModel!.userDetails![0].wallet.mainBalance > 0)
        ? Obx(
            () => Scaffold(
                backgroundColor: Theme.of(context).canvasColor,
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Theme.of(context).canvasColor,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(
                    'Utilities',
                    style: GoogleFonts.nunito(
                      color: Theme.of(context).primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Get.to(const UtilitiesHistory());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "History$varValue",
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.history_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                body: (canLoad)
                    ? LiquidPullToRefresh(
                        height: 100,
                        animSpeedFactor: 2,
                        color: brandOne,
                        backgroundColor: Colors.white,
                        showChildOpacityTransition: false,
                        onRefresh: onRefresh,
                        child: SizedBox(
                          child: (userController.userModel!.userDetails![0]
                                      .hasVerifiedBvn ==
                                  true)
                              ? Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.fromLTRB(2.0, 5, 2.0, 5),
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    children: [
                                      // const SizedBox(
                                      //   height: 30,
                                      // ),

                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Text(
                                              "Pay for your bills and earn one SpacePoint!",
                                              // textAlign: TextAlign.center,
                                              style: GoogleFonts.nunito(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            child: Text(
                                              "Get access to a wide range of utilities and earn a SpacePoint when you make payment from your SpaceWallet!",
                                              // textAlign: TextAlign.center,
                                              style: GoogleFonts.nunito(
                                                fontSize: 14,
                                                //height: 0.5,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Wallet balance",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      hideBalance =
                                                          !hideBalance;
                                                    });
                                                  },
                                                  child: Icon(
                                                    hideBalance
                                                        ? Icons
                                                            .visibility_outlined
                                                        : Icons
                                                            .visibility_off_outlined,
                                                    color: brandOne,
                                                    size: 15.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                (userController.isLoading.value)
                                                    ? Text(
                                                        '${nairaFormaet.format(0)} ',
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      )
                                                    : Text(
                                                        '${hideBalance ? nairaFormaet.format(double.parse(userController.userModel!.userDetails![0].wallet.mainBalance.toString())) : "*****"} ',
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 0),
                                        child: Row(
                                          children: [
                                            (userController.isLoading.value)
                                                ? Text(
                                                    'SpacePoints: 0',
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  )
                                                : Text(
                                                    'SpacePoints: ${userController.userModel!.userDetails![0].utilityPoints.toString()}',
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: ExpansionTile(
                                          initiallyExpanded: true,
                                          title: Text(
                                            'Airtime Top Up',
                                            style: GoogleFonts.nunito(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          backgroundColor: brandOne,
                                          collapsedBackgroundColor: brandOne,
                                          iconColor: Colors.white,
                                          collapsedIconColor: Colors.white,
                                          tilePadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                          childrenPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          collapsedShape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          children: [
                                            mtnAirtimeMethod(
                                                context,
                                                airtimePhone,
                                                airtimeAmount,
                                                validatePin),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            gloMethod(context, airtimePhone,
                                                airtimeAmount, validatePin),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            airtelMethod(context, airtimePhone,
                                                airtimeAmount, validatePin),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            etisalatMethod(
                                                context,
                                                airtimePhone,
                                                airtimeAmount,
                                                validatePin),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: ExpansionTile(
                                          initiallyExpanded: true,
                                          title: Text(
                                            'Data Subscription',
                                            style: GoogleFonts.nunito(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          backgroundColor: brandOne,
                                          collapsedBackgroundColor: brandOne,
                                          iconColor: Colors.white,
                                          collapsedIconColor: Colors.white,
                                          tilePadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                          childrenPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          collapsedShape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                setState(() {
                                                  showLoading = true;
                                                });
                                                dataList.clear();
                                                getData("bill-18", 'MTN');
                                              },
                                              tileColor: Colors.white,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/mtn.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'MTN Data Plans',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ListTile(
                                              onTap: () {
                                                setState(() {
                                                  showLoading = true;
                                                });
                                                dataList.clear();
                                                getData("bill-07", 'GLO');
                                              },
                                              tileColor: brandSix,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/glo.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'GLO Data Plans',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ListTile(
                                              onTap: () {
                                                setState(() {
                                                  showLoading = true;
                                                });
                                                dataList.clear();
                                                getData("bill-16", 'AIRTEL');
                                              },
                                              tileColor: brandSix,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/airtel.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'Airtel Data Plans',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ListTile(
                                              onTap: () {
                                                setState(() {
                                                  showLoading = true;
                                                });
                                                dataList.clear();

                                                getData("bill-19", '9MOBILE');
                                              },
                                              tileColor: brandSix,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/9mobile.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                '9Mobile Data Plans',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      (showLoading)
                                          ? const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Center(
                                                child: CustomLoader(),
                                              ),
                                            )
                                          : const SizedBox(),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: ExpansionTile(
                                          initiallyExpanded: true,
                                          title: Text(
                                            'Cable Tv',
                                            style: GoogleFonts.nunito(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          backgroundColor: brandOne,
                                          collapsedBackgroundColor: brandOne,
                                          iconColor: Colors.white,
                                          collapsedIconColor: Colors.white,
                                          tilePadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                          childrenPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          collapsedShape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                setState(() {
                                                  showTvLoading = true;
                                                });
                                                tvList.clear();

                                                getTv("bill-20");
                                              },
                                              tileColor: Colors.white,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/dstv.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'DSTV - Subscription',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
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
                                              tileColor: Colors.white,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/gotv.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'GOtv - Subscription',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            // ListTile(
                                            //   onTap: () {
                                            //     setState(() {
                                            //       showTvLoading = true;
                                            //     });
                                            //     tvList.clear();

                                            //     getTv("bill-15");
                                            //   },
                                            //   tileColor: Colors.white,
                                            //   trailing: ClipRRect(
                                            //     borderRadius:
                                            //         BorderRadius.circular(100.0),
                                            //     child: Image.asset(
                                            //       "assets/utility/startimes.jpg",
                                            //       height: 40,
                                            //       width: 40,
                                            //     ),
                                            //   ),
                                            //   leading: Text(
                                            //     'Startimes - Subscription',
                                            //     style: GoogleFonts.nunito(
                                            //       color: Theme.of(context)
                                            //           .canvasColor,
                                            //       fontSize: 15,
                                            //     ),
                                            //   ),
                                            // ),
                                            // const SizedBox(
                                            //   height: 10,
                                            // ),
                                          ],
                                        ),
                                      ),

                                      (showTvLoading)
                                          ? const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Center(
                                                child: CustomLoader(),
                                              ),
                                            )
                                          : const SizedBox(),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: ExpansionTile(
                                          initiallyExpanded: true,
                                          title: Text(
                                            'Electricity - Prepaid',
                                            style: GoogleFonts.nunito(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          backgroundColor: brandOne,
                                          collapsedBackgroundColor: brandOne,
                                          iconColor: Colors.white,
                                          collapsedIconColor: Colors.white,
                                          tilePadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                          childrenPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          collapsedShape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                setState(() {
                                                  electricName =
                                                      "Areas in Lagos covered by Ikeja Electricity Distribution Company (IKEDC) inlcude Abule Egba, Akowonjo, Ikeja, Ikorodu, Oshodi & Shomolu.";
                                                });
                                                validateElectric("bill-11");
                                              },
                                              tileColor: Colors.white,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/7.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'Ikeja Electric',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
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
                                              tileColor: Colors.white,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/9.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'EKO Electric',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
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
                                              tileColor: Colors.white,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/11.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'IBEDC',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
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
                                              tileColor: Colors.white,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/13.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'Jos Electricity',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
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
                                              tileColor: Colors.white,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/15.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'Abuja Electricity',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
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
                                              tileColor: Colors.white,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/17.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'Kaduna Electric',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
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
                                              tileColor: Colors.white,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/19.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'Kano Electric',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
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
                                              tileColor: Colors.white,
                                              trailing: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.asset(
                                                  "assets/utility/21.jpg",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              leading: Text(
                                                'PH Electric',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),

                                      // const SizedBox(
                                      //   height: 80,
                                      // ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "kindly confirm your BVN to use this service.",
                                              style: GoogleFonts.nunito(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      GFButton(
                                        onPressed: () async {
                                          Get.to(nt.BvnPage(
                                              email: userController.userModel!
                                                  .userDetails![0].email));
                                        },
                                        text: "  Begin Verification  ",
                                        fullWidthButton: false,
                                        color: brandOne,
                                        shape: GFButtonShape.pills,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      )
                    : SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Column(
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
                                  "$loadMssg$varValue",
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
                            const CustomLoader(),
                          ],
                        ),
                      )),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "You need to fund your Space Wallet to use this service.",
                    style: GoogleFonts.nunito(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 50),
                        backgroundColor: brandOne,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Get.to(const FundWallet());
                      },
                      child: Text(
                        'Fund Wallet',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  ListTile gloMethod(
      BuildContext context,
      TextFormField airtimePhone,
      TextFormField airtimeAmount,
      String? Function(dynamic pinOneValue) validatePin) {
    return ListTile(
      onTap: () {
        Get.bottomSheet(
          isDismissible: true,
          SingleChildScrollView(
            child: SizedBox(
              height: 500,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  color: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.asset(
                          "assets/utility/glo.jpg",
                          height: 80,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Recharge and get 1 SpacePoint!',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: airtimeFormKey,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Valid GLO Phone number",
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                airtimePhone,
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            airtimeAmount,
                            SizedBox(
                              height: 40.h,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            isDismissible: true,
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 350,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                                child: Container(
                                  color: Theme.of(context).canvasColor,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        'Enter PIN to Proceed',
                                        style: GoogleFonts.nunito(
                                            fontSize: 18,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w800),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Pinput(
                                        obscureText: true,
                                        defaultPinTheme: PinTheme(
                                          width: 50,
                                          height: 50,
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            color: brandOne,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: brandTwo, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        onCompleted: (String val) async {
                                          if (BCrypt.checkpw(
                                            _pinController.text
                                                .trim()
                                                .toString(),
                                            userController.userModel!
                                                .userDetails![0].wallet.pin,
                                          )) {
                                            _pinController.clear();
                                            Get.back();
                                            Get.back();
                                            setState(() {
                                              loadMssg = "Processing...";
                                              canLoad = false;
                                            });

                                            if (userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .wallet
                                                    .mainBalance >
                                                ((int.tryParse(
                                                    _airtimeAmountController
                                                        .text
                                                        .trim()))!)) {
                                              if (airtimeFormKey.currentState!
                                                  .validate()) {
                                                const String apiUrl =
                                                    'https://api.watupay.com/v1/watubill/vend';
                                                const String bearerToken =
                                                    'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                                final response =
                                                    await http.post(
                                                  Uri.parse(apiUrl),
                                                  headers: {
                                                    'Authorization':
                                                        'Bearer $bearerToken',
                                                    "Content-Type":
                                                        "application/json"
                                                  },
                                                  body: jsonEncode(<String,
                                                      String>{
                                                    "amount":
                                                        _airtimeAmountController
                                                            .text
                                                            .trim()
                                                            .toString(),
                                                    "channel": "bill-27",
                                                    "business_signature":
                                                        "a390960dfa37469d824ffe6cb80472f6",
                                                    "phone_number":
                                                        _airtimeNumberController
                                                            .text
                                                            .trim()
                                                            .toString(),
                                                    "ignore_duplicate": "1"
                                                  }),
                                                );

                                                if (response.statusCode ==
                                                    200) {
                                                  String authToken =
                                                      await GlobalService
                                                          .sharedPreferencesManager
                                                          .getAuthToken();
                                                  print(authToken);
                                                  try {
                                                    EasyLoading.show(
                                                      indicator:
                                                          const CustomLoader(),
                                                      maskType:
                                                          EasyLoadingMaskType
                                                              .black,
                                                      dismissOnTap: true,
                                                    );
                                                    final addUtility =
                                                        await http.post(
                                                      Uri.parse(AppConstants
                                                              .BASE_URL +
                                                          AppConstants
                                                              .ADD_UTILITY_HISTORY),
                                                      headers: {
                                                        'Authorization':
                                                            'Bearer $authToken',
                                                        "Content-Type":
                                                            "application/json"
                                                      },
                                                      body: jsonEncode(<String,
                                                          dynamic>{
                                                        "amount":
                                                            _airtimeAmountController
                                                                .text
                                                                .trim()
                                                                .toString(),
                                                        'biller': "GLO AIRTIME",
                                                        "transactionType":
                                                            "Airtime",
                                                        "description":
                                                            'Airtime Payment to ${_airtimeNumberController.text.trim().toString()}',
                                                      }),
                                                    );
                                                    print(addUtility);
                                                    print(addUtility.body);
                                                    EasyLoading.dismiss();
                                                  } on TimeoutException {
                                                    throw http.Response(
                                                        'Network Timeout', 500);
                                                  } on http
                                                  .ClientException catch (e) {
                                                    print(
                                                        'Error while getting data is $e');
                                                    throw http.Response(
                                                        'HTTP Client Exception: $e',
                                                        500);
                                                  } catch (e) {
                                                    print(e);
                                                    EasyLoading.dismiss();
                                                    customErrorDialog(
                                                        context,
                                                        "Oops",
                                                        'Something Went wrong. Try Again Later!');
                                                  } finally {
                                                    EasyLoading.dismiss();
                                                  }
                                                  setState(() {
                                                    canLoad = true;
                                                  });
                                                  _airtimeAmountController
                                                      .clear();
                                                  _airtimeNumberController
                                                      .clear();
                                                  _pinController.clear();
                                                  Get.to(FirstPage());
                                                  showTopSnackBar(
                                                    Overlay.of(context),
                                                    CustomSnackBar.success(
                                                      backgroundColor: brandOne,
                                                      message:
                                                          'You just earned a Space point!',
                                                      textStyle:
                                                          GoogleFonts.nunito(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  print(response.body);
                                                  setState(() {
                                                    canLoad = true;
                                                  });
                                                  // Error handling
                                                  _airtimeAmountController
                                                      .clear();
                                                  _airtimeNumberController
                                                      .clear();
                                                  _pinController.clear();

                                                  customErrorDialog(
                                                      context,
                                                      "Error",
                                                      "Try again later");
                                                }
                                              } else {
                                                setState(() {
                                                  canLoad = true;
                                                });
                                                customErrorDialog(
                                                    context,
                                                    "Incomplete",
                                                    "Fill the field correctly to proceed");
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        AlertDialog(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .fromLTRB(30,
                                                                  30, 30, 20),
                                                          elevation: 0,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          scrollable: true,
                                                          title: null,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              topRight: Radius
                                                                  .circular(30),
                                                            ),
                                                          ),
                                                          content: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          40),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                15),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                          child:
                                                                              Text(
                                                                            'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              color: brandOne,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(3),
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  Get.back();
                                                                                  Get.to(const FundWallet());
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                                                                  textStyle: const TextStyle(color: brandFour, fontSize: 13),
                                                                                ),
                                                                                child: const Text(
                                                                                  "Fund Wallet",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }
                                          } else {
                                            _pinController.clear();
                                            if (context.mounted) {
                                              customErrorDialog(
                                                  context,
                                                  "Invalid PIN",
                                                  'Enter correct PIN to proceed');
                                            }
                                          }
                                        },
                                        validator: validatePin,
                                        onChanged: validatePin,
                                        controller: _pinController,
                                        length: 4,
                                        closeKeyboardWhenCompleted: true,
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(300, 50),
                                          backgroundColor: brandOne,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (BCrypt.checkpw(
                                            _pinController.text
                                                .trim()
                                                .toString(),
                                            userController.userModel!
                                                .userDetails![0].wallet.pin,
                                          )) {
                                            _pinController.clear();
                                            Get.back();
                                            // _doWallet();
                                            Get.back();
                                            setState(() {
                                              loadMssg = "Processing...";
                                              canLoad = false;
                                            });

                                            if (airtimeFormKey.currentState!
                                                .validate()) {
                                              const String apiUrl =
                                                  'https://api.watupay.com/v1/watubill/vend';
                                              const String bearerToken =
                                                  'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                              final response = await http.post(
                                                Uri.parse(apiUrl),
                                                headers: {
                                                  'Authorization':
                                                      'Bearer $bearerToken',
                                                  "Content-Type":
                                                      "application/json"
                                                },
                                                body: jsonEncode(<String,
                                                    dynamic>{
                                                  "amount":
                                                      _airtimeAmountController
                                                          .text
                                                          .trim()
                                                          .toString(),
                                                  "channel": "bill-27",
                                                  "business_signature":
                                                      "a390960dfa37469d824ffe6cb80472f6",
                                                  "phone_number":
                                                      _airtimeNumberController
                                                          .text
                                                          .trim()
                                                          .toString(),
                                                  "ignore_duplicate": 1
                                                }),
                                              );

                                              if (response.statusCode == 200) {
                                                String authToken =
                                                    await GlobalService
                                                        .sharedPreferencesManager
                                                        .getAuthToken();
                                                print(authToken);
                                                try {
                                                  EasyLoading.show(
                                                    indicator:
                                                        const CustomLoader(),
                                                    maskType:
                                                        EasyLoadingMaskType
                                                            .black,
                                                    dismissOnTap: true,
                                                  );
                                                  final addUtility =
                                                      await http.post(
                                                    Uri.parse(AppConstants
                                                            .BASE_URL +
                                                        AppConstants
                                                            .ADD_UTILITY_HISTORY),
                                                    headers: {
                                                      'Authorization':
                                                          'Bearer $authToken',
                                                      "Content-Type":
                                                          "application/json"
                                                    },
                                                    body: jsonEncode(<String,
                                                        dynamic>{
                                                      "amount":
                                                          _airtimeAmountController
                                                              .text
                                                              .trim()
                                                              .toString(),
                                                      'biller': "GLO AIRTIME",
                                                      "transactionType":
                                                          "Airtime",
                                                      "description":
                                                          'Airtime Payment to ${_airtimeNumberController.text.trim().toString()}',
                                                    }),
                                                  );
                                                  print(addUtility);
                                                  print(addUtility.body);
                                                  EasyLoading.dismiss();
                                                } on TimeoutException {
                                                  throw http.Response(
                                                      'Network Timeout', 500);
                                                } on http
                                                .ClientException catch (e) {
                                                  print(
                                                      'Error while getting data is $e');
                                                  throw http.Response(
                                                      'HTTP Client Exception: $e',
                                                      500);
                                                } catch (e) {
                                                  print(e);
                                                  EasyLoading.dismiss();
                                                  customErrorDialog(
                                                      context,
                                                      "Oops",
                                                      'Something Went wrong. Try Again Later!');
                                                } finally {
                                                  EasyLoading.dismiss();
                                                }
                                                setState(() {
                                                  canLoad = true;
                                                });
                                                _airtimeAmountController
                                                    .clear();
                                                _airtimeNumberController
                                                    .clear();
                                                _pinController.clear();
                                                Get.to(FirstPage());
                                                showTopSnackBar(
                                                  Overlay.of(context),
                                                  CustomSnackBar.success(
                                                    backgroundColor: brandOne,
                                                    message:
                                                        'You just earned a Space point!',
                                                    textStyle:
                                                        GoogleFonts.nunito(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                print(response.body);
                                                setState(() {
                                                  canLoad = true;
                                                });
                                                // Error handling
                                                _airtimeAmountController
                                                    .clear();
                                                _airtimeNumberController
                                                    .clear();
                                                _pinController.clear();

                                                customErrorDialog(context,
                                                    "Error", "Try again later");
                                              }
                                            } else {
                                              setState(() {
                                                canLoad = true;
                                              });
                                              customErrorDialog(
                                                  context,
                                                  "Incomplete",
                                                  "Fill the field correctly to proceed");
                                            }
                                          } else {
                                            _pinController.clear();
                                            if (context.mounted) {
                                              customErrorDialog(
                                                  context,
                                                  "Invalid PIN",
                                                  'Enter correct PIN to proceed');
                                            }
                                          }
                                        },
                                        child: Text(
                                          'Proceed to Payment',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: brandOne,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Align(
                              child: Text(
                                'Pay',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
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
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.asset(
          "assets/utility/glo.jpg",
          height: 40,
          width: 40,
        ),
      ),
      leading: Text(
        'GLO airtime',
        style: GoogleFonts.nunito(
          color: Theme.of(context).canvasColor,
          fontSize: 15,
        ),
      ),
    );
  }

  ListTile airtelMethod(
      BuildContext context,
      TextFormField airtimePhone,
      TextFormField airtimeAmount,
      String? Function(dynamic pinOneValue) validatePin) {
    return ListTile(
      onTap: () {
        Get.bottomSheet(
          isDismissible: true,
          SingleChildScrollView(
            child: SizedBox(
              height: 500,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  color: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.asset(
                          "assets/utility/airtel.jpg",
                          height: 80,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Recharge and get 1 SpacePoint!',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: airtimeFormKey,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Valid AIRTEL Phone number",
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                airtimePhone,
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            airtimeAmount,
                            SizedBox(
                              height: 40.h,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            isDismissible: true,
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 350,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                                child: Container(
                                  color: Theme.of(context).canvasColor,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        'Enter PIN to Proceed',
                                        style: GoogleFonts.nunito(
                                            fontSize: 18,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w800),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Pinput(
                                        obscureText: true,
                                        defaultPinTheme: PinTheme(
                                          width: 50,
                                          height: 50,
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            color: brandOne,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: brandTwo, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        onCompleted: (String val) async {
                                          if (BCrypt.checkpw(
                                            _pinController.text
                                                .trim()
                                                .toString(),
                                            userController.userModel!
                                                .userDetails![0].wallet.pin,
                                          )) {
                                            _pinController.clear();
                                            Get.back();
                                            Get.back();
                                            setState(() {
                                              loadMssg = "Processing...";
                                              canLoad = false;
                                            });
                                            if (userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .wallet
                                                    .mainBalance >
                                                ((int.tryParse(
                                                    _airtimeAmountController
                                                        .text
                                                        .trim()))!)) {
                                              if (airtimeFormKey.currentState!
                                                  .validate()) {
                                                const String apiUrl =
                                                    'https://api.watupay.com/v1/watubill/vend';
                                                const String bearerToken =
                                                    'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                                final response =
                                                    await http.post(
                                                  Uri.parse(apiUrl),
                                                  headers: {
                                                    'Authorization':
                                                        'Bearer $bearerToken',
                                                    "Content-Type":
                                                        "application/json"
                                                  },
                                                  body: jsonEncode(<String,
                                                      dynamic>{
                                                    "amount":
                                                        _airtimeAmountController
                                                            .text
                                                            .trim()
                                                            .toString(),
                                                    "channel": "bill-28",
                                                    "business_signature":
                                                        "a390960dfa37469d824ffe6cb80472f6",
                                                    "phone_number":
                                                        _airtimeNumberController
                                                            .text
                                                            .trim()
                                                            .toString(),
                                                    "ignore_duplicate": "1"
                                                  }),
                                                );

                                                if (response.statusCode ==
                                                    200) {
                                                  String authToken =
                                                      await GlobalService
                                                          .sharedPreferencesManager
                                                          .getAuthToken();
                                                  print(authToken);
                                                  try {
                                                    EasyLoading.show(
                                                      indicator:
                                                          const CustomLoader(),
                                                      maskType:
                                                          EasyLoadingMaskType
                                                              .black,
                                                      dismissOnTap: true,
                                                    );
                                                    final addUtility =
                                                        await http.post(
                                                      Uri.parse(AppConstants
                                                              .BASE_URL +
                                                          AppConstants
                                                              .ADD_UTILITY_HISTORY),
                                                      headers: {
                                                        'Authorization':
                                                            'Bearer $authToken',
                                                        "Content-Type":
                                                            "application/json"
                                                      },
                                                      body: jsonEncode(<String,
                                                          dynamic>{
                                                        "amount":
                                                            _airtimeAmountController
                                                                .text
                                                                .trim()
                                                                .toString(),
                                                        'biller':
                                                            "AIRTEL AIRTIME",
                                                        "transactionType":
                                                            "Airtime",
                                                        "description":
                                                            'Airtime Payment to ${_airtimeNumberController.text.trim().toString()}',
                                                      }),
                                                    );
                                                    print(addUtility);
                                                    print(addUtility.body);
                                                    EasyLoading.dismiss();
                                                  } on TimeoutException {
                                                    throw http.Response(
                                                        'Network Timeout', 500);
                                                  } on http
                                                  .ClientException catch (e) {
                                                    print(
                                                        'Error while getting data is $e');
                                                    throw http.Response(
                                                        'HTTP Client Exception: $e',
                                                        500);
                                                  } catch (e) {
                                                    print(e);
                                                    EasyLoading.dismiss();
                                                    customErrorDialog(
                                                        context,
                                                        "Oops",
                                                        'Something Went wrong. Try Again Later!');
                                                  } finally {
                                                    EasyLoading.dismiss();
                                                  }
                                                  setState(() {
                                                    canLoad = true;
                                                  });
                                                  _airtimeAmountController
                                                      .clear();
                                                  _airtimeNumberController
                                                      .clear();
                                                  _pinController.clear();
                                                  Get.to(FirstPage());
                                                  showTopSnackBar(
                                                    Overlay.of(context),
                                                    CustomSnackBar.success(
                                                      backgroundColor: brandOne,
                                                      message:
                                                          'You just earned a Space point!',
                                                      textStyle:
                                                          GoogleFonts.nunito(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  print(response.body);
                                                  setState(() {
                                                    canLoad = true;
                                                  });
                                                  // Error handling
                                                  _airtimeAmountController
                                                      .clear();
                                                  _airtimeNumberController
                                                      .clear();
                                                  _pinController.clear();

                                                  customErrorDialog(
                                                      context,
                                                      "Error",
                                                      "Try again later");
                                                }
                                              } else {
                                                setState(() {
                                                  canLoad = true;
                                                });
                                                customErrorDialog(
                                                    context,
                                                    "Incomplete",
                                                    "Fill the field correctly to proceed");
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        AlertDialog(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .fromLTRB(30,
                                                                  30, 30, 20),
                                                          elevation: 0,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          scrollable: true,
                                                          title: null,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              topRight: Radius
                                                                  .circular(30),
                                                            ),
                                                          ),
                                                          content: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          40),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                15),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                          child:
                                                                              Text(
                                                                            'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              color: brandOne,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(3),
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  Get.back();
                                                                                  Get.to(const FundWallet());
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                                                                  textStyle: const TextStyle(color: brandFour, fontSize: 13),
                                                                                ),
                                                                                child: const Text(
                                                                                  "Fund Wallet",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }
                                          } else {
                                            _pinController.clear();
                                            if (context.mounted) {
                                              customErrorDialog(
                                                  context,
                                                  "Invalid PIN",
                                                  'Enter correct PIN to proceed');
                                            }
                                          }
                                        },
                                        validator: validatePin,
                                        onChanged: validatePin,
                                        controller: _pinController,
                                        length: 4,
                                        closeKeyboardWhenCompleted: true,
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(300, 50),
                                          backgroundColor: brandOne,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (BCrypt.checkpw(
                                            _pinController.text
                                                .trim()
                                                .toString(),
                                            userController.userModel!
                                                .userDetails![0].wallet.pin,
                                          )) {
                                            _pinController.clear();
                                            Get.back();
                                            // _doWallet();
                                            Get.back();
                                            setState(() {
                                              loadMssg = "Processing...";
                                              canLoad = false;
                                            });

                                            if (airtimeFormKey.currentState!
                                                .validate()) {
                                              const String apiUrl =
                                                  'https://api.watupay.com/v1/watubill/vend';
                                              const String bearerToken =
                                                  'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                              final response = await http.post(
                                                Uri.parse(apiUrl),
                                                headers: {
                                                  'Authorization':
                                                      'Bearer $bearerToken',
                                                  "Content-Type":
                                                      "application/json"
                                                },
                                                body: jsonEncode(<String,
                                                    dynamic>{
                                                  "amount":
                                                      _airtimeAmountController
                                                          .text
                                                          .trim()
                                                          .toString(),
                                                  "channel": "bill-28",
                                                  "business_signature":
                                                      "a390960dfa37469d824ffe6cb80472f6",
                                                  "phone_number":
                                                      _airtimeNumberController
                                                          .text
                                                          .trim()
                                                          .toString(),
                                                  "ignore_duplicate": 1
                                                }),
                                              );

                                              if (response.statusCode == 200) {
                                                String authToken =
                                                    await GlobalService
                                                        .sharedPreferencesManager
                                                        .getAuthToken();
                                                print(authToken);
                                                try {
                                                  EasyLoading.show(
                                                    indicator:
                                                        const CustomLoader(),
                                                    maskType:
                                                        EasyLoadingMaskType
                                                            .black,
                                                    dismissOnTap: true,
                                                  );
                                                  final addUtility =
                                                      await http.post(
                                                    Uri.parse(AppConstants
                                                            .BASE_URL +
                                                        AppConstants
                                                            .ADD_UTILITY_HISTORY),
                                                    headers: {
                                                      'Authorization':
                                                          'Bearer $authToken',
                                                      "Content-Type":
                                                          "application/json"
                                                    },
                                                    body: jsonEncode(<String,
                                                        dynamic>{
                                                      "amount":
                                                          _airtimeAmountController
                                                              .text
                                                              .trim()
                                                              .toString(),
                                                      'biller':
                                                          "AIRTEL AIRTIME",
                                                      "transactionType":
                                                          "Airtime",
                                                      "description":
                                                          'Airtime Payment to ${_airtimeNumberController.text.trim().toString()}',
                                                    }),
                                                  );
                                                  print(addUtility);
                                                  print(addUtility.body);
                                                  EasyLoading.dismiss();
                                                } on TimeoutException {
                                                  throw http.Response(
                                                      'Network Timeout', 500);
                                                } on http
                                                .ClientException catch (e) {
                                                  print(
                                                      'Error while getting data is $e');
                                                  throw http.Response(
                                                      'HTTP Client Exception: $e',
                                                      500);
                                                } catch (e) {
                                                  print(e);
                                                  EasyLoading.dismiss();
                                                  customErrorDialog(
                                                      context,
                                                      "Oops",
                                                      'Something Went wrong. Try Again Later!');
                                                } finally {
                                                  EasyLoading.dismiss();
                                                }
                                                setState(() {
                                                  canLoad = true;
                                                });
                                                _airtimeAmountController
                                                    .clear();
                                                _airtimeNumberController
                                                    .clear();
                                                _pinController.clear();
                                                Get.to(FirstPage());
                                                showTopSnackBar(
                                                  Overlay.of(context),
                                                  CustomSnackBar.success(
                                                    backgroundColor: brandOne,
                                                    message:
                                                        'You just earned a Space point!',
                                                    textStyle:
                                                        GoogleFonts.nunito(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                print(response.body);
                                                setState(() {
                                                  canLoad = true;
                                                });
                                                // Error handling
                                                _airtimeAmountController
                                                    .clear();
                                                _airtimeNumberController
                                                    .clear();
                                                _pinController.clear();

                                                customErrorDialog(context,
                                                    "Error", "Try again later");
                                              }
                                            } else {
                                              setState(() {
                                                canLoad = true;
                                              });
                                              customErrorDialog(
                                                  context,
                                                  "Incomplete",
                                                  "Fill the field correctly to proceed");
                                            }
                                          } else {
                                            _pinController.clear();
                                            if (context.mounted) {
                                              customErrorDialog(
                                                  context,
                                                  "Invalid PIN",
                                                  'Enter correct PIN to proceed');
                                            }
                                          }
                                        },
                                        child: Text(
                                          'Proceed to Payment',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: brandOne,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Align(
                              child: Text(
                                'Pay',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
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
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.asset(
          "assets/utility/airtel.jpg",
          height: 40,
          width: 40,
        ),
      ),
      leading: Text(
        'Airtel airtime',
        style: GoogleFonts.nunito(
          color: Theme.of(context).canvasColor,
          fontSize: 15,
        ),
      ),
    );
  }

  ListTile etisalatMethod(
      BuildContext context,
      TextFormField airtimePhone,
      TextFormField airtimeAmount,
      String? Function(dynamic pinOneValue) validatePin) {
    return ListTile(
      onTap: () {
        Get.bottomSheet(
          isDismissible: true,
          SingleChildScrollView(
            child: SizedBox(
              height: 500,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  color: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.asset(
                          "assets/utility/9mobile.jpg",
                          height: 80,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Recharge and get 1 SpacePoint!',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: airtimeFormKey,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Valid 9MOBILE Phone number",
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                airtimePhone,
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            airtimeAmount,
                            SizedBox(
                              height: 40.h,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            isDismissible: true,
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 350,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                                child: Container(
                                  color: Theme.of(context).canvasColor,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        'Enter PIN to Proceed',
                                        style: GoogleFonts.nunito(
                                            fontSize: 18,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w800),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Pinput(
                                        obscureText: true,
                                        defaultPinTheme: PinTheme(
                                          width: 50,
                                          height: 50,
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            color: brandOne,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: brandTwo, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        onCompleted: (String val) async {
                                          if (BCrypt.checkpw(
                                            _pinController.text
                                                .trim()
                                                .toString(),
                                            userController.userModel!
                                                .userDetails![0].wallet.pin,
                                          )) {
                                            _pinController.clear();
                                            Get.back();
                                            Get.back();
                                            setState(() {
                                              loadMssg = "Processing...";
                                              canLoad = false;
                                            });
                                            if (userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .wallet
                                                    .mainBalance >
                                                ((int.tryParse(
                                                    _airtimeAmountController
                                                        .text
                                                        .trim()))!)) {
                                              if (airtimeFormKey.currentState!
                                                  .validate()) {
                                                const String apiUrl =
                                                    'https://api.watupay.com/v1/watubill/vend';
                                                const String bearerToken =
                                                    'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                                final response =
                                                    await http.post(
                                                  Uri.parse(apiUrl),
                                                  headers: {
                                                    'Authorization':
                                                        'Bearer $bearerToken',
                                                    "Content-Type":
                                                        "application/json"
                                                  },
                                                  body: jsonEncode(<String,
                                                      dynamic>{
                                                    "amount":
                                                        _airtimeAmountController
                                                            .text
                                                            .trim()
                                                            .toString(),
                                                    "channel": "bill-26",
                                                    "business_signature":
                                                        "a390960dfa37469d824ffe6cb80472f6",
                                                    "phone_number":
                                                        _airtimeNumberController
                                                            .text
                                                            .trim()
                                                            .toString(),
                                                    "ignore_duplicate": 1
                                                  }),
                                                );

                                                if (response.statusCode ==
                                                    200) {
                                                  String authToken =
                                                      await GlobalService
                                                          .sharedPreferencesManager
                                                          .getAuthToken();
                                                  print(authToken);
                                                  try {
                                                    EasyLoading.show(
                                                      indicator:
                                                          const CustomLoader(),
                                                      maskType:
                                                          EasyLoadingMaskType
                                                              .black,
                                                      dismissOnTap: true,
                                                    );
                                                    final addUtility =
                                                        await http.post(
                                                      Uri.parse(AppConstants
                                                              .BASE_URL +
                                                          AppConstants
                                                              .ADD_UTILITY_HISTORY),
                                                      headers: {
                                                        'Authorization':
                                                            'Bearer $authToken',
                                                        "Content-Type":
                                                            "application/json"
                                                      },
                                                      body: jsonEncode(<String,
                                                          dynamic>{
                                                        "amount":
                                                            _airtimeAmountController
                                                                .text
                                                                .trim()
                                                                .toString(),
                                                        'biller':
                                                            "9MOBILE AIRTIME",
                                                        "transactionType":
                                                            "Airtime",
                                                        "description":
                                                            'Airtime Payment to ${_airtimeNumberController.text.trim().toString()}',
                                                      }),
                                                    );
                                                    print(addUtility);
                                                    print(addUtility.body);
                                                    EasyLoading.dismiss();
                                                  } on TimeoutException {
                                                    throw http.Response(
                                                        'Network Timeout', 500);
                                                  } on http
                                                  .ClientException catch (e) {
                                                    print(
                                                        'Error while getting data is $e');
                                                    throw http.Response(
                                                        'HTTP Client Exception: $e',
                                                        500);
                                                  } catch (e) {
                                                    print(e);
                                                    EasyLoading.dismiss();
                                                    customErrorDialog(
                                                        context,
                                                        "Oops",
                                                        'Something Went wrong. Try Again Later!');
                                                  } finally {
                                                    EasyLoading.dismiss();
                                                  }
                                                  setState(() {
                                                    canLoad = true;
                                                  });
                                                  _airtimeAmountController
                                                      .clear();
                                                  _airtimeNumberController
                                                      .clear();
                                                  _pinController.clear();
                                                  Get.to(FirstPage());
                                                  showTopSnackBar(
                                                    Overlay.of(context),
                                                    CustomSnackBar.success(
                                                      backgroundColor: brandOne,
                                                      message:
                                                          'You just earned a Space point!',
                                                      textStyle:
                                                          GoogleFonts.nunito(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  print(response.body);
                                                  setState(() {
                                                    canLoad = true;
                                                  });
                                                  // Error handling
                                                  _airtimeAmountController
                                                      .clear();
                                                  _airtimeNumberController
                                                      .clear();
                                                  _pinController.clear();

                                                  customErrorDialog(
                                                      context,
                                                      "Error",
                                                      "Try again later");
                                                }
                                              } else {
                                                setState(() {
                                                  canLoad = true;
                                                });
                                                customErrorDialog(
                                                    context,
                                                    "Incomplete",
                                                    "Fill the field correctly to proceed");
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        AlertDialog(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .fromLTRB(30,
                                                                  30, 30, 20),
                                                          elevation: 0,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          scrollable: true,
                                                          title: null,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              topRight: Radius
                                                                  .circular(30),
                                                            ),
                                                          ),
                                                          content: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          40),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                15),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                          child:
                                                                              Text(
                                                                            'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              color: brandOne,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(3),
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  Get.back();
                                                                                  Get.to(const FundWallet());
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                                                                  textStyle: const TextStyle(color: brandFour, fontSize: 13),
                                                                                ),
                                                                                child: const Text(
                                                                                  "Fund Wallet",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }
                                          } else {
                                            _pinController.clear();
                                            if (context.mounted) {
                                              customErrorDialog(
                                                  context,
                                                  "Invalid PIN",
                                                  'Enter correct PIN to proceed');
                                            }
                                          }
                                        },
                                        validator: validatePin,
                                        onChanged: validatePin,
                                        controller: _pinController,
                                        length: 4,
                                        closeKeyboardWhenCompleted: true,
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(300, 50),
                                          backgroundColor: brandOne,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (BCrypt.checkpw(
                                            _pinController.text
                                                .trim()
                                                .toString(),
                                            userController.userModel!
                                                .userDetails![0].wallet.pin,
                                          )) {
                                            _pinController.clear();
                                            Get.back();
                                            // _doWallet();
                                            Get.back();
                                            setState(() {
                                              loadMssg = "Processing...";
                                              canLoad = false;
                                            });

                                            if (airtimeFormKey.currentState!
                                                .validate()) {
                                              const String apiUrl =
                                                  'https://api.watupay.com/v1/watubill/vend';
                                              const String bearerToken =
                                                  'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                              final response = await http.post(
                                                Uri.parse(apiUrl),
                                                headers: {
                                                  'Authorization':
                                                      'Bearer $bearerToken',
                                                  "Content-Type":
                                                      "application/json"
                                                },
                                                body: jsonEncode(<String,
                                                    dynamic>{
                                                  "amount":
                                                      _airtimeAmountController
                                                          .text
                                                          .trim()
                                                          .toString(),
                                                  "channel": "bill-26",
                                                  "business_signature":
                                                      "a390960dfa37469d824ffe6cb80472f6",
                                                  "phone_number":
                                                      _airtimeNumberController
                                                          .text
                                                          .trim()
                                                          .toString(),
                                                  "ignore_duplicate": 1
                                                }),
                                              );

                                              if (response.statusCode == 200) {
                                                String authToken =
                                                    await GlobalService
                                                        .sharedPreferencesManager
                                                        .getAuthToken();
                                                print(authToken);
                                                try {
                                                  EasyLoading.show(
                                                    indicator:
                                                        const CustomLoader(),
                                                    maskType:
                                                        EasyLoadingMaskType
                                                            .black,
                                                    dismissOnTap: true,
                                                  );
                                                  final addUtility =
                                                      await http.post(
                                                    Uri.parse(AppConstants
                                                            .BASE_URL +
                                                        AppConstants
                                                            .ADD_UTILITY_HISTORY),
                                                    headers: {
                                                      'Authorization':
                                                          'Bearer $authToken',
                                                      "Content-Type":
                                                          "application/json"
                                                    },
                                                    body: jsonEncode(<String,
                                                        dynamic>{
                                                      "amount":
                                                          _airtimeAmountController
                                                              .text
                                                              .trim()
                                                              .toString(),
                                                      'biller':
                                                          "9MOBILE AIRTIME",
                                                      "transactionType":
                                                          "Airtime",
                                                      "description":
                                                          'Airtime Payment to ${_airtimeNumberController.text.trim().toString()}',
                                                    }),
                                                  );
                                                  print(addUtility);
                                                  print(addUtility.body);
                                                  EasyLoading.dismiss();
                                                } on TimeoutException {
                                                  throw http.Response(
                                                      'Network Timeout', 500);
                                                } on http
                                                .ClientException catch (e) {
                                                  print(
                                                      'Error while getting data is $e');
                                                  throw http.Response(
                                                      'HTTP Client Exception: $e',
                                                      500);
                                                } catch (e) {
                                                  print(e);
                                                  EasyLoading.dismiss();
                                                  customErrorDialog(
                                                      context,
                                                      "Oops",
                                                      'Something Went wrong. Try Again Later!');
                                                } finally {
                                                  EasyLoading.dismiss();
                                                }
                                                setState(() {
                                                  canLoad = true;
                                                });
                                                _airtimeAmountController
                                                    .clear();
                                                _airtimeNumberController
                                                    .clear();
                                                _pinController.clear();
                                                Get.to(FirstPage());
                                                showTopSnackBar(
                                                  Overlay.of(context),
                                                  CustomSnackBar.success(
                                                    backgroundColor: brandOne,
                                                    message:
                                                        'You just earned a Space point!',
                                                    textStyle:
                                                        GoogleFonts.nunito(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                print(response.body);
                                                setState(() {
                                                  canLoad = true;
                                                });
                                                // Error handling
                                                _airtimeAmountController
                                                    .clear();
                                                _airtimeNumberController
                                                    .clear();
                                                _pinController.clear();

                                                customErrorDialog(context,
                                                    "Error", "Try again later");
                                              }
                                            } else {
                                              setState(() {
                                                canLoad = true;
                                              });
                                              customErrorDialog(
                                                  context,
                                                  "Incomplete",
                                                  "Fill the field correctly to proceed");
                                            }
                                          } else {
                                            _pinController.clear();
                                            if (context.mounted) {
                                              customErrorDialog(
                                                  context,
                                                  "Invalid PIN",
                                                  'Enter correct PIN to proceed');
                                            }
                                          }
                                        },
                                        child: Text(
                                          'Proceed to Payment',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: brandOne,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Align(
                              child: Text(
                                'Pay',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
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
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.asset(
          "assets/utility/9mobile.jpg",
          height: 40,
          width: 40,
        ),
      ),
      leading: Text(
        '9Mobile airtime',
        style: GoogleFonts.nunito(
          color: Theme.of(context).canvasColor,
          fontSize: 15,
        ),
      ),
    );
  }

  ListTile mtnAirtimeMethod(
      BuildContext context,
      TextFormField airtimePhone,
      TextFormField airtimeAmount,
      String? Function(dynamic pinOneValue) validatePin) {
    return ListTile(
      onTap: () {
        Get.bottomSheet(
          isDismissible: true,
          SingleChildScrollView(
            child: SizedBox(
              height: 500.h,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  color: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.asset(
                          "assets/utility/mtn.jpg",
                          height: 80,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Recharge and get 1 SpacePoint!',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: airtimeFormKey,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Valid MTN Phone number",
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                airtimePhone,
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            airtimeAmount,
                            SizedBox(
                              height: 40.h,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            isDismissible: true,
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 350,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                                child: Container(
                                  color: Theme.of(context).canvasColor,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        'Enter PIN to Proceed',
                                        style: GoogleFonts.nunito(
                                            fontSize: 18,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w800),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Pinput(
                                        obscureText: true,
                                        defaultPinTheme: PinTheme(
                                          width: 50,
                                          height: 50,
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            color: brandOne,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: brandTwo, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        onCompleted: (String val) async {
                                          if (BCrypt.checkpw(
                                            _pinController.text
                                                .trim()
                                                .toString(),
                                            userController.userModel!
                                                .userDetails![0].wallet.pin,
                                          )) {
                                            _pinController.clear();
                                            Get.back();
                                            Get.back();
                                            setState(() {
                                              loadMssg = "Processing...";
                                              canLoad = false;
                                            });

                                            if (userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .wallet
                                                    .mainBalance >
                                                ((int.tryParse(
                                                    _airtimeAmountController
                                                        .text
                                                        .trim()))!)) {
                                              if (airtimeFormKey.currentState!
                                                  .validate()) {
                                                const String apiUrl =
                                                    'https://api.watupay.com/v1/watubill/vend';
                                                const String bearerToken =
                                                    'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                                final response =
                                                    await http.post(
                                                  Uri.parse(apiUrl),
                                                  headers: {
                                                    'Authorization':
                                                        'Bearer $bearerToken',
                                                    "Content-Type":
                                                        "application/json"
                                                  },
                                                  body: jsonEncode(<String,
                                                      dynamic>{
                                                    "amount":
                                                        _airtimeAmountController
                                                            .text
                                                            .trim()
                                                            .toString(),
                                                    "channel": "bill-25",
                                                    "business_signature":
                                                        "a390960dfa37469d824ffe6cb80472f6",
                                                    "phone_number":
                                                        _airtimeNumberController
                                                            .text
                                                            .trim()
                                                            .toString(),
                                                    "ignore_duplicate": 1
                                                  }),
                                                );

                                                if (response.statusCode ==
                                                    200) {
                                                  String authToken =
                                                      await GlobalService
                                                          .sharedPreferencesManager
                                                          .getAuthToken();
                                                  print(authToken);
                                                  try {
                                                    EasyLoading.show(
                                                      indicator:
                                                          const CustomLoader(),
                                                      maskType:
                                                          EasyLoadingMaskType
                                                              .black,
                                                      dismissOnTap: true,
                                                    );
                                                    final addUtility =
                                                        await http.post(
                                                      Uri.parse(AppConstants
                                                              .BASE_URL +
                                                          AppConstants
                                                              .ADD_UTILITY_HISTORY),
                                                      headers: {
                                                        'Authorization':
                                                            'Bearer $authToken',
                                                        "Content-Type":
                                                            "application/json"
                                                      },
                                                      body: jsonEncode(<String,
                                                          dynamic>{
                                                        "amount":
                                                            _airtimeAmountController
                                                                .text
                                                                .trim()
                                                                .toString(),
                                                        'biller': "MTN AIRTIME",
                                                        "transactionType":
                                                            "Airtime",
                                                        "description":
                                                            'Airtime Payment to ${_airtimeNumberController.text.trim().toString()}',
                                                      }),
                                                    );
                                                    print(addUtility);
                                                    print(addUtility.body);
                                                    EasyLoading.dismiss();
                                                  } on TimeoutException {
                                                    throw http.Response(
                                                        'Network Timeout', 500);
                                                  } on http
                                                  .ClientException catch (e) {
                                                    print(
                                                        'Error while getting data is $e');
                                                    throw http.Response(
                                                        'HTTP Client Exception: $e',
                                                        500);
                                                  } catch (e) {
                                                    print(e);
                                                    EasyLoading.dismiss();
                                                    customErrorDialog(
                                                        context,
                                                        "Oops",
                                                        'Something Went wrong. Try Again Later!');
                                                  } finally {
                                                    EasyLoading.dismiss();
                                                  }

                                                  setState(() {
                                                    canLoad = true;
                                                  });
                                                  _airtimeAmountController
                                                      .clear();
                                                  _airtimeNumberController
                                                      .clear();
                                                  _pinController.clear();
                                                  Get.to(FirstPage());
                                                  showTopSnackBar(
                                                    Overlay.of(context),
                                                    CustomSnackBar.success(
                                                      backgroundColor: brandOne,
                                                      message:
                                                          'You just earned a Space point!',
                                                      textStyle:
                                                          GoogleFonts.nunito(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  print(response.body);
                                                  setState(() {
                                                    canLoad = true;
                                                  });
                                                  // Error handling
                                                  _airtimeAmountController
                                                      .clear();
                                                  _airtimeNumberController
                                                      .clear();
                                                  _pinController.clear();

                                                  customErrorDialog(
                                                      context,
                                                      "Error",
                                                      "Try again later");
                                                }
                                              } else {
                                                setState(() {
                                                  canLoad = true;
                                                });
                                                customErrorDialog(
                                                    context,
                                                    "Incomplete",
                                                    "Fill the field correctly to proceed");
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        AlertDialog(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .fromLTRB(30,
                                                                  30, 30, 20),
                                                          elevation: 0,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          scrollable: true,
                                                          title: null,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              topRight: Radius
                                                                  .circular(30),
                                                            ),
                                                          ),
                                                          content: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          40),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                15),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                          child:
                                                                              Text(
                                                                            'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              color: brandOne,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(3),
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  Get.back();
                                                                                  Get.to(const FundWallet());
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                                                                  textStyle: const TextStyle(color: brandFour, fontSize: 13),
                                                                                ),
                                                                                child: const Text(
                                                                                  "Fund Wallet",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }
                                          } else {
                                            _pinController.clear();
                                            if (context.mounted) {
                                              customErrorDialog(
                                                  context,
                                                  "Invalid PIN",
                                                  'Enter correct PIN to proceed');
                                            }
                                          }
                                        },
                                        validator: validatePin,
                                        onChanged: validatePin,
                                        controller: _pinController,
                                        length: 4,
                                        closeKeyboardWhenCompleted: true,
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(300, 50),
                                          backgroundColor: brandOne,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (BCrypt.checkpw(
                                            _pinController.text
                                                .trim()
                                                .toString(),
                                            userController.userModel!
                                                .userDetails![0].wallet.pin,
                                          )) {
                                            _pinController.clear();
                                            Get.back();
                                            // _doWallet();
                                            Get.back();
                                            setState(() {
                                              loadMssg = "Processing...";
                                              canLoad = false;
                                            });

                                            if (airtimeFormKey.currentState!
                                                .validate()) {
                                              const String apiUrl =
                                                  'https://api.watupay.com/v1/watubill/vend';
                                              const String bearerToken =
                                                  'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                              final response = await http.post(
                                                Uri.parse(apiUrl),
                                                headers: {
                                                  'Authorization':
                                                      'Bearer $bearerToken',
                                                  "Content-Type":
                                                      "application/json"
                                                },
                                                body: jsonEncode(<String,
                                                    dynamic>{
                                                  "amount":
                                                      _airtimeAmountController
                                                          .text
                                                          .trim()
                                                          .toString(),
                                                  "channel": "bill-25",
                                                  "business_signature":
                                                      "a390960dfa37469d824ffe6cb80472f6",
                                                  "phone_number":
                                                      _airtimeNumberController
                                                          .text
                                                          .trim()
                                                          .toString(),
                                                  "ignore_duplicate": 1
                                                }),
                                              );

                                              if (response.statusCode == 200) {
                                                String authToken =
                                                    await GlobalService
                                                        .sharedPreferencesManager
                                                        .getAuthToken();
                                                print(authToken);
                                                try {
                                                  EasyLoading.show(
                                                    indicator:
                                                        const CustomLoader(),
                                                    maskType:
                                                        EasyLoadingMaskType
                                                            .black,
                                                    dismissOnTap: true,
                                                  );
                                                  final addUtility =
                                                      await http.post(
                                                    Uri.parse(AppConstants
                                                            .BASE_URL +
                                                        AppConstants
                                                            .ADD_UTILITY_HISTORY),
                                                    headers: {
                                                      'Authorization':
                                                          'Bearer $authToken',
                                                      "Content-Type":
                                                          "application/json"
                                                    },
                                                    body: jsonEncode(<String,
                                                        dynamic>{
                                                      "amount":
                                                          _airtimeAmountController
                                                              .text
                                                              .trim()
                                                              .toString(),
                                                      'biller': "MTN AIRTIME",
                                                      "transactionType":
                                                          "Airtime",
                                                      "description":
                                                          'Airtime Payment to ${_airtimeNumberController.text.trim().toString()}',
                                                    }),
                                                  );
                                                  print(addUtility);
                                                  print(addUtility.body);
                                                  EasyLoading.dismiss();
                                                } on TimeoutException {
                                                  throw http.Response(
                                                      'Network Timeout', 500);
                                                } on http
                                                .ClientException catch (e) {
                                                  print(
                                                      'Error while getting data is $e');
                                                  throw http.Response(
                                                      'HTTP Client Exception: $e',
                                                      500);
                                                } catch (e) {
                                                  print(e);
                                                  EasyLoading.dismiss();
                                                  customErrorDialog(
                                                      context,
                                                      "Oops",
                                                      'Something Went wrong. Try Again Later!');
                                                } finally {
                                                  EasyLoading.dismiss();
                                                }

                                                setState(() {
                                                  canLoad = true;
                                                });
                                                _airtimeAmountController
                                                    .clear();
                                                _airtimeNumberController
                                                    .clear();
                                                _pinController.clear();
                                                Get.to(FirstPage());
                                                showTopSnackBar(
                                                  Overlay.of(context),
                                                  CustomSnackBar.success(
                                                    backgroundColor: brandOne,
                                                    message:
                                                        'You just earned a Space point!',
                                                    textStyle:
                                                        GoogleFonts.nunito(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                print(response.body);
                                                setState(() {
                                                  canLoad = true;
                                                });
                                                // Error handling
                                                _airtimeAmountController
                                                    .clear();
                                                _airtimeNumberController
                                                    .clear();
                                                _pinController.clear();

                                                customErrorDialog(context,
                                                    "Error", "Try again later");
                                              }
                                            } else {
                                              setState(() {
                                                canLoad = true;
                                              });
                                              customErrorDialog(
                                                  context,
                                                  "Incomplete",
                                                  "Fill the field correctly to proceed");
                                            }
                                          } else {
                                            _pinController.clear();
                                            if (context.mounted) {
                                              customErrorDialog(
                                                  context,
                                                  "Invalid PIN",
                                                  'Enter correct PIN to proceed');
                                            }
                                          }
                                        },
                                        child: Text(
                                          'Proceed to Payment',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: brandOne,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Align(
                              child: Text(
                                'Pay',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
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
        style: GoogleFonts.nunito(
          color: Theme.of(context).canvasColor,
          fontSize: 15,
        ),
      ),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.asset(
          "assets/utility/mtn.jpg",
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}
