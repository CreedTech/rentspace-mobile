import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_payment.dart';
import 'package:rentspace/view/terms_and_conditions.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class SpaceDepositSubscription extends StatefulWidget {
  const SpaceDepositSubscription({Key? key}) : super(key: key);

  @override
  _SpaceDepositSubscriptionState createState() =>
      _SpaceDepositSubscriptionState();
}

var ch8t = NumberFormat.simpleCurrency(name: 'NGN');
var varValue = "".obs;
String interestValue = "0";
String interestText = "Fill all the fields to see your interest.";
String amountNotice = "";
bool showNotice = false;
String interestType = "Empty";
bool showInterest = false;
bool showSaveButton = false;
final _history = [];
String _userFirst = '';
String _userLast = '';
String _userAddress = '';
String _userMail = '';
String _userID = '';
String _id = '';
String _rentSpaceID = '';
String _amountValue = "";
String _nameValue = "";
String _durationValue = "1";
int durationVal = 1;

const _chars = '1234567890';
Random _rnd = Random();
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
String durationType = "Days";

final TextEditingController _depositAmountController = TextEditingController();
final TextEditingController _planNameController = TextEditingController();
final TextEditingController _planDurationController = TextEditingController();
final RoundedLoadingButtonController _depositController =
    RoundedLoadingButtonController();

class _SpaceDepositSubscriptionState extends State<SpaceDepositSubscription> {
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
        _userFirst = data?['firstname'];
        _userLast = data?['lastname'];
        _userAddress = data?['address'];
        _userMail = data?['email'];
        _userID = data?['rentspace_id'];
        _id = data?['id'];
        _rentSpaceID = getRandom(20);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      showInterest = false;
      interestValue = "0";
      amountNotice = "";
      showNotice = false;
      showSaveButton = false;
      interestText = "";
      _depositAmountController.clear();
      _planNameController.clear();
      _planDurationController.clear();
    });
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
//change duration value
    changeDuration() {
      if (durationType == "Days") {
        setState(() {
          durationVal = 365;
        });
      } else if (durationType == "Weeks") {
        setState(() {
          durationVal = 62;
        });
      } else {
        setState(() {
          durationVal = 12;
        });
      }
    }

//calculate interest
    String calculateInterest() {
      //50k to 1m, 7% interest
      if ((int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! >=
              500) &&
          (int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! <
              1000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _depositAmountController.text.trim().replaceAll(',', ''))! *
                0.07 *
                ((int.tryParse(_planDurationController.text.trim())!) /
                    durationVal))
            .toString();
      }
      //1m to 2m, 7.5% interest
      else if ((int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! >=
              1000000) &&
          (int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! <
              2000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _depositAmountController.text.trim().replaceAll(',', ''))! *
                0.075 *
                ((int.tryParse(_planDurationController.text.trim())!) /
                    durationVal))
            .toString();
      }
      //2m to 5m, 8.25% interest
      else if ((int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! >=
              2000000) &&
          (int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! <
              5000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _depositAmountController.text.trim().replaceAll(',', ''))! *
                0.0825 *
                ((int.tryParse(_planDurationController.text.trim())!) /
                    durationVal))
            .toString();
      }
      //5m to 10m, 9% interest
      else if ((int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! >=
              5000000) &&
          (int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! <
              10000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _depositAmountController.text.trim().replaceAll(',', ''))! *
                0.09 *
                ((int.tryParse(_planDurationController.text.trim())!) /
                    durationVal))
            .toString();
      }
      //10m to 20m, 10.25% interest
      else if ((int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! >=
              10000000) &&
          (int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! <
              20000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _depositAmountController.text.trim().replaceAll(',', ''))! *
                0.1025 *
                ((int.tryParse(_planDurationController.text.trim())!) /
                    durationVal))
            .toString();
      }
      //20m to 30m, 12% interest
      else if ((int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! >=
              20000000) &&
          (int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! <
              30000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _depositAmountController.text.trim().replaceAll(',', ''))! *
                0.12 *
                ((int.tryParse(_planDurationController.text.trim())!) /
                    durationVal))
            .toString();
      }
      //30m to 50m, 14% interest
      else if ((int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! >=
              30000000) &&
          (int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! <
              50000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _depositAmountController.text.trim().replaceAll(',', ''))! *
                0.14 *
                ((int.tryParse(_planDurationController.text.trim())!) /
                    durationVal))
            .toString();
      } else {
        setState(() {
          amountNotice = "Please contact us for a conversational interest.";
          showNotice = true;
          showSaveButton = false;
        });
        return interestValue = "1";
      }
    }

//check duration
    checkDuration() {
      //check duration -- amount / duration
      if ((durationType == "Months") &&
          (int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! <
              50000)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Minimum amount is ₦50,000 per month";
        });
      } else if ((durationType == "Weeks") &&
          (int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))! <
              5000)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Minimum amount is ₦5,000 per week";
        });
      } else if ((durationType == "Days") &&
          ((int.tryParse(
                  _depositAmountController.text.trim().replaceAll(',', ''))!) <
              500)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Minimum amount is ₦500 per day";
        });
      }
      //check duration -- maximum duration
      else if ((durationType == "Months") &&
          (int.tryParse(_planDurationController.text.trim())! > 24)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Maximum duration is 24 months";
        });
      } else if ((durationType == "Weeks") &&
          ((int.tryParse(_planDurationController.text.trim())!) > 104)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Maximum duration is 104 weeks";
        });
      } else if ((durationType == "Days") &&
          ((int.tryParse(_planDurationController.text.trim())!) > 760)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Maximum duration is 760 days";
        });
      }
      //check duration -- minimum duration
      else if ((durationType == "Months") &&
          (int.tryParse(_planDurationController.text.trim())! < 6)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Minimum duration is 6 months";
        });
      } else if ((durationType == "Weeks") &&
          ((int.tryParse(_planDurationController.text.trim())!) < 26)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Minimum duration is 26 weeks";
        });
      } else if ((durationType == "Days") &&
          ((int.tryParse(_planDurationController.text.trim())!) < 182)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Minimum duration is 182 days";
        });
      } else {
        setState(() {
          interestValue = calculateInterest();
          interestText = "";
        });
      }
      print("Duration: " +
          _planDurationController.text.trim() +
          " " +
          durationType);
    }

//validation function
    validateAmount(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if ((int.tryParse(text.replaceAll(',', ''))! >= 1) &&
          (int.tryParse(text.replaceAll(',', ''))! < 500)) {
        return 'minimum amount is ₦500';
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

    validateDuration(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (int.tryParse(text) == null) {
        return 'enter valid number';
      }
      if (int.tryParse(text) == 0) {
        return 'number cannot be zero';
      }

      if (int.tryParse(text)!.isNegative) {
        return 'enter positive number';
      }
      return '';
    }

    //validation function
    validateName(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (text.length < 1) {
        return 'Too short';
      }

      return '';
    }

/////get savingsID
    String getRandom(int length) => String.fromCharCodes(
          Iterable.generate(
            length,
            (_) => _chars.codeUnitAt(
              _rnd.nextInt(_chars.length),
            ),
          ),
        );

    final autoAmount = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _depositAmountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      // update the state variable when the text changes
      onChanged: (text) {
        setState(() => _amountValue = text);
        changeDuration();
        if ((validateAmount(_depositAmountController.text.trim()) == "") &&
            (validateDuration(_planDurationController.text.trim()) == "")) {
          checkDuration();
        } else {
          setState(() {
            showInterest = false;
            interestValue = "0";
          });
        }
      },
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsFormatter()],
      decoration: InputDecoration(
        label: Text(
          "How much do you want to fix?",
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
        prefix: Text(
          "₦" + varValue.toString(),
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
    final planDuration = TextFormField(
      enableSuggestions: true,

      cursorColor: Colors.black,
      controller: _planDurationController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateDuration,
      // update the state variable when the text changes
      onChanged: (text) {
        setState(() => _durationValue = text);
        changeDuration();

        if ((validateAmount(_depositAmountController.text.trim()) == "") &&
            (validateDuration(_planDurationController.text.trim()) == "")) {
          checkDuration();
        } else {
          setState(() {
            showInterest = false;
            interestValue = "0";
          });
        }
      },
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [],
      decoration: InputDecoration(
        label: Text(
          "How long do you want to fix this savings for?",
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
        hintText: 'Enter a value',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
    final planName = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _planNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateName,
      // update the state variable when the text changes
      onChanged: (text) => setState(() => _nameValue = text),
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      inputFormatters: [],
      decoration: InputDecoration(
        label: Text(
          " What name would you give this savings?",
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
        hintText: 'E.g First deposit',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );

    final durationOption = Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20),
      child: DropdownButtonHideUnderline(
        child: GFDropdown(
          borderRadius: BorderRadius.circular(10),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Theme.of(context).canvasColor,
          dropdownColor: Theme.of(context).canvasColor,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          value: durationType,
          onChanged: (newValue) {
            setState(() {
              durationType = newValue.toString();
            });
            changeDuration();

            if ((validateAmount(_depositAmountController.text.trim()) == "") &&
                (validateDuration(_planDurationController.text.trim()) == "")) {
              checkDuration();
            } else {
              setState(() {
                showInterest = false;
                interestValue = "0";
              });
            }
          },
          items: ['Days', 'Weeks', 'Months']
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
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
            //resetCalculator();
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
            padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Let's get you started" + varValue.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "DefaultFontFamily",
                    letterSpacing: 0.5,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        planName,
                        SizedBox(
                          height: 20,
                        ),
                        autoAmount,
                        SizedBox(
                          height: 20,
                        ),
                        planDuration,
                        durationOption,
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Interest: ${ch8t.format(double.tryParse(interestValue))} per annum" +
                              varValue.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "DefaultFontFamily",
                            //height: 1.5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          interestText,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "DefaultFontFamily",
                            //height: 1.5,
                            color: Colors.red,
                          ),
                        ),
                        (showNotice)
                            ? Text(
                                amountNotice,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "DefaultFontFamily",
                                  //height: 1.5,
                                  color: Colors.red,
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 20,
                        ),
                        (showSaveButton)
                            ? GFButton(
                                shape: GFButtonShape.pills,
                                onPressed: (_planNameController.text.trim() !=
                                            "" &&
                                        ((validateAmount(
                                                    _depositAmountController
                                                        .text
                                                        .trim()) ==
                                                "") &&
                                            (validateDuration(
                                                    _planDurationController.text
                                                        .trim()) ==
                                                "")))
                                    ? () async {
                                        Timer(const Duration(seconds: 1), () {
                                          _depositController.stop();
                                        });
                                        var userUpdate = FirebaseFirestore
                                            .instance
                                            .collection('accounts');
                                        var updateDeposit = FirebaseFirestore
                                            .instance
                                            .collection('spacedeposit');

                                        await updateDeposit.add({
                                          'user_id': _userID,
                                          'id': _id,
                                          'interest': 0,
                                          'plan_name':
                                              _planNameController.text.trim(),
                                          'savings_id': _rentSpaceID,
                                          'date': formattedDate,
                                          'upfront':
                                              double.tryParse(interestValue),
                                          'withdrawal_count': 0,
                                          'interval_amount': ((double.tryParse(
                                                  _depositAmountController.text
                                                      .trim()
                                                      .replaceAll(',', '')))! /
                                              (int.tryParse(
                                                  _planDurationController.text
                                                      .trim()))!),
                                          'target_amount': double.tryParse(
                                              _depositAmountController.text
                                                  .trim()
                                                  .replaceAll(',', '')),
                                          'paid_amount': 0,
                                          'interval': durationType,
                                          'has_paid': 'false',
                                          'status': 'active',
                                          'history': _history,
                                          'is_new': 'true',
                                          'no_of_payments': ((int.tryParse(
                                              _planDurationController.text
                                                  .trim()))!),
                                          'current_payment': '0',
                                          'token': ''
                                        });
                                        await userUpdate.doc(userId).update({
                                          "activities": FieldValue.arrayUnion(
                                            [
                                              "$formattedDate\nSpaceDeposit created\n${ch8t.format(double.tryParse(_depositAmountController.text.trim().replaceAll(',', ''))).toString()} target amount.",
                                            ],
                                          ),
                                        }).then((value) {
                                          Get.bottomSheet(
                                            isDismissible: true,
                                            SizedBox(
                                              height: 300,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(30.0),
                                                  topRight:
                                                      Radius.circular(30.0),
                                                ),
                                                child: Container(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        height: 50,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: brandOne,
                                                        size: 80,
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        'SpaceDeposit created',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "DefaultFontFamily",
                                                          fontSize: 16,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                      RoundedLoadingButton(
                                                        controller:
                                                            _depositController,
                                                        onPressed: () async {
                                                          Timer(
                                                              const Duration(
                                                                  seconds: 1),
                                                              () {
                                                            _depositController
                                                                .stop();
                                                          });
                                                          Get.back();
                                                          Get.to(
                                                              SpaceDepositPayment(
                                                            amount: ((double.tryParse(
                                                                    _depositAmountController
                                                                        .text
                                                                        .trim()
                                                                        .replaceAll(
                                                                            ',',
                                                                            '')))! /
                                                                (int.tryParse(
                                                                    _planDurationController
                                                                        .text
                                                                        .trim()))!),
                                                            refId: _rentSpaceID,
                                                          ));
                                                        },
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        child: Text(
                                                          'Proceed to payment',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "DefaultFontFamily",
                                                            color: Colors.white,
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
                                          );
                                        }).catchError((error) {
                                          Get.snackbar(
                                            "Oops",
                                            "Something went wrong, try again later",
                                            animationDuration:
                                                Duration(seconds: 2),
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        });
                                      }
                                    : () async {
                                        Timer(const Duration(seconds: 1), () {
                                          _depositController.stop();
                                        });
                                        Get.snackbar(
                                          "Incompleted!",
                                          "fill all the fields to continue",
                                          animationDuration:
                                              Duration(seconds: 1),
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                child: Text(
                                  "Save ${ch8t.format(((((double.tryParse(_depositAmountController.text.trim().replaceAll(',', ''))) != null) ? ((double.tryParse(_depositAmountController.text.trim().replaceAll(',', '')))!) : 1) / ((((int.tryParse(_planDurationController.text.trim())) != null) ? ((int.tryParse(_planDurationController.text.trim()))!) : 1))))} for ${_planDurationController.text.trim()} ${durationType}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: "DefaultFontFamily",
                                  ),
                                ),
                                color: brandOne,
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 20,
                        ),
                        (showSaveButton)
                            ? InkWell(
                                onTap: () {
                                  Get.to(TermsAndConditions());
                                },
                                child: Text(
                                  "By proceeding, you agree with our terms and conditions",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.red,
                                    fontFamily: "DefaultFontFamily",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Text(""),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
