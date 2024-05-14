import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../constants/widgets/separator.dart';

class SpaceDepositConfirmationPage extends StatefulWidget {
  const SpaceDepositConfirmationPage(
      {super.key,
      required this.name,
      required this.amount,
      required this.startDate,
      required this.endDate,
      required this.interval,
      required this.dateDifference,
      required this.durationVal});
  final String name, amount, startDate, endDate, interval, dateDifference;
  final int durationVal;

  @override
  State<SpaceDepositConfirmationPage> createState() =>
      _SpaceDepositConfirmationPageState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'N');
bool showNotice = false;
String interestValue = "0";
String amountNotice = "";
String interestRate = "10";
bool isChecked = false;
String selectedId = '';

class _SpaceDepositConfirmationPageState
    extends State<SpaceDepositConfirmationPage> {
  final TextEditingController fundingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      showNotice = false;
      interestValue = "0";
      amountNotice = "";
      interestRate = "0";
      isChecked = false;
      selectedId = '';
    });
    calculateInterest();
  }

  //calculate interest
  String calculateInterest() {
    //50k to 1m, 7% interest
    if ((int.parse(widget.amount) >= 500) &&
        (int.parse(widget.amount) < 1000000)) {
      setState(() {
        showNotice = false;
        // showSaveButton = true;
        interestRate = "7";
      });
      return interestValue = (int.parse(widget.amount) *
              0.07 *
              (int.parse(widget.dateDifference) / widget.durationVal))
          .toString();
    }
    //1m to 2m, 7.5% interest
    else if ((int.parse(widget.amount) >= 1000000) &&
        (int.parse(widget.amount) < 2000000)) {
      setState(() {
        showNotice = false;
        // showSaveButton = true;
        interestRate = "7.5";
      });
      return interestValue = (int.parse(widget.amount) *
              0.075 *
              (int.parse(widget.dateDifference) / widget.durationVal))
          .toString();
    }
    //2m to 5m, 8.25% interest
    else if ((int.parse(widget.amount) >= 2000000) &&
        (int.parse(widget.amount) < 5000000)) {
      setState(() {
        showNotice = false;
        // showSaveButton = true;
        interestRate = "8.5";
      });
      return interestValue = (int.parse(widget.amount) *
              0.0825 *
              (int.parse(widget.dateDifference) / widget.durationVal))
          .toString();
    }
    //5m to 10m, 9% interest
    else if ((int.parse(widget.amount) >= 5000000) &&
        (int.parse(widget.amount) < 10000000)) {
      setState(() {
        showNotice = false;
        interestRate = "9";
        // showSaveButton = true;
      });
      return interestValue = (int.parse(widget.amount) *
              0.09 *
              (int.parse(widget.dateDifference) / widget.durationVal))
          .toString();
    }
    //10m to 20m, 10.25% interest
    else if ((int.parse(widget.amount) >= 10000000) &&
        (int.parse(widget.amount) < 20000000)) {
      setState(() {
        showNotice = false;
        // showSaveButton = true;
        interestRate = "10.25";
      });
      return interestValue = (int.parse(widget.amount) *
              0.1025 *
              (int.parse(widget.dateDifference) / widget.durationVal))
          .toString();
    }
    //20m to 30m, 12% interest
    else if ((int.parse(widget.amount) >= 20000000) &&
        (int.parse(widget.amount) < 30000000)) {
      setState(() {
        showNotice = false;
        interestRate = "12";
        // showSaveButton = true;
      });
      return interestValue = (int.parse(widget.amount) *
              0.12 *
              (int.parse(widget.dateDifference) / widget.durationVal))
          .toString();
    }
    //30m to 50m, 14% interest
    else if ((int.parse(widget.amount) >= 30000000) &&
        (int.parse(widget.amount) < 50000000)) {
      setState(() {
        showNotice = false;
        interestRate = "14";
        // showSaveButton = true;
      });
      return interestValue = (int.parse(widget.amount) *
              0.14 *
              (int.parse(widget.dateDifference) / widget.durationVal))
          .toString();
    } else {
      // setState(() {
      //   amountNotice = "Please contact us for a conversational interest.";
      //   showNotice = true;
      //   // showSaveButton = false;
      // });
      return interestValue = "1";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.name);
    print(widget.amount);
    print(widget.startDate);
    print(widget.endDate);
    print(widget.interval);
    print(widget.dateDifference);
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
        padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
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
                        AutoSizeText(
                          "Setting up your ${widget.name.capitalizeFirst} plan",
                          maxLines: 2,
                          minFontSize: 2.0,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 16.sp,
                            // letterSpacing: 0.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Target Amount",
                                    style: GoogleFonts.lato(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,

                                      // letterSpacing: 0.5,
                                      color: brandOne,
                                    ),
                                  ),
                                  Text(
                                    nairaFormaet
                                        .format(int.parse(widget.amount)),
                                    style: GoogleFonts.lato(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      // letterSpacing: 0.5,
                                      color: brandOne,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              const MySeparator(
                                color: Color(0xffE0E0E0),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${widget.interval} Savings:",
                                    style: GoogleFonts.lato(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,

                                      // letterSpacing: 0.5,
                                      color: brandOne,
                                    ),
                                  ),
                                  Text(
                                    nairaFormaet
                                        .format(double.parse(interestValue)),
                                    style: GoogleFonts.lato(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      // letterSpacing: 0.5,
                                      color: brandOne,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              const MySeparator(
                                color: Color(0xffE0E0E0),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Interest Rate:",
                                    style: GoogleFonts.lato(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,

                                      // letterSpacing: 0.5,
                                      color: brandOne,
                                    ),
                                  ),
                                  Text(
                                    '$interestRate% per annum',
                                    style: GoogleFonts.lato(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      // letterSpacing: 0.5,
                                      color: brandOne,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              const MySeparator(
                                color: Color(0xffE0E0E0),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Frequency:",
                                    style: GoogleFonts.lato(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,

                                      // letterSpacing: 0.5,
                                      color: brandOne,
                                    ),
                                  ),
                                  Text(
                                    widget.interval,
                                    style: GoogleFonts.lato(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      // letterSpacing: 0.5,
                                      color: brandOne,
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
                    height: 30.h,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                        ),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Select Funding Source',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      CustomDropdown(
                        selectedStyle: GoogleFonts.lato(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12),
                        hintText: 'Select Source?',
                        hintStyle: GoogleFonts.lato(fontSize: 12),
                        excludeSelected: true,
                        fillColor: Colors.transparent,
                        listItemStyle: GoogleFonts.lato(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 12),
                        items: const ['DVA Wallet ', 'Debit Card'],
                        controller: fundingController,
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        fieldSuffixIcon: Icon(
                          Iconsax.arrow_down5,
                          size: 25.h,
                          color: Theme.of(context).primaryColor,
                        ),
                        onChanged: (String val) {
                          setState(() {
                            // idSelected = true;
                            selectedId = fundingController.text;
                          });
                          print(val);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox.adaptive(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        overlayColor: MaterialStateColor.resolveWith(
                          (states) => brandFour,
                        ),
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return brandFour;
                          }
                          return const Color(0xffF2F2F2);
                        }),
                        focusColor: MaterialStateColor.resolveWith(
                          (states) => brandFour,
                        ),
                        activeColor: MaterialStateColor.resolveWith(
                          (states) => brandFour,
                        ),
                        side: const BorderSide(
                          color: Color(0xffBDBDBD),
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "Accept ",
                            style: GoogleFonts.lato(
                                color: brandOne,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: GoogleFonts.lato(
                                color: brandOne,
                                fontWeight: FontWeight.w700,
                                fontSize: 12),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 5),
                    child: Column(
                      children: [
                        Text(
                          'I acknowledge that if I do not reach my set Target amount by the end date, I will forfeit all interest accrued on this Target Savings',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w400, fontSize: 10),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'case I break this Target before its end date, I acknowledge that I will forfeit all accrued interest and pay a 1% early withdrawal fee, which is aimed to encourage commitment to the savings goal and cover processing costs.',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w400, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
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
                  onPressed: () {},
                  child: Text(
                    "Create Space Deposit",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
