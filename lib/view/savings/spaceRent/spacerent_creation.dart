// ignore_for_file: use_build_context_synchronously

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:rentspace/controller/wallet_controller.dart';

import '../../../constants/colors.dart';
import '../../../constants/widgets/custom_dialog.dart';
import '../../../constants/widgets/custom_loader.dart';
import '../../../controller/app_controller.dart';
import '../../../controller/auth/user_controller.dart';
import '../../actions/fund_wallet.dart';

class SpaceRentCreation extends ConsumerStatefulWidget {
  const SpaceRentCreation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpaceRentCreationState();
}

var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');
String _id = '';
String _rentSpaceID = '';
String _amountValue = "";
double _rentValue = 0.0;
double _rentSeventy = 0.0;
double _rentThirty = 0.0;
double _holdingFee = 0.0;
String _canShowRent = 'false';
String _hasCalculate = 'true';

String paymentCount = "";
//savings goals
double _dailyValue = 0.0;
double _savingValue = 0.0;
double _rentAmount = 0.0;
double _weeklyValue = 0.0;
double _monthlyValue = 0.0;
bool showSaveButton = false;
String selectedId = '';
int numberInDays = 0;
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
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  // DateTime selectedDate = DateTime.now().add(Duration(days: 6 * 30));
  DateTime _endDate = DateTime.now();
  List<String> intervalLabels = ['Weekly', 'Monthly'];

  bool idSelected = false;
  String durationType = "";

  int _daysInMonth(int month, int year) {
    switch (month) {
      case 2: // February
        if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
          return 29; // Leap year
        } else {
          return 28;
        }
      case 4: // April
      case 6: // June
      case 9: // September
      case 11: // November
        return 30;
      default:
        return 31;
    }
  }

  // int _daysInMonth(int month) {
  //   switch (month) {
  //     case 2: // February
  //       return 28;
  //     case 4: // April
  //     case 6: // June
  //     case 9: // September
  //     case 11: // November
  //       return 30;
  //     default:
  //       return 31;
  //   }
  // }

  int _calculateDaysInSixMonths(DateTime today) {
    // Calculate the number of days in the next 6 months
    int daysInSixMonths = 0;
    for (int i = 0; i < 6; i++) {
      // Calculate days in each month and add to total
      daysInSixMonths += _daysInMonth(today.month + i, today.year);
    }
    // print('here');
    // print(daysInSixMonths);
    // print('daysInSixMonths');
    // print(_daysInMonth(today.month + 6, today.year));
    return daysInSixMonths;
  }

  int _calculateDaysInEightMonths(DateTime today) {
    int daysInEightMonths = 0;
    for (int i = 0; i < 8; i++) {
      daysInEightMonths += _daysInMonth(today.month + i, today.year);
    }
    // print(daysInEightMonths);
    // print('daysInEightMonths');
    // print(_daysInMonth(today.month + 8, today.year));
    return daysInEightMonths;
  }

  // int _calculateMonthsDifference() {
  //   final differenceMonths = _endDate
  //           .add(const Duration(days: 1))
  //           .difference(DateTime.now())
  //           .inDays ~/
  //       30; // Calculate difference in months
  //   print('differenceMonths');
  //   print(differenceMonths);

  //   return differenceMonths.abs();
  // }
  int _calculateMonthsDifference() {
    final startDate = DateTime.now();
    final endDate = _endDate;

    final startYear = startDate.year;
    final startMonth = startDate.month;
    final endYear = endDate.year;
    final endMonth = endDate.month;

    final monthsDifference =
        ((endYear - startYear) * 12) + (endMonth - startMonth);

    // print('monthsDifference: $monthsDifference');

    return monthsDifference.abs();
  }

  // int _calculateWeeksDifference() {
  //   final differenceMonths = _calculateMonthsDifference();
  //   final differenceWeeks = differenceMonths * 4; // Assuming 4 weeks in a month
  //   print('differenceWeeks');
  //   print(differenceWeeks);

  //   return differenceWeeks.abs();
  // }
  // import 'dart:math';

int _calculateWeeksDifference() {
  final startDate = DateTime.now();
  final endDate = _endDate;

  final differenceInDays = endDate.difference(startDate).inDays;
  final weeksDifference = (differenceInDays / 7).ceil();

  // print('weeksDifference: $weeksDifference');

  return weeksDifference.abs();
}


  // String _formatWeeksDifference() {
  //   final weeksDifference = _calculateWeeksDifference();
  //   return '$weeksDifference weeks';
  // }

  bool isWithinRange() {
    int monthsDifference = _calculateMonthsDifference();
    return monthsDifference >= 6 && monthsDifference <= 8;
  }

  int _calculateDaysDifference() {
    // final differenceDays = selectedDate
    //     .add(const Duration(days: 1))
    //     .difference(DateTime.now())
    //     .inDays;
    final differenceDays =
        _endDate.add(const Duration(days: 1)).difference(DateTime.now()).inDays;

    return differenceDays.abs();
  }

  getCurrentUser() async {
    setState(() {
      _id = userController.userModel!.userDetails![0].id;
    });
    // print(_id);
    // print(_rentSpaceID);
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
      // setState(() {}); // Move setState inside fetchData
    }
    EasyLoading.dismiss();
    return true;
  }

  @override
  initState() {
    super.initState();
    fetchUserData();
    numberInDays = 0;
    showSaveButton = false;
    selectedId = '';
    _savingValue = 0.0;
    _rentNameController.clear();
    getCurrentUser();
    resetCalculator();
    _intervalController.addListener(_updateDurationType);
  }

  void _updateDurationType() {
    setState(() {
      durationType = _intervalController.text;
    });
    // print(durationType);
  }

  @override
  void dispose() {
    super.dispose();
    _rentNameController.clear();
    _rentAmountController.clear();
    _endDateController.clear();
    fundingController.clear();
    _intervalController.clear();
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    // Calculate the date 6 months from today
    // DateTime sixMonthsLater =
    //     today.add(Duration(days: _calculateDaysInSixMonths(today)));

    // print('6 months from today is: $sixMonthsLater');
    int daysInSixMonths = _calculateDaysInSixMonths(today);
    int daysInEightMonths = _calculateDaysInEightMonths(today);

    // DateTime sixMonthsLater = today.add(Duration(days: daysInSixMonths));
    // print('6 months from today is: $daysInSixMonths');
    // print('8 months from today is: $daysInEightMonths');
    final rentState = ref.watch(appControllerProvider.notifier);

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

///////calculate rent
    calculateRent(rent) {
      // print('_calculateDaysDifference()');
      // print(_calculateDaysDifference());
      // print(_calculateMonthsDifference());
      // print(_calculateWeeksDifference());
      setState(() {
        _rentThirty = (rent - (rent * 0.7));
        _rentSeventy = (rent * 0.7);
        // _rentAmount = double.parse(_rentAmountController.text.trim().replaceAll(',', ''));
        _amountValue = _rentAmountController.text;
        _holdingFee = 0.01 * _rentSeventy;
        _rentValue = rent;
        _hasCalculate = 'true';
        if (durationType == "Weekly") {
          paymentCount = _calculateWeeksDifference().toString();
          _savingValue = ((rent) / _calculateWeeksDifference());
        } else {
          paymentCount = _calculateMonthsDifference().toString();
          _savingValue = ((rent) / _calculateMonthsDifference());
        }
        _dailyValue = ((rent) / _calculateDaysDifference());
      });
    }

    // void _showDatePicker() {
    //   DatePicker.showDatePicker(
    //     context,
    //     onMonthChangeStartWithFirstDate: true,
    //     pickerTheme: DateTimePickerTheme(
    //       backgroundColor: brandOne,
    //       itemTextStyle: GoogleFonts.nunito(color: Colors.white),
    //       itemHeight: 50.h,
    //       pickerHeight: 300.h,
    //       showTitle: true,
    //       cancel: Icon(
    //         Iconsax.close_circle,
    //         color: Colors.white,
    //         size: 30.sp,
    //       ),
    //       confirm: Text(
    //         'Done',
    //         style: GoogleFonts.nunito(color: Colors.white),
    //       ),
    //     ),
    //     initialDateTime: selectedDate,
    //     minDateTime: DateTime.now().add(Duration(days: 6 * daysInSixMonths)),
    //     maxDateTime: DateTime.now().add(
    //       Duration(days: 8 * daysInEightMonths),
    //     ),
    //     dateFormat: _format,
    //     locale: DateTimePickerLocale.en_us,
    //     onCancel: () => print('onCancel'),
    //     onChange: (dateTime, List<int> index) {
    //       setState(() {
    //         _dateTime = dateTime;
    //       });
    //     },
    //     onConfirm: (dateTime, List<int> index) {
    //       setState(() {
    //         _dateTime = dateTime;
    //       });
    //       print(dateTime);
    //     },
    //     onClose: () {
    //       if (_dateTime != null && _dateTime != selectedDate) {
    //         // final int age = DateTime.now().year - _dateTime!.year;
    //         setState(() {
    //           selectedDate = _dateTime!;
    //           Duration difference = _dateTime!.difference(DateTime.now());
    //           print(difference.inDays);
    //           numberInDays = difference.inDays;
    //           if (validateFunc(
    //                   _rentAmountController.text.trim().replaceAll(',', '')) ==
    //               null) {
    //             setState(() {
    //               showSaveButton = true;
    //               selectedDate = _dateTime!;
    //               _endDateController.text =
    //                   DateFormat('dd/MM/yyyy').format(selectedDate);
    //               _canShowRent = 'true';
    //             });
    //           } else {
    //             if (context.mounted) {
    //               customErrorDialog(context, 'Invalid',
    //                   "Please enter valid amount to proceed.");
    //             }
    //           }
    //         });
    //       }
    //     },
    //   );
    // }

    int calculateDaysInMonths(DateTime startDate, int months) {
      int daysInMonths = 0;
      for (int i = 0; i < months; i++) {
        daysInMonths += _daysInMonth(startDate.month + i, startDate.year);
      }
      return daysInMonths;
    }

    Future<void> selectEndDate(BuildContext context) async {
      final DateTime now = DateTime.now();
      final DateTime sixMonthsLater =
          now.add(Duration(days: calculateDaysInMonths(now, 6)));
      final DateTime eightMonthsLater =
          now.add(Duration(days: calculateDaysInMonths(now, 8)));

      // final picks = await showDateRangePicker(
      //     context: context,
      //     firstDate: DateTime.now(),
      //     lastDate: DateTime(2030));

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
                // onSecondary: brandTwo,

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
        initialDate: sixMonthsLater,
        firstDate: sixMonthsLater,
        lastDate: eightMonthsLater,
      );
      if (picked != null &&
          picked != now &&
          !picked.difference(now).inDays.isNaN) {
        setState(() {
          _endDate = picked;
          Duration difference = picked.difference(now);
          // Duration difference = picked.difference(DateTime.now());
          // print(difference.inDays + 1);
          numberInDays = difference.inDays + 1;
          // print('numberInDays');
          // print(numberInDays);
          if (validateFunc(
                  _rentAmountController.text.trim().replaceAll(',', '')) ==
              null) {
            if (numberInDays < daysInSixMonths) {
              showSaveButton = false;
              customErrorDialog(
                  context, 'Invalid date', 'Minimum duration is 6 months');
            } else if (numberInDays > daysInEightMonths) {
              showSaveButton = false;
              customErrorDialog(
                  context, 'Invalid date', 'Maximum duration is 8 months');
            } else {
              showSaveButton = true;
              _endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
            }
          } else {
            if (context.mounted) {
              customErrorDialog(
                  context, 'Invalid', "Please enter valid amount to proceed.");
            }
          }

          // calculateRent(rent);
          _canShowRent = 'true';
        });
      }
    }

    final rentName = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _rentNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateName,
      // update the state variable when the text changes
      // onChanged: (text) => setState(() => _nameValue = text),
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.text,
      inputFormatters: const [],
      decoration: InputDecoration(
        label: Text(
          "Enter Rent name",
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: '',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    final rentAmount = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _rentAmountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateFunc,
      // update the state variable when the text changes
      onChanged: (text) {
        setState(() {
          _amountValue = "";
          _rentValue = 0.0;
          _rentSeventy = 0.0;
          _rentThirty = 0.0;
          _holdingFee = 0.0;
          _hasCalculate = 'true';
          _canShowRent = 'false';
          showSaveButton = false;
          _endDateController.clear();
        });
        setState(() => _amountValue = text);
      },
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
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
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        prefixText: "₦ ",
        prefixStyle: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w700,
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
    final endDate = TextFormField(
      controller: _endDateController,
      cursorColor: Theme.of(context).primaryColor,
      validator: validateEndDate,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      readOnly: true,
      // onTap: _showDatePicker,
      onTap: () => selectEndDate(context),
      decoration: InputDecoration(
        labelText: 'End Date',
        labelStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: const Icon(
          Icons.calendar_today,
          color: brandOne,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
    );

    return Scaffold(
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
        title: Text(
          'Create Spacerent Savings',
          style: GoogleFonts.nunito(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: rentFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 3),
                            child: Text(
                              'Space Rent Name',
                              style: GoogleFonts.nunito(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          rentName,
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
                              'Target Amount',
                              style: GoogleFonts.nunito(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                // fontFamily: "DefaultFontFamily",
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
                              'Select Frequency',
                              style: GoogleFonts.nunito(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomDropdown(
                        selectedStyle: GoogleFonts.nunito(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12),
                        hintText: 'Select frequency',
                        hintStyle: GoogleFonts.nunito(fontSize: 12),
                        excludeSelected: true,
                        fillColor: Colors.transparent,
                        listItemStyle: GoogleFonts.nunito(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 12),
                        items: intervalLabels,
                        controller: _intervalController,
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        fieldSuffixIcon: Icon(
                          Iconsax.arrow_down5,
                          size: 25.h,
                          color: Theme.of(context).primaryColor,
                        ),
                        onChanged: (String val) {
                          setState(() {
                            idSelected = true;
                            durationType = _intervalController.text;
                            // durationType = _intervalController.text;
                          });

                          // print(val);
                        },
                      ),
                      (idSelected == true)
                          ? const SizedBox()
                          : const SizedBox(),
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
                              'End Date',
                              style: GoogleFonts.nunito(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          endDate,
                          (numberInDays < daysInSixMonths)
                              ? const Text("")
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 3),
                                  child: Text(
                                    'Due in ${_calculateDaysDifference()} days',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.nunito(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              // (showSaveButton == true)
              //     ?
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 50),
                      backgroundColor: brandOne,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (rentFormKey.currentState!.validate()) {
                        calculateRent(double.tryParse(_rentAmountController.text
                            .trim()
                            .replaceAll(',', '')));
                        Get.bottomSheet(
                          isDismissible: true,
                          SizedBox(
                            height: 400,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              child: Container(
                                color: Theme.of(context).canvasColor,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    const Icon(
                                      Icons.check_circle_outline,
                                      color: brandOne,
                                      size: 80,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Setting up your Savings plan',
                                      style: GoogleFonts.nunito(
                                          fontSize: 18.sp,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Total Rent: ',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 14.sp,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              currencyFormat
                                                  .format(double.tryParse(
                                                      _rentAmountController.text
                                                          .trim()
                                                          .replaceAll(',', '')))
                                                  .toString(),
                                              overflow: TextOverflow.clip,
                                              style: GoogleFonts.nunito(
                                                  fontSize: 14.sp,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '$durationType Savings: ',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 14.sp,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              currencyFormat
                                                  .format(double.tryParse(
                                                      _savingValue.toString()))
                                                  .toString(),
                                              overflow: TextOverflow.clip,
                                              style: GoogleFonts.nunito(
                                                  fontSize: 14.sp,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
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
                                                minimumSize:
                                                    const Size(300, 50),
                                                backgroundColor: brandOne,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Get.back();
                                                // print(_endDateController.text);
                                                // print(durationType);
                                                // print(_savingValue);
                                                // print(paymentCount);
                                                // print(DateFormat('dd/MM/yyyy')
                                                //     .format(DateTime.now()));
                                                // print(fundingController.text);
                                                // print(_rentValue);
                                                // print(durationType);
                                                await fetchUserData()
                                                    .then((value) {
                                                  if (userController
                                                          .userModel!
                                                          .userDetails![0]
                                                          .wallet
                                                          .mainBalance <
                                                      _savingValue) {
                                                    Get.back();
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              AlertDialog(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        30,
                                                                        30,
                                                                        30,
                                                                        20),
                                                                elevation: 0,
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                insetPadding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                scrollable:
                                                                    true,
                                                                title: null,
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            30),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            30),
                                                                  ),
                                                                ),
                                                                content:
                                                                    SizedBox(
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 40),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 15),
                                                                                child: Align(
                                                                                  alignment: Alignment.topCenter,
                                                                                  child: Text(
                                                                                    'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.nunito(
                                                                                      color: brandOne,
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(3),
                                                                                      child: ElevatedButton(
                                                                                        onPressed: () {
                                                                                          FocusScope.of(context).unfocus();
                                                                                          Get.back();
                                                                                          Get.to(const FundWallet());
                                                                                        },
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(8),
                                                                                          ),
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                                                                          textStyle: const TextStyle(color: brandFour, fontSize: 13),
                                                                                        ),
                                                                                        child: const Text(
                                                                                          "Fund Wallet",
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                            fontWeight: FontWeight.w700,
                                                                                            fontSize: 16,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    // print(DateFormat(
                                                    //         'dd/MM/yyyy')
                                                    //     .format(
                                                    //         DateTime.now()));
                                                    rentState.createRent(
                                                      context,
                                                      _rentNameController.text,
                                                      _endDateController.text,
                                                      durationType,
                                                      _savingValue,
                                                      _rentValue,
                                                      paymentCount,
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(
                                                              DateTime.now()),
                                                      // fundingController.text,
                                                    );
                                                  }
                                                }).catchError(
                                                  (error) {
                                                    customErrorDialog(
                                                        context,
                                                        'Oops',
                                                        'Something went wrong. Try again later');
                                                  },
                                                );
                                              },
                                              child: Text(
                                                'Create Space Rent',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.nunito(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
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
                      } else {
                        customErrorDialog(context, "Invalid",
                            "Please Fill All Required Fields");
                      }
                    },
                    child: const Text(
                      'Proceed',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
              // : SizedBox(),
            ],
          ),
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
      _holdingFee = 0.0;
      _savingValue = 0.0;
      _hasCalculate = 'true';
      _canShowRent = 'false';
    });
    _rentNameController.clear();
    _rentAmountController.clear();
    _endDateController.clear();
    fundingController.clear();
    _intervalController.clear();
  }
}
