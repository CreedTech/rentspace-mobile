// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/controller/user_controller.dart';
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

import '../../constants/widgets/custom_loader.dart';

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
  TextEditingController _amountController = TextEditingController();
  TextEditingController _aPinController = TextEditingController();
  final withdrawFormKey = GlobalKey<FormState>();

  String liquidateReason = "I have an emergency";
  var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
  String walletID = "";
  String userID = "";
  String? selectedItem;
  String sourceName = "";
  String uId = "";
  String walletBalance = "0";
  String accountToUse = "0";
  List<String> _bankName = [];
  String _currentBankName = 'Select bank';
  String _currentBankCode = '';
  List<String> _bankCode = [];
  bool canShowOption = false;
  bool isChecking = false;
  String _bankAccountName = "";

  getAccountDetails(String currentCode) async {
    setState(() {
      isChecking = true;
      _bankAccountName = "";
    });
    const String apiUrl = 'https://api-d.squadco.com/payout/account/lookup';
    const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "bank_code": _currentBankName,
        "account_number": _accountNumberController.text.trim().toString(),
      }),
    );

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final userBankName = jsonResponse['data']["account_name"];
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

        // Get.snackbar(
        //   "Error!",
        //   "Invalid account number",
        //   animationDuration: const Duration(seconds: 1),
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
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

      // Get.snackbar(
      //   "Error!",
      //   "something went wrong",
      //   animationDuration: const Duration(seconds: 1),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  getBanksList() async {
    const String bankApiUrl =
        'https://api.watupay.com/v1/country/NG/financial-institutions';
    const String bearerToken = 'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
    final response = await http.get(
      Uri.parse(bankApiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
    );
    print('response');
    print(response);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('jsonResponse');
      print(jsonResponse);
      List<String> tempName = [];
      List<String> tempCode = [];
      tempName.add("Select bank");
      for (var item in jsonResponse['data']) {
        String localCode = item['local_code'] ?? 'N/A';
        print('localCode');
        print(localCode);
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

      print(_bankName);
      print('_bankCode');
      print(_bankCode);
      setState(() {
        canShowOption = true;
      });
    } else {
      print('Failed to load data from the server');
    }
  }

  var _chars = '1234567890';
  Random _rnd = Random();
  String _payUrl = "";
  String getRandom(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  getCurrentUser() async {
    var collection = FirebaseFirestore.instance.collection('accounts');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        walletID = data?['wallet_id'];
        userID = data?['rentspace_id'];
        walletBalance = data?['wallet_balance'];
        uId = data?['id'];
      });
    }
  }

  final TextEditingController _accountNumberController =
      TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  initState() {
    super.initState();
    notLoading = true;
    getCurrentUser();
    getBanksList();
  }

  void _doWallet() async {
    setState(() {
      notLoading = false;
    });
    Timer(const Duration(seconds: 1), () {
      _btnController.stop();
    });
    var updateLiquidate = FirebaseFirestore.instance.collection('liquidation');
    const String apiUrl = 'https://api-d.squadco.com/payout/transfer';
    const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "remark": "SpaceWallet Withdrawal",
        "bank_code": _currentBankName,
        "currency_id": "NGN",
        "amount":
            (int.tryParse(_amountController.text.trim())! * 100).toString(),
        "account_number": _accountNumberController.text.trim().toString(),
        "transaction_reference": "C6NZ61CS_${getRandom(11)}",
        "account_name": _bankAccountName,
      }),
    );

    if (response.statusCode == 200) {
      await updateLiquidate.add({
        'user_id': userID,
        'date': formattedDate,
        'amount': _amountController.text.trim(),
        'reason': liquidateReason,
        'name': 'SpaceWallet Withdrawal',
        'charges': '20',
        'bank_name': _currentBankName,
        'status': 'success',
        'trans_id': getRandom(10),
        'id': uId,
        'account_number': _accountNumberController.text.trim(),
        'account_name': _bankAccountName,
        'withdrawal_location': "Bank",
        'liquidation_source': "Space Wallet"
      }).then((value) async {
        var walletUpdate = FirebaseFirestore.instance.collection('accounts');
        await walletUpdate.doc(userId).update({
          'wallet_balance': (((int.tryParse(
                      userController.user[0].userWalletBalance))!) -
                  ((int.tryParse(_amountController.text.trim().toString()))! +
                      20))
              .toString(),
          "activities": FieldValue.arrayUnion(
            [
              "$formattedDate \nBank Withdrawal\n${nairaFormaet.format(double.tryParse(_amountController.text.trim()))} from SpaceWallet",
            ],
          ),
        });
        setState(() {
          notLoading = true;
        });
        Get.back();
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            backgroundColor: brandOne,
            message: 'Wallet withdrawal successful.',
            textStyle: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        // Get.snackbar(
        //   "Success!",
        //   'Wallet withdrawal successful.',
        //   animationDuration: const Duration(seconds: 1),
        //   backgroundColor: brandOne,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.TOP,
        // );
      }).catchError((error) {
        setState(() {
          notLoading = true;
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
                          'Oops',
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
                          "Something went wrong, try again later",
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
        // Get.snackbar(
        //   "Oops",
        //   "Something went wrong, try again later",
        //   animationDuration: const Duration(seconds: 2),
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      });
    } else {
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
      // Get.snackbar(
      //   "Error!",
      //   "something went wrong",
      //   animationDuration: const Duration(seconds: 1),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
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
      if (int.tryParse(amountValue)! > (int.tryParse(walletBalance)!) - 20) {
        return 'you cannot withdraw more than your balance';
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

    final bankOption = Container(
      height: 450.h,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      child: DropdownButtonHideUnderline(
        child: GFDropdown(
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Theme.of(context).canvasColor,
          value: _currentBankName,
          hint: Text(
            'Choose bank',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 60.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),
          dropdownColor: Theme.of(context).canvasColor,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 60.sp,
            color: Theme.of(context).primaryColor,
          ),
          focusColor: brandOne,
          onChanged: (newValue) {
            setState(() {
              _currentBankName = newValue.toString();
              selectedItem = newValue as String?;
              int index = _bankName.indexOf(selectedItem!);
              _currentBankCode = _bankCode[index - 1];
            });
          },
          items: _bankName
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
        ),
      ),
    );

    final bankOption2 = DropdownButtonFormField(
      style: GoogleFonts.nunito(
        color: brandOne,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      items: const [
        DropdownMenuItem(value: 'Select bank', child: Text('Select bank')),
        DropdownMenuItem(value: '000001', child: Text('Sterling Bank')),
        DropdownMenuItem(value: '000002', child: Text('Keystone Bank')),
        DropdownMenuItem(value: '000003', child: Text('FCMB')),
        DropdownMenuItem(
            value: '000004', child: Text('United Bank for Africa')),
        DropdownMenuItem(value: '000005', child: Text('Diamond Bank')),
        DropdownMenuItem(value: '000006', child: Text('JAIZ Bank')),
        DropdownMenuItem(value: '000007', child: Text('Fidelity Bank')),
        DropdownMenuItem(value: '000008', child: Text('Polaris Bank')),
        DropdownMenuItem(value: '000009', child: Text('Citi Bank')),
        DropdownMenuItem(value: '000010', child: Text('Ecobank Bank')),
        DropdownMenuItem(value: '000011', child: Text('Unity Bank')),
        DropdownMenuItem(value: '000012', child: Text('StanbicIBTC Bank')),
        DropdownMenuItem(value: '000013', child: Text('GTBank Plc')),
        DropdownMenuItem(value: '000014', child: Text('Access Bank')),
        DropdownMenuItem(value: '000015', child: Text('Zenith Bank Plc')),
        DropdownMenuItem(value: '000016', child: Text('First Bank of Nigeria')),
        DropdownMenuItem(value: '000017', child: Text('Wema Bank')),
        DropdownMenuItem(value: '000018', child: Text('Union Bank')),
        DropdownMenuItem(value: '000019', child: Text('Enterprise Bank')),
        DropdownMenuItem(value: '000020', child: Text('Heritage')),
        DropdownMenuItem(value: '000021', child: Text('Standard Chartered')),
        DropdownMenuItem(value: '000022', child: Text('Suntrust Bank')),
        DropdownMenuItem(value: '000023', child: Text('Providus Bank')),
        DropdownMenuItem(value: '000024', child: Text('Rand Merchant Bank')),
        DropdownMenuItem(value: '000025', child: Text('Titan Trust Bank')),
        DropdownMenuItem(value: '000026', child: Text('Taj Bank')),
        DropdownMenuItem(value: '000027', child: Text('Globus Bank')),
        DropdownMenuItem(
            value: '000028', child: Text('Central Bank of Nigeria')),
        DropdownMenuItem(value: '000029', child: Text('Lotus Bank')),
        DropdownMenuItem(value: '000031', child: Text('Premium Trust Bank')),
        DropdownMenuItem(value: '000033', child: Text('eNaira')),
        DropdownMenuItem(value: '000034', child: Text('Signature Bank')),
        DropdownMenuItem(value: '000036', child: Text('Optimus Bank')),
        DropdownMenuItem(
            value: '050002', child: Text('FEWCHORE FINANCE COMPANY LIMITED')),
        DropdownMenuItem(
            value: '050003', child: Text('SageGrey Finance Limited')),
        DropdownMenuItem(value: '050005', child: Text('AAA Finance')),
        DropdownMenuItem(
            value: '050006',
            child: Text('Branch International Financial Services')),
        DropdownMenuItem(value: '050007', child: Text('Tekla Finance Limited')),
        DropdownMenuItem(value: '050009', child: Text('Fast Credit')),
        DropdownMenuItem(
            value: '050010',
            child: Text('Fundquest Financial Services Limited')),
        DropdownMenuItem(value: '050012', child: Text('Enco Finance')),
        DropdownMenuItem(value: '050013', child: Text('Dignity Finance')),
        DropdownMenuItem(
            value: '050013', child: Text('Trinity Financial Services Limited')),
        DropdownMenuItem(value: '400001', child: Text('FSDH Merchant Bank')),
        DropdownMenuItem(
            value: '060001', child: Text('Coronation Merchant Bank')),
        DropdownMenuItem(
            value: '060002', child: Text('FBNQUEST Merchant Bank')),
        DropdownMenuItem(value: '060003', child: Text('Nova Merchant Bank')),
        DropdownMenuItem(
            value: '060004', child: Text('Greenwich Merchant Bank')),
        DropdownMenuItem(
            value: '070007', child: Text('Omoluabi savings and loans')),
        DropdownMenuItem(value: '090001', child: Text('ASOSavings & Loans')),
        DropdownMenuItem(
            value: '090005', child: Text('Trustbond Mortgage Bank')),
        DropdownMenuItem(value: '090006', child: Text('SafeTrust')),
        DropdownMenuItem(value: '090107', child: Text('FBN Mortgages Limited')),
        DropdownMenuItem(
            value: '100024', child: Text('Imperial Homes Mortgage Bank')),
        DropdownMenuItem(value: '100028', child: Text('AG Mortgage Bank')),
        DropdownMenuItem(value: '070009', child: Text('Gateway Mortgage Bank')),
        DropdownMenuItem(value: '070010', child: Text('Abbey Mortgage Bank')),
        DropdownMenuItem(value: '070011', child: Text('Refuge Mortgage Bank')),
        DropdownMenuItem(
            value: '070012', child: Text('Lagos Building Investment Company')),
        DropdownMenuItem(
            value: '070013', child: Text('Platinum Mortgage Bank')),
        DropdownMenuItem(
            value: '070014', child: Text('First Generation Mortgage Bank')),
        DropdownMenuItem(value: '070015', child: Text('Brent Mortgage Bank')),
        DropdownMenuItem(
            value: '070016', child: Text('Infinity Trust Mortgage Bank')),
        DropdownMenuItem(
            value: '070019', child: Text('MayFresh Mortgage Bank')),
        DropdownMenuItem(
            value: '090003', child: Text('Jubilee-Life Mortgage Bank')),
        DropdownMenuItem(
            value: '070017', child: Text('Haggai Mortgage Bank Limited')),
        DropdownMenuItem(value: '070021', child: Text('Coop Mortgage Bank')),
        DropdownMenuItem(
            value: '070023', child: Text('Delta Trust Microfinance Bank')),
        DropdownMenuItem(
            value: '070024', child: Text('Homebase Mortgage Bank')),
        DropdownMenuItem(
            value: '070025', child: Text('Akwa Savings & Loans Limited')),
        DropdownMenuItem(value: '070026', child: Text('FHA Mortgage Bank')),
        DropdownMenuItem(value: '090108', child: Text('New Prudential Bank')),
        DropdownMenuItem(value: '070001', child: Text('NPF MicroFinance Bank')),
        DropdownMenuItem(
            value: '070002', child: Text('Fortis Microfinance Bank')),
        DropdownMenuItem(value: '070006', child: Text('Covenant MFB')),
        DropdownMenuItem(value: '070008', child: Text('Page Financials')),
        DropdownMenuItem(
            value: '090004', child: Text('Parralex Microfinance bank')),
        DropdownMenuItem(value: '090097', child: Text('Ekondo MFB')),
        DropdownMenuItem(value: '090110', child: Text('VFD MFB')),
        DropdownMenuItem(
            value: '090111', child: Text('FinaTrust Microfinance Bank')),
        DropdownMenuItem(
            value: '090112', child: Text('Seed Capital Microfinance Bank')),
        DropdownMenuItem(value: '090114', child: Text('Empire trust MFB')),
        DropdownMenuItem(value: '090115', child: Text('TCF MFB')),
        DropdownMenuItem(value: '090116', child: Text('AMML MFB')),
        DropdownMenuItem(
            value: '090117', child: Text('Boctrust Microfinance Bank')),
        DropdownMenuItem(
            value: '090118', child: Text('IBILE Microfinance Bank')),
        DropdownMenuItem(
            value: '090119', child: Text('Ohafia Microfinance Bank')),
        DropdownMenuItem(
            value: '090120', child: Text('Wetland Microfinance Bank')),
        DropdownMenuItem(
            value: '090121', child: Text('Hasal Microfinance Bank')),
        DropdownMenuItem(
            value: '090122', child: Text('Gowans Microfinance Bank')),
        DropdownMenuItem(
            value: '090123', child: Text('Verite Microfinance Bank')),
        DropdownMenuItem(
            value: '090124', child: Text('Xslnce Microfinance Bank')),
        DropdownMenuItem(
            value: '090125', child: Text('Regent Microfinance Bank')),
        DropdownMenuItem(
            value: '090126', child: Text('Fidfund Microfinance Bank')),
        DropdownMenuItem(
            value: '090127', child: Text('BC Kash Microfinance Bank')),
        DropdownMenuItem(
            value: '090128', child: Text('Ndiorah Microfinance Bank')),
        DropdownMenuItem(
            value: '090129', child: Text('Money Trust Microfinance Bank')),
        DropdownMenuItem(
            value: '090130', child: Text('Consumer Microfinance Bank')),
        DropdownMenuItem(
            value: '090131', child: Text('Allworkers Microfinance Bank')),
        DropdownMenuItem(
            value: '090132', child: Text('Richway Microfinance Bank')),
        DropdownMenuItem(
            value: '090133', child: Text('AL-Barakah Microfinance Bank')),
        DropdownMenuItem(
            value: '090134', child: Text('Accion Microfinance Bank')),
        DropdownMenuItem(
            value: '090135', child: Text('Personal Trust Microfinance Bank')),
        DropdownMenuItem(
            value: '090136', child: Text('Microcred Microfinance Bank')),
        DropdownMenuItem(
            value: '090137', child: Text('PecanTrust Microfinance Bank')),
        DropdownMenuItem(
            value: '090138', child: Text('Royal Exchange Microfinance Bank')),
        DropdownMenuItem(
            value: '090139', child: Text('Visa Microfinance Bank')),
        DropdownMenuItem(
            value: '090140', child: Text('Sagamu Microfinance Bank')),
        DropdownMenuItem(
            value: '090141', child: Text('Chikum Microfinance Bank')),
        DropdownMenuItem(value: '090142', child: Text('Yes Microfinance Bank')),
        DropdownMenuItem(
            value: '090143', child: Text('Apeks Microfinance Bank')),
        DropdownMenuItem(value: '090144', child: Text('CIT Microfinance Bank')),
        DropdownMenuItem(
            value: '090145', child: Text('Fullrange Microfinance Bank')),
        DropdownMenuItem(
            value: '090146', child: Text('Trident Microfinance Bank')),
        DropdownMenuItem(
            value: '090147', child: Text('Hackman Microfinance Bank')),
        DropdownMenuItem(
            value: '090148', child: Text('Bowen Microfinance Bank')),
        DropdownMenuItem(value: '090149', child: Text('IRL Microfinance Bank')),
        DropdownMenuItem(
            value: '090150', child: Text('Virtue Microfinance Bank')),
        DropdownMenuItem(
            value: '090151', child: Text('Mutual Trust Microfinance Bank')),
        DropdownMenuItem(
            value: '090152', child: Text('Nagarta Microfinance Bank')),
        DropdownMenuItem(value: '090153', child: Text('FFS Microfinance Bank')),
        DropdownMenuItem(
            value: '090154', child: Text('CEMCS Microfinance Bank')),
        DropdownMenuItem(
            value: '090155',
            child: Text('Advans La Fayette Microfinance Bank')),
        DropdownMenuItem(
            value: '090156', child: Text('e-Barcs Microfinance Bank')),
        DropdownMenuItem(
            value: '090157', child: Text('Infinity Microfinance Bank')),
        DropdownMenuItem(
            value: '090158', child: Text('Futo Microfinance Bank')),
        DropdownMenuItem(
            value: '090159', child: Text('Credit Afrique Microfinance Bank')),
        DropdownMenuItem(
            value: '090160', child: Text('Addosser Microfinance Bank')),
        DropdownMenuItem(
            value: '090161', child: Text('Okpoga Microfinance Bank')),
        DropdownMenuItem(
            value: '090162', child: Text('Stanford Microfinance Bak')),
        DropdownMenuItem(
            value: '090164', child: Text('First Royal Microfinance Bank')),
        DropdownMenuItem(
            value: '090165', child: Text('Petra Microfinance Bank')),
        DropdownMenuItem(
            value: '090166', child: Text('Eso-E Microfinance Bank')),
        DropdownMenuItem(
            value: '090167', child: Text('Daylight Microfinance Bank')),
        DropdownMenuItem(
            value: '090168', child: Text('Gashua Microfinance Bank')),
        DropdownMenuItem(
            value: '090169', child: Text('Alpha Kapital Microfinance Bank')),
        DropdownMenuItem(
            value: '090171', child: Text('Mainstreet Microfinance Bank')),
      ],
     
      onChanged: (newValue) {
        setState(() {
          _currentBankName = newValue.toString();
        });
        print(_currentBankName);
      },
      decoration: InputDecoration(
        hintText: 'Choose Bank',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        contentPadding: const EdgeInsets.all(14),
      ),
    );

    final fewBankOption = Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      child: DropdownButtonHideUnderline(
        child: GFDropdown(
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Theme.of(context).canvasColor,
          value: _currentBankName,
          hint: Text(
            'Choose bank',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 60,
              color: Theme.of(context).primaryColor,
            ),
          ),
          dropdownColor: Theme.of(context).canvasColor,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 60,
            color: Theme.of(context).primaryColor,
          ),
          focusColor: brandOne,
          items: const [
            DropdownMenuItem(value: 'Select bank', child: Text('Select bank')),
            DropdownMenuItem(value: '000001', child: Text('Sterling Bank')),
            DropdownMenuItem(value: '000002', child: Text('Keystone Bank')),
            DropdownMenuItem(value: '000003', child: Text('FCMB')),
            DropdownMenuItem(
                value: '000004', child: Text('United Bank for Africa')),
            DropdownMenuItem(value: '000005', child: Text('Diamond Bank')),
            DropdownMenuItem(value: '000006', child: Text('JAIZ Bank')),
            DropdownMenuItem(value: '000007', child: Text('Fidelity Bank')),
            DropdownMenuItem(value: '000008', child: Text('Polaris Bank')),
            DropdownMenuItem(value: '000009', child: Text('Citi Bank')),
            DropdownMenuItem(value: '000010', child: Text('Ecobank Bank')),
            DropdownMenuItem(value: '000011', child: Text('Unity Bank')),
            DropdownMenuItem(value: '000012', child: Text('StanbicIBTC Bank')),
            DropdownMenuItem(value: '000013', child: Text('GTBank Plc')),
            DropdownMenuItem(value: '000014', child: Text('Access Bank')),
            DropdownMenuItem(value: '000015', child: Text('Zenith Bank Plc')),
            DropdownMenuItem(
                value: '000016', child: Text('First Bank of Nigeria')),
            DropdownMenuItem(value: '000017', child: Text('Wema Bank')),
            DropdownMenuItem(value: '000018', child: Text('Union Bank')),
            DropdownMenuItem(value: '000019', child: Text('Enterprise Bank')),
            DropdownMenuItem(value: '000020', child: Text('Heritage')),
            DropdownMenuItem(
                value: '000021', child: Text('Standard Chartered')),
            DropdownMenuItem(value: '000022', child: Text('Suntrust Bank')),
            DropdownMenuItem(value: '000023', child: Text('Providus Bank')),
            DropdownMenuItem(
                value: '000024', child: Text('Rand Merchant Bank')),
            DropdownMenuItem(value: '000025', child: Text('Titan Trust Bank')),
            DropdownMenuItem(value: '000026', child: Text('Taj Bank')),
            DropdownMenuItem(value: '000027', child: Text('Globus Bank')),
            DropdownMenuItem(
                value: '000028', child: Text('Central Bank of Nigeria')),
            DropdownMenuItem(value: '000029', child: Text('Lotus Bank')),
            DropdownMenuItem(
                value: '000031', child: Text('Premium Trust Bank')),
            DropdownMenuItem(value: '000033', child: Text('eNaira')),
            DropdownMenuItem(value: '000034', child: Text('Signature Bank')),
            DropdownMenuItem(value: '000036', child: Text('Optimus Bank')),
            DropdownMenuItem(
                value: '050002',
                child: Text('FEWCHORE FINANCE COMPANY LIMITED')),
            DropdownMenuItem(
                value: '050003', child: Text('SageGrey Finance Limited')),
            DropdownMenuItem(value: '050005', child: Text('AAA Finance')),
            DropdownMenuItem(
                value: '050006',
                child: Text('Branch International Financial Services')),
            DropdownMenuItem(
                value: '050007', child: Text('Tekla Finance Limited')),
            DropdownMenuItem(value: '050009', child: Text('Fast Credit')),
            DropdownMenuItem(
                value: '050010',
                child: Text('Fundquest Financial Services Limited')),
            DropdownMenuItem(value: '050012', child: Text('Enco Finance')),
            DropdownMenuItem(value: '050013', child: Text('Dignity Finance')),
            DropdownMenuItem(
                value: '050013',
                child: Text('Trinity Financial Services Limited')),
            DropdownMenuItem(
                value: '400001', child: Text('FSDH Merchant Bank')),
            DropdownMenuItem(
                value: '060001', child: Text('Coronation Merchant Bank')),
            DropdownMenuItem(
                value: '060002', child: Text('FBNQUEST Merchant Bank')),
            DropdownMenuItem(
                value: '060003', child: Text('Nova Merchant Bank')),
            DropdownMenuItem(
                value: '060004', child: Text('Greenwich Merchant Bank')),
            DropdownMenuItem(
                value: '070007', child: Text('Omoluabi savings and loans')),
            DropdownMenuItem(
                value: '090001', child: Text('ASOSavings & Loans')),
            DropdownMenuItem(
                value: '090005', child: Text('Trustbond Mortgage Bank')),
            DropdownMenuItem(value: '090006', child: Text('SafeTrust')),
            DropdownMenuItem(
                value: '090107', child: Text('FBN Mortgages Limited')),
            DropdownMenuItem(
                value: '100024', child: Text('Imperial Homes Mortgage Bank')),
            DropdownMenuItem(value: '100028', child: Text('AG Mortgage Bank')),
            DropdownMenuItem(
                value: '070009', child: Text('Gateway Mortgage Bank')),
            DropdownMenuItem(
                value: '070010', child: Text('Abbey Mortgage Bank')),
            DropdownMenuItem(
                value: '070011', child: Text('Refuge Mortgage Bank')),
            DropdownMenuItem(
                value: '070012',
                child: Text('Lagos Building Investment Company')),
            DropdownMenuItem(
                value: '070013', child: Text('Platinum Mortgage Bank')),
            DropdownMenuItem(
                value: '070014', child: Text('First Generation Mortgage Bank')),
            DropdownMenuItem(
                value: '070015', child: Text('Brent Mortgage Bank')),
            DropdownMenuItem(
                value: '070016', child: Text('Infinity Trust Mortgage Bank')),
            DropdownMenuItem(
                value: '070019', child: Text('MayFresh Mortgage Bank')),
            DropdownMenuItem(
                value: '090003', child: Text('Jubilee-Life Mortgage Bank')),
            DropdownMenuItem(
                value: '070017', child: Text('Haggai Mortgage Bank Limited')),
            DropdownMenuItem(
                value: '070021', child: Text('Coop Mortgage Bank')),
            DropdownMenuItem(
                value: '070023', child: Text('Delta Trust Microfinance Bank')),
            DropdownMenuItem(
                value: '070024', child: Text('Homebase Mortgage Bank')),
            DropdownMenuItem(
                value: '070025', child: Text('Akwa Savings & Loans Limited')),
            DropdownMenuItem(value: '070026', child: Text('FHA Mortgage Bank')),
            DropdownMenuItem(
                value: '090108', child: Text('New Prudential Bank')),
            DropdownMenuItem(
                value: '070001', child: Text('NPF MicroFinance Bank')),
            DropdownMenuItem(
                value: '070002', child: Text('Fortis Microfinance Bank')),
            DropdownMenuItem(value: '070006', child: Text('Covenant MFB')),
            DropdownMenuItem(value: '070008', child: Text('Page Financials')),
            DropdownMenuItem(
                value: '090004', child: Text('Parralex Microfinance bank')),
            DropdownMenuItem(value: '090097', child: Text('Ekondo MFB')),
            DropdownMenuItem(value: '090110', child: Text('VFD MFB')),
            DropdownMenuItem(
                value: '090111', child: Text('FinaTrust Microfinance Bank')),
            DropdownMenuItem(
                value: '090112', child: Text('Seed Capital Microfinance Bank')),
            DropdownMenuItem(value: '090114', child: Text('Empire trust MFB')),
            DropdownMenuItem(value: '090115', child: Text('TCF MFB')),
            DropdownMenuItem(value: '090116', child: Text('AMML MFB')),
            DropdownMenuItem(
                value: '090117', child: Text('Boctrust Microfinance Bank')),
            DropdownMenuItem(
                value: '090118', child: Text('IBILE Microfinance Bank')),
            DropdownMenuItem(
                value: '090119', child: Text('Ohafia Microfinance Bank')),
            DropdownMenuItem(
                value: '090120', child: Text('Wetland Microfinance Bank')),
            DropdownMenuItem(
                value: '090121', child: Text('Hasal Microfinance Bank')),
            DropdownMenuItem(
                value: '090122', child: Text('Gowans Microfinance Bank')),
            DropdownMenuItem(
                value: '090123', child: Text('Verite Microfinance Bank')),
            DropdownMenuItem(
                value: '090124', child: Text('Xslnce Microfinance Bank')),
            DropdownMenuItem(
                value: '090125', child: Text('Regent Microfinance Bank')),
            DropdownMenuItem(
                value: '090126', child: Text('Fidfund Microfinance Bank')),
            DropdownMenuItem(
                value: '090127', child: Text('BC Kash Microfinance Bank')),
            DropdownMenuItem(
                value: '090128', child: Text('Ndiorah Microfinance Bank')),
            DropdownMenuItem(
                value: '090129', child: Text('Money Trust Microfinance Bank')),
            DropdownMenuItem(
                value: '090130', child: Text('Consumer Microfinance Bank')),
            DropdownMenuItem(
                value: '090131', child: Text('Allworkers Microfinance Bank')),
            DropdownMenuItem(
                value: '090132', child: Text('Richway Microfinance Bank')),
            DropdownMenuItem(
                value: '090133', child: Text('AL-Barakah Microfinance Bank')),
            DropdownMenuItem(
                value: '090134', child: Text('Accion Microfinance Bank')),
            DropdownMenuItem(
                value: '090135',
                child: Text('Personal Trust Microfinance Bank')),
            DropdownMenuItem(
                value: '090136', child: Text('Microcred Microfinance Bank')),
            DropdownMenuItem(
                value: '090137', child: Text('PecanTrust Microfinance Bank')),
            DropdownMenuItem(
                value: '090138',
                child: Text('Royal Exchange Microfinance Bank')),
            DropdownMenuItem(
                value: '090139', child: Text('Visa Microfinance Bank')),
            DropdownMenuItem(
                value: '090140', child: Text('Sagamu Microfinance Bank')),
            DropdownMenuItem(
                value: '090141', child: Text('Chikum Microfinance Bank')),
            DropdownMenuItem(
                value: '090142', child: Text('Yes Microfinance Bank')),
            DropdownMenuItem(
                value: '090143', child: Text('Apeks Microfinance Bank')),
            DropdownMenuItem(
                value: '090144', child: Text('CIT Microfinance Bank')),
            DropdownMenuItem(
                value: '090145', child: Text('Fullrange Microfinance Bank')),
            DropdownMenuItem(
                value: '090146', child: Text('Trident Microfinance Bank')),
            DropdownMenuItem(
                value: '090147', child: Text('Hackman Microfinance Bank')),
            DropdownMenuItem(
                value: '090148', child: Text('Bowen Microfinance Bank')),
            DropdownMenuItem(
                value: '090149', child: Text('IRL Microfinance Bank')),
            DropdownMenuItem(
                value: '090150', child: Text('Virtue Microfinance Bank')),
            DropdownMenuItem(
                value: '090151', child: Text('Mutual Trust Microfinance Bank')),
            DropdownMenuItem(
                value: '090152', child: Text('Nagarta Microfinance Bank')),
            DropdownMenuItem(
                value: '090153', child: Text('FFS Microfinance Bank')),
            DropdownMenuItem(
                value: '090154', child: Text('CEMCS Microfinance Bank')),
            DropdownMenuItem(
                value: '090155',
                child: Text('Advans La Fayette Microfinance Bank')),
            DropdownMenuItem(
                value: '090156', child: Text('e-Barcs Microfinance Bank')),
            DropdownMenuItem(
                value: '090157', child: Text('Infinity Microfinance Bank')),
            DropdownMenuItem(
                value: '090158', child: Text('Futo Microfinance Bank')),
            DropdownMenuItem(
                value: '090159',
                child: Text('Credit Afrique Microfinance Bank')),
            DropdownMenuItem(
                value: '090160', child: Text('Addosser Microfinance Bank')),
            DropdownMenuItem(
                value: '090161', child: Text('Okpoga Microfinance Bank')),
            DropdownMenuItem(
                value: '090162', child: Text('Stanford Microfinance Bak')),
            DropdownMenuItem(
                value: '090164', child: Text('First Royal Microfinance Bank')),
            DropdownMenuItem(
                value: '090165', child: Text('Petra Microfinance Bank')),
            DropdownMenuItem(
                value: '090166', child: Text('Eso-E Microfinance Bank')),
            DropdownMenuItem(
                value: '090167', child: Text('Daylight Microfinance Bank')),
            DropdownMenuItem(
                value: '090168', child: Text('Gashua Microfinance Bank')),
            DropdownMenuItem(
                value: '090169',
                child: Text('Alpha Kapital Microfinance Bank')),
            DropdownMenuItem(
                value: '090171', child: Text('Mainstreet Microfinance Bank')),
          ],
          onChanged: (newValue) {
            setState(() {
              _currentBankName = newValue.toString();
            });
            print(_currentBankName);
          },
        ),
      ),
    );
    final accountNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      style: GoogleFonts.nunito(
        color: Colors.black,
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
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
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
    final reasonOption = DropdownButtonFormField(
      style: GoogleFonts.nunito(
        color: brandOne,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      items: [
        'I have an emergency',
        'I no longer need to save',
        'Its too hard for me to save',
        'I have other reasons',
      ]
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value),
              ))
          .toList(),
      onChanged: (newValue) {
        //updated(state);
        setState(() {
          liquidateReason = newValue.toString();
        });
      },
      decoration: InputDecoration(
        hintText: 'Tell us why',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        contentPadding: const EdgeInsets.all(14),
        filled: false,
      ),
    );
    final reasonOption2 = Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      child: DropdownButtonHideUnderline(
        child: GFDropdown(
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Theme.of(context).canvasColor,
          value: liquidateReason,
          hint: Text(
            'Tell us why',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 60,
              color: Theme.of(context).primaryColor,
            ),
          ),
          dropdownColor: Theme.of(context).canvasColor,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 60,
            color: Theme.of(context).primaryColor,
          ),
          focusColor: brandOne,
          onChanged: (newValue) {
            //updated(state);
            setState(() {
              liquidateReason = newValue.toString();
            });
          },
          items: [
            'I have an emergency',
            'I no longer need to save',
            'Its too hard for me to save',
            'I have other reasons',
          ]
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
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
      cursorColor: Colors.black,
      controller: _amountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      style: const TextStyle(
        color: Colors.black,
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
        prefixText: "₦",
        prefixStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
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
          'Withdraw Funds',
          style: GoogleFonts.nunito(
            color: brandOne,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: (userController.user[0].status == "verified")
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
                              height: 50,
                            ),
                            Text(
                              "Note that the withdrawal process will be according to our Terms of use",
                              style: GoogleFonts.nunito(
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Available balance: ${nairaFormaet.format(int.tryParse(walletBalance)! - 20)}",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                //fontFamily: "DefaultFontFamily",
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
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 5, 0.0, 5),
                                    child: Text(
                                      "Why do you want to withdraw?",
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        //letterSpacing: 2.0,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  reasonOption,
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 5, 0.0, 5),
                                    child: Text(
                                      "Where should we send your withdrawal?",
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
                                            bankOption2,
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
                                        20.0, 10, 20.0, 10),
                                    child: Text(
                                      _bankAccountName,
                                      style: GoogleFonts.nunito(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        "How much do you want to withdraw?",
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
                                    backgroundColor: brandTwo,
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
                                          height: 300,
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
                                                          FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize:
                                                          const Size(300, 50),
                                                      backgroundColor: brandTwo,
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
                                                      if (_aPinController.text
                                                              .trim()
                                                              .toString() ==
                                                          userController.user[0]
                                                              .transactionPIN) {
                                                        Get.back();
                                                        _doWallet();
                                                      } else {
                                                        if (context.mounted) {
                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  title: null,
                                                                  elevation: 0,
                                                                  content:
                                                                      SizedBox(
                                                                    height: 250,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            child:
                                                                                Container(
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
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Icon(
                                                                            Iconsax.warning_24,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                75,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              12,
                                                                        ),
                                                                        Text(
                                                                          'Invalid PIN',
                                                                          style:
                                                                              GoogleFonts.nunito(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize:
                                                                                28,
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          "Enter correct PIN",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: GoogleFonts.nunito(
                                                                              color: brandOne,
                                                                              fontSize: 18),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        }
                                                        // Get.snackbar(
                                                        //   "Invalid PIN",
                                                        //   "Enter correct PIN",
                                                        //   animationDuration:
                                                        //       const Duration(
                                                        //           seconds: 2),
                                                        //   backgroundColor:
                                                        //       Colors.red,
                                                        //   colorText:
                                                        //       Colors.white,
                                                        //   snackPosition:
                                                        //       SnackPosition
                                                        //           .BOTTOM,
                                                        // );
                                                      }
                                                    },
                                                    child: Text(
                                                      'Proceed to Withdraw',
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
                                                  // GFButton(
                                                  //   onPressed: () {
                                                  //     if (_aPinController.text
                                                  //             .trim()
                                                  //             .toString() ==
                                                  //         userController.user[0]
                                                  //             .transactionPIN) {
                                                  //       Get.back();
                                                  //       _doWallet();
                                                  //     } else {
                                                  //       Get.snackbar(
                                                  //         "Invalid PIN",
                                                  //         "Enter correct PIN",
                                                  //         animationDuration:
                                                  //             const Duration(
                                                  //                 seconds: 2),
                                                  //         backgroundColor:
                                                  //             Colors.red,
                                                  //         colorText:
                                                  //             Colors.white,
                                                  //         snackPosition:
                                                  //             SnackPosition
                                                  //                 .BOTTOM,
                                                  //       );
                                                  //     }
                                                  //   },
                                                  //   icon: const Icon(
                                                  //     Icons
                                                  //         .arrow_right_outlined,
                                                  //     size: 30,
                                                  //     color: Colors.white,
                                                  //   ),
                                                  //   color: brandOne,
                                                  //   text: "Proceed to Withdraw",
                                                  //   shape: GFButtonShape.pills,
                                                  //   fullWidthButton: false,
                                                  // ),

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
                                    'Withdraw',
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
                            // RoundedLoadingButton(
                            //   child: const Text(
                            //     'Withdraw',
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //       fontFamily: "DefaultFontFamily",
                            //     ),
                            //   ),
                            //   elevation: 0.0,
                            //   successColor: brandOne,
                            //   borderRadius: 10,
                            //   color: brandOne,
                            //   controller: _btnController,
                            //   onPressed: () {
                            //     if (validateAmount(
                            //                 _amountController.text.trim()) ==
                            //             "" &&
                            //         validateName(_bankAccountName) == "" &&
                            //         validateNumber(_accountNumberController.text
                            //                 .trim()) ==
                            //             "") {
                            //       Timer(const Duration(seconds: 1), () {
                            //         _btnController.stop();
                            //       });
                            //       Get.bottomSheet(
                            //         isDismissible: true,
                            //         SizedBox(
                            //           height: 300,
                            //           child: ClipRRect(
                            //             borderRadius: const BorderRadius.only(
                            //               topLeft: Radius.circular(30.0),
                            //               topRight: Radius.circular(30.0),
                            //             ),
                            //             child: Container(
                            //               color: Theme.of(context).canvasColor,
                            //               padding: const EdgeInsets.fromLTRB(
                            //                   10, 5, 10, 5),
                            //               child: Column(
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.center,
                            //                 children: [
                            //                   const SizedBox(
                            //                     height: 50,
                            //                   ),
                            //                   Text(
                            //                     'Enter PIN to Proceed',
                            //                     style: TextStyle(
                            //                       fontSize: 18,
                            //                       fontFamily:
                            //                           "DefaultFontFamily",
                            //                       color: Theme.of(context)
                            //                           .primaryColor,
                            //                     ),
                            //                     textAlign: TextAlign.center,
                            //                   ),
                            //                   Pinput(
                            //                     defaultPinTheme: PinTheme(
                            //                       width: 30,
                            //                       height: 30,
                            //                       textStyle: TextStyle(
                            //                         fontSize: 20,
                            //                         color: Theme.of(context)
                            //                             .primaryColor,
                            //                       ),
                            //                       decoration: BoxDecoration(
                            //                         border: Border.all(
                            //                             color: brandOne,
                            //                             width: 2.0),
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                                 10),
                            //                       ),
                            //                     ),
                            //                     controller: _aPinController,
                            //                     length: 4,
                            //                     closeKeyboardWhenCompleted:
                            //                         true,
                            //                     keyboardType:
                            //                         TextInputType.number,
                            //                   ),
                            //                   const SizedBox(
                            //                     height: 20,
                            //                   ),
                            //                   Text(
                            //                     '(₦20 charges applied)',
                            //                     style: TextStyle(
                            //                       fontSize: 14,
                            //                       fontFamily:
                            //                           "DefaultFontFamily",
                            //                       color: Theme.of(context)
                            //                           .primaryColor,
                            //                     ),
                            //                     textAlign: TextAlign.center,
                            //                   ),
                            //                   const SizedBox(
                            //                     height: 30,
                            //                   ),
                            //                   GFButton(
                            //                     onPressed: () {
                            //                       if (_aPinController.text
                            //                               .trim()
                            //                               .toString() ==
                            //                           userController.user[0]
                            //                               .transactionPIN) {
                            //                         Get.back();
                            //                         _doWallet();
                            //                       } else {
                            //                         Get.snackbar(
                            //                           "Invalid PIN",
                            //                           "Enter correct PIN",
                            //                           animationDuration:
                            //                               const Duration(
                            //                                   seconds: 2),
                            //                           backgroundColor:
                            //                               Colors.red,
                            //                           colorText: Colors.white,
                            //                           snackPosition:
                            //                               SnackPosition.BOTTOM,
                            //                         );
                            //                       }
                            //                     },
                            //                     icon: const Icon(
                            //                       Icons.arrow_right_outlined,
                            //                       size: 30,
                            //                       color: Colors.white,
                            //                     ),
                            //                     color: brandOne,
                            //                     text: "Proceed to Withdraw",
                            //                     shape: GFButtonShape.pills,
                            //                     fullWidthButton: false,
                            //                   ),
                            //                   const SizedBox(
                            //                     height: 20,
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     } else {
                            //       Timer(const Duration(seconds: 1), () {
                            //         _btnController.stop();
                            //       });
                            //       Get.snackbar(
                            //         "Invalid",
                            //         'Please fill the form properly to proceed',
                            //         animationDuration:
                            //             const Duration(seconds: 1),
                            //         backgroundColor: Colors.red,
                            //         colorText: Colors.white,
                            //         snackPosition: SnackPosition.BOTTOM,
                            //       );
                            //     }
                            //   },
                            // ),

                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: const BoxDecoration(
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
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Processing...",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "DefaultFontFamily",
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icons/RentSpace-icon.png"),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Flexible(
                          child: Text(
                            "kindly confirm your BVN to perform this action.",
                            style: TextStyle(
                              fontSize: 16.0,
                              letterSpacing: 0.5,
                              fontFamily: "DefaultFontFamily",
                              color: Theme.of(context).primaryColor,
                            ),
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
                      Get.to(const BvnPage());
                    },
                    text: "  Begin Verification  ",
                    fullWidthButton: false,
                    color: brandOne,
                    shape: GFButtonShape.pills,
                  ),
                ],
              ),
            ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
