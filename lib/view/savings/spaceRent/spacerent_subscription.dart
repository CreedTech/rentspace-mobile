import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
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
              colorScheme: ColorScheme.dark(
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
        _endDate.add(Duration(days: 1)).difference(DateTime.now()).inDays;

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
      return '';
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
      return '';
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
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsFormatter()],
      decoration: InputDecoration(
        label: Text(
          "How much is your rent per year?",
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
        hintText: 'Rent amount in Naira',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 13,
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
      style: TextStyle(
        color: Colors.black,
      ),
      inputFormatters: [ThousandsFormatter()],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(
          "How much of your rent is left?",
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
        hintText: 'Rent amount in Naira',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 13,
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
                    height: 100,
                  ),
                  Text(
                    "Let's get you started" + varValue.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "DefaultFontFamily",
                        letterSpacing: 0.5,
                        color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (_hasCalculate == 'true')
                      ? Text(
                          "" + varValue.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "DefaultFontFamily",
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : Text(""),
                  //rent amount input
                  (_hasCalculate == 'true')
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            rentAmount,
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : Text(""),

                  (_hasCalculate == 'true')
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(30, 2, 30, 2),
                          child: Center(
                            child: GFButton(
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
                                    '') {
                                  calculateRent(double.tryParse(
                                      _rentAmountController.text
                                          .trim()
                                          .replaceAll(',', '')));
                                } else {
                                  Get.snackbar(
                                    "Invalid",
                                    'Please enter valid amount to proceed.',
                                    animationDuration: Duration(seconds: 1),
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                              fullWidthButton: true,
                              size: 40,
                              icon: Icon(
                                Icons.add_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              text: "Calculate",
                              textStyle: TextStyle(
                                fontSize: 13,
                                fontFamily: "DefaultFontFamily",
                                color: Colors.white,
                              ),
                              color: brandOne,
                              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
                              shape: GFButtonShape.pills,
                            ),
                          ),
                        )
                      : Text(""),
                  SizedBox(
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
                            style: TextStyle(
                              fontFamily: "DefaultFontFamily",
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
                            style: TextStyle(
                              fontFamily: "DefaultFontFamily",
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (_hasCreated == 'true')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                rentAmountOld,
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'When is your current rent due?\n${DateFormat('dd/MM/yyyy').format(_endDate)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "DefaultFontFamily",
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GFButton(
                                  onPressed: () => _selectEndDate(context),
                                  shape: GFButtonShape.pills,
                                  text: "Select on calendar",
                                  padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
                                  icon: Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  color: brandOne,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "DefaultFontFamily",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            (_canShowRent == 'true')
                                ? (_calculateDaysDifference().abs() == 0)
                                    ? Text("")
                                    : Text(
                                        'Your rent will be due in ${_calculateDaysDifference()} days',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "DefaultFontFamily",
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                : Text(''),
                            SizedBox(
                              height: 20,
                            ),
                            (_canShowRent == 'true')
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
                              height: 20,
                            ),
                            (_canShowRent == 'true' &&
                                    (_rentAmountOldController.text
                                                .trim()
                                                .replaceAll(',', '') !=
                                            "" &&
                                        validateOldFunc(_rentAmountOldController
                                                .text
                                                .trim()
                                                .replaceAll(',', '')) ==
                                            "" &&
                                        int.tryParse(_rentAmountOldController
                                                .text
                                                .trim()
                                                .replaceAll(',', '')) !=
                                            null))
                                ? (_calculateDaysDifference().abs() == 0)
                                    ? Text(
                                        "Invalid date. Pick a different date.",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "DefaultFontFamily",
                                          color: Colors.red,
                                        ),
                                      )
                                    : GFButton(
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
                                                        .replaceAll(',', ''))!
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
                                          await userUpdate.doc(userId).update({
                                            'has_rent': 'true',
                                            "activities": FieldValue.arrayUnion(
                                              [
                                                "$formattedDate \nSaving for rent\n${ch8t.format(double.tryParse(_rentAmountOldController.text.trim().replaceAll(',', '')))} target amount.",
                                              ],
                                            ),
                                          }).then((value) {
                                            Get.bottomSheet(
                                              isDismissible: true,
                                              SizedBox(
                                                height: 300,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30.0),
                                                    topRight:
                                                        Radius.circular(30.0),
                                                  ),
                                                  child: Container(
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
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
                                                          'RentSpace created',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                "DefaultFontFamily",
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        GFButton(
                                                          onPressed: () async {
                                                            Get.back();
                                                            Get.to(
                                                                SpaceRentFunding(
                                                              amount: (((int.tryParse(_rentAmountOldController
                                                                          .text
                                                                          .trim()
                                                                          .replaceAll(
                                                                              ',',
                                                                              ''))! /
                                                                      _calculateDaysDifference()))
                                                                  .toInt()),
                                                              date:
                                                                  formattedDate,
                                                              interval: 'daily',
                                                              numPayment: 0,
                                                              refId:
                                                                  _rentSpaceID,
                                                              userID: _userID,
                                                            ));
                                                            resetCalculator();
                                                          },
                                                          shape: GFButtonShape
                                                              .pills,
                                                          fullWidthButton: true,
                                                          child: Text(
                                                            'Proceed to payment',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  "DefaultFontFamily",
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
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                            );
                                          });
                                        },
                                        size: 30.0,
                                        icon: Icon(
                                          Icons.add_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        color: brandOne,
                                        fullWidthButton: true,
                                        text:
                                            "Click to save ${ch8t.format((((int.tryParse(_rentAmountOldController.text.trim().replaceAll(',', ''))! / _calculateDaysDifference())).toInt()))} daily for ${_calculateDaysDifference()} days",
                                        textStyle: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontFamily: "DefaultFontFamily",
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(0, 2, 0, 2),
                                        shape: GFButtonShape.pills,
                                      )
                                : Text(""),
                          ],
                        )
                      : Text(""),
                  (_hasCalculate == 'true')
                      ? (_rentSeventy != 0.0)
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "DefaultFontFamily",
                                      letterSpacing: 0.5,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ////////Daily payment
                                  GFButton(
                                    shape: GFButtonShape.pills,
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
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30.0),
                                                topRight: Radius.circular(30.0),
                                              ),
                                              child: Container(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 5, 10, 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                      'RentSpace created',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily:
                                                            "DefaultFontFamily",
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    SizedBox(
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
                                                      child: Text(
                                                        'Proceed to payment',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily:
                                                              "DefaultFontFamily",
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
                                    },
                                    child: Text(
                                      'save ${ch8t.format(double.tryParse(_dailyValue.toString())).toString()} daily for 335 days',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "DefaultFontFamily",
                                        fontSize: 13,
                                      ),
                                    ),
                                    color: brandOne,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ////////Weekly payment
                                  GFButton(
                                    shape: GFButtonShape.pills,
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
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30.0),
                                                topRight: Radius.circular(30.0),
                                              ),
                                              child: Container(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 5, 10, 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                      'RentSpace created',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily:
                                                            "DefaultFontFamily",
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    SizedBox(
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
                                    },
                                    child: Text(
                                      'save ${ch8t.format(double.tryParse(_weeklyValue.toString())).toString()} weekly for 44 weeks',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: "DefaultFontFamily",
                                      ),
                                    ),
                                    color: brandOne,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ////////Monthly payment
                                  GFButton(
                                    shape: GFButtonShape.pills,
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
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30.0),
                                                topRight: Radius.circular(30.0),
                                              ),
                                              child: Container(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 5, 10, 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                      'RentSpace created',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily:
                                                            "DefaultFontFamily",
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    SizedBox(
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
                                                      child: Text(
                                                        'Proceed to payment',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily:
                                                              "DefaultFontFamily",
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
                                    },
                                    child: Text(
                                      'save ${ch8t.format(double.tryParse(_monthlyValue.toString())).toString()} monthly for 11 months',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: "DefaultFontFamily",
                                      ),
                                    ),
                                    color: brandOne,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
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
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            )
                          : Text("")
                      : Text(""),
                  SizedBox(
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
