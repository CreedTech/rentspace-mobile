import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
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

class _TransferPageState extends State<TransferPage> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final withdrawFormKey = GlobalKey<FormState>();
  String? _selectedBank;
  String _bankAccountName = "";
  String _currentBankCode = '';
  bool hasError = false;
  String verifyAccountError = "";
  String _message = '';
  bool isChecking = false;

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
      await userController.fetchData();
      await walletController.fetchWallet();
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

// Function to check if both fields are not empty and initiate API call
  void _checkFieldsAndHitApi() {
    if (withdrawFormKey.currentState!.validate() && _selectedBank != null) {
      getAccountDetails(_currentBankCode);
    }
  }

  @override
  void initState() {
    super.initState();
    // Initially, the message is null
    _message = '';
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
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

//     String? editedValue;

// // Define a function to handle editing completion
//     void handleEditingComplete(String? val) {
//       editedValue = val;
//       if (val == null || val.isEmpty) {
//         // Handle empty value
//       } else {
//         // Handle non-empty value
//       }
//     }

    final accountNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateNumber,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: _accountNumberController,
      keyboardType: TextInputType.number,
      onChanged: (e) {
        _checkFieldsAndHitApi();
      },
      // onEditingComplete: handleEditingComplete(editedValue),

      maxLength: 10,
      decoration: InputDecoration(
        //prefix: Icon(Icons.email),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        contentPadding: const EdgeInsets.all(14),
        filled: false,
        hintText: 'Enter 10 digits Account Number',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    final bank = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
        fontSize: 14.sp,
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
        suffixIcon: Icon(
          Icons.arrow_forward_ios,
          size: 15.h,
          color: Colors.grey,
        ),
        //prefix: Icon(Icons.email),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        contentPadding: const EdgeInsets.all(14),
        filled: false,
        hintText: _selectedBank ?? 'Tap to select bank',
        hintStyle: GoogleFonts.nunito(
          color: _selectedBank == null ? Colors.grey : brandOne,
          fontSize: 12.sp,
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
            Icons.arrow_back_ios,
            size: 20.sp,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Transfer to Bank Account',
          style: GoogleFonts.nunito(
            color: brandOne,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: (userController.userModel!.userDetails![0].hasBvn == true)
          ? Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 20.w,
              ),
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: brandTwo.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Please note that charging of ₦20.00 on all  transfers will be according to our Terms of use',
                      style: GoogleFonts.nunito(
                        color: brandOne.withOpacity(0.7),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
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
                          padding: const EdgeInsets.fromLTRB(10, 5, 0.0, 0),
                          child: Text(
                            "Recipient Account",
                            style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5, 0.0, 5),
                          child: accountNumber,
                        ),
                        GestureDetector(
                          onTap: _openBankSelectorOverlay,
                          child: AbsorbPointer(
                            child: bank,
                          ),
                        ),
                        // Text(_selectedBank ?? 'Tap to select bank'),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 20.h,
                  // ),
                  (isChecking)
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: brandTwo.withOpacity(0.2),
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
                                    style: GoogleFonts.nunito(
                                      color: brandOne,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  // flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: 10.w, left: 10.w),
                                    child: const Icon(
                                      Iconsax.close_circle5,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 6,
                                  child: Text(
                                    verifyAccountError,
                                    style: GoogleFonts.nunito(
                                      color: Colors.red,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  (_bankAccountName != '')
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: brandTwo.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  // flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: 10.w, left: 10.w),
                                    child: const Icon(
                                      Icons.verified,
                                      color: brandOne,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 6,
                                  child: Text(
                                    _bankAccountName,
                                    style: GoogleFonts.nunito(
                                      color: brandOne,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 40.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(250, 50),
                        backgroundColor:
                            (withdrawFormKey.currentState != null &&
                                    withdrawFormKey.currentState!.validate() &&
                                    _bankAccountName != '')
                                ? brandOne
                                : Colors.grey,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                      ),
                      onPressed: withdrawFormKey.currentState != null &&
                              withdrawFormKey.currentState!.validate()
                          ? () async {
                              FocusScope.of(context).unfocus();
                            
                              await fetchUserData()
                                  .then(
                                    (value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TransferPaymentPage(
                                                bankName: _bankController.text,
                                                accountNumber:
                                                    _accountNumberController
                                                        .text,
                                                bankCode: _currentBankCode,
                                                accountName: _bankAccountName),
                                      ),
                                    ),
                                  )
                                  .catchError(
                                    (error) => {
                                      customErrorDialog(context, 'Oops',
                                          'Something went wrong. Try again later'),
                                    },
                                  );
                              // Proceed with the action
                            }
                          : null,
                      child: Text(
                        'Next',
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
                      FocusScope.of(context).unfocus();
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
