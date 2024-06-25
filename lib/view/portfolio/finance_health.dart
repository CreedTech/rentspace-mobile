import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:intl/intl.dart';
// import 'package:rentspace/controller/box_controller.dart';
// import 'package:rentspace/controller/deposit_controller.dart';
// import 'package:rentspace/controller/rent_controller.dart';
// import 'package:rentspace/controller/tank_controller.dart';
// import 'package:rentspace/controller/user_controller.dart';

import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
import 'package:rentspace/controller/wallet/wallet_controller.dart';
// import 'package:rentspace/controller/utility_controller.dart';
// import 'package:rentspace/controller/withdrawal_controller.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';

class FinanceHealth extends StatefulWidget {
  const FinanceHealth({Key? key}) : super(key: key);

  @override
  _FinanceHealthState createState() => _FinanceHealthState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');

double tankBalance = 0;
double boxBalance = 0;
double depositBalance = 0;
double rentBalance = 0;

double tankInterest = 0;
double boxInterest = 0;
double depositInterest = 0;

double totalUtility = 0;
double totalSavings = 0;
double totalInterest = 0;
double totalWithdraw = 0;

class _FinanceHealthState extends State<FinanceHealth> {
  TextEditingController _incomeController = TextEditingController();
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  // final DepositController depositController = Get.find();
  final RentController rentController = Get.find();
  // final TankController tankController = Get.find();
  // final UtilityController utilityController = Get.find();
  // final WithdrawalController withdrawalController = Get.find();
  final financeformKey = GlobalKey<FormState>();

  getSavingsAndInterest() {
    // if (utilityController.utility.isNotEmpty) {
    //   for (int h = 0; h < utilityController.utility.length; h++) {
    //     totalUtility += int.tryParse(utilityController.utility[h].amount)!;
    //   }
    // } else {
    //   setState(() {
    //     totalUtility = 0;
    //   });
    // }
    // if (withdrawalController.withdrawal.isNotEmpty) {
    //   for (int g = 0; g < withdrawalController.withdrawal.length; g++) {
    //     totalWithdraw +=
    //         int.tryParse(withdrawalController.withdrawal[g].amount)!;
    //   }
    // } else {
    //   setState(() {
    //     totalUtility = 0;
    //   });
    // }
    // if (tankController.tank.isNotEmpty) {
    //   for (int i = 0; i < tankController.tank.length; i++) {
    //     tankBalance += tankController.tank[i].targetAmount.toInt();
    //     tankInterest += tankController.tank[i].upfront.toInt();
    //   }
    // } else {
    //   setState(() {
    //     tankBalance = 0;
    //   });
    // }
    // if (rentController.rent.isNotEmpty) {
    //   rentBalance += rentController.rent[0].paidAmount;
    //   // for (int j = 0; j < rentController.rent.length; j++) {
    //   // }
    // } else {
    //   setState(() {
    //     rentBalance = 0;
    //   });
    // }
    // if (boxController.box.isNotEmpty) {
    //   for (int i = 0; i < boxController.box.length; i++) {
    //     boxBalance += boxController.box[i].savedAmount.toInt();
    //     boxInterest += boxController.box[i].upfront.toInt();
    //   }
    // } else {
    //   setState(() {
    //     boxBalance = 0;
    //   });
    // }
    // if (depositController.deposit.isNotEmpty) {
    //   for (int i = 0; i < depositController.deposit.length; i++) {
    //     depositBalance += depositController.deposit[i].savedAmount.toInt();
    //     depositInterest += depositController.deposit[i].upfront.toInt();
    //   }
    // } else {
    //   setState(() {
    //     depositBalance = 0;
    //   });
    // }

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
      return null;
    }

    final income = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      inputFormatters: [ThousandsFormatter()],
      controller: _incomeController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateIncome,
      style: GoogleFonts.lato(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(
          "Monthly income ? ",
          style: GoogleFonts.lato(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        prefixText: "₦",
        prefixStyle: GoogleFonts.roboto(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'amount in Naira',
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
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
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Finance Health',
          style: GoogleFonts.lato(
            color: brandOne,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Form(
              key: financeformKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Use the following assesments to calculate your portfolio worth',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your assets are calculated automatically for you.',
                    style: GoogleFonts.lato(
                      color: const Color(0xff4E4B4B),
                      fontSize: 14,
                      // fontFamily: "DefaultFontFamily",
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  income,
                  const SizedBox(
                    height: 120,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // width: MediaQuery.of(context).size.width * 2,
                      alignment: Alignment.center,
                      // height: 110.h,
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(400, 50),
                              backgroundColor: brandOne,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              // EasyLoading.show(
                              //   indicator: const CustomLoader(),
                              //   maskType: EasyLoadingMaskType.black,
                              //   dismissOnTap: false,
                              // );
                              // if (financeformKey.currentState!.validate()) {
                              //   int inflow = (totalSavings +
                              //       totalInterest +
                              //       (walletController
                              //           .walletModel!.wallet![0].mainBalance) +
                              //       int.tryParse(_incomeController.text
                              //           .trim()
                              //           .replaceAll(',', ''))!);
                              //   int outflow = ((int.tryParse(
                              //           totalUtility.toString())!) +
                              //       (int.tryParse(totalWithdraw.toString())!));
                              //   var outcome =
                              //       ((((inflow - outflow) / inflow) * 100)
                              //           .toInt());

                              //   var userHealthUpdate = FirebaseFirestore
                              //       .instance
                              //       .collection('accounts');
                              //   await userHealthUpdate.doc(userId).update({
                              //     'loan_amount': 0.toString(),
                              //     'total_savings': totalSavings.toString(),
                              //     'total_interest': totalInterest.toString(),
                              //     'total_debts': 0.toString(),
                              //     'finance_health': outcome.toString(),
                              //   }).then((value) {
                              //     EasyLoading.dismiss();
                              //     Get.back();
                              //     showTopSnackBar(
                              //       Overlay.of(context),
                              //       CustomSnackBar.success(
                              //         backgroundColor: brandOne,
                              //         message:
                              //             'You scored ${outcome.toString()}%',
                              //         textStyle: GoogleFonts.lato(
                              //           fontSize: 14,
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.w700,
                              //         ),
                              //       ),
                              //     );
                              //   }).catchError((error) {
                              //     EasyLoading.dismiss();
                              //     if (context.mounted) {
                              //       customErrorDialog(
                              //         context,
                              //         'Error',
                              //         error.toString(),
                              //       );
                              //     }

                              //   });
                              // } else {
                              //   EasyLoading.dismiss();
                              //   if (context.mounted) {
                              //     customErrorDialog(
                              //       context,
                              //       'Invalid! :)',
                              //       'Please fill the form properly to proceed',
                              //     );
                              //   }

                              // }
                            },
                            child: const Text(
                              'Calculate',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
