import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';


import 'package:http/http.dart' as http;
import 'dart:convert';


import '../../constants/widgets/custom_dialog.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  _AddCardState createState() => _AddCardState();
}

String cardType = "";
String cardBrand = "";
String cardBank = "";
String cardValidity = "";
String cardExpiry = "";

class _AddCardState extends State<AddCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  String cardSix = "";
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> addCardformKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  // final TextEditingController _bankListController = TextEditingController();

  List<String> _bankName = [];
  String _currentBankName = 'Select bank';
  String _currentBankCode = '';
  List<String> _bankCode = [];
  bool canShowOption = false;
  bool isChecking = false;
  String _bankAccountName = "";
  String? selectedItem;

  getAccountDetails(String currentCode) async {
    setState(() {
      isChecking = true;
      _bankAccountName = "";
    });
    const String apiUrl =
        'https://api.watupay.com/v1/financial-institution/verify';
    const String bearerToken = 'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, dynamic>{
        "data": [
          {
            "financial_institution": currentCode,
            "account_id": _accountNumberController.text.trim().toString(),
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final userBankName = jsonResponse['data'][0]["account_name"];
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
        if (!context.mounted) return;
        customErrorDialog(context, "Error", 'Invalid account number');
      }

      //print(response.body);
    } else {
      // Error handling
      setState(() {
        _bankAccountName = "";
        isChecking = false;
      });
      if (!context.mounted) return;
      customErrorDialog(context, "Error", 'Something went wrong');
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

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<String> tempName = [];
      List<String> tempCode = [];
      tempName.add("Select bank");
      for (var item in jsonResponse['data']) {
        String localCode = item['local_code'] ?? 'N/A';
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
      setState(() {
        canShowOption = true;
      });
    } else {
      print('Failed to load data from the server');
    }
  }

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
    setState(() {
      cardValidity = "";
      cardBank = "";
      cardBrand = "";
      cardType = "";
      cardExpiry = "";
    });
    getBanksList();
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

    validateName(nameValue) {
      if (nameValue.isEmpty) {
        return 'account name cannot be empty';
      }

      return '';
    }

    void _doSomething() async {
      // if ((cardNumber != "" &&
      //         expiryDate != "" &&
      //         cardHolderName != "" &&
      //         cvvCode != "" &&
      //         cardValidity != "Invalid Card" &&
      //         cardExpiry != "Expired Card") ||
      //     (_bankAccountName != "" &&
      //         _accountNumberController.text.trim() != "" &&
      //         (validateNumber(_accountNumberController.text.trim()) == "" &&
      //             validateName(_bankAccountName) == ""))) {
      //   var userUpdate = FirebaseFirestore.instance.collection('accounts');

      //   await userUpdate.doc(userId).update({
      //     'card_cvv': cvvCode,
      //     'card_expire': expiryDate,
      //     'card_digit': cardNumber,
      //     'card_holder': cardHolderName,
      //     'bank_name': _currentBankName,
      //     'account_name': _bankAccountName,
      //     'account_number': _accountNumberController.text.trim()
      //   }).then((value) {
      //     Get.back();
      //     print(_bankName);
      //     showTopSnackBar(
      //       Overlay.of(context),
      //       CustomSnackBar.success(
      //         backgroundColor: brandOne,
      //         message: 'Your details have been updated successfully. !!',
      //         textStyle: GoogleFonts.nunito(
      //           fontSize: 14,
      //           color: Colors.white,
      //           fontWeight: FontWeight.w700,
      //         ),
      //       ),
      //     );

      //   }).catchError((error) {
      //     if (!context.mounted) return;
      //     customErrorDialog(context, "Error", error.toString());

      //   });

      // } else {
      //   if (!context.mounted) return;
      //   customErrorDialog(
      //       context, "Invalid", 'Fill the form properly to proceed.');

      // }
    }

    // final banksList = CustomDropdown(
    //   selectedStyle: GoogleFonts.nunito(
    //       color: Theme.of(context).primaryColor, fontSize: 14),
    //   hintText: 'Select an option?',
    //   excludeSelected: true,
    //   fillColor: Colors.transparent,
    //   listItemStyle: GoogleFonts.nunito(
    //       color: Theme.of(context).colorScheme.secondary, fontSize: 14),
    //   items: _bankName,
    //   controller: bankNameController,
    //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
    //   fieldSuffixIcon: Icon(
    //     Iconsax.arrow_down5,
    //     size: 25.h,
    //     color: Theme.of(context).primaryColor,
    //   ),
    //   onChanged: (newValue) {
    //     setState(() {
    //       _currentBankName = newValue.toString();
    //       selectedItem = newValue as String?;
    //       int index = _bankName.indexOf(selectedItem!);
    //       _currentBankCode = _bankCode[index - 1];
    //     });
    //   },
    // );
    // final bankOption = DropdownButtonFormField(
    //   style: GoogleFonts.nunito(
    //     color: Theme.of(context).primaryColor,
    //     fontSize: 16,
    //     fontWeight: FontWeight.w600,
    //   ),
    //   items: _bankName
    //       .map((value) => DropdownMenuItem(
    //             value: value,
    //             child: Text(value),
    //           ))
    //       .toList(),
    //   onChanged: (newValue) {
    //     setState(() {
    //       _currentBankName = newValue.toString();
    //       selectedItem = newValue as String?;
    //       int index = _bankName.indexOf(selectedItem!);
    //       _currentBankCode = _bankCode[index - 1];
    //     });
    //   },
    //   decoration: InputDecoration(
    //     hintText: 'Choose Bank',
    //     hintStyle: GoogleFonts.nunito(
    //       color: Colors.grey,
    //       fontSize: 12,
    //       fontWeight: FontWeight.w400,
    //     ),
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //       borderSide: const BorderSide(
    //         color: Color(0xffE0E0E0),
    //       ),
    //     ),
    //     focusedBorder: const OutlineInputBorder(
    //       borderSide: BorderSide(color: brandOne, width: 2.0),
    //     ),
    //     enabledBorder: const OutlineInputBorder(
    //       borderSide: BorderSide(
    //         color: Color(0xffE0E0E0),
    //       ),
    //     ),
    //     errorBorder: const OutlineInputBorder(
    //       borderSide: BorderSide(
    //           color: Colors.red, width: 2.0), // Change color to yellow
    //     ),
    //     contentPadding: const EdgeInsets.all(14),
    //   ),
    // );

// final banks = Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Text(widget.title),
//         const SizedBox(
//           height: 5.0,
//         ),
//         TextFormField(
//           controller: _bankListController,
//           cursorColor: Colors.black,
//           onTap: widget.isCitySelected
//               ? () {
//                   FocusScope.of(context).unfocus();
//                   onTextFieldTap();
//                 }
//               : null,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.black12,
//             contentPadding:
//                 const EdgeInsets.only(left: 8, bottom: 0, top: 0, right: 15),
//             hintText: widget.hint,
//             border: const OutlineInputBorder(
//               borderSide: BorderSide(
//                 width: 0,
//                 style: BorderStyle.none,
//               ),
//               borderRadius: BorderRadius.all(
//                 Radius.circular(8.0),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 15.0,
//         ),
//       ],
//     );
    // final bankOptions = DropdownMenu(
    //   // width: 300,
    //   // menuStyle: MenuStyle,
    //   enableSearch: true,
    //   enableFilter: true,
    //   onSelected: (newValue) {
    //     setState(() {
    //       _currentBankName = newValue.toString();
    //       selectedItem = newValue as String?;
    //       int index = _bankName.indexOf(selectedItem!);
    //       _currentBankCode = _bankCode[index - 1];
    //     });
    //   },
    //   dropdownMenuEntries: _bankName
    //       .map((value) => DropdownMenuEntry(
    //             value: value,
    //             label: value,
    //           ))
    //       .toList(),
    //   hintText: 'Choose Bank',
    //   inputDecorationTheme: InputDecorationTheme(
    //     hintStyle: GoogleFonts.nunito(
    //       color: Colors.grey,
    //       fontSize: 12,
    //       fontWeight: FontWeight.w400,
    //     ),
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //       borderSide: const BorderSide(
    //         color: Color(0xffE0E0E0),
    //       ),
    //     ),
    //     focusedBorder: const OutlineInputBorder(
    //       borderSide: BorderSide(color: brandOne, width: 2.0),
    //     ),
    //     enabledBorder: const OutlineInputBorder(
    //       borderSide: BorderSide(
    //         color: Color(0xffE0E0E0),
    //       ),
    //     ),
    //     errorBorder: const OutlineInputBorder(
    //       borderSide: BorderSide(
    //           color: Colors.red, width: 2.0), // Change color to yellow
    //     ),
    //     contentPadding: const EdgeInsets.all(14),
    //     filled: false,
    //   ),
    // );

    // void showSnackBar(String message) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text(message)));
    // }

    // final banks = TextFormField(
    //   controller: _bankListController,
    //   cursorColor: Colors.black,
    //   onTap: () {
    //     FocusScope.of(context).unfocus();
    //     DropDownState(
    //       DropDown(
    //         isDismissible: true,
    //         bottomSheetTitle: const Text(
    //           'List of Banks',
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 20.0,
    //           ),
    //         ),
    //         submitButtonChild: const Text(
    //           'Done',
    //           style: TextStyle(
    //             fontSize: 16,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         data: _bankName
    //             .map((value) => SelectedListItem(
    //                   name: value,
    //                   value: value,
    //                   isSelected: true,
    //                 ))
    //             .toList(),
    //         selectedItems: (List<dynamic> selectedList) {
    //           List<String> list = [];
    //           for (var item in selectedList) {
    //             if (item is SelectedListItem) {
    //               list.add(item.name);
    //               print(item.name);
    //               // _currentBankName = item.name;
    //               // selectedItem = item.name;
    //               // int index = _bankName.indexOf(selectedItem!);
    //               // _currentBankCode = _bankCode[index - 1];
    //             }
    //           }

    //           showSnackBar(selectedList.toString());
    //         },
    //         enableMultipleSelection: false,
    //       ),
    //     ).showModal(context);
    //   },
    //   decoration: InputDecoration(
    //     filled: true,
    //     fillColor: Colors.black12,
    //     contentPadding:
    //         const EdgeInsets.only(left: 8, bottom: 0, top: 0, right: 15),
    //     hintText: 'Select Bank',
    //     border: const OutlineInputBorder(
    //       borderSide: BorderSide(
    //         width: 0,
    //         style: BorderStyle.none,
    //       ),
    //       borderRadius: BorderRadius.all(
    //         Radius.circular(8.0),
    //       ),
    //     ),
    //   ),
    // );

    final accountNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateNumber,
      controller: _accountNumberController,
      keyboardType: TextInputType.number,
      maxLength: 10,
      onChanged: (e) {
        if (_accountNumberController.text.trim().length == 10) {
          getAccountDetails(_currentBankCode);
        }
      },
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
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        fillColor: brandThree,
        hintText: 'Enter your account number...',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Add Bank & Card Details',
          style: GoogleFonts.nunito(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                CreditCardWidget(
                  glassmorphismConfig:
                      useGlassMorphism ? Glassmorphism.defaultConfig() : null,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  bankName: '   ',
                  frontCardBorder:
                      !useGlassMorphism ? Border.all(color: Colors.grey) : null,
                  backCardBorder:
                      !useGlassMorphism ? Border.all(color: Colors.grey) : null,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: brandOne,
                  backgroundImage: 'assets/card.jpg',
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/icons/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: addCardformKey,
                        obscureCvv: false,
                        obscureNumber: false,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: brandOne,
                        textColor: Theme.of(context).primaryColor,
                        cardNumberDecoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Color(0xffE0E0E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                                const BorderSide(color: brandOne, width: 2.0),
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
                                color: Colors.red,
                                width: 2.0), // Change color to yellow
                          ),
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          hintStyle: GoogleFonts.nunito(
                            color: Theme.of(context).primaryColor,
                          ),
                          labelStyle: GoogleFonts.nunito(
                            color: Theme.of(context).primaryColor,
                          ),
                          contentPadding: const EdgeInsets.all(14),
                        ),
                        expiryDateDecoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Color(0xffE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide:
                                  const BorderSide(color: brandOne, width: 2.0),
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
                                  color: Colors.red,
                                  width: 2.0), // Change color to yellow
                            ),
                            hintStyle: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                            ),
                            labelStyle: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Expiry Date',
                            hintText: 'XX/XX',
                            contentPadding: const EdgeInsets.all(14)),
                        cvvCodeDecoration: InputDecoration(
                          hintStyle: GoogleFonts.nunito(
                            color: Theme.of(context).primaryColor,
                          ),
                          labelStyle: GoogleFonts.nunito(
                            color: Theme.of(context).primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Color(0xffE0E0E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                                const BorderSide(color: brandOne, width: 2.0),
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
                                color: Colors.red,
                                width: 2.0), // Change color to yellow
                          ),
                          labelText: 'CVV',
                          hintText: 'XXX',
                          contentPadding: const EdgeInsets.all(14),
                        ),
                        cardHolderDecoration: InputDecoration(
                          hintStyle: GoogleFonts.nunito(
                            color: Theme.of(context).primaryColor,
                          ),
                          labelStyle: GoogleFonts.nunito(
                            color: Theme.of(context).primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Color(0xffE0E0E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                                const BorderSide(color: brandOne, width: 2.0),
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
                                color: Colors.red,
                                width: 2.0), // Change color to yellow
                          ),
                          labelText: 'Card Holder',
                          contentPadding: const EdgeInsets.all(14),
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 2, 20, 2),
                        child: Text(
                          (cardValidity == "Valid Card" || cardValidity == "")
                              ? ""
                              : "Invalid Card",
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            // fontFamily: "DefaultFontFamily",
                            // letterSpacing: 0.5,
                            color: (cardValidity == "Valid Card")
                                ? Colors.greenAccent
                                : Colors.red,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 2, 20, 2),
                        child: Text(
                          (cardExpiry == "Expired Card") ? "Expired Card" : "",
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            color: (cardValidity == "Expired Card")
                                ? Colors.greenAccent
                                : Colors.red,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 10),
                        child: Text(
                          "Add your bank details",
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            // fontFamily: "DefaultFontFamily",
                            // letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      (canShowOption)
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 2, 15.0, 2),
                                  child: CustomDropdown(
                                    selectedStyle: GoogleFonts.nunito(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 14),
                                    hintText: 'Select an option?',
                                    excludeSelected: true,
                                    fillColor: Colors.transparent,
                                    listItemStyle: GoogleFonts.nunito(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 14),
                                    items: _bankName,
                                    controller: bankNameController,
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    fieldSuffixIcon: Icon(
                                      Iconsax.arrow_down5,
                                      size: 25.h,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _currentBankName = newValue.toString();
                                        selectedItem = newValue as String?;
                                        int index =
                                            _bankName.indexOf(selectedItem!);
                                        _currentBankCode = _bankCode[index - 1];
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 2, 15.0, 2),
                                  child: accountNumber,
                                ),
                              ],
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 10, 20.0, 10),
                              child: Text(
                                "Loading banks...",
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  // fontFamily: "DefaultFontFamily",
                                  //letterSpacing: 2.0,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                      (isChecking)
                          ? const Padding(
                              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
                              child: CustomLoader(),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 10),
                        child: Text(
                          _bankAccountName,
                          style: GoogleFonts.nunito(
                            fontSize: 16.0,
                            // fontFamily: "DefaultFontFamily",
                            // letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(350, 50),
                          backgroundColor: brandOne,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () {
                          _doSomething();
                        },
                        child: Text(
                          'Submit',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(color: Colors.white),
                        ),
                      ),

                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onValidate() {
    if (addCardformKey.currentState!.validate()) {
      print('valid!');
    } else {
      print('invalid!');
    }
  }

  verifyCard(String cardFirstSix) async {
    String apiUrl = "https://api.watupay.com/v1/verify/bin/$cardFirstSix";
    const String bearerToken = 'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        cardType = jsonResponse['data']["card_type"];
        cardBrand = jsonResponse['data']["card_brand"];
        cardBank = jsonResponse['data']['bank']["name"];
        cardValidity = "Valid Card";
      });
    } else {
      setState(() {
        cardType = "";
        cardBrand = "";
        cardBank = "";
        cardValidity = "Invalid Card";
      });
      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    if (creditCardModel!.cardNumber.replaceAll(' ', '').length == 6) {
      setState(() {
        cardSix = creditCardModel.cardNumber.toString();
      });

      print(cardSix.replaceAll(' ', ''));
      verifyCard(creditCardModel.cardNumber.replaceAll(' ', ''));
    }

    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
    if (expiryDate.length == 5) {
      int? month = int.tryParse(expiryDate.substring(0, 2));
      int? year = int.tryParse('20${expiryDate.substring(3)}');
      final currentDate = DateTime.now();
      final lastDateOfExpiryMonth = DateTime(year!, month! + 1, 0);
      if (currentDate.isAfter(lastDateOfExpiryMonth)) {
        setState(() {
          cardExpiry = "Expired Card";
        });
      } else {
        setState(() {
          cardExpiry = "";
        });
      }
    }
  }
}
