import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
import 'package:convert/convert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/controller/box_controller.dart';
import 'package:rentspace/controller/deposit_controller.dart';
import 'package:rentspace/controller/rent_controller.dart';
import 'package:rentspace/controller/tank_controller.dart';
import 'package:rentspace/controller/user_controller.dart';

import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:rentspace/controller/utility_controller.dart';
import 'package:rentspace/controller/withdrawal_controller.dart';

class FinanceHealth extends StatefulWidget {
  const FinanceHealth({Key? key}) : super(key: key);

  @override
  _FinanceHealthState createState() => _FinanceHealthState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');

int tankBalance = 0;
int boxBalance = 0;
int depositBalance = 0;
int rentBalance = 0;

int tankInterest = 0;
int boxInterest = 0;
int depositInterest = 0;

int totalUtility = 0;
int totalSavings = 0;
int totalInterest = 0;
int totalWithdraw = 0;

class _FinanceHealthState extends State<FinanceHealth> {
  TextEditingController _incomeController = TextEditingController();
  final UserController userController = Get.find();
  final BoxController boxController = Get.find();
  final DepositController depositController = Get.find();
  final RentController rentController = Get.find();
  final TankController tankController = Get.find();
  final UtilityController utilityController = Get.find();
  final WithdrawalController withdrawalController = Get.find();

  getSavingsAndInterest() {
    if (utilityController.utility.isNotEmpty) {
      for (int h = 0; h < utilityController.utility.length; h++) {
        totalUtility += int.tryParse(utilityController.utility[h].amount)!;
      }
    } else {
      setState(() {
        totalUtility = 0;
      });
    }
    if (withdrawalController.withdrawal.isNotEmpty) {
      for (int g = 0; g < withdrawalController.withdrawal.length; g++) {
        totalWithdraw +=
            int.tryParse(withdrawalController.withdrawal[g].amount)!;
      }
    } else {
      setState(() {
        totalUtility = 0;
      });
    }
    if (tankController.tank.isNotEmpty) {
      for (int i = 0; i < tankController.tank.length; i++) {
        tankBalance += tankController.tank[i].targetAmount.toInt();
        tankInterest += tankController.tank[i].upfront.toInt();
      }
    } else {
      setState(() {
        tankBalance = 0;
      });
    }
    if (rentController.rent.isNotEmpty) {
      for (int j = 0; j < rentController.rent.length; j++) {
        rentBalance += rentController.rent[j].savedAmount.toInt();
      }
    } else {
      setState(() {
        rentBalance = 0;
      });
    }
    if (boxController.box.isNotEmpty) {
      for (int i = 0; i < boxController.box.length; i++) {
        boxBalance += boxController.box[i].savedAmount.toInt();
        boxInterest += boxController.box[i].upfront.toInt();
      }
    } else {
      setState(() {
        boxBalance = 0;
      });
    }
    if (depositController.deposit.isNotEmpty) {
      for (int i = 0; i < depositController.deposit.length; i++) {
        depositBalance += depositController.deposit[i].savedAmount.toInt();
        depositInterest += depositController.deposit[i].upfront.toInt();
      }
    } else {
      setState(() {
        depositBalance = 0;
      });
    }

    setState(() {
      totalSavings = (tankBalance + rentBalance + boxBalance + depositBalance);
      totalInterest = (tankInterest + boxInterest + depositInterest);
    });
    print(totalWithdraw);
  }

  @override
  initState() {
    super.initState();

    rentBalance = 0;
    tankBalance = 0;
    boxBalance = 0;
    depositBalance = 0;

    tankInterest = 0;
    boxInterest = 0;
    totalUtility = 0;
    totalWithdraw = 0;
    depositInterest = 0;
    getSavingsAndInterest();
  }

  @override
  Widget build(BuildContext context) {
    validateIncome(text) {
      if (text.isEmpty) {
        return 'amount cannot be empty';
      }
      if (int.tryParse(text.replaceAll(',', '')) == null) {
        return 'enter valid number';
      }
      if (int.tryParse(text.replaceAll(',', '')) == 0) {
        return 'number cannot be zero, enter 1 instead';
      }
      if (int.tryParse(text.replaceAll(',', ''))!.isNegative) {
        return 'enter positive number';
      }
      return '';
    }

    final income = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      inputFormatters: [ThousandsFormatter()],
      controller: _incomeController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateIncome,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(
          "Monthly income?",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        prefixText: "₦",
        prefixStyle: TextStyle(
          color: Colors.grey,
          fontSize: 13,
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
        hintText: 'amount in Naira',
        hintStyle: TextStyle(
          color: Colors.grey,
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
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: ListView(
              children: [
                SizedBox(
                  height: 80,
                ),
                Text(
                  'Use the following\nassesments to calculate your\nportfolio worth',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: "DefaultFontFamily",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Your assets are calculated automatically for you.',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontFamily: "DefaultFontFamily",
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                income,
                SizedBox(
                  height: 10,
                ),
                GFButton(
                  onPressed: () async {
                    int inflow = (totalSavings +
                        totalInterest +
                        (int.tryParse(
                            userController.user[0].userWalletBalance)!) +
                        int.tryParse(_incomeController.text
                            .trim()
                            .replaceAll(',', ''))!);
                    int outflow = ((int.tryParse(totalUtility.toString())!) +
                        (int.tryParse(totalWithdraw.toString())!));
                    var outcome =
                        ((((inflow - outflow) / inflow) * 100).toInt());

                    var userHealthUpdate =
                        FirebaseFirestore.instance.collection('accounts');
                    await userHealthUpdate.doc(userId).update({
                      'loan_amount': 0.toString(),
                      'total_savings': totalSavings.toString(),
                      'total_interest': totalInterest.toString(),
                      'total_debts': 0.toString(),
                      'finance_health': outcome.toString(),
                    }).then((value) {
                      Get.back();
                      Get.snackbar(
                        "You scored ${outcome.toString()}%",
                        'Your portfolio has been updated successfully',
                        animationDuration: Duration(seconds: 1),
                        backgroundColor: brandOne,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                      );
                    }).catchError((error) {
                      Get.snackbar(
                        "Error",
                        error.toString(),
                        animationDuration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    });
                  },
                  shape: GFButtonShape.square,
                  fullWidthButton: false,
                  child: Text(
                    'Calculate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: "DefaultFontFamily",
                    ),
                  ),
                  color: brandOne,
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
