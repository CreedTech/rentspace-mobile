import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/savings/spaceBox/spacebox_payment.dart';
import 'package:rentspace/view/terms_and_conditions.dart';

import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class SpaceBoxSubscription extends StatefulWidget {
  const SpaceBoxSubscription({Key? key}) : super(key: key);

  @override
  _SpaceBoxSubscriptionState createState() => _SpaceBoxSubscriptionState();
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
String _durationValue = "";

const _chars = '1234567890';
Random _rnd = Random();
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
String durationType = "Days";

final TextEditingController _boxAmountController = TextEditingController();
final TextEditingController _planNameController = TextEditingController();
final TextEditingController _planDurationController = TextEditingController();

class _SpaceBoxSubscriptionState extends State<SpaceBoxSubscription> {
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
  //       _userFirst = data?['firstname'];
  //       _userLast = data?['lastname'];
  //       _userAddress = data?['address'];
  //       _userMail = data?['email'];
  //       _userID = data?['rentspace_id'];
  //       _id = data?['id'];
  //       _rentSpaceID = getRandom(20);
  //     });
  //   }
  // }

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
      _boxAmountController.clear();
      _planNameController.clear();
      _planDurationController.clear();
    });
    // getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
//calculate interest
    String calculateInterest() {
      //50k to 1m, 7% interest
      if ((int.tryParse(
                  _boxAmountController.text.trim().replaceAll(',', ''))! >=
              50000) &&
          (int.tryParse(_boxAmountController.text.trim().replaceAll(',', ''))! <
              1000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _boxAmountController.text.trim().replaceAll(',', ''))! *
                0.07 *
                ((int.tryParse(_planDurationController.text.trim())!) / 12))
            .toString();
      }
      //1m to 2m, 7.5% interest
      else if ((int.tryParse(
                  _boxAmountController.text.trim().replaceAll(',', ''))! >=
              1000000) &&
          (int.tryParse(_boxAmountController.text.trim().replaceAll(',', ''))! <
              2000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _boxAmountController.text.trim().replaceAll(',', ''))! *
                0.075 *
                ((int.tryParse(_planDurationController.text.trim())!) / 12))
            .toString();
      }
      //2m to 5m, 8.25% interest
      else if ((int.tryParse(
                  _boxAmountController.text.trim().replaceAll(',', ''))! >=
              2000000) &&
          (int.tryParse(_boxAmountController.text.trim().replaceAll(',', ''))! <
              5000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _boxAmountController.text.trim().replaceAll(',', ''))! *
                0.0825 *
                ((int.tryParse(_planDurationController.text.trim())!) / 12))
            .toString();
      }
      //5m to 10m, 9% interest
      else if ((int.tryParse(
                  _boxAmountController.text.trim().replaceAll(',', ''))! >=
              5000000) &&
          (int.tryParse(_boxAmountController.text.trim().replaceAll(',', ''))! <
              10000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _boxAmountController.text.trim().replaceAll(',', ''))! *
                0.09 *
                ((int.tryParse(_planDurationController.text.trim())!) / 12))
            .toString();
      }
      //10m to 20m, 10.25% interest
      else if ((int.tryParse(
                  _boxAmountController.text.trim().replaceAll(',', ''))! >=
              10000000) &&
          (int.tryParse(_boxAmountController.text.trim().replaceAll(',', ''))! <
              20000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _boxAmountController.text.trim().replaceAll(',', ''))! *
                0.1025 *
                ((int.tryParse(_planDurationController.text.trim())!) / 12))
            .toString();
      }
      //20m to 30m, 12% interest
      else if ((int.tryParse(
                  _boxAmountController.text.trim().replaceAll(',', ''))! >=
              20000000) &&
          (int.tryParse(_boxAmountController.text.trim().replaceAll(',', ''))! <
              30000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _boxAmountController.text.trim().replaceAll(',', ''))! *
                0.12 *
                ((int.tryParse(_planDurationController.text.trim())!) / 12))
            .toString();
      }
      //30m to 50m, 14% interest
      else if ((int.tryParse(
                  _boxAmountController.text.trim().replaceAll(',', ''))! >=
              30000000) &&
          (int.tryParse(_boxAmountController.text.trim().replaceAll(',', ''))! <
              50000000)) {
        setState(() {
          showNotice = false;
          showSaveButton = true;
        });
        return interestValue = (int.tryParse(
                    _boxAmountController.text.trim().replaceAll(',', ''))! *
                0.14 *
                ((int.tryParse(_planDurationController.text.trim())!) / 12))
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

//validation function
    validateAmount(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if ((int.tryParse(text.replaceAll(',', ''))! >= 1) &&
          (int.tryParse(text.replaceAll(',', ''))! < 50000)) {
        return 'minimum amount is ₦50,000';
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
      if (int.tryParse(text)! < 9) {
        return 'minimum duration is 9 months';
      }
      if (int.tryParse(text)! > 24) {
        return 'maximum duration is 24 months';
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
      controller: _boxAmountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      inputFormatters: [ThousandsFormatter()],
      // update the state variable when the text changes
      onChanged: (text) {
        setState(() => _amountValue = text);
        if ((_boxAmountController.text.trim() != "") &&
            (_planDurationController.text.trim() != "")) {
          if ((validateAmount(_boxAmountController.text.trim()) == "") &&
              (validateDuration(_planDurationController.text.trim()) == "")) {
            setState(() {
              interestValue = calculateInterest();
            });
          } else {
            setState(() {
              showInterest = false;
              interestValue = "0";
            });
          }
        } else {
          print("nothing");
        }
      },
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefix: Text(
          "₦" + varValue.toString(),
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        label: Text(
          "How much do you want to save?",
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
    final planDuration = TextFormField(
      enableSuggestions: true,

      cursorColor: Colors.black,
      controller: _planDurationController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateDuration,
      // update the state variable when the text changes
      onChanged: (text) {
        setState(() => _durationValue = text);
        if ((_boxAmountController.text.trim() != "") &&
            (_planDurationController.text.trim() != "")) {
          if ((validateAmount(_boxAmountController.text.trim()) == "") &&
              (validateDuration(_planDurationController.text.trim()) == "")) {
            setState(() {
              interestValue = calculateInterest();
            });
          } else {
            setState(() {
              showInterest = false;
              interestValue = "0";
            });
          }
        } else {
          print("nothing");
        }
      },
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        suffix: Text(
          "Months" + varValue.toString(),
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        label: Text(
          "How long do you want to save for?",
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
      decoration: InputDecoration(
        label: Text(
          " What goal are you savings towards?",
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
        hintText: 'E.g My travel expenses',
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

            if ((validateAmount(_boxAmountController.text.trim()) == "") &&
                (validateDuration(_planDurationController.text.trim()) == "")) {
              setState(() {
                interestValue = calculateInterest();
              });
            } else {
              setState(() {
                showInterest = false;
                interestValue = "0";
              });
            }
          },
          items: ['Days', 'Weeks', 'Months', 'Years']
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
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: Theme.of(context).canvasColor,
      //   leading: GestureDetector(
      //     onTap: () {
      //       //resetCalculator();
      //       Get.back();
      //     },
      //     child: Icon(
      //       Icons.close,
      //       size: 30,
      //       color: Theme.of(context).primaryColor,
      //     ),
      //   ),
      // ),
      // body: Stack(
      //   children: [
      //     Positioned.fill(
      //       child: Opacity(
      //         opacity: 0.3,
      //         child: Image.asset(
      //           'assets/icons/RentSpace-icon.png',
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
      //       child: ListView(
      //         shrinkWrap: true,
      //         physics: ClampingScrollPhysics(),
      //         children: [
      //           SizedBox(
      //             height: 100,
      //           ),
      //           Text(
      //             "Let's get you started" + varValue.toString(),
      //             style: TextStyle(
      //               fontSize: 20,
      //               fontFamily: "DefaultFontFamily",
      //               letterSpacing: 0.5,
      //               color: Theme.of(context).primaryColor,
      //             ),
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               Column(
      //                 children: [
      //                   SizedBox(
      //                     height: 20,
      //                   ),
      //                   planName,
      //                   SizedBox(
      //                     height: 20,
      //                   ),
      //                   autoAmount,
      //                   SizedBox(
      //                     height: 20,
      //                   ),
      //                   planDuration,
      //                   SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     "Interest: ${ch8t.format(double.tryParse(interestValue))} per annum" +
      //                         varValue.toString(),
      //                     style: TextStyle(
      //                       fontSize: 14,
      //                       fontFamily: "DefaultFontFamily",
      //                       //height: 1.5,
      //                       color: Theme.of(context).primaryColor,
      //                     ),
      //                   ),
      //                   Text(
      //                     interestText,
      //                     style: TextStyle(
      //                       fontSize: 14,
      //                       fontFamily: "DefaultFontFamily",
      //                       //height: 1.5,
      //                       color: Colors.red,
      //                     ),
      //                   ),
      //                   (showNotice)
      //                       ? Text(
      //                           amountNotice,
      //                           style: TextStyle(
      //                             fontSize: 14,
      //                             fontFamily: "DefaultFontFamily",
      //                             //height: 1.5,
      //                             color: Colors.red,
      //                           ),
      //                         )
      //                       : SizedBox(),
      //                   SizedBox(
      //                     height: 20,
      //                   ),
      //                   (showSaveButton)
      //                       ? GFButton(
      //                           shape: GFButtonShape.pills,
      //                           onPressed: (_planNameController.text.trim() !=
      //                                       "" &&
      //                                   ((validateAmount(_boxAmountController
      //                                               .text
      //                                               .trim()) ==
      //                                           "") &&
      //                                       (validateDuration(
      //                                               _planDurationController.text
      //                                                   .trim()) ==
      //                                           "")))
      //                               ? () async {
      //                                   _boxController.stop();
      //                                   var userUpdate = FirebaseFirestore
      //                                       .instance
      //                                       .collection('accounts');
      //                                   var updateBox = FirebaseFirestore
      //                                       .instance
      //                                       .collection('spacebox');

      //                                   await updateBox.add({
      //                                     'user_id': _userID,
      //                                     'id': _id,
      //                                     'interest': 0,
      //                                     'upfront':
      //                                         double.tryParse(interestValue),
      //                                     'plan_name':
      //                                         _planNameController.text.trim(),
      //                                     'savings_id': _rentSpaceID,
      //                                     'date': formattedDate,
      //                                     'interval_amount': ((double.tryParse(
      //                                             _boxAmountController.text
      //                                                 .trim()
      //                                                 .replaceAll(',', '')))! /
      //                                         (int.tryParse(
      //                                             _planDurationController.text
      //                                                 .trim()))!),
      //                                     'target_amount': double.tryParse(
      //                                         _boxAmountController.text
      //                                             .trim()
      //                                             .replaceAll(',', '')),
      //                                     'paid_amount': 0,
      //                                     'interval': "monthly",
      //                                     'has_paid': 'false',
      //                                     'status': 'active',
      //                                     'history': _history,
      //                                     'is_new': 'true',
      //                                     'no_of_payments': ((int.tryParse(
      //                                         _planDurationController.text
      //                                             .trim()))!),
      //                                     'current_payment': '0',
      //                                     'token': ''
      //                                   });
      //                                   await userUpdate.doc(userId).update({
      //                                     "activities": FieldValue.arrayUnion(
      //                                       [
      //                                         "$formattedDate\nSpaceBox created\n${ch8t.format(double.tryParse(_boxAmountController.text.trim().replaceAll(',', ''))).toString()} target amount.",
      //                                       ],
      //                                     ),
      //                                   }).then((value) {
      //                                     _boxController.stop();

      //                                     Get.bottomSheet(
      //                                       isDismissible: true,
      //                                       SizedBox(
      //                                         height: 300,
      //                                         child: ClipRRect(
      //                                           borderRadius: BorderRadius.only(
      //                                             topLeft:
      //                                                 Radius.circular(30.0),
      //                                             topRight:
      //                                                 Radius.circular(30.0),
      //                                           ),
      //                                           child: Container(
      //                                             color: Theme.of(context)
      //                                                 .canvasColor,
      //                                             padding: EdgeInsets.fromLTRB(
      //                                                 10, 5, 10, 5),
      //                                             child: Column(
      //                                               crossAxisAlignment:
      //                                                   CrossAxisAlignment
      //                                                       .center,
      //                                               children: [
      //                                                 SizedBox(
      //                                                   height: 50,
      //                                                 ),
      //                                                 Icon(
      //                                                   Icons
      //                                                       .check_circle_outline,
      //                                                   color: brandOne,
      //                                                   size: 80,
      //                                                 ),
      //                                                 SizedBox(
      //                                                   height: 20,
      //                                                 ),
      //                                                 Text(
      //                                                   'SpaceBox created',
      //                                                   style: TextStyle(
      //                                                     fontSize: 16,
      //                                                     fontFamily:
      //                                                         "DefaultFontFamily",
      //                                                     color:
      //                                                         Theme.of(context)
      //                                                             .primaryColor,
      //                                                   ),
      //                                                 ),
      //                                                 SizedBox(
      //                                                   height: 30,
      //                                                 ),
      //                                                 RoundedLoadingButton(
      //                                                   controller:
      //                                                       _boxController,
      //                                                   onPressed: () {
      //                                                     _boxController.stop();
      //                                                     Get.back();
      //                                                     Get.to(
      //                                                         SpaceBoxPayment(
      //                                                       amount: ((double.tryParse(
      //                                                               _boxAmountController
      //                                                                   .text
      //                                                                   .trim()
      //                                                                   .replaceAll(
      //                                                                       ',',
      //                                                                       '')))! /
      //                                                           (int.tryParse(
      //                                                               _planDurationController
      //                                                                   .text
      //                                                                   .trim()))!),
      //                                                       refId: _rentSpaceID,
      //                                                     ));
      //                                                   },
      //                                                   width: MediaQuery.of(
      //                                                               context)
      //                                                           .size
      //                                                           .width /
      //                                                       2,
      //                                                   child: Text(
      //                                                     'Proceed to payment',
      //                                                     style: TextStyle(
      //                                                       color: Colors.white,
      //                                                       fontSize: 13,
      //                                                       fontFamily:
      //                                                           "DefaultFontFamily",
      //                                                     ),
      //                                                   ),
      //                                                   color: brandOne,
      //                                                 ),
      //                                                 SizedBox(
      //                                                   height: 20,
      //                                                 ),
      //                                               ],
      //                                             ),
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     );
      //                                   }).catchError((error) {
      //                                     Get.snackbar(
      //                                       "Oops",
      //                                       "Something went wrong, try again later",
      //                                       animationDuration:
      //                                           Duration(seconds: 2),
      //                                       backgroundColor: Colors.red,
      //                                       colorText: Colors.white,
      //                                       snackPosition: SnackPosition.BOTTOM,
      //                                     );
      //                                   });
      //                                 }
      //                               : () {
      //                                   _boxController.stop();
      //                                   Get.snackbar(
      //                                     "Incompleted!",
      //                                     "fill all the fields to continue",
      //                                     animationDuration:
      //                                         Duration(seconds: 1),
      //                                     backgroundColor: Colors.red,
      //                                     colorText: Colors.white,
      //                                     snackPosition: SnackPosition.BOTTOM,
      //                                   );
      //                                 },
      //                           child: Text(
      //                             "Save ${ch8t.format((((double.tryParse(_boxAmountController.text.trim().replaceAll(',', ''))) != null) ? ((double.tryParse(_boxAmountController.text.trim().replaceAll(',', '')))!) : 1) / (((int.tryParse(_planDurationController.text.trim())) != null) ? ((int.tryParse(_planDurationController.text.trim()))!) : 1))} monthly for ${_planDurationController.text.trim()} months",
      //                             style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 13,
      //                               fontFamily: "DefaultFontFamily",
      //                             ),
      //                           ),
      //                           color: brandOne,
      //                         )
      //                       : SizedBox(),
      //                   SizedBox(
      //                     height: 20,
      //                   ),
      //                   (showSaveButton)
      //                       ? InkWell(
      //                           onTap: () {
      //                             Get.to(TermsAndConditions());
      //                           },
      //                           child: Text(
      //                             "By proceeding, you agree with our terms and conditions",
      //                             style: TextStyle(
      //                               decoration: TextDecoration.underline,
      //                               color: Colors.red,
      //                               fontFamily: "DefaultFontFamily",
      //                             ),
      //                             textAlign: TextAlign.center,
      //                           ),
      //                         )
      //                       : Text(""),
      //                   SizedBox(
      //                     height: 50,
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //           SizedBox(
      //             height: 50,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
