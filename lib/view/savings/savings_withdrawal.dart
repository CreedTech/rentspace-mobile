// ignore_for_file: use_build_context_synchronously

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/constants/app_constants.dart';
import 'package:rentspace/constants/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/controller/wallet_controller.dart';
// import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/view/actions/onboarding_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../api/global_services.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';

class WalletWithdrawal extends StatefulWidget {
  const WalletWithdrawal({Key? key}) : super(key: key);

  @override
  _WalletWithdrawalState createState() => _WalletWithdrawalState();
}

var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
bool notLoading = true;

class _WalletWithdrawalState extends State<WalletWithdrawal> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _aPinController = TextEditingController();
  final withdrawFormKey = GlobalKey<FormState>();

  String liquidateReason = "I have an emergency";
  var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
  // String walletID = "";
  // String userID = "";
  String? selectedItem;
  String sourceName = "";
  // String uId = "";
  // String walletBalance = "0";
  String accountToUse = "0";
  List<String> _bankName = [];
  String _currentBankName = 'Select bank';
  String _currentBankCode = '';

  List<String> _bankCode = [];
  bool canShowOption = false;
  bool isChecking = false;
  String _bankAccountName = "";

  getAccountDetails(String currentCode) async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken here');
    print(authToken);
    setState(() {
      isChecking = true;
      _bankAccountName = "";
    });
    // const String apiUrl = 'https://api-d.squadco.com/payout/account/lookup';
    // const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';
    final response = await http.post(
        Uri.parse(AppConstants.BASE_URL + AppConstants.VERFIY_ACCOUNT_DETAILS),
        headers: {
          'Authorization': 'Bearer $authToken',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "financial_institution": currentCode,
          "account_id": _accountNumberController.text.trim().toString()
        })

        //   jsonEncode(<String, String>{
        //     "financial_institution": _currentBankName,
        //     "account_id": _accountNumberController.text.trim().toString(),
        //   }),
        );
    print(currentCode);
    print(_accountNumberController.text.trim().toString());

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse['account'][0]['bank']);
      final userBankName = jsonResponse['account'][0]["account_name"];
      if (userBankName != null) {
        setState(() {
          _bankAccountName = userBankName;
          isChecking = false;
        });
      } else {
        // Error handling
        setState(() {
          _bankAccountName = "";
          isChecking = false;
        });
        if (context.mounted) {
          customErrorDialog(context, 'Error!', "Invalid account number");
        }
      }

      //print(response.body);
    } else {
      // Error handling
      setState(() {
        _bankAccountName = "";
        isChecking = false;
      });
      if (context.mounted) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: null,
                elevation: 0,
                content: SizedBox(
                  height: 250,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              // color: brandOne,
                            ),
                            child: const Icon(
                              Iconsax.close_circle,
                              color: brandOne,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Iconsax.warning_24,
                          color: Colors.red,
                          size: 75,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Error!',
                        style: GoogleFonts.nunito(
                          color: Colors.red,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Something went wrong",
                        textAlign: TextAlign.center,
                        style:
                            GoogleFonts.nunito(color: brandOne, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            });
      }

      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  getBanksList() async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken here');
    print(authToken);
    // const String bankApiUrl =
    // 'https://api.watupay.com/v1/country/NG/financial-institutions';
    // const String bearerToken = 'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
    final response = await http.get(
      Uri.parse(AppConstants.BASE_URL + AppConstants.GET_BANKS_LIST),
      headers: {
        'Authorization': 'Bearer $authToken',
        "Content-Type": "application/json"
      },
    );
    print('response');
    // print(response);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('jsonResponse');
      // print(jsonResponse);
      List<String> tempName = [];
      List<String> tempCode = [];
      tempName.add("Select bank");
      for (var item in jsonResponse['banks']) {
        String localCode = item['local_code'] ?? 'N/A';
        // print('localCode');
        // print(localCode);
        String name = item['name'];
        if (localCode != "N/A") {
          tempName.add(name);
          tempCode.add(localCode);
        }
      }
      setState(() {
        _bankName = tempName;
        _bankCode = tempCode;
      });

      // print(_bankName);
      // print('_bankCode');
      // print(_bankCode);
      setState(() {
        canShowOption = true;
      });
    } else {
      print('Failed to load data from the server');
    }
  }

  final _chars = '1234567890';
  final Random _rnd = Random();
  final String _payUrl = "";
  String getRandom(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  // getCurrentUser() async {
  //   var collection = FirebaseFirestore.instance.collection('accounts');
  //   var docSnapshot = await collection.doc(userId).get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     setState(() {
  //       walletID = data?['wallet_id'];
  //       userID = data?['rentspace_id'];
  //       walletBalance = data?['wallet_balance'];
  //       uId = data?['id'];
  //     });
  //   }
  // }

  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  initState() {
    super.initState();
    notLoading = true;
    // getCurrentUser();
    getBanksList();
    //   final String passwordHashed = BCrypt.hashpw(
    //   '7679',
    //   BCrypt.gensalt(),
    // );
    // var word = "\$2b\$10\$XmGXD6mydlXp8zRdJXcba.Htb3OB1Suo9qJay4P/amCu93MNX.jkS";
    // print(passwordHashed);
    //   final bool checkPassword = BCrypt.checkpw(
    //   '7679',
    //   "\$2b\$10\$Mj7bACy9tx2bjXzqjChupugfnpSZzPuIkVG1TD3MFgvnL/O.1lLmK",
    // );
    //   print(checkPassword);
  }

  void _doWallet() async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken here');
    print(authToken);
    setState(() {
      notLoading = false;
    });
    Timer(const Duration(seconds: 1), () {
      _btnController.stop();
    });
    // var updateLiquidate = FirebaseFirestore.instance.collection('liquidation');
    const String apiUrl = 'https://api-d.squadco.com/payout/transfer';
    const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';

    final response = await http.post(
      Uri.parse(AppConstants.BASE_URL + AppConstants.WALLET_WITHDRAWAL),
      headers: {
        'Authorization': 'Bearer $authToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, dynamic>{
        // "remark": "SpaceWallet Withdrawal",
        "bank_code": _currentBankCode,
        // "currency_id": "NGN",
        "amount":
            double.tryParse(_amountController.text.trim().replaceAll(',', '')),
        "accountNumber": _accountNumberController.text.trim().toString(),
        // "transaction_reference": "C6NZ61CS_${getRandom(11)}",
        // "account_name": _bankAccountName,
      }),
    );

    if (response.statusCode == 200) {
      // await updateLiquidate.add({
      //   'user_id': userID,
      //   'date': formattedDate,
      //   'amount': _amountController.text.trim(),
      //   'reason': liquidateReason,
      //   'name': 'SpaceWallet Withdrawal',
      //   'charges': '20',
      //   'bank_name': _currentBankName,
      //   'status': 'success',
      //   'trans_id': getRandom(10),
      //   'id': uId,
      //   'account_number': _accountNumberController.text.trim(),
      //   'account_name': _bankAccountName,
      //   'withdrawal_location': "Bank",
      //   'liquidation_source': "Space Wallet"
      // }).then((value) async {
      //   var walletUpdate = FirebaseFirestore.instance.collection('accounts');
      //   await walletUpdate.doc(userId).update({
      //     'wallet_balance': (walletController.wallet[0].wallet.mainBalance -
      //             ((int.tryParse(_amountController.text.trim().toString()))! +
      //                 20))
      //         .toString(),
      //     "activities": FieldValue.arrayUnion(
      //       [
      //         "$formattedDate \nBank Withdrawal\n${nairaFormaet.format(double.tryParse(_amountController.text.trim()))} from SpaceWallet",
      //       ],
      //     ),
      //   });
      //   setState(() {
      //     notLoading = true;
      //   });
      //   Get.back();
      //   showTopSnackBar(
      //     Overlay.of(context),
      //     CustomSnackBar.success(
      //       backgroundColor: brandOne,
      //       message: 'Wallet withdrawal successful.',
      //       textStyle: GoogleFonts.nunito(
      //         fontSize: 14,
      //         color: Colors.white,
      //         fontWeight: FontWeight.w700,
      //       ),
      //     ),
      //   );

      // }).catchError((error) {
      //   setState(() {
      //     notLoading = true;
      //   });
      //   if (context.mounted) {
      //     showDialog(
      //         context: context,
      //         barrierDismissible: false,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10),
      //             ),
      //             title: null,
      //             elevation: 0,
      //             content: SizedBox(
      //               height: 250,
      //               child: Column(
      //                 children: [
      //                   GestureDetector(
      //                     onTap: () {
      //                       Navigator.of(context).pop();
      //                     },
      //                     child: Align(
      //                       alignment: Alignment.topRight,
      //                       child: Container(
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(30),
      //                           // color: brandOne,
      //                         ),
      //                         child: const Icon(
      //                           Iconsax.close_circle,
      //                           color: brandOne,
      //                           size: 30,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                   const Align(
      //                     alignment: Alignment.center,
      //                     child: Icon(
      //                       Iconsax.warning_24,
      //                       color: Colors.red,
      //                       size: 75,
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     height: 12,
      //                   ),
      //                   Text(
      //                     'Oops',
      //                     style: GoogleFonts.nunito(
      //                       color: Colors.red,
      //                       fontSize: 28,
      //                       fontWeight: FontWeight.w800,
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     height: 5,
      //                   ),
      //                   Text(
      //                     "Something went wrong, try again later",
      //                     textAlign: TextAlign.center,
      //                     style:
      //                         GoogleFonts.nunito(color: brandOne, fontSize: 18),
      //                   ),
      //                   const SizedBox(
      //                     height: 10,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           );
      //         });
      //   }
      // });
    } else {
      if (context.mounted) {
        customErrorDialog(context, 'Error', 'Something went wrong');
      }
      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    validateAmount(amountValue) {
      if (amountValue.isEmpty) {
        return 'amount cannot be empty';
      }
      if (int.tryParse(amountValue) == null) {
        return 'enter valid number';
      }
      if (int.tryParse(amountValue)!.isNegative) {
        return 'enter valid number';
      }
      if (int.tryParse(amountValue)! >
          walletController.walletModel!.wallet![0].mainBalance - 20) {
        return 'you cannot transfer more than your balance';
      }
      return null;
    }

    validateNumber(accountValue) {
      if (accountValue.isEmpty) {
        return 'account number cannot be empty';
      }
      if (accountValue.length < 10) {
        return 'account number is invalid';
      }
      if (int.tryParse(accountValue) == null) {
        return 'enter valid account number';
      }
      return null;
    }

    validateName(nameValue) {
      if (nameValue.isEmpty) {
        return 'account name cannot be empty';
      }

      return null;
    }

    final accountNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateNumber,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: _accountNumberController,
      keyboardType: TextInputType.number,
      onChanged: (e) {
        if (_accountNumberController.text.trim().length == 10) {
          getAccountDetails(_currentBankCode);
        }
      },
      maxLength: 10,
      decoration: InputDecoration(
        //prefix: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        contentPadding: const EdgeInsets.all(14),
        filled: false,
        hintText: 'Enter your account number...',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    validatePinOne(pinOneValue) {
      if (pinOneValue.isEmpty) {
        return 'pin cannot be empty';
      }
      if (pinOneValue.length < 4) {
        return 'pin is incomplete';
      }
      if (int.tryParse(pinOneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    final amount = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _amountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(
          "Enter amount",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        prefixText: "₦ ",
        prefixStyle: GoogleFonts.nunito(
          color: Theme.of(context).primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
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
        title: Text(
          'Transfer Funds',
          style: GoogleFonts.nunito(
            color: brandOne,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: (userController.userModel!.userDetails![0].hasBvn == true)
          ? Stack(
              children: [
                // Positioned.fill(
                //   child: Opacity(
                //     opacity: 0.3,
                //     child: Image.asset(
                //       'assets/icons/RentSpace-icon.png',
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                (notLoading)
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Note that the transfer process will be according to our Terms of use",
                              style: GoogleFonts.nunito(
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "Available balance: ${nairaFormaet.format(walletController.walletModel!.wallet![0].mainBalance - 20)}",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Form(
                              key: withdrawFormKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.fromLTRB(
                                  //       0.0, 5, 0.0, 5),
                                  //   child: Text(
                                  //     "Why do you want to withdraw?",
                                  //     style: GoogleFonts.nunito(
                                  //       fontSize: 16,
                                  //       //letterSpacing: 2.0,
                                  //       color: Theme.of(context).primaryColor,
                                  //       fontWeight: FontWeight.w600,
                                  //     ),
                                  //   ),
                                  // ),
                                  // reasonOption,
                                  // const SizedBox(
                                  //   height: 20,
                                  // ),
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        "How much do you want to transfer?",
                                        style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                    child: amount,
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 5, 0.0, 5),
                                    child: Text(
                                      "Where should we send your transfer?",
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        //letterSpacing: 2.0,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  (canShowOption)
                                      ? Column(
                                          children: [
                                            CustomDropdown(
                                              selectedStyle: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 12),
                                              hintText: 'Select Bank',
                                              hintStyle: GoogleFonts.nunito(
                                                  fontSize: 12),
                                              excludeSelected: true,
                                              fillColor: Colors.transparent,
                                              listItemStyle: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 12),
                                              items: _bankName,
                                              controller:
                                                  _bankAccountController,
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              fieldSuffixIcon: Icon(
                                                Iconsax.arrow_down5,
                                                size: 25.h,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _currentBankName =
                                                      newValue.toString();
                                                  selectedItem = newValue;
                                                  int index = _bankName
                                                      .indexOf(selectedItem!);
                                                  _currentBankCode =
                                                      _bankCode[index - 1];
                                                });
                                                print("_currentBankCode");
                                                print(_currentBankCode);
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0.0, 5, 0.0, 5),
                                              child: accountNumber,
                                            ),
                                          ],
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 10, 20.0, 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Loading banks...",
                                                style: GoogleFonts.nunito(
                                                  fontSize: 16,
                                                  //letterSpacing: 2.0,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CustomLoader(),
                                              ),
                                            ],
                                          ),
                                        ),
                                  (isChecking)
                                      ? const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 0, 20.0, 10),
                                          child: LinearProgressIndicator(
                                            color: brandOne,
                                            minHeight: 4,
                                          ),
                                        )
                                      : const SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0, 20.0, 10),
                                    child: Text(
                                      _bankAccountName,
                                      style: GoogleFonts.nunito(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                  onPressed: () {
                                    if (validateAmount(_amountController.text
                                                .trim()) ==
                                            null &&
                                        validateName(_bankAccountName) ==
                                            null &&
                                        validateNumber(_accountNumberController
                                                .text
                                                .trim()) ==
                                            null) {
                                      // print('yo');
                                      Get.bottomSheet(
                                        isDismissible: true,
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 400,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(30.0),
                                              topRight: Radius.circular(30.0),
                                            ),
                                            child: Container(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
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
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w800),
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
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 20,
                                                        color: brandOne,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: brandTwo,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    onCompleted: (String val) {
                                                      if (BCrypt.checkpw(
                                                        _aPinController.text
                                                            .trim()
                                                            .toString(),
                                                        walletController
                                                            .walletModel!
                                                            .wallet![0]
                                                            .pin,
                                                      )) {
                                                        _aPinController.clear();
                                                        Get.back();
                                                        _doWallet();
                                                      } else {
                                                        _aPinController.clear();
                                                        if (context.mounted) {
                                                          customErrorDialog(
                                                              context,
                                                              "Invalid PIN",
                                                              'Enter correct PIN to proceed');
                                                        }
                                                      }
                                                    },
                                                    validator: validatePinOne,
                                                    onChanged: validatePinOne,
                                                    controller: _aPinController,
                                                    length: 4,
                                                    closeKeyboardWhenCompleted:
                                                        true,
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    '(₦20 charges applied)',
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(
                                                    height: 40,
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize:
                                                          const Size(300, 50),
                                                      backgroundColor: brandOne,
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      if (BCrypt.checkpw(
                                                        _aPinController.text
                                                            .trim()
                                                            .toString(),
                                                        walletController
                                                            .walletModel!
                                                            .wallet![0]
                                                            .pin,
                                                      )) {
                                                        _aPinController.clear();
                                                        Get.back();
                                                        _doWallet();
                                                      } else {
                                                        _aPinController.clear();
                                                        if (context.mounted) {
                                                          customErrorDialog(
                                                              context,
                                                              "Invalid PIN",
                                                              'Enter correct PIN to proceed');
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                      'Proceed to Transfer',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.nunito(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
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
                                      );
                                    } else {
                                      // Timer(const Duration(seconds: 1), () {
                                      //   _btnController.stop();
                                      // });
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              title: null,
                                              elevation: 0,
                                              content: SizedBox(
                                                height: 250,
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            // color: brandOne,
                                                          ),
                                                          child: const Icon(
                                                            Iconsax
                                                                .close_circle,
                                                            color: brandOne,
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Icon(
                                                        Iconsax.warning_24,
                                                        color: Colors.red,
                                                        size: 75,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Text(
                                                      'Invalid',
                                                      style: GoogleFonts.nunito(
                                                        color: Colors.red,
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "Please fill the form properly to proceed",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.nunito(
                                                          color: brandOne,
                                                          fontSize: 18),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });

                                      // Get.snackbar(
                                      //   "Invalid",
                                      //   'Please fill the form properly to proceed',
                                      //   animationDuration:
                                      //       const Duration(seconds: 1),
                                      //   backgroundColor: Colors.red,
                                      //   colorText: Colors.white,
                                      //   snackPosition: SnackPosition.BOTTOM,
                                      // );
                                    }
                                  },
                                  child: Text(
                                    'Transfer',
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
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Processing...",
                                  style: GoogleFonts.nunito(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
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
                      ),
              ],
            )
          : Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "kindly confirm your BVN to perform this action.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
                    onPressed: () {
                      Get.to(BvnPage(
                          email:
                              userController.userModel!.userDetails![0].email));
                    },
                    child: Text(
                      'Begin Verification',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // GFButton(
                  //   onPressed: () async {
                  //     Get.to(const BvnPage());
                  //   },
                  //   text: "  Begin Verification  ",
                  //   fullWidthButton: false,
                  //   color: brandOne,
                  //   shape: GFButtonShape.pills,
                  // ),
                ],
              ),
            ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
