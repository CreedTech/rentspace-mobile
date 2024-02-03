import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/controller/rent_controller.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/view/loan/loan_page.dart';
import 'package:rentspace/view/portfolio/finance_health.dart';
//import 'package:rentspace/view/savings/spaceRent/spacerent_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/widgets/separator.dart';

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
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Portfolio',
          style: GoogleFonts.nunito(
            color: brandOne,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // color: brandOne,
                    gradient: const LinearGradient(
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
                        style: GoogleFonts.nunito(
                          fontSize: 20.0,
                          // letterSpacing: 0.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Manage your account portfolio",
                        style: GoogleFonts.nunito(
                          fontSize: 16.0,
                          // letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total interests:",
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,

                                    // letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  nairaFormaet
                                      .format(int.parse(_totalInterest)),
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    // letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const MySeparator(
                              color: Color(0xffE0E0E0),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total savings:",
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,

                                    // letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  nairaFormaet.format(int.parse(_totalSavings)),
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    // letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const MySeparator(
                              color: Color(0xffE0E0E0),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total loans:",
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,

                                    // letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  nairaFormaet.format(int.parse(_loanAmount)),
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    // letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const MySeparator(
                              color: Color(0xffE0E0E0),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total debts:",
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,

                                    // letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  nairaFormaet.format(int.parse(_totalDebts)),
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    // letterSpacing: 0.5,
                                    color: Colors.black,
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
                const SizedBox(
                  height: 20,
                ),

                // const SizedBox(
                //   height: 30,
                // ),
                // finance health

                // const SizedBox(
                //   height: 30,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Portfolio Actions",
                      style: GoogleFonts.nunito(
                        fontSize: 20.0,
                        // letterSpacing: 0.5,

                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: Image.asset(
                        "assets/icons/carbon_portfolio.png",
                        height: 28,
                        width: 29,
                        color: brandOne,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Container(
                    decoration: BoxDecoration(
                      color: brandThree,
                      borderRadius:
                          BorderRadius.circular(8.0), // Set border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: ListTile(
                        // shape: ShapeBorder,
                        leading: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: brandTwo.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Iconsax.money_recive5,
                            color: brandOne,
                          ),
                        ),
                        title: Text(
                          'Loan',
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "Access Your Loan",
                          style: GoogleFonts.nunito(
                            fontSize: 14.0,
                            // letterSpacing: 0.5,

                            color: const Color(0xff828282),
                          ),
                        ),
                        onTap: () {
                          ((rentController.rent[0].savedAmount) !=
                                  (rentController.rent[0].targetAmount * 0.7))
                              ? showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.success(
                                    backgroundColor: brandOne,
                                    message: 'Coming soon !!',
                                    textStyle: GoogleFonts.nunito(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              : Get.to(const LoanPage());
                          // Get.to(const ProfilePage());
                          // Navigator.pushNamed(context, RouteList.profile);
                        },
                        trailing: const Icon(
                          Iconsax.arrow_right_3,
                          color: brandOne,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Container(
                    decoration: BoxDecoration(
                      color: brandThree,
                      borderRadius:
                          BorderRadius.circular(8.0), // Set border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: ListTile(
                        // shape: ShapeBorder,
                        leading: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: brandTwo.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Icons.credit_score,
                            color: brandOne,
                          ),
                        ),
                        title: Text(
                          'Credit Score',
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "Build your credit score",
                          style: GoogleFonts.nunito(
                            fontSize: 14.0,
                            // letterSpacing: 0.5,

                            color: const Color(0xff828282),
                          ),
                        ),
                        onTap: () {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.success(
                              backgroundColor: brandOne,
                              message: 'Coming soon !!',
                              textStyle: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                          // Get.to(const ProfilePage());
                          // Navigator.pushNamed(context, RouteList.profile);
                        },
                        trailing: const Icon(
                          Iconsax.arrow_right_3,
                          color: brandOne,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Container(
                    decoration: BoxDecoration(
                      color: brandThree,
                      borderRadius:
                          BorderRadius.circular(8.0), // Set border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: ListTile(
                        // shape: ShapeBorder,
                        leading: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: brandTwo.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Icons.heart_broken_outlined,
                            color: brandOne,
                          ),
                        ),
                        title: Text(
                          'Finance Health',
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "Free finance health checker",
                          style: GoogleFonts.nunito(
                            fontSize: 14.0,
                            // letterSpacing: 0.5,

                            color: const Color(0xff828282),
                          ),
                        ),
                        onTap: () {
                          Get.to(const FinanceHealth());
                        },
                        trailing: const Icon(
                          Iconsax.arrow_right_3,
                          color: brandOne,
                        ),
                      ),
                    ),
                  ),
                ),

                // Container(
                //   decoration: BoxDecoration(
                //     // border: Border.all(
                //     //   color: Colors.grey, // Set the border color
                //     //   width: 1.0, // Set the border width
                //     // ),
                //     color: brandThree,
                //     borderRadius:
                //         BorderRadius.circular(8.0), // Set border radius
                //   ),
                //   child: ListTile(
                //     // tileColor: brandThree,
                //     onTap: () {
                //       showTopSnackBar(
                //         Overlay.of(context),
                //         CustomSnackBar.success(
                //           backgroundColor: brandOne,
                //           message: 'Coming soon !!',
                //           textStyle: GoogleFonts.nunito(
                //             fontSize: 14,
                //             color: Colors.white,
                //             fontWeight: FontWeight.w700,
                //           ),
                //         ),
                //       );
                //       // Get.snackbar(
                //       //   "Coming soon!",
                //       //   'This feature is coming soon to RentSpace!',
                //       //   animationDuration: const Duration(seconds: 1),
                //       //   backgroundColor: brandOne,
                //       //   colorText: Colors.white,
                //       //   snackPosition: SnackPosition.TOP,
                //       // );
                //     },
                //     leading: const Icon(
                //       Icons.credit_score,
                //       color: brandOne,
                //       size: 30,
                //     ),
                //     title: const Text(
                //       "Credit Score",
                //       style: TextStyle(
                //         fontSize: 15.0,
                //         fontWeight: FontWeight.bold,
                //         fontFamily: "DefaultFontFamily",
                //         letterSpacing: 0.5,
                //         color: Colors.black,
                //       ),
                //     ),
                //     subtitle: const Text(
                //       "Build your credit score",
                //       style: TextStyle(
                //         fontSize: 14.0,
                //         letterSpacing: 0.5,
                //         fontFamily: "DefaultFontFamily",
                //         color: Colors.black,
                //       ),
                //     ),
                //     trailing: const Icon(
                //       Icons.arrow_right_outlined,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
                // // const SizedBox(
                // //   height: 20,
                // // ),
                // ListTile(
                //   tileColor: brandThree,
                //   onTap: () {
                //     Get.to(const FinanceHealth());
                //   },
                //   leading: Image.asset(
                //     "assets/icons/health-icon.png",
                //     height: 40,
                //     width: 40,
                //   ),
                //   title: const Text(
                //     "Finance Health",
                //     style: TextStyle(
                //       fontSize: 15.0,
                //       fontFamily: "DefaultFontFamily",
                //       letterSpacing: 0.5,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black,
                //     ),
                //   ),
                //   subtitle: const Text(
                //     "Free finance health checker",
                //     style: TextStyle(
                //       fontSize: 14.0,
                //       letterSpacing: 0.5,
                //       fontFamily: "DefaultFontFamily",
                //       color: Colors.black,
                //     ),
                //   ),
                //   trailing: const Icon(
                //     Icons.arrow_right_outlined,
                //     color: Colors.black,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
