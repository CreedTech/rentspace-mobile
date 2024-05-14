import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
import 'package:rentspace/view/dashboard/transfer_confirmation_page.dart';
import 'package:rentspace/view/dashboard/transfer_payment_page.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet_controller.dart';
import '../actions/onboarding_page.dart';
import 'bank_select_overlay.dart';
import 'package:http/http.dart' as http;

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

var currencyFormat = NumberFormat.simpleCurrency(name: 'N');

class _TransferPageState extends State<TransferPage> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _narrationController = TextEditingController();
  final withdrawFormKey = GlobalKey<FormState>();
  late TextEditingController _searchController;
  String searchQuery = '';
  String? _selectedBank;
  String _bankAccountName = "";
  String _currentBankCode = '';
  bool hasError = false;
  String verifyAccountError = "";
  String _message = '';
  bool isChecking = false;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  late StreamSubscription subscription;
  List<String> _bankName = [];
  String _currentBankName = 'Select bank';
  bool _canShowOptions = false;
  bool _isTyping = false;
  String? selectedItem;
  bool isTextFieldEmpty = false;

  List<String> _bankCode = [];
  // bool canShowOption = false;
  Future getBanksList() async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

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
      EasyLoading.dismiss();
      var jsonResponse = jsonDecode(response.body);
      print('jsonResponse');
      // print(jsonResponse);
      List<String> tempName = [];
      List<String> tempCode = [];
      // tempName.add("Select bank");
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
      if (!mounted) return;
      setState(() {
        _bankName = tempName;
        _bankCode = tempCode;

        _canShowOptions = true;
      });
    } else {
      EasyLoading.dismiss();
      print('Failed to load data from the server');
    }
  }

  void _openBankSelectorOverlay() async {
    final List<dynamic>? selectedBank = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BankSelectorOverlay()),
    );
    if (selectedBank != null && selectedBank.length == 2) {
      setState(() {
        _selectedBank = selectedBank[0];
        _currentBankCode = selectedBank[1];
        _bankController.text = _selectedBank!;
      });
    }
    _checkFieldsAndHitApi();
  }

  void _updateMessage() {
    if (isChecking) {
      // If checking, display loader message
      _message = 'Verifying Account Details';
      verifyAccountError = "";
      hasError = false;
      _bankAccountName = "";
    }
  }

  Future<bool> fetchUserData({bool refresh = true}) async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    if (refresh) {
      print('fetching');
      await getBanksList();
      await userController.fetchData();
      await walletController.fetchWallet();
      print('fetched');
      // setState(() {}); // Move setState inside fetchData
    }
    EasyLoading.dismiss();
    return true;
  }

  getAccountDetails(String currentCode) async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    setState(() {
      isChecking = true;
      _bankAccountName = "";
      verifyAccountError = "";
      hasError = false;
    });
    final response = await http.post(
        Uri.parse(AppConstants.BASE_URL + AppConstants.VERFIY_ACCOUNT_DETAILS),
        headers: {
          'Authorization': 'Bearer $authToken',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "financial_institution": currentCode,
          "account_id": _accountNumberController.text.trim().toString()
        }));

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final userBankName = jsonResponse['account'][0]["account_name"];

      if (userBankName != null && userBankName != 'NA') {
        setState(() {
          _bankAccountName = userBankName;
          isChecking = false;
          hasError = false;
        });
        _updateMessage();
      } else {
        // Error handling
        setState(() {
          _bankAccountName = "";
          isChecking = false;
          hasError = true;
          verifyAccountError =
              'Account verification failed. Please check the details and try again';
        });
        _updateMessage();
        // if (context.mounted) {
        //   customErrorDialog(context, 'Error!', "Invalid account number");
        // }
      }

      //print(response.body);
    } else {
      // Error handling
      setState(() {
        _bankAccountName = "";
        isChecking = false;
        hasError = false;
        verifyAccountError = "";
      });
      _updateMessage();

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
                        style: GoogleFonts.lato(
                          color: Colors.red,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Something went wrong",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(color: brandOne, fontSize: 18),
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

// Function to check if both fields are not empty and initiate API call
  void _checkFieldsAndHitApi() {
    if (withdrawFormKey.currentState!.validate() && _selectedBank != null) {
      getAccountDetails(_currentBankCode);
    }
  }

  @override
  void initState() {
    super.initState();
    getConnectivity();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _message = '';
    fetchUserData();
  }

  void getConnectivity() {
    print('checking internet...');
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && !isAlertSet) {
          noInternetConnectionScreen(context);
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  noInternetConnectionScreen(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
            elevation: 0.0,
            alignment: Alignment.bottomCenter,
            insetPadding: const EdgeInsets.all(0),
            title: null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            content: SizedBox(
              height: 170.h,
              child: Container(
                width: 400.w,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Text(
                      'No internet Connection',
                      style: GoogleFonts.lato(
                          color: brandOne,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: brandOne,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 50),
                          maximumSize: const Size(400, 50),
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          // EasyLoading.dismiss();
                          setState(() => isAlertSet = false);
                          isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!isDeviceConnected && isAlertSet == false) {
                            // showDialogBox();
                            noInternetConnectionScreen(context);
                            setState(() => isAlertSet = true);
                          }
                          // fetchUserData();
                        },
                        child: Text(
                          "Try Again",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      // _searchQuery = _searchController.text.toLowerCase();
      _isTyping = searchQuery.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    validateNumber(accountValue) {
      if (accountValue.isEmpty) {
        return '';
      }
      if (accountValue.length < 10) {
        return 'account number is invalid';
      }
      if (accountValue.length > 10) {
        return 'Invalid account Number';
      }
      if (int.tryParse(accountValue) == null) {
        return 'enter valid account number';
      }
      return null;
    }

    validateAmount(amountValue) {
      if (amountValue.isEmpty) {
        return '';
      }
      if (int.tryParse(amountValue.trim().replaceAll(',', '')) == null) {
        return 'enter valid number';
      }
      if (int.tryParse(amountValue)!.isNegative) {
        return 'enter valid number';
      }
      if (int.tryParse(amountValue.trim().replaceAll(',', '')) == 0) {
        return 'number cannot be zero';
      }
      if (int.tryParse(amountValue)! < 10) {
        return 'minimum amount is ₦10.00';
      }
      // if (double.tryParse(amountValue + 20)! >
      //     walletController.walletModel!.wallet![0].mainBalance) {
      //   return 'you cannot transfer more than your balance';
      // }
      return null;
    }

    final amount = TextFormField(
      enableSuggestions: true,
      controller: _amountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      cursorColor: colorBlack,
      style: GoogleFonts.lato(
        color: colorBlack,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          // Check if the text field is empty
          isTextFieldEmpty = value.isNotEmpty &&
              int.tryParse(value) != null &&
              int.parse(value) >= 10 &&
              !(int.tryParse(value)!.isNegative) &&
              int.tryParse(value.trim().replaceAll(',', '')) != 0;
        });
      },
      decoration: InputDecoration(
        // label: Text(
        //   "Enter amount",
        //   style: GoogleFonts.lato(
        //     color: Colors.grey,
        //     fontSize: 12,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        prefixText: "₦ ",
        prefixStyle: GoogleFonts.lato(
          color: Theme.of(context).primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
    );

    final narration = TextFormField(
      enableSuggestions: true,
      controller: _narrationController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: colorBlack,
      style: GoogleFonts.lato(
        color: colorBlack,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
    );

    final accountNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: colorBlack,
      style: GoogleFonts.lato(
        color: colorBlack,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateNumber,
      // maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: _accountNumberController,
      keyboardType: TextInputType.number,
      onChanged: (e) {
        _checkFieldsAndHitApi();
      },
      // onEditingComplete: handleEditingComplete(editedValue),

      // maxLength: 10,
      decoration: InputDecoration(
        //prefix: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        contentPadding: const EdgeInsets.all(14),
        filled: false,
        // hintText: 'Enter 10 digits Account Number',
        // hintStyle: GoogleFonts.lato(
        //   color: Colors.grey,
        //   fontSize: 12,
        //   fontWeight: FontWeight.w400,
        // ),
      ),
    );
    final bank = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: GoogleFonts.lato(
        color: Theme.of(context).primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // validator: validateNumber,
      // maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: _bankController,
      keyboardType: TextInputType.text,
      onChanged: (e) {
        _checkFieldsAndHitApi();
      },
      // onEditingComplete: handleEditingComplete(editedValue),

      // maxLength: 10,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Image.asset(
            'assets/icons/bank_icon.png',
            width: 26,
          ),
        ),
        suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp,
            size: 24, color: colorBlack),
        //prefix: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        contentPadding: const EdgeInsets.all(14),
        filled: false,
        // hintText: _selectedBank ?? 'Tap to select bank',
        // hintStyle: GoogleFonts.lato(
        //   color: _selectedBank == null ? Colors.grey : brandOne,
        //   fontSize: 12,
        //   fontWeight: FontWeight.w400,
        // ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffF6F6F8),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: colorBlack,
              ),
            ),
            SizedBox(
              width: 4.h,
            ),
            Text(
              'Send Money',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: (userController.userModel!.userDetails![0].hasBvn == true)
          ? Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 24.w,
              ),
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.lato(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Space Wallet: ',
                              style: GoogleFonts.lato(
                                color: colorBlack,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              )),
                          TextSpan(
                            text: currencyFormat.format(walletController
                                .walletModel!.wallet![0].mainBalance),
                            style: GoogleFonts.lato(
                              color: brandOne,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 24,
                        color: colorBlack,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.lato(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Please note that there is a',
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: ' N20',
                                style: GoogleFonts.lato(
                                  color: brandOne,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: ' charge on all transfer.',
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 10),
                    child: Text(
                      'Recents',
                      style: GoogleFonts.lato(
                        color: colorBlack,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          width: 59,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/icons/bank_icon.png',
                                width: 44,
                                height: 44,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ken',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lato(
                                      color: colorBlack,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Cameroon',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lato(
                                      color: colorBlack,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: withdrawFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0.0, 10),
                          child: Text(
                            "Recipient Account",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: colorBlack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.h, horizontal: 3.w),
                              child: Text(
                                'Select Bank',
                                style: GoogleFonts.lato(
                                    color: colorBlack,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            TextFormField(
                              onTap: () async {
                                showModalBottomSheet(
                                  backgroundColor: const Color(0xffF6F6F8),
                                  isDismissible: false,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (
                                    BuildContext context,
                                  ) {
                                    return StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      // String searchQuery = '';
                                      List<String> filteredBanks(String query) {
                                        if (query.isEmpty) {
                                          return _bankName;
                                        } else {
                                          setState(() {});

                                          return _bankName
                                              .where((bankName) => bankName
                                                  .toLowerCase()
                                                  .contains(
                                                      query.toLowerCase()))
                                              .toList();
                                        }
                                      }

                                      return FractionallySizedBox(
                                        heightFactor: 0.8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 26, horizontal: 24),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Select Bank',
                                                          style:
                                                              GoogleFonts.lato(
                                                                  color:
                                                                      colorBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 24),
                                                        ),
                                                        GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Icon(
                                                              Icons.close,
                                                              size: 24,
                                                              color: colorBlack,
                                                            )),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 18,
                                                    ),
                                                    Container(
                                                      color: const Color(
                                                          0xffEBEBEB),
                                                      child: TextFormField(
                                                        style: GoogleFonts.lato(
                                                            color: colorBlack,
                                                            fontSize: 14),
                                                        cursorColor: colorBlack,
                                                        controller:
                                                            _searchController,
                                                        onChanged:
                                                            (String value) {
                                                          _onSearchChanged();
                                                          print(
                                                              "searchQuery here");
                                                          print(searchQuery);
                                                        },
                                                        // onChanged: (value) {
                                                        //   setState(() {
                                                        //     searchQuery = value;
                                                        //   });

                                                        // },
                                                        decoration:
                                                            InputDecoration(
                                                          filled: false,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          prefixIcon:
                                                              const Icon(
                                                            Icons
                                                                .search_outlined,
                                                            color: colorBlack,
                                                            size: 24,
                                                          ),
                                                          suffixIcon:
                                                              _isTyping // Show clear button only when typing
                                                                  ? IconButton(
                                                                      icon:
                                                                          const Icon(
                                                                        Iconsax
                                                                            .close_circle5,
                                                                        size:
                                                                            18,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        _searchController
                                                                            .clear(); // Clear the text field
                                                                      },
                                                                    )
                                                                  : null,
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                            // borderSide: BorderSide.none
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                              color: brandOne,
                                                            ),
                                                            // borderSide: BorderSide.none
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                              color: brandOne,
                                                            ),
                                                            // borderSide: BorderSide.none
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 2.0),
                                                          ),
                                                          hintStyle:
                                                              const TextStyle(
                                                            color: colorBlack,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          hintText:
                                                              "Search Bank",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: filteredBanks(
                                                            searchQuery)
                                                        .length,
                                                    itemBuilder:
                                                        (context, idx) {
                                                      final bankName =
                                                          filteredBanks(
                                                              searchQuery)[idx];
                                                      return Column(
                                                        children: [
                                                          StatefulBuilder(builder:
                                                              (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                            return ListTileTheme(
                                                              selectedColor: Theme
                                                                      .of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                              child: ListTile(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 0.0,
                                                                  right: 0.0,
                                                                ),
                                                                minLeadingWidth:
                                                                    0,
                                                                leading:
                                                                    Image.asset(
                                                                  'assets/icons/bank_icon.png',
                                                                  width: 44,
                                                                  height: 44,
                                                                  fit: BoxFit
                                                                      .fitWidth, // Ensure the image fits inside the circle
                                                                ),
                                                                title: SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      1.5,
                                                                  child: Text(
                                                                    bankName,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.lato(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color:
                                                                            colorBlack),
                                                                  ),
                                                                ),

                                                                // leading: Radio<String>(
                                                                //   fillColor: MaterialStateColor
                                                                //       .resolveWith(
                                                                //     (states) => brandOne,
                                                                //   ),
                                                                //   value: name[idx],
                                                                //   groupValue: tvCable,
                                                                //   onChanged: (String? value) {
                                                                //     tvCable = value!;
                                                                //     // Hive.box('settings')
                                                                //     //     .put('region', region);
                                                                //     Navigator.pop(context);
                                                                //     setState(() {
                                                                //       _selectedTVCode =
                                                                //           tvBill[idx];
                                                                //       tvCable = name[idx];
                                                                //       tvImage = image[idx];
                                                                //       canProceed = true;
                                                                //     });
                                                                //   },
                                                                // ),
                                                                // selected: tvCable == name[idx],
                                                                onTap: () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  setState(() {
                                                                    _currentBankName =
                                                                        bankName
                                                                            .toString();
                                                                    selectedItem =
                                                                        bankName;
                                                                    int index =
                                                                        _bankName
                                                                            .indexOf(selectedItem!);
                                                                    _currentBankCode =
                                                                        _bankCode[
                                                                            index];
                                                                    _selectedBank =
                                                                        selectedItem;
                                                                  });

                                                                  _bankController
                                                                          .text =
                                                                      selectedItem!;
                                                                  _checkFieldsAndHitApi();
                                                                  // _selectedTVCode = tvBill[idx];
                                                                  // tvCable = name[idx];
                                                                  // tvImage = image[idx];
                                                                  // canProceed = true;

                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                  print(
                                                                      _selectedBank);

                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                            );
                                                          }),
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        20),
                                                            child: Divider(
                                                              thickness: 1,
                                                              color: Color(
                                                                  0xffC9C9C9),
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                );
                              },
                              onChanged: (e) {
                                _checkFieldsAndHitApi();
                                setState(() {
                                  canProceed = false;
                                });
                                // tvName = "";
                              },
                              readOnly: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              enableSuggestions: true,
                              cursorColor: colorBlack,
                              style: GoogleFonts.lato(
                                  color: colorBlack, fontSize: 14),

                              controller: _bankController,
                              textAlignVertical: TextAlignVertical.center,
                              // textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: brandOne, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE0E0E0),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 2.0), // Change color to yellow
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 12),
                                  child: Image.asset(
                                    'assets/icons/bank_icon.png',
                                    width: 26,
                                    // Ensure the image fits inside the circle
                                  ),
                                ),
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 24,
                                  color: colorBlack,
                                ),
                                filled: false,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.all(14),
                              ),
                              maxLines: 1,
                            ),

                            // GestureDetector(
                            //   onTap: _openBankSelectorOverlay,
                            //   child: AbsorbPointer(
                            //     child: bank,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.h, horizontal: 3.w),
                              child: Text(
                                'Account Number',
                                style: GoogleFonts.lato(
                                    color: colorBlack,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            accountNumber
                          ],
                        ),
                        (isChecking)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Color(0xffEEF8FF),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Center(
                                          widthFactor: 0.2,
                                          child: SizedBox(
                                            height: 20.h,
                                            width: 20.w,
                                            child: const SpinKitSpinningLines(
                                              color: brandTwo,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Text(
                                          'Verifying Account Details',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            color: brandOne,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )

                            // :(hasError == true)?Text(verifyAccountError):Text(_bankAccountName)
                            : const SizedBox(),
                        (hasError == true || verifyAccountError != '')
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    verifyAccountError,
                                    style: GoogleFonts.lato(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        (_bankAccountName != '')
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Color(0xffEEF8FF),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    _bankAccountName.capitalize!,
                                    style: GoogleFonts.lato(
                                      color: brandOne,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.h, horizontal: 3.w),
                              child: Text(
                                'Amount',
                                style: GoogleFonts.lato(
                                    color: colorBlack,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            amount
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.h, horizontal: 3.w),
                              child: Text(
                                'Narration',
                                style: GoogleFonts.lato(
                                    color: colorBlack,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            narration
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width - 50, 50),
                        backgroundColor:
                            (withdrawFormKey.currentState != null &&
                                    withdrawFormKey.currentState!.validate() &&
                                    _bankAccountName != '')
                                ? brandTwo
                                : Colors.grey,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                      onPressed: withdrawFormKey.currentState != null &&
                              withdrawFormKey.currentState!.validate()
                          ? () async {
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TransferConfirmationPage(
                                    bankName: _bankController.text,
                                    accountNumber:
                                        _accountNumberController.text,
                                    bankCode: _currentBankCode,
                                    accountName: _bankAccountName,
                                    amount: _amountController.text,
                                    narration: _narrationController.text,
                                  ),
                                ),
                              );
                              // Proceed with the action
                            }
                          : null,
                      child: Text(
                        'Proceed',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          color: (withdrawFormKey.currentState != null &&
                                  withdrawFormKey.currentState!.validate() &&
                                  _bankAccountName != '')
                              ? colorWhite
                              : colorBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                          style: GoogleFonts.lato(
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
                      FocusScope.of(context).unfocus();
                      Get.to(BvnPage(
                          email:
                              userController.userModel!.userDetails![0].email));
                    },
                    child: Text(
                      'Begin Verification',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontSize: 14, fontWeight: FontWeight.w600),
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
    );
  }

  // List<String> get _filteredBanks {
  //   if (_searchQuery.isEmpty) {
  //     return _bankName;
  //   } else {
  //     return _bankName
  //         .where((bankName) => bankName.toLowerCase().contains(_searchQuery))
  //         .toList();
  //   }
  // }
}
