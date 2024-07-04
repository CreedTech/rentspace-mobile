// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:rentspace/controller/wallet/wallet_controller.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_confirmation.dart';

import '../../../constants/colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dialogs/index.dart';
import '../../../widgets/custom_loader.dart';
import '../../../controller/auth/user_controller.dart';

class SpaceRentCreation extends ConsumerStatefulWidget {
  const SpaceRentCreation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpaceRentCreationState();
}

var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');
String _amountValue = "";
double _rentValue = 0.0;
bool isDeviceConnected = false;
bool isAlertSet = false;
late StreamSubscription subscription;

String paymentCount = "";
//savings goals
double _dailyValue = 0.0;
double _savingValue = 0.0;
bool showSaveButton = false;
String selectedId = '';
int numberInDays = 0;
int _duration = 5;
var receivalDate =
    Jiffy.parseFromDateTime(DateTime.now()).add(months: _duration).dateTime;
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
final rentFormKey = GlobalKey<FormState>();
final TextEditingController _rentAmountController = TextEditingController();
final TextEditingController _rentNameController = TextEditingController();
final TextEditingController _endDateController = TextEditingController();
final TextEditingController fundingController = TextEditingController();

List<String> fundingSource = ['DVA Wallet', 'Debit Card'];

class _SpaceRentCreationState extends ConsumerState<SpaceRentCreation> {
  final TextEditingController _intervalController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  DateTime _endDate = DateTime.now();
  List<String> intervalLabels = ['Weekly', 'Monthly'];
  List<String> durations = ['5 months', '6 months', '7 months', '8 months'];

  bool idSelected = false;

  // int _daysInMonth(int month, int year) {
  //   switch (month) {
  //     case 2: // February
  //       if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
  //         return 29; // Leap year
  //       } else {
  //         return 28;
  //       }
  //     case 4: // April
  //     case 6: // June
  //     case 9: // September
  //     case 11: // November
  //       return 30;
  //     default:
  //       return 31;
  //   }
  // }

  int _calculateMonthsDifference(DateTime startDate, int duration) {
    DateTime endDate =
        Jiffy.parseFromDateTime(startDate).add(months: duration).dateTime;

    final startYear = startDate.year;
    final startMonth = startDate.month;
    final endYear = endDate.year;
    final endMonth = endDate.month;

    final monthsDifference =
        ((endYear - startYear) * 12) + (endMonth - startMonth);
    return monthsDifference.abs();
  }

  int _calculateWeeksDifferences(DateTime startDate, int duration) {
    DateTime endDate =
        Jiffy.parseFromDateTime(startDate).add(months: duration).dateTime;

    receivalDate = endDate;
    return endDate.difference(startDate).inDays ~/ 7;
  }

  int _calculateDaysDifference() {
    final differenceDays =
        _endDate.add(const Duration(days: 1)).difference(DateTime.now()).inDays;

    return differenceDays.abs();
  }

  Future<bool> fetchUserData({bool refresh = true}) async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    if (refresh) {
      await userController.fetchData();
      await walletController.fetchWallet();
    }
    EasyLoading.dismiss();
    return true;
  }

  @override
  initState() {
    super.initState();
    getConnectivity();
    fetchUserData();
    numberInDays = 0;
    showSaveButton = false;
    selectedId = '';
    _savingValue = 0.0;
    _rentNameController.clear();
    resetCalculator();
  }

  void getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && !isAlertSet) {
          noInternetConnectionScreen(context);
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  noInternetConnectionScreen(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
            elevation: 0.0,
            alignment: Alignment.bottomCenter,
            insetPadding: const EdgeInsets.all(0),
            title: null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            content: SizedBox(
              height: 170.h,
              child: Container(
                width: 400.w,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Text(
                      'No internet Connection',
                      style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(MediaQuery.of(context).size.width - 50, 50),
                          backgroundColor: brandTwo,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          setState(() => isAlertSet = false);
                          isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!isDeviceConnected && isAlertSet == false) {
                            noInternetConnectionScreen(context);
                            setState(() => isAlertSet = true);
                          }
                        },
                        child: Text(
                          "Try Again",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _rentNameController.clear();
    _rentAmountController.clear();
    _endDateController.clear();
    fundingController.clear();
    _intervalController.clear();
    _durationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    validateFunc(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (text.length < 1) {
        return 'Too short';
      }
      if ((int.tryParse(text.trim().replaceAll(',', ''))! >= 1) &&
          (int.tryParse(text.trim().replaceAll(',', ''))! < 150000)) {
        return 'minimum amount is ₦150,000';
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

    validateEndDate(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      return null;
    }

    //validation function
    validateName(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (text.length < 1) {
        return 'Too short';
      }

      return null;
    }

// calculate rent
    Future<void> calculateRent(rent) async {
      setState(() {
        _amountValue = _rentAmountController.text;
        _rentValue = rent;
        if (_intervalController.text.toLowerCase() == "weekly") {
          paymentCount =
              _calculateWeeksDifferences(_endDate, _duration).toString();

          _savingValue =
              ((rent) / _calculateWeeksDifferences(_endDate, _duration));
        } else {
          paymentCount =
              _calculateMonthsDifference(_endDate, _duration).toString();
          _savingValue =
              ((rent) / _calculateMonthsDifference(_endDate, _duration));
        }
        _dailyValue = ((rent) / _calculateDaysDifference());
      });
    }

    // int calculateDaysInMonths(DateTime startDate, int months) {
    //   int daysInMonths = 0;
    //   for (int i = 0; i < months; i++) {
    //     daysInMonths += _daysInMonth(startDate.month + i, startDate.year);
    //   }
    //   return daysInMonths;
    // }

    Future<void> selectEndDate(BuildContext context) async {
      final DateTime now = DateTime.now();

      final DateTime? picked = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primaryContainer: brandTwo,
                primary: brandTwo, // header background color
                onPrimary: Colors.white,
                onBackground: brandTwo,

                outline: brandTwo,
                background: brandTwo,
                onSurface: brandTwo, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: brandTwo, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)),
      );
      if (picked != null &&
          picked != now &&
          !picked.difference(now).inDays.isNaN) {
        setState(() {
          _endDate = picked;
          Duration difference = picked.difference(now);
          numberInDays = difference.inDays + 1;
          if (validateFunc(
                  _rentAmountController.text.trim().replaceAll(',', '')) ==
              null) {
            showSaveButton = true;
            _endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
          } else {
            if (context.mounted) {
              customErrorDialog(
                  context, 'Invalid', "Please enter valid amount to proceed.");
            }
          }
        });
      }
    }

    final rentName = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _rentNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 12,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      validator: validateName,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      keyboardType: TextInputType.text,
      inputFormatters: const [],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: '',
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    final rentAmount = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _rentAmountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateFunc,
      // update the state variable when the text changes
      onChanged: (text) {
        setState(() {
          _amountValue = "";
          _rentValue = 0.0;
          showSaveButton = false;
          _endDateController.clear();
        });
        setState(() => _amountValue = text);
      },
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsFormatter()],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        prefixText: "₦ ",
        prefixStyle: GoogleFonts.roboto(
          color: Theme.of(context).brightness == Brightness.dark
              ? colorWhite
              : Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        // hintText: 'Rent amount in Naira',
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    final endDate = TextFormField(
      controller: _endDateController,
      cursorColor: Theme.of(context).colorScheme.primary,
      validator: validateEndDate,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      readOnly: true,
      // onTap: _showDatePicker,
      onTap: () => selectEndDate(context),
      decoration: InputDecoration(
        // labelText: 'Select Start Date',
        labelStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          Icons.calendar_today,
          color: Theme.of(context).colorScheme.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
    );

    final frequencySelect = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.45,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Select Frequency',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: intervalLabels.length,
                        itemBuilder: (context, idx) {
                          return Column(
                            children: [
                              ListTileTheme(
                                contentPadding: const EdgeInsets.only(
                                    left: 13.0, right: 13.0, top: 4, bottom: 4),
                                selectedColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          intervalLabels[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      idSelected = true;
                                    });

                                    _intervalController.text =
                                        intervalLabels[idx];
                                    // });

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != intervalLabels.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
                                      height: 1,
                                      indent: 13,
                                      endIndent: 13,
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),

      controller: _intervalController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        filled: false,
        fillColor: Colors.transparent,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      ),
      maxLines: 1,
    );
    final durationSelect = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Select Duration',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: durations.length,
                        itemBuilder: (context, idx) {
                          return Column(
                            children: [
                              ListTileTheme(
                                contentPadding: const EdgeInsets.only(
                                    left: 13.0, right: 13.0, top: 4, bottom: 4),
                                selectedColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          durations[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      idSelected = true;
                                      _duration = int.parse(
                                          durations[idx].split(' ')[0]);
                                    });

                                    _durationController.text = durations[idx];

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != durations.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
                                      height: 1,
                                      indent: 13,
                                      endIndent: 13,
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),

      controller: _durationController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        filled: false,
        fillColor: Colors.transparent,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      ),
      maxLines: 1,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                resetCalculator();
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(
              width: 4.h,
            ),
            Text(
              'Create Space Rent',
              style: GoogleFonts.lato(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Form(
                          key: rentFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/space_rent_img_round.png',
                                width: 86.w,
                              ),
                              SizedBox(
                                height: 32.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 3),
                                    child: Text(
                                      'Space Rent Name',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  rentName,
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 3),
                                    child: Text(
                                      'Rent Amount',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  rentAmount,
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 3),
                                    child: Text(
                                      'Start Date',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  endDate,
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 3),
                                    child: Text(
                                      'Select Frequency',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  frequencySelect,
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 3),
                                    child: Text(
                                      'Select Duration',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  durationSelect,
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                    text: 'Proceed',
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (rentFormKey.currentState!.validate()) {
                        await calculateRent(double.tryParse(
                                _rentAmountController.text
                                    .trim()
                                    .replaceAll(',', '')))
                            .then((value) {
                          Get.to(
                            SpaceRentConfirmationPage(
                              rentValue: _rentValue,
                              savingsValue: _savingValue,
                              startDate: _endDateController.text,
                              receivalDate: receivalDate,
                              durationType: _intervalController.text,
                              paymentCount: paymentCount,
                              rentName: _rentNameController.text,
                              duration: _duration,
                            ),
                          );
                        });
                      } else {
                        customErrorDialog(context, "Invalid",
                            "Please Fill All Required Fields");
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  resetCalculator() {
    setState(() {
      _amountValue = "";
      _rentValue = 0.0;
      _savingValue = 0.0;
    });
    _rentNameController.clear();
    _rentAmountController.clear();
    _endDateController.clear();
    fundingController.clear();
    _intervalController.clear();
  }
}
