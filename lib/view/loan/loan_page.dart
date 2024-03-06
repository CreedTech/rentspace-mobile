import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/controller/user_controller.dart';

import 'package:rentspace/view/actions/onboarding_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'dart:async';
import 'dart:math';
import 'dart:async';

import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../controller/auth/user_controller.dart';
import '../../controller/rent/rent_controller.dart';
import '../../controller/rent_controller.dart';
import '../dashboard/dashboard.dart';
import '../savings/spaceRent/spacerent_history.dart';

String _hasBvn = "";
String _hasKyc = "";
int _interest = 1;
String _userFirst = "";
String _userLast = "";
String _userId = "";

class LoanPage extends StatefulWidget {
  const LoanPage({Key? key}) : super(key: key);

  @override
  _LoanPageState createState() => _LoanPageState();
}

var ch8t = NumberFormat.simpleCurrency(name: 'NGN');
var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
var changeOne = "".obs();
String savedAmount = "0";
String fundingId = "";
String fundDate = "";

int rentBalance = 0;
int totalSavings = 0;
bool hideBalance = false;

class _LoanPageState extends State<LoanPage> {
  final RentController rentController = Get.find();
  final UserController userController = Get.find();

  DateTime parseDate(String dateString) {
    List<int> parts = dateString.split('-').map(int.parse).toList();
    return DateTime(parts[0], parts[1], parts[2]);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  DateTime calculateNextPaymentDate(
      String chosenDateString, String interval, int numberOfIntervals) {
    DateTime chosenDate = parseDate(chosenDateString);
    DateTime nextPaymentDate;

    switch (interval.toLowerCase()) {
      case 'daily':
        nextPaymentDate = chosenDate.add(const Duration(days: 1));
        break;
      case 'weekly':
        nextPaymentDate = chosenDate.add(const Duration(days: 7));
        break;
      case 'monthly':
        nextPaymentDate =
            DateTime(chosenDate.year, chosenDate.month + 1, chosenDate.day);
        break;
      default:
        throw Exception("Invalid interval: $interval");
    }

    return nextPaymentDate;
  }

  Timer? timer;

  String duration = "Days";
  final form = intl.NumberFormat.decimalPattern();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  // getUser() async {
  //   var collection = FirebaseFirestore.instance.collection('accounts');
  //   var docSnapshot = await collection.doc(userId).get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     setState(() {
  //       _userFirst = data?['firstname'];
  //       _userLast = data?['lastname'];
  //       _userId = data?['rentspace_id'];
  //       _hasBvn = data?['bvn'];
  //       _hasKyc = data?['kyc_details'];
  //     });
  //   }
  // }

  @override
  initState() {
    super.initState();
    // getUser();
  }

  @override
  Widget build(BuildContext context) {
    String chosenDateString = rentController.rentModel!.rents![0].date;
    String interval = rentController.rentModel!.rents![0].interval;
    int numberOfIntervals = int.parse(rentController.rentModel!.rents![0].paymentCount);
    DateTime nextPaymentDate =
        calculateNextPaymentDate(chosenDateString, interval, numberOfIntervals);
    String formattedNextDate = formatDate(nextPaymentDate);
    print(((rentController.rentModel!.rents![0].paidAmount) ==
        (rentController.rentModel!.rents![0].amount * 0.7).abs()));
    print(((rentController.rentModel!.rents![0].paidAmount)));
    print(((rentController.rentModel!.rents![0].amount * 0.7)));

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
      margin: const EdgeInsets.all(20),
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
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
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
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
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
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
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
      appBar: AppBar(
        // toolbarHeight: 105.0,
        backgroundColor: Theme.of(context).primaryColorLight,
        elevation: 1.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
        ),
        // centerTitle: true,
        title: Text(
          'Loan',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      //
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 26),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Loan Balance',
                          style: GoogleFonts.nunito(
                            color: Colors.white.withOpacity(0.75),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          nairaFormaet
                              .format(userController.userModel!.userDetails![0].loanAmount)
                              .toString(),
                          style: GoogleFonts.nunito(
                            color: Theme.of(context).colorScheme.background,
                            fontWeight: FontWeight.w800,
                            fontSize: 31.sp,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'of your ',
                              style: GoogleFonts.nunito(
                                color: Colors.white.withOpacity(0.75),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                              ),
                            ),
                            Text(
                              nairaFormaet
                                  .format(rentController.rentModel!.rents![0].amount)
                                  .toString(),
                              style: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.background,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              ' Loan',
                              style: GoogleFonts.nunito(
                                color: Colors.white.withOpacity(0.75),
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Interest Accrued:',
                                        style: GoogleFonts.nunito(
                                          color: (themeChange.isSavedDarkMode())
                                              ? brandTwo
                                              : Colors.white.withOpacity(0.75),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Text(
                                          nairaFormaet
                                              .format(rentController
                                                      .rentModel!.rents![0].amount -
                                                  (rentController.rentModel!.rents![0]
                                                          .amount *
                                                      0.7))
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.nunito(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Center(
                                  child: Text(
                                    'Rent Loan',
                                    style: GoogleFonts.nunito(
                                      color: (themeChange.isSavedDarkMode())
                                          ? brandTwo
                                          : Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25.sp,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 50),
                            backgroundColor: (themeChange.isSavedDarkMode())
                                ? brandOne
                                : brandTwo,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          onPressed: () {
                            // Get.to(const HomePage());
                            // for (int i = 0; i < 2; i++) {
                            //   Get.to(HomePage());
                            // }
                          },
                          child: Text(
                            'Pay Off Loan',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25.sp,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next payement date: ',
                              style: GoogleFonts.nunito(
                                color: Colors.white.withOpacity(0.75),
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              formattedNextDate.toString(),
                              style: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.background,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 400,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 20,
                      bottom: 5,
                      right: 20,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: brandThree,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 0, bottom: 25, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Loan History',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     // print(int.parse(rentController.rent[0].id));
                                //     // Get.to(SpaceRentHistory(
                                //     //   current: 0,
                                //     // ));
                                //   },
                                //   child: Text(
                                //     "See All",
                                //     style: GoogleFonts.nunito(
                                //       fontSize: 12.0,
                                //       fontWeight: FontWeight.w700,
                                //       color: Theme.of(context).primaryColor,
                                //       // decoration: TextDecoration.underline,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          rentController.rentModel!.rents![0].rentHistories.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Image.asset(
                                      'assets/card_empty.png',
                                      height: 200,
                                    ),
                                    Center(
                                      child: Text(
                                        "Nothing to show",
                                        style: GoogleFonts.nunito(
                                          fontSize: 20,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: rentController
                                        .rentModel!.rents![0].rentHistories.reversed
                                        .toList()
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 7),
                                        child: ListTile(
                                          leading: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: Icon(
                                              Icons.arrow_outward_sharp,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                          title: Text(
                                            'Space Rent Saving',
                                            style: GoogleFonts.nunito(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            _formatTime(DateTime.parse(
                                                    (rentController.rentModel!.rents![0]
                                                        .rentHistories.reversed
                                                        .toList()[index]
                                                        .split(" ")[0]
                                                        .substring(
                                                            0,
                                                            rentController
                                                                    .rentModel!.rents![0]
                                                                    .rentHistories
                                                                    .reversed
                                                                    .toList()[
                                                                        index]
                                                                    .split(
                                                                        " ")[0]
                                                                    .length -
                                                                4))))
                                                .toString(),
                                            style: GoogleFonts.nunito(
                                              color: brandTwo,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          // onTap: () {
                                          //   Get.to(
                                          //       CustomTransactionDetailsCard(current: index));
                                          //   // Navigator.pushNamed(context, RouteList.profile);
                                          // },
                                          trailing: Text(
                                            '+ ₦${extractAmount(rentController.rentModel!.rents![0].rentHistories.reversed.toList()[index])}'
                                            // rentController
                                            //     .rent[0].history.reversed
                                            //     .toList()[index]
                                            //     .split(" ")
                                            //     .last
                                            ,
                                            style: GoogleFonts.nunito(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),

      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  String extractAmount(String input) {
    final nairaIndex = input.indexOf('₦');
    if (nairaIndex != -1 && nairaIndex < input.length - 1) {
      return input.substring(nairaIndex + 1).trim();
    }
    return '';
  }
}
