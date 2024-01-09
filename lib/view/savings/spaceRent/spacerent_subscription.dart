import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/terms_and_conditions.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_payment.dart';
import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import '../../../constants/widgets/custom_dialog.dart';

class RentSpaceSubscription extends StatefulWidget {
  const RentSpaceSubscription({Key? key}) : super(key: key);

  @override
  _RentSpaceSubscriptionState createState() => _RentSpaceSubscriptionState();
}

var ch8t = NumberFormat.simpleCurrency(name: 'NGN');
var varValue = "".obs;
final _history = [];
String _userFirst = '';
String _userLast = '';
String _userAddress = '';
String _userMail = '';
String _hasCalculate = 'true';
String _hasCreated = 'false';
String _canShowRent = 'false';
double _dailyPaymentamount = 0.0;
String _userID = '';
String _id = '';
String _rentSpaceID = '';
String _amountValue = "";
double _rentValue = 0.0;
double _rentSeventy = 0.0;
int _daysDifference = 1;
double _rentThirty = 0.0;
//savings goals
double _dailyValue = 0.0;
double _weeklyValue = 0.0;
double _monthlyValue = 0.0;
const _chars = '1234567890';
Random _rnd = Random();
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);

final TextEditingController _rentAmountController = TextEditingController();
final TextEditingController _rentAmountOldController = TextEditingController();

final RoundedLoadingButtonController _dailyController =
    RoundedLoadingButtonController();
final RoundedLoadingButtonController _weeklyController =
    RoundedLoadingButtonController();
final RoundedLoadingButtonController _monthlyController =
    RoundedLoadingButtonController();

final RoundedLoadingButtonController _dailyModalController =
    RoundedLoadingButtonController();
final RoundedLoadingButtonController _weeklyModalController =
    RoundedLoadingButtonController();
final RoundedLoadingButtonController _monthlyModalController =
    RoundedLoadingButtonController();

class _RentSpaceSubscriptionState extends State<RentSpaceSubscription> {
  DateTime _endDate = DateTime.now();

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.black, // header background color
                onPrimary: Colors.white,
                onBackground: Colors.black,

                outline: Colors.black,
                background: Colors.black,
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.black, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (picked != null &&
        picked != DateTime.now() &&
        !picked.difference(DateTime.now()).inDays.isNaN) {
      setState(() {
        _endDate = picked;
        _canShowRent = 'true';
      });
    }
  }

  int _calculateDaysDifference() {
    final differenceDays =
        _endDate.add(const Duration(days: 1)).difference(DateTime.now()).inDays;

    return differenceDays.abs();
  }

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
      print(_userID);
    }
  }

  @override
  initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
//validation function

    validateFunc(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (text.length < 1) {
        return 'Too short';
      }
      if ((int.tryParse(text.trim().replaceAll(',', ''))! >= 1) &&
          (int.tryParse(text.trim().replaceAll(',', ''))! < 5000)) {
        return 'minimum amount is ₦5,000';
      }
      if (int.tryParse(text.trim().replaceAll(',', '')) == null) {
        return 'enter valid number';
      }
      if (int.tryParse(text.trim().replaceAll(',', '')) == 0) {
        return 'number cannot be zero';
      }
      if (int.tryParse(text.trim().replaceAll(',', ''))!.isNegative) {
        return 'enter positive number';
      }
      return null;
    }

    //validation function
    validateOldFunc(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (text.length < 1) {
        return 'Too short';
      }
      if (int.tryParse(text.trim().replaceAll(',', '')) == 0) {
        return 'number cannot be zero';
      }
      if ((int.tryParse(text.trim().replaceAll(',', ''))! >= 1) &&
          (int.tryParse(text.trim().replaceAll(',', ''))! < 1000)) {
        return 'minimum amount is ₦1,000';
      }
      if (int.tryParse(text.trim().replaceAll(',', '')) == null) {
        return 'enter valid number';
      }
      if (int.tryParse(text.trim().replaceAll(',', ''))!.isNegative) {
        return 'enter positive number';
      }
      return null;
    }

///////calculate rent
    calculateRent(rent) {
      setState(() {
        _rentThirty = (rent - (rent * 0.7));
        _rentSeventy = (rent * 0.7);
        _rentValue = rent;
        _hasCalculate = 'true';
        _hasCreated = 'false';
        _dailyValue = ((rent * 0.7) / 335);
        _weeklyValue = ((rent * 0.7) / 48);
        _monthlyValue = ((rent * 0.7) / 11);
      });
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

    final rentAmount = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _rentAmountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateFunc,
      // update the state variable when the text changes
      onChanged: (text) => setState(() => _amountValue = text),
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsFormatter()],
      decoration: InputDecoration(
        label: Text(
          "How much is your rent per year?",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
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
        hintText: 'Rent amount in Naira',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    final rentAmountOld = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _rentAmountOldController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateOldFunc,
      // update the state variable when the text changes
      onChanged: (text) => setState(() => _amountValue = text),
      style: const TextStyle(
        color: Colors.black,
      ),
      inputFormatters: [ThousandsFormatter()],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(
          "How much of your rent is left?",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
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
        hintText: 'Rent amount in Naira',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    return Obx(
      () => Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).canvasColor,
          leading: GestureDetector(
            onTap: () {
              resetCalculator();
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
            // Positioned.fill(
            //   child: Opacity(
            //     opacity: 0.3,
            //     child: Image.asset(
            //       'assets/icons/RentSpace-icon.png',
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "We Simplified the process for you$varValue",
                      style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // letterSpacing: 0.5,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  (_hasCalculate == 'true')
                      ? Text(
                          "$varValue",
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : const Text(""),
                  //rent amount input
                  (_hasCalculate == 'true')
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            rentAmount,
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : const Text(""),

                  (_hasCalculate == 'true')
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
                          child: Center(
                            child: ElevatedButton(
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
                              onLongPress: () {
                                setState(() {
                                  _amountValue = "";
                                  _rentValue = 0.0;
                                  _rentSeventy = 0.0;
                                  _rentThirty = 0.0;
                                });
                              },
                              onPressed: () {
                                if (validateFunc(_rentAmountController.text
                                        .trim()
                                        .replaceAll(',', '')) ==
                                    null) {
                                  calculateRent(double.tryParse(
                                      _rentAmountController.text
                                          .trim()
                                          .replaceAll(',', '')));
                                } else {
                                  if (context.mounted) {
                                    customErrorDialog(context, 'Invalid',
                                        "Please enter valid amount to proceed.");
                                  }

                                  // Get.snackbar(
                                  //   "Invalid",
                                  //   'Please enter valid amount to proceed.',
                                  //   animationDuration:
                                  //       const Duration(seconds: 1),
                                  //   backgroundColor: Colors.red,
                                  //   colorText: Colors.white,
                                  //   snackPosition: SnackPosition.BOTTOM,
                                  // );
                                }
                              },
                              child: Text(
                                'Calculate',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            // GFButton(
                            //   onLongPress: () {
                            //     setState(() {
                            //       _amountValue = "";
                            //       _rentValue = 0.0;
                            //       _rentSeventy = 0.0;
                            //       _rentThirty = 0.0;
                            //     });
                            //   },
                            //   onPressed: () {
                            //     if (validateFunc(_rentAmountController.text
                            //             .trim()
                            //             .replaceAll(',', '')) ==
                            //         '') {
                            //       calculateRent(double.tryParse(
                            //           _rentAmountController.text
                            //               .trim()
                            //               .replaceAll(',', '')));
                            //     } else {
                            //       Get.snackbar(
                            //         "Invalid",
                            //         'Please enter valid amount to proceed.',
                            //         animationDuration:
                            //             const Duration(seconds: 1),
                            //         backgroundColor: Colors.red,
                            //         colorText: Colors.white,
                            //         snackPosition: SnackPosition.BOTTOM,
                            //       );
                            //     }
                            //   },
                            //   fullWidthButton: true,
                            //   size: 40,
                            //   icon: const Icon(
                            //     Icons.add_outlined,
                            //     color: Colors.white,
                            //     size: 20,
                            //   ),
                            //   text: "Calculate",
                            //   textStyle: const TextStyle(
                            //     fontSize: 13,
                            //     fontFamily: "DefaultFontFamily",
                            //     color: Colors.white,
                            //   ),
                            //   color: brandOne,
                            //   padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                            //   shape: GFButtonShape.pills,
                            // ),
                          ),
                        )
                      : const Text(""),
                  const SizedBox(
                    height: 20,
                  ),
                  (_hasCalculate == 'true')
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              _hasCreated = 'true';
                              _hasCalculate = 'false';
                            });
                          },
                          child: Text(
                            "Already paying for a rent? click here",
                            style: GoogleFonts.nunito(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              _hasCreated = 'false';
                              _hasCalculate = 'true';
                            });
                          },
                          child: Text(
                            "Paying for a new rent? click here",
                            style: GoogleFonts.nunito(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  (_hasCreated == 'true')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                rentAmountOld,
                                const SizedBox(
                                  height: 50,
                                ),
                                Text(
                                  'When is your current rent due?\n${DateFormat('dd/MM/yyyy').format(_endDate)}',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(200, 50),
                                    maximumSize: const Size(250, 50),
                                    backgroundColor: brandTwo,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  onPressed: () => _selectEndDate(context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.calendar_month_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Select on calendar',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.nunito(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // GFButton(
                                //   onPressed: () => _selectEndDate(context),
                                //   shape: GFButtonShape.pills,
                                //   text: "Select on calendar",
                                //   padding:
                                //       const EdgeInsets.fromLTRB(20, 2, 20, 2),
                                //   icon: const Icon(
                                //     Icons.calendar_month_outlined,
                                //     color: Colors.white,
                                //     size: 18,
                                //   ),
                                //   color: brandOne,
                                //   textStyle: GoogleFonts.nunito(
                                //     color: Colors.white,
                                //     fontSize: 16,
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            (_canShowRent == 'true')
                                ? (_calculateDaysDifference().abs() == 0)
                                    ? const Text("")
                                    : Text(
                                        'Your rent will be due in ${_calculateDaysDifference()} days',
                                        style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                : const Text(''),
                            const SizedBox(
                              height: 20,
                            ),
                            (_canShowRent == 'true')
                                ? InkWell(
                                    onTap: () {
                                      Get.to(const TermsAndConditions());
                                    },
                                    child: Text(
                                      "By proceeding, you agree with our terms and conditions",
                                      style: GoogleFonts.nunito(
                                        decoration: TextDecoration.underline,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : const Text(""),
                            const SizedBox(
                              height: 20,
                            ),
                            (_canShowRent == 'true' &&
                                    (_rentAmountOldController.text
                                            .trim()
                                            .replaceAll(',', '')
                                            .isNotEmpty &&
                                        validateOldFunc(_rentAmountOldController
                                                .text
                                                .trim()
                                                .replaceAll(',', '')) ==
                                            null &&
                                        int.tryParse(_rentAmountOldController
                                                .text
                                                .trim()
                                                .replaceAll(',', '')) !=
                                            null))
                                ? (_calculateDaysDifference().abs() == 0)
                                    ? Builder(builder: (context) {
                                        return Text(
                                          "Invalid date. Pick a different date.",
                                          style: GoogleFonts.nunito(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        );
                                      })
                                    : Column(
                                        children: [
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(100, 50),
                                              maximumSize: const Size(350, 50),
                                              backgroundColor: brandTwo,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              var userUpdate = FirebaseFirestore
                                                  .instance
                                                  .collection('accounts');
                                              var updateRent = FirebaseFirestore
                                                  .instance
                                                  .collection('rent_space');

                                              await updateRent.add({
                                                'user_id': _userID,
                                                'id': _id,
                                                'rentspace_id': _rentSpaceID,
                                                'date': formattedDate,
                                                'interval_amount': (((int.tryParse(
                                                            _rentAmountOldController
                                                                .text
                                                                .trim()
                                                                .replaceAll(
                                                                    ',', ''))! /
                                                        _calculateDaysDifference()))
                                                    .toDouble()),
                                                'target_amount': int.tryParse(
                                                        _rentAmountOldController
                                                            .text
                                                            .trim()
                                                            .replaceAll(
                                                                ',', ''))!
                                                    .toDouble(),
                                                'paid_amount': 0,
                                                'interval': 'daily',
                                                'has_paid': 'false',
                                                'status': 'active',
                                                'history': _history,
                                                'is_new': 'false',
                                                'no_of_payments': '0',
                                                'current_payment': '0',
                                                'token': ''
                                              });
                                              await userUpdate
                                                  .doc(userId)
                                                  .update({
                                                'has_rent': 'true',
                                                "activities":
                                                    FieldValue.arrayUnion(
                                                  [
                                                    "$formattedDate \nSaving for rent\n${ch8t.format(double.tryParse(_rentAmountOldController.text.trim().replaceAll(',', '')))} target amount.",
                                                  ],
                                                ),
                                              }).then((value) {
                                                Get.bottomSheet(
                                                  isDismissible: false,
                                                  SizedBox(
                                                    height: 400,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                30.0),
                                                        topRight:
                                                            Radius.circular(
                                                                30.0),
                                                      ),
                                                      child: Container(
                                                        color: Theme.of(context)
                                                            .canvasColor,
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                10, 47, 10, 24),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            // const Icon(
                                                            //   Icons
                                                            //       .check_circle_outline,
                                                            //   color: brandOne,
                                                            //   size: 80,
                                                            // ),
                                                            Image.asset(
                                                              'assets/check.png',
                                                              width: 120,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              'SpaceRent Created',
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                // fontFamily:
                                                                //     "DefaultFontFamily",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          48),
                                                              child: Text(
                                                                'Your SpaceRent savings has been created successfully kindly proceed to make payment',
                                                                style:
                                                                    GoogleFonts
                                                                        .nunito(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  // fontFamily:
                                                                  //     "DefaultFontFamily",
                                                                  color: Color(
                                                                      0xff828282),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),

                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Container(
                                                                // width: MediaQuery.of(context).size.width * 2,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                // height: 110.h,
                                                                child: Column(
                                                                  children: [
                                                                    ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        minimumSize: const Size(
                                                                            300,
                                                                            50),
                                                                        backgroundColor:
                                                                            brandTwo,
                                                                        elevation:
                                                                            0,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        Get.back();
                                                                        Get.to(
                                                                            SpaceRentFunding(
                                                                          amount:
                                                                              (int.tryParse(_rentAmountOldController.text.trim().replaceAll(',', ''))! ~/ _calculateDaysDifference()),
                                                                          date:
                                                                              formattedDate,
                                                                          interval:
                                                                              'daily',
                                                                          numPayment:
                                                                              0,
                                                                          refId:
                                                                              _rentSpaceID,
                                                                          userID:
                                                                              _userID,
                                                                        ));
                                                                        resetCalculator();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Proceed To Payment',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            // GFButton(
                                                            //   onPressed: () {
                                                            //     Get.to(
                                                            //         HomePage());
                                                            //     // for (int i = 0; i < 2; i++) {
                                                            //     //   Get.to(HomePage());
                                                            //     // }
                                                            //   },
                                                            //   icon: const Icon(
                                                            //     Icons
                                                            //         .arrow_right_outlined,
                                                            //     size: 30,
                                                            //     color:
                                                            //         Colors.white,
                                                            //   ),
                                                            //   color: brandOne,
                                                            //   text: "Done",
                                                            //   shape: GFButtonShape
                                                            //       .pills,
                                                            //   fullWidthButton:
                                                            //       true,
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
                                              }).catchError((error) {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        title: null,
                                                        elevation: 0,
                                                        content: SizedBox(
                                                          height: 250,
                                                          child: Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                      // color: brandOne,
                                                                    ),
                                                                    child:
                                                                        const Icon(
                                                                      Iconsax
                                                                          .close_circle,
                                                                      color:
                                                                          brandOne,
                                                                      size: 30,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Icon(
                                                                  Iconsax
                                                                      .warning_24,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 75,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                              ),
                                                              Text(
                                                                'Oops!!',
                                                                style:
                                                                    GoogleFonts
                                                                        .nunito(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 28,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                'Something went wrong, try again later',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .nunito(
                                                                        color:
                                                                            brandOne,
                                                                        fontSize:
                                                                            18),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.add_outlined,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Click to save ${ch8t.format((int.tryParse(_rentAmountOldController.text.trim().replaceAll(',', ''))! ~/ _calculateDaysDifference()))} daily for ${_calculateDaysDifference()} days",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                : const Text(""),
                          ],
                        )
                      : const Text(""),
                  (_hasCalculate == 'true')
                      ? (_rentSeventy != 0.0)
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "",
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 100,
                                  ),
                                  ////////Daily payment
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(100, 50),
                                      backgroundColor: brandTwo,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Timer(const Duration(seconds: 1), () {
                                        _dailyModalController.stop();
                                      });
                                      var userUpdate = FirebaseFirestore
                                          .instance
                                          .collection('accounts');
                                      var updateRent = FirebaseFirestore
                                          .instance
                                          .collection('rent_space');

                                      await updateRent.add({
                                        'user_id': _userID,
                                        'id': _id,
                                        'rentspace_id': _rentSpaceID,
                                        'date': formattedDate,
                                        'interval_amount': _dailyValue,
                                        'target_amount': _rentValue,
                                        'paid_amount': 0,
                                        'interval': 'daily',
                                        'has_paid': 'false',
                                        'status': 'active',
                                        'history': _history,
                                        'is_new': 'true',
                                        'no_of_payments': '335',
                                        'current_payment': '0',
                                        'token': ''
                                      });
                                      await userUpdate.doc(userId).update({
                                        'has_rent': 'true',
                                        "activities": FieldValue.arrayUnion(
                                          [
                                            "$formattedDate\nRentSpace created\n${ch8t.format(double.tryParse(_rentValue.toString())).toString()} target amount.",
                                          ],
                                        ),
                                      }).then((value) {
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
                                                color: Theme.of(context)
                                                    .canvasColor,
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
                                                    const Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: brandOne,
                                                      size: 80,
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      'RentSpace created',
                                                      style: GoogleFonts.nunito(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    RoundedLoadingButton(
                                                      controller:
                                                          _dailyController,
                                                      onPressed: () async {
                                                        _dailyController.stop();
                                                        Get.back();
                                                        Get.to(SpaceRentFunding(
                                                          amount: _dailyValue
                                                              .toInt(),
                                                          date: formattedDate,
                                                          interval: 'daily',
                                                          numPayment: 0,
                                                          refId: _rentSpaceID,
                                                          userID: _userID,
                                                        ));
                                                        resetCalculator();
                                                      },
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      color: brandOne,
                                                      child: Text(
                                                        'Proceed to payment',
                                                        style:
                                                            GoogleFonts.nunito(
                                                          color: Colors.white,
                                                          fontSize: 13,
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
                                      }).catchError((error) {
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
                                                          alignment: Alignment
                                                              .topRight,
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
                                                        'Oops!!',
                                                        style:
                                                            GoogleFonts.nunito(
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
                                                        'Oops! \n Something went wrong, try again later',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.nunito(
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
                                      });
                                    },
                                    child: Text(
                                      'save ${ch8t.format(double.tryParse(_dailyValue.toString())).toString()} daily for 335 days',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ////////Weekly payment
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(100, 50),
                                      backgroundColor: brandTwo,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      _weeklyModalController.stop();
                                      var userUpdate = FirebaseFirestore
                                          .instance
                                          .collection('accounts');
                                      var updateRent = FirebaseFirestore
                                          .instance
                                          .collection('rent_space');

                                      await updateRent.add({
                                        'id': _id,
                                        'user_id': _userID,
                                        'rentspace_id': _rentSpaceID,
                                        'date': formattedDate,
                                        'interval_amount': _weeklyValue,
                                        'target_amount': _rentValue,
                                        'paid_amount': 0,
                                        'interval': 'weekly',
                                        'has_paid': 'false',
                                        'status': 'active',
                                        'history': _history,
                                        'is_new': 'true',
                                        'no_of_payments': '44',
                                        'current_payment': '0',
                                        'token': ''
                                      });
                                      await userUpdate.doc(userId).update({
                                        'has_rent': 'true',
                                        "activities": FieldValue.arrayUnion(
                                          [
                                            "$formattedDate\nRentSpace created\n${ch8t.format(double.tryParse(_rentValue.toString())).toString()} target amount.",
                                          ],
                                        ),
                                      }).then((value) {
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
                                                color: Theme.of(context)
                                                    .canvasColor,
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
                                                    const Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: brandOne,
                                                      size: 80,
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      'RentSpace created',
                                                      style: GoogleFonts.nunito(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    RoundedLoadingButton(
                                                      controller:
                                                          _weeklyController,
                                                      onPressed: () async {
                                                        _weeklyController
                                                            .stop();
                                                        Get.back();
                                                        Get.to(SpaceRentFunding(
                                                          amount: _weeklyValue
                                                              .toInt(),
                                                          date: formattedDate,
                                                          interval: 'weekly',
                                                          numPayment: 0,
                                                          refId: _rentSpaceID,
                                                          userID: _userID,
                                                        ));
                                                        resetCalculator();
                                                      },
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      color: brandOne,
                                                      child: Text(
                                                        'Proceed to payment',
                                                        style:
                                                            GoogleFonts.nunito(
                                                          color: Colors.white,
                                                          fontSize: 13,
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
                                      }).catchError((error) {
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
                                                          alignment: Alignment
                                                              .topRight,
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
                                                        'Oops!!',
                                                        style:
                                                            GoogleFonts.nunito(
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
                                                        'Oops! \n Something went wrong, try again later',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.nunito(
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
                                      });
                                    },
                                    child: Text(
                                      'save ${ch8t.format(double.tryParse(_weeklyValue.toString())).toString()} weekly for 44 weeks',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ////////Monthly payment
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(100, 50),
                                      backgroundColor: brandTwo,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      _monthlyModalController.stop();
                                      var userUpdate = FirebaseFirestore
                                          .instance
                                          .collection('accounts');
                                      var updateRent = FirebaseFirestore
                                          .instance
                                          .collection('rent_space');

                                      await updateRent.add({
                                        'id': _id,
                                        'user_id': _userID,
                                        'rentspace_id': _rentSpaceID,
                                        'date': formattedDate,
                                        'interval_amount': _monthlyValue,
                                        'target_amount': _rentValue,
                                        'paid_amount': 0,
                                        'interval': 'monthly',
                                        'has_paid': 'false',
                                        'status': 'active',
                                        'history': _history,
                                        'is_new': 'true',
                                        'no_of_payments': '11',
                                        'current_payment': '0',
                                        'token': ''
                                      });
                                      await userUpdate.doc(userId).update({
                                        'has_rent': 'true',
                                        "activities": FieldValue.arrayUnion(
                                          [
                                            "$formattedDate\nRentSpace created\n${ch8t.format(double.tryParse(_rentValue.toString())).toString()} target amount.",
                                          ],
                                        ),
                                      }).then((value) {
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
                                                color: Theme.of(context)
                                                    .canvasColor,
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
                                                    const Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: brandOne,
                                                      size: 80,
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      'RentSpace created',
                                                      style: GoogleFonts.nunito(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    RoundedLoadingButton(
                                                      controller:
                                                          _monthlyController,
                                                      onPressed: () async {
                                                        _monthlyController
                                                            .stop();
                                                        Get.back();
                                                        Get.to(SpaceRentFunding(
                                                          amount: _monthlyValue
                                                              .toInt(),
                                                          date: formattedDate,
                                                          interval: 'monthly',
                                                          numPayment: 0,
                                                          refId: _rentSpaceID,
                                                          userID: _userID,
                                                        ));
                                                        resetCalculator();
                                                      },
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      color: brandOne,
                                                      child: Text(
                                                        'Proceed to payment',
                                                        style:
                                                            GoogleFonts.nunito(
                                                          color: Colors.white,
                                                          fontSize: 13,
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
                                      }).catchError((error) {
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
                                                          alignment: Alignment
                                                              .topRight,
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
                                                        'Oops!!',
                                                        style:
                                                            GoogleFonts.nunito(
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
                                                        'Oops! \n Something went wrong, try again later',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.nunito(
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
                                      });
                                    },
                                    child: Text(
                                      'save ${ch8t.format(double.tryParse(_monthlyValue.toString())).toString()} monthly for 11 months',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(const TermsAndConditions());
                                    },
                                    child: Text(
                                      "By proceeding, you agree with our terms and conditions",
                                      style: GoogleFonts.nunito(
                                        decoration: TextDecoration.underline,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            )
                          : const Text("")
                      : const Text(""),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  resetCalculator() {
    setState(() {
      _amountValue = "";
      _rentValue = 0.0;
      _rentSeventy = 0.0;
      _rentThirty = 0.0;
      _hasCalculate = 'true';
      _hasCreated = 'false';
      _canShowRent = 'false';
    });
    _rentAmountController.clear();
    _rentAmountOldController.clear();
  }
}
