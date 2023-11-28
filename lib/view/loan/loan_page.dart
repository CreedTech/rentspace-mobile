import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:rentspace/view/actions/onboarding_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math';
import 'dart:async';

String _hasBvn = "";
String _hasKyc = "";
int _interest = 1;
String _userFirst = "";
String _userLast = "";
String _userId = "";
var now = DateTime.now();
var ch8t = NumberFormat.simpleCurrency(name: 'NGN');

var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);

class LoanPage extends StatefulWidget {
  const LoanPage({Key? key}) : super(key: key);

  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  Timer? timer;

  String duration = "Days";
  final form = intl.NumberFormat.decimalPattern();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  getUser() async {
    var collection = FirebaseFirestore.instance.collection('accounts');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        _userFirst = data?['firstname'];
        _userLast = data?['lastname'];
        _userId = data?['rentspace_id'];
        _hasBvn = data?['bvn'];
        _hasKyc = data?['kyc_details'];
      });
    }
  }

  @override
  initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    validateReason(reasonValue) {
      if (reasonValue.isEmpty) {
        return 'Enter a value';
      }

      return '';
    }

    validateAmount(amountValue) {
      if (amountValue.isEmpty) {
        return 'amount cannot be empty';
      }
      if (int.tryParse(amountValue) == null) {
        return 'enter valid number';
      }
      if (int.tryParse(amountValue)!.isNegative) {
        return 'enter positive number';
      }
      return '';
    }

    validateDuration(durationVal) {
      if (durationVal.isEmpty) {
        return 'duration cannot be empty';
      }
      if (int.tryParse(durationVal) == null) {
        return 'enter valid number';
      }
      return '';
    }

    //duration
    final payDuration = Container(
      height: 60,
      width: MediaQuery.of(context).size.width / 3,
      margin: EdgeInsets.all(20),
      child: DropdownButtonHideUnderline(
        child: GFDropdown(
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Theme.of(context).canvasColor,
          value: duration,
          hint: Text(
            'select duration',
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
          focusColor: brandTwo,
          onChanged: (newValue) {
            setState(() {
              duration = newValue.toString();
            });
          },
          items: [
            'Days',
            'Weeks',
            'Months',
            'Years',
          ]
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
        ),
      ),
    );
    final amount = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _amountController,
      onChanged: (value) {
        if (value.isNum &&
            value.isNotEmpty &&
            _durationController.text.trim() != '') {
          if (duration == 'Days') {
            setState(() {
              _interest = int.tryParse(value)! *
                  5 *
                  int.tryParse(_durationController.text.trim())!;
            });
          }
          if (duration == 'Weeks') {
            setState(() {
              _interest = int.tryParse(value)! *
                  100 *
                  int.tryParse(_durationController.text.trim())!;
            });
          }
          if (duration == 'Months') {
            setState(() {
              _interest = int.tryParse(value)! *
                  200 *
                  int.tryParse(_durationController.text.trim())!;
            });
          }
          if (duration == 'Years') {
            setState(() {
              _interest = int.tryParse(value)! *
                  500 *
                  int.tryParse(_durationController.text.trim())!;
            });
          }
        } else {
          null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(
          "How much loan do you want to take?",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        prefixText: "₦",
        prefixStyle: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
        border: InputBorder.none,
        filled: true,
        fillColor: brandThree,
        hintText: 'enter amount in Naira',
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
    );
    final durationValue = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _durationController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateDuration,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(
          "Duration",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        border: InputBorder.none,
        filled: true,
        fillColor: brandThree,
        hintText: 'enter duration',
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
    );
    final reasonValue = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _reasonController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateReason,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        label: Text(
          "Description",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        border: InputBorder.none,
        filled: true,
        fillColor: brandThree,
        hintText: 'why are you taking the loan?',
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
    );
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
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: (_hasBvn != "" && _hasKyc != "")
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Text(
                    "Select duration first, then enter amount to see repayment amount in realtime",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "DefaultFontFamily",
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: durationValue,
                        ),
                        payDuration,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  reasonValue,
                  SizedBox(
                    height: 20,
                  ),
                  amount,
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Repayment: ₦${form.format(_interest)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "DefaultFontFamily",
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RoundedLoadingButton(
                    child: Text(
                      'Apply for loan account',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "DefaultFontFamily",
                      ),
                    ),
                    elevation: 0.0,
                    successColor: brandOne,
                    color: brandTwo,
                    controller: _btnController,
                    onPressed: () async {
                      if (validateAmount(_amountController.text.trim()) == "" &&
                          validateReason(_reasonController.text.trim()) == "" &&
                          _interest != 1) {
                        var userUpdate =
                            FirebaseFirestore.instance.collection('accounts');

                        var updateLoan =
                            FirebaseFirestore.instance.collection('space_loan');
                        await userUpdate.doc(userId).update({
                          'has_rent': 'true',
                          "activities": FieldValue.arrayUnion(
                            [
                              "$formattedDate\nLoan requested for ${_reasonController.text.trim()}\nAmount: ${ch8t.format(double.tryParse(_amountController.text.trim()))}",
                            ],
                          ),
                        });
                        await updateLoan.add({
                          'user_id': _userId,
                          'first_name': _userFirst,
                          'last_name': _userLast,
                          'date': formattedDate,
                          'loan_amount': _amountController.text.trim(),
                          'duration':
                              _durationController.text.trim() + " " + duration,
                          'reason': _reasonController.text.trim(),
                          'status': 'pending',
                          'repayment': _interest,
                        }).then((value) {
                          Timer(Duration(seconds: 1), () {
                            _btnController.stop();
                          });
                          setState(() {
                            _amountController.clear();
                            _durationController.clear();
                            _reasonController.clear();
                            _interest = 0;
                            duration = 'Days';
                          });
                          Get.snackbar(
                            "Received",
                            "Loan request received",
                            animationDuration: Duration(seconds: 2),
                            backgroundColor: brandOne,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                        }).catchError((error) {
                          Get.snackbar(
                            "Oops",
                            "Something went wrong, try again later",
                            animationDuration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        });
                      } else {
                        Timer(Duration(seconds: 1), () {
                          _btnController.stop();
                        });
                        Get.snackbar(
                          "Invalid",
                          'Please fill the form properly to proceed',
                          animationDuration: Duration(seconds: 1),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              )
            : Center(
                child: GFButton(
                  onPressed: () {
                    Get.to(BvnPage());
                  },
                  size: 30.0,
                  icon: Icon(
                    Icons.add_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  text: "Complete your verification",
                  textStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontFamily: "DefaultFontFamily",
                  ),
                  padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                  shape: GFButtonShape.pills,
                ),
              ),
      ),
    );
  }
}
