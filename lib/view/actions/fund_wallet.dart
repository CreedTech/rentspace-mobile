import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/view/actions/wallet_funding.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class FundWallet extends StatefulWidget {
  const FundWallet({Key? key}) : super(key: key);

  @override
  _FundWalletState createState() => _FundWalletState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
String _isSet = "false";
var dum1 = "".obs;
CollectionReference users = FirebaseFirestore.instance.collection('accounts');
CollectionReference allUsers =
    FirebaseFirestore.instance.collection('accounts');

class _FundWalletState extends State<FundWallet> {
  final UserController userController = Get.find();
  final form = intl.NumberFormat.decimalPattern();

  TextEditingController _amountController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    validateAmount(amountValue) {
      if (amountValue.isEmpty) {
        return 'amount cannot be empty';
      }
      if (int.tryParse(_amountController.text.trim().replaceAll(',', '')) ==
          null) {
        return 'enter valid number';
      }
      if ((int.tryParse(_amountController.text.trim().replaceAll(',', '')) ==
              0) ||
          (int.tryParse(_amountController.text.trim().replaceAll(',', ''))! <
              100)) {
        return 'minimum amount is ₦100';
      }
      if (int.tryParse(_amountController.text.trim().replaceAll(',', ''))!
          .isNegative) {
        return 'enter valid number';
      }
      return '';
    }

    final amount = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _amountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [ThousandsFormatter()],
      validator: validateAmount,
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: const Text(
          "Enter amount",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        prefixText: "₦",
        prefixStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        filled: true,
        fillColor: brandThree,
        hintText: 'amount in Naira',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
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
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/icons/RentSpace-icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 60, 20, 2),
            child: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      "Fund your SpaceWallet",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "DefaultFontFamily",
                        letterSpacing: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    amount,
                    const SizedBox(
                      height: 20,
                    ),
                    GFButton(
                      onPressed: () async {
                        if (validateAmount(_amountController.text
                                .trim()
                                .replaceAll(',', '')) ==
                            "") {
                          Get.to(WalletFunding(
                            amount: int.tryParse(_amountController.text
                                .trim()
                                .replaceAll(',', ''))!,
                            date: formattedDate,
                            interval: "",
                            numPayment: 1,
                            savingsID: userController.user[0].userId,
                          ));
                        } else {
                          Get.snackbar(
                            "Invalid",
                            "Fill the form properly to proceed",
                            animationDuration: const Duration(seconds: 1),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      shape: GFButtonShape.pills,
                      fullWidthButton: true,
                      color: brandOne,
                      child: const Text(
                        'Fund now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: "DefaultFontFamily",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                (userController.user[0].hasDva == 'true')
                    ? Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Or use your DVA to Fund your\nSpaceWallet',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 25,
                                fontFamily: "DefaultFontFamily",
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Account Name: ${userController.user[0].dvaName}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontFamily: "DefaultFontFamily",
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Account Number: ${userController.user[0].dvaNumber}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontFamily: "DefaultFontFamily",
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Bank Name: GTBank',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontFamily: "DefaultFontFamily",
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              '(Note that this can take few minutes for your transaction to be verified)',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontFamily: "DefaultFontFamily",
                              ),
                            ),
                            GFButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: userController.user[0].dvaNumber,
                                  ),
                                );
                                Fluttertoast.showToast(
                                  msg: "Account Number copied to clipboard!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: brandOne,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              },
                              shape: GFButtonShape.pills,
                              fullWidthButton: true,
                              color: brandOne,
                              child: const Text(
                                'Copy Account Number',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: "DefaultFontFamily",
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
