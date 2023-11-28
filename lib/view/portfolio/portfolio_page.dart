import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/controller/rent_controller.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/view/loan/loan_page.dart';
import 'package:rentspace/view/portfolio/finance_health.dart';
import 'package:rentspace/view/savings/savings_withdrawal.dart';
//import 'package:rentspace/view/savings/spaceRent/spacerent_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_liquidate.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
String _totalInterest = "0";
String _loanAmount = "0";
String _totalSavings = "0";
String _totalDebts = "0";
String _totalInvestments = "0";
var changeOne = 6.obs();

class _PortfolioPageState extends State<PortfolioPage> {
  final RentController rentController = Get.find();
  final UserController userController = Get.find();
  getUser() async {
    var collection = FirebaseFirestore.instance.collection('accounts');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        _totalInterest = data?['total_interest'];
        _loanAmount = data?['loan_amount'];
        _totalSavings = data?['total_savings'];
        _totalDebts = data?['total_debts'];
        _totalInvestments = data?['total_investments'];
      });
    }
  }

  late ValueNotifier<double> valueNotifier;
  @override
  initState() {
    super.initState();
    userController.user.isEmpty
        ? valueNotifier = ValueNotifier(0.0)
        : valueNotifier = ValueNotifier(
            double.tryParse(userController.user[0].finance_health)!);
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.07,
              child: Image.asset(
                'assets/icons/RentSpace-icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 60,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        gradientOne,
                        gradientTwo,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Portfolio Overview",
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 0.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DefaultFontFamily",
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Manage your account portfolio",
                        style: TextStyle(
                          fontSize: 14.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "DefaultFontFamily",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total interests:",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DefaultFontFamily",
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "${nairaFormaet.format(int.parse(_totalInterest))}",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                    fontFamily: "DefaultFontFamily",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total savings:",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "DefaultFontFamily",
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "${nairaFormaet.format(int.parse(_totalSavings))}",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    fontFamily: "DefaultFontFamily",
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total loans:",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DefaultFontFamily",
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "${nairaFormaet.format(int.parse(_loanAmount))}",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      letterSpacing: 0.5,
                                      fontFamily: "DefaultFontFamily",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total debts:",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DefaultFontFamily",
                                    letterSpacing: 0.5,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  "${nairaFormaet.format(int.parse(_totalDebts))}",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "DefaultFontFamily",
                                    letterSpacing: 0.5,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: 30,
                ),
                // finance health
                Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: ListTile(
                    title: Text(
                      "My finance health",
                      style: TextStyle(
                        fontFamily: "DefaultFontFamily",
                        fontSize: 30.0,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        color: customColorOne,
                      ),
                    ),
                    subtitle: Text(
                      "Based on portfolio worth",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "DefaultFontFamily",
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        color: brandOne,
                      ),
                    ),
                    trailing: SimpleCircularProgressBar(
                      progressColors: (valueNotifier.value < 70)
                          ? (valueNotifier.value < 30
                              ? ([Colors.red])
                              : ([Colors.cyan]))
                          : [Colors.greenAccent],
                      size: 50.0,
                      animationDuration: 3,
                      backColor: brandThree,
                      backStrokeWidth: 10.0,
                      fullProgressColor: Colors.greenAccent,
                      maxValue: 100,
                      valueNotifier: valueNotifier,
                      progressStrokeWidth: 10.0,
                      startAngle: 0,
                      mergeMode: true,
                      onGetText: (value) {
                        return Text(value.toInt().toString() + "%");
                      },
                    ),
                    tileColor: brandThree,
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Portfolio Actions",
                      style: TextStyle(
                        fontSize: 15.0,
                        letterSpacing: 0.5,
                        fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: customColorOne,
                        //borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(2),
                      child: Image.asset(
                        "assets/icons/portfolio-icon.png",
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  tileColor: brandThree,
                  onTap: () {
                    Get.snackbar(
                      "Coming soon!",
                      'This feature is coming soon to RentSpace!',
                      animationDuration: Duration(seconds: 1),
                      backgroundColor: brandOne,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  leading: Image.asset(
                    "assets/icons/credit-score-icon.png",
                    height: 40,
                    width: 40,
                  ),
                  title: Text(
                    "Credit Score",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "DefaultFontFamily",
                      letterSpacing: 0.5,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    "Build your credit score",
                    style: TextStyle(
                      fontSize: 14.0,
                      letterSpacing: 0.5,
                      fontFamily: "DefaultFontFamily",
                      color: Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  tileColor: brandThree,
                  onTap: () {
                    Get.to(FinanceHealth());
                  },
                  leading: Image.asset(
                    "assets/icons/health-icon.png",
                    height: 40,
                    width: 40,
                  ),
                  title: Text(
                    "Finance Health",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontFamily: "DefaultFontFamily",
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    "Free finance health checker",
                    style: TextStyle(
                      fontSize: 14.0,
                      letterSpacing: 0.5,
                      fontFamily: "DefaultFontFamily",
                      color: Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
