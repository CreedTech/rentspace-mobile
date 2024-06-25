import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/view/savings/spaceDeposit/space_deposit_confirmation_page.dart';
import 'package:typewritertext/typewritertext.dart';

import '../../../constants/colors.dart';

class SpaceDepositIntervalPage extends StatefulWidget {
  const SpaceDepositIntervalPage(
      {super.key, required this.name, required this.amount});
  final String name, amount;

  @override
  State<SpaceDepositIntervalPage> createState() =>
      _SpaceDepositIntervalPageState();
}

String interestValue = "0";
String interestText = "Fill all the fields to see your interest.";
bool showSaveButton = false;
String amountNotice = "";
bool showNotice = false;
int durationVal = 1;
String durationType = "Daily";
String _durationValue = "1";

class _SpaceDepositIntervalPageState extends State<SpaceDepositIntervalPage> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  int selectedIndex = -1;
  List<String> buttonLabels = ['Daily', 'Weekly', 'Monthly'];
  bool hasChosen = false;
  bool startDateSelected = false;

  // final TextEditingController _depositAmountController =
  //   TextEditingController();
  final GlobalKey<FormState> dateformKey = GlobalKey<FormState>();
  bool showNextText = false;
  bool showForm = false;
  bool showNameText = false;
  String numberInDays = '';
  String differenceInWeeks = '';
  String differenceInMonths = '';

  void _startTypingAnimation() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        // _startNextAnimation();
        setState(
          () {
            showNextText = true;
          },
        );
      },
    ).then(
      (value) => Future.delayed(
        const Duration(seconds: 2),
        () {
          // _startNextAnimation();
          setState(() {
            showForm = true;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
    // showInterest = false;
    interestValue = "0";
    amountNotice = "";
    showNotice = false;
    showSaveButton = false;
    interestText = "";
    numberInDays = '';
    differenceInWeeks = '';
    differenceInMonths = '';
  }

  @override
  Widget build(BuildContext context) {
    //change duration value
    changeDuration() {
      print('duration');
      if (durationType == "Daily") {
        setState(() {
          durationVal = 365;
        });
      } else if (durationType == "Weekly") {
        setState(() {
          durationVal = 52;
        });
      } else {
        setState(() {
          durationVal = 12;
        });
      }
    }

    //calculate interest
    // String calculateInterest() {
    //   //50k to 1m, 7% interest
    //   if ((int.tryParse(widget.amount.trim().replaceAll(',', ''))! >= 500) &&
    //       (int.tryParse(widget.amount.trim().replaceAll(',', ''))! < 1000000)) {
    //     setState(() {
    //       showNotice = false;
    //       showSaveButton = true;
    //     });
    //     return interestValue =
    //         (int.tryParse(widget.amount.trim().replaceAll(',', ''))! *
    //                 0.07 *
    //                 ((int.parse(numberInDays)) / durationVal))
    //             .toString();
    //   }
    //   //1m to 2m, 7.5% interest
    //   else if ((int.tryParse(widget.amount.trim().replaceAll(',', ''))! >=
    //           1000000) &&
    //       (int.tryParse(widget.amount.trim().replaceAll(',', ''))! < 2000000)) {
    //     setState(() {
    //       showNotice = false;
    //       showSaveButton = true;
    //     });
    //     return interestValue =
    //         (int.tryParse(widget.amount.trim().replaceAll(',', ''))! *
    //                 0.075 *
    //                 ((int.parse(numberInDays)) / durationVal))
    //             .toString();
    //   }
    //   //2m to 5m, 8.25% interest
    //   else if ((int.tryParse(widget.amount.trim().replaceAll(',', ''))! >=
    //           2000000) &&
    //       (int.tryParse(widget.amount.trim().replaceAll(',', ''))! < 5000000)) {
    //     setState(() {
    //       showNotice = false;
    //       showSaveButton = true;
    //     });
    //     return interestValue =
    //         (int.tryParse(widget.amount.trim().replaceAll(',', ''))! *
    //                 0.0825 *
    //                 ((int.parse(numberInDays)) / durationVal))
    //             .toString();
    //   }
    //   //5m to 10m, 9% interest
    //   else if ((int.tryParse(widget.amount.trim().replaceAll(',', ''))! >=
    //           5000000) &&
    //       (int.tryParse(widget.amount.trim().replaceAll(',', ''))! <
    //           10000000)) {
    //     setState(() {
    //       showNotice = false;
    //       showSaveButton = true;
    //     });
    //     return interestValue =
    //         (int.tryParse(widget.amount.trim().replaceAll(',', ''))! *
    //                 0.09 *
    //                 ((int.parse(numberInDays)) / durationVal))
    //             .toString();
    //   }
    //   //10m to 20m, 10.25% interest
    //   else if ((int.tryParse(widget.amount.trim().replaceAll(',', ''))! >=
    //           10000000) &&
    //       (int.tryParse(widget.amount.trim().replaceAll(',', ''))! <
    //           20000000)) {
    //     setState(() {
    //       showNotice = false;
    //       showSaveButton = true;
    //     });
    //     return interestValue =
    //         (int.tryParse(widget.amount.trim().replaceAll(',', ''))! *
    //                 0.1025 *
    //                 ((int.parse(numberInDays)) / durationVal))
    //             .toString();
    //   }
    //   //20m to 30m, 12% interest
    //   else if ((int.tryParse(widget.amount.trim().replaceAll(',', ''))! >=
    //           20000000) &&
    //       (int.tryParse(widget.amount.trim().replaceAll(',', ''))! <
    //           30000000)) {
    //     setState(() {
    //       showNotice = false;
    //       showSaveButton = true;
    //     });
    //     return interestValue =
    //         (int.tryParse(widget.amount.trim().replaceAll(',', ''))! *
    //                 0.12 *
    //                 ((int.parse(numberInDays)) / durationVal))
    //             .toString();
    //   }
    //   //30m to 50m, 14% interest
    //   else if ((int.tryParse(widget.amount.trim().replaceAll(',', ''))! >=
    //           30000000) &&
    //       (int.tryParse(widget.amount.trim().replaceAll(',', ''))! <
    //           50000000)) {
    //     setState(() {
    //       showNotice = false;
    //       showSaveButton = true;
    //     });
    //     return interestValue =
    //         (int.tryParse(widget.amount.trim().replaceAll(',', ''))! *
    //                 0.14 *
    //                 ((int.parse(numberInDays)) / durationVal))
    //             .toString();
    //   } else {
    //     setState(() {
    //       amountNotice = "Please contact us for a conversational interest.";
    //       showNotice = true;
    //       showSaveButton = false;
    //     });
    //     return interestValue = "1";
    //   }
    // }

    //check duration
    checkDuration() {
      //check duration -- amount / duration
      // if ((durationType == "Monthly") &&
      //     (int.tryParse(
      //             widget.amount.trim().replaceAll(',', ''))! <
      //         50000)) {
      //   setState(() {
      //     interestValue = "0";
      //     showSaveButton = false;
      //     interestText = "Minimum amount is ₦50,000 per month";
      //   });
      // } else if ((durationType == "Weekly") &&
      //     (int.tryParse(
      //             widget.amount.trim().replaceAll(',', ''))! <
      //         5000)) {
      //   setState(() {
      //     interestValue = "0";
      //     showSaveButton = false;
      //     interestText = "Minimum amount is ₦5,000 per week";
      //   });
      // }
      //  else if ((durationType == "Daily") &&
      //     ((int.tryParse(
      //             widget.amount.trim().replaceAll(',', ''))!) <
      //         500)) {
      //   setState(() {
      //     interestValue = "0";
      //     showSaveButton = false;
      //     interestText = "Minimum amount is ₦500 per day";
      //   });
      // }
      //check duration -- maximum duration
      // else
      if ((durationType == "Monthly") && (int.parse(differenceInMonths) > 12)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Maximum duration is 12 months";
        });
      } else if ((durationType == "Weekly") &&
          ((int.parse(differenceInWeeks)) > 52)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Maximum duration is 52 weeks";
        });
      } else if ((durationType == "Daily") &&
          ((int.parse(numberInDays)) > 365)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Maximum duration is 365 days";
        });
      }
      //check duration -- minimum duration
      else if ((durationType == "Monthly") &&
          (int.parse(differenceInMonths) < 3)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Minimum duration is 3 months";
        });
      } else if ((durationType == "Weekly") &&
          ((int.parse(differenceInWeeks)) < 12)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Minimum duration is 12 weeks";
        });
      } else if ((durationType == "Daily") &&
          ((int.parse(numberInDays)) < 90)) {
        setState(() {
          interestValue = "0";
          showSaveButton = false;
          interestText = "Minimum duration is 90 days";
        });
      } else {
        setState(() {
          // interestValue = calculateInterest();
          showSaveButton = true;
          interestText = "";
        });
      }
      print('interestValue');
      print(interestValue);
      print('interestText');
      print(interestText);
      print("Duration: $numberInDays $durationType");
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
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
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != selectedDate) {
        // final int age = DateTime.now().year - picked.year;
        setState(() {
          selectedDate = picked;
          _startDateController.text =
              DateFormat('EEE d, y').format(selectedDate);
          startDateSelected = true;
          _endDateController.clear();
        });
      }
    }

    Future<void> _endDate(BuildContext context) async {
      // DateTime endSelectedDate = DateTime.parse(_startDateController.text);
      final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
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
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2025, 02, 06),
      );

      if (picked != null && picked != DateTime.now()) {
        // final int age = DateTime.now().year - picked.year;
        setState(() {
          // endSelectedDate = picked;
          _endDateController.text = DateFormat('EEE d, y').format(picked);
          print(selectedDate);
          print(picked);
          Duration difference = picked.difference(selectedDate);
          print(difference.inDays);
          numberInDays = difference.inDays.toString();
          // Calculate the difference in months
          differenceInMonths = ((picked.year - selectedDate.year) * 12 +
                  picked.month -
                  selectedDate.month)
              .toString();

          // Calculate the difference in weeks
          differenceInWeeks =
              (picked.difference(selectedDate).inDays ~/ 7).toString();
          _durationValue = numberInDays;
        });
        // setState(() => _durationValue = text);
        changeDuration();
        checkDuration();

        print(numberInDays);
        print(differenceInWeeks);
        print(differenceInMonths);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: () {
            // resetCalculator();
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypeWriterText.builder(
                    "Accomplish Your Financial Goals",
                    repeat: false,
                    builder: (context, value) {
                      return AutoSizeText(
                        value,
                        maxLines: 2,
                        minFontSize: 2.0,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                    duration: const Duration(milliseconds: 50),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  (showNextText == true)
                      ? TypeWriterText.builder(
                          "Deposit Frequency: ",
                          repeat: false,
                          builder: (context, value) {
                            return AutoSizeText(
                              value,
                              maxLines: 2,
                              minFontSize: 2.0,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                          duration: const Duration(milliseconds: 50),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  (showForm == true)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int i = 0; i < buttonLabels.length; i++)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedIndex = i;
                                    hasChosen = true;
                                    durationType = buttonLabels[i];
                                    print(buttonLabels[i]);
                                  });
                                  // changeDuration();
                                  // hasChosen = false;
                                  // checkDuration();
                                  print(durationType);
                                  startDateSelected = false;
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(110, 50),
                                  maximumSize: const Size(110, 50),
                                  backgroundColor: selectedIndex == i
                                      ? brandOne
                                      : brandThree,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  // primary: selectedIndex == i ? Colors.blue : null,
                                ),
                                child: Text(
                                  buttonLabels[i],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    color: selectedIndex == i
                                        ? Colors.white
                                        : brandOne,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: dateformKey,
                    child: Column(
                      children: [
                        (hasChosen == true)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 3),
                                    child: Text(
                                      'Preferred Start Date',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        // fontFamily: "DefaultFontFamily",
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _startDateController,
                                    cursorColor: Theme.of(context).primaryColor,
                                    style: GoogleFonts.lato(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    readOnly: true,
                                    onTap: () => _selectDate(context),
                                    decoration: InputDecoration(
                                      labelText: 'Select your Start date',
                                      labelStyle: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      suffixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: brandOne,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xffE0E0E0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: brandOne, width: 1.0),
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
                                            color: Colors.red, width: 2.0),
                                      ),
                                      filled: false,
                                      contentPadding: const EdgeInsets.all(14),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 30,
                        ),
                        (startDateSelected == true)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 3),
                                    child: Text(
                                      'Preferred End Date',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        // fontFamily: "DefaultFontFamily",
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _endDateController,
                                    cursorColor: Theme.of(context).primaryColor,
                                    style: GoogleFonts.lato(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    readOnly: true,
                                    onTap: () => _endDate(context),
                                    onChanged: (text) {
                                      setState(() => _durationValue = text);
                                      changeDuration();
                                      checkDuration();
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Select your End date',
                                      labelStyle: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      suffixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: brandOne,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xffE0E0E0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: brandOne, width: 1.0),
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
                                            color: Colors.red, width: 2.0),
                                      ),
                                      filled: false,
                                      contentPadding: const EdgeInsets.all(14),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      interestText,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            (showSaveButton == true)
                ? Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 50),
                        maximumSize: const Size(400, 50),
                        backgroundColor: brandOne,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (dateformKey.currentState!.validate()) {
                          Get.to(SpaceDepositConfirmationPage(
                            name: widget.name,
                            amount: widget.amount,
                            startDate: _startDateController.text,
                            endDate: _endDateController.text,
                            interval: durationType,
                            dateDifference: (durationType == 'Daily')
                                ? numberInDays.toString()
                                : (durationType == 'Weekly')
                                    ? differenceInWeeks.toString()
                                    : differenceInMonths.toString(),
                            durationVal: durationVal,
                          ));
                        }
                      },
                      child: Text(
                        "Proceed",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       for (int i = 0; i < buttonLabels.length; i++)
      //         ElevatedButton(
      //           onPressed: () {
      //             setState(() {
      //               selectedIndex = i;
      //             });
      //           },
      //           style: ElevatedButton.styleFrom(
      //             primary: selectedIndex == i ? Colors.blue : null,
      //           ),
      //           child: Text(buttonLabels[i]),
      //         ),
      //       SizedBox(height: 20),
      //       Text(
      //         selectedIndex != -1
      //             ? 'Selected Button: ${buttonLabels[selectedIndex]}'
      //             : 'No button selected',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
