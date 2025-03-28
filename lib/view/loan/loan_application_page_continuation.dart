import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:rentspace/controller/loan/loan_controller.dart';
import 'package:rentspace/view/loan/loan_application_success_page.dart';
import 'package:rentspace/widgets/custom_dialogs/custom_error_dialog.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/colors.dart';
import '../../constants/utils/formatPhoneNumber.dart';
import '../../controller/rent/rent_controller.dart';
import '../../widgets/custom_loader.dart';
import 'package:http/http.dart' as http;

class LoanApplicationPageContinuation extends StatefulWidget {
  final int current;
  final String reason,
      id,
      idNumber,
      bvn,
      phoneNumber,
      address,
      bill,
      landlordOrAgent,
      landlordOrAgentName,
      livesInSameProperty,
      // landlordOrAgentAddress,
      landlordOrAgentNumber,
      landlordAccountNumber,
      landlordBankName,
      // duration,
      propertyType;
  const LoanApplicationPageContinuation({
    super.key,
    required this.current,
    required this.reason,
    required this.id,
    required this.idNumber,
    required this.bvn,
    required this.phoneNumber,
    required this.address,
    required this.bill,
    required this.landlordOrAgent,
    required this.landlordOrAgentName,
    required this.livesInSameProperty,
    // required this.landlordOrAgentAddress,
    required this.landlordOrAgentNumber,
    required this.landlordAccountNumber,
    required this.landlordBankName,
    // required this.duration,
    required this.propertyType,
  });

  @override
  State<LoanApplicationPageContinuation> createState() =>
      _LoanApplicationPageContinuationState();
}

class _LoanApplicationPageContinuationState
    extends State<LoanApplicationPageContinuation> {
  final LoanController loanController = Get.find();
  final TextEditingController _employmentStatusController =
      TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _netSalaryController = TextEditingController();
  final TextEditingController _nameOfBusinessController =
      TextEditingController();
  final TextEditingController _cacController = TextEditingController();
  final TextEditingController _estimatedMonthlyTurnOverController =
      TextEditingController();
  final TextEditingController _estimatedNetMonthlyNetProfitController =
      TextEditingController();
  final TextEditingController _existingLoansController =
      TextEditingController();
  final TextEditingController _howMuchController = TextEditingController();
  final TextEditingController _whereLoanWasCollectedController =
      TextEditingController();
  final TextEditingController _howLongController = TextEditingController();
  final TextEditingController _guarantorNameController =
      TextEditingController();
  final TextEditingController _guarantorRelationshipController =
      TextEditingController();
  final TextEditingController _guarantorNumberController =
      TextEditingController();
  final TextEditingController _guarantorAddressController =
      TextEditingController();
  var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0);
  final RentController rentController = Get.find();
  final loanContFormKey = GlobalKey<FormState>();
  List<String> employmentStatusList = ['Employed', 'Self-Employed'];
  List<String> existingLoansResponse = ['Yes', 'No'];
  bool employmentStatusSelected = false;
  String? selectedId;
  bool idSelected = false;
  bool authorizeRentspace = false;
  bool agreeToTerms = false;
  // bool hasExistingLoans = false;
  @override
  Widget build(BuildContext context) {
    validateEmploymentStatus(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please select one';
      }
      return null;
    }

    validatePosition(lastValue) {
      if (lastValue.isEmpty) {
        return 'Position cannot be empty';
      }

      return null;
    }

    validateNetSalary(lastValue) {
      if (lastValue.isEmpty) {
        return 'Net Salary cannot be empty';
      }
      return null;
    }

    validateNameOfBusiness(lastValue) {
      if (lastValue.isEmpty) {
        return 'Name of Business cannot be empty';
      }
      return null;
    }

    validateCacNumber(lastValue) {
      if (lastValue.isEmpty) {
        return 'CAC cannot be empty';
      }
      return null;
    }

    validateEstimatedMonthlyTurnOver(lastValue) {
      if (lastValue.isEmpty) {
        return 'Estimated Monthly TurnOver cannot be empty';
      }
      return null;
    }

    validateEstimatedNetMonthlyProfit(lastValue) {
      if (lastValue.isEmpty) {
        return 'Estimated Net Monthly Profit cannot be empty';
      }
      return null;
    }

    validateExistingLoans(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please select one';
      }
      return null;
    }

    validateHowMuch(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please enter amount';
      }
      return null;
    }

    validateWhere(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please enter where you collected the loan';
      }
      return null;
    }

    validateHowLong(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please enter duration of the loan';
      }
      return null;
    }

    validateGuarantorName(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please enter guarantor Full name';
      }
      return null;
    }

    validateGuarantorRelationship(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please enter your relationship with the guarantor';
      }
      return null;
    }

    validateGuarantorNumber(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please enter your guarantor phone number';
      }
      return null;
    }

    validateGuarantorAddress(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please enter your guarantor Address';
      }
      return null;
    }

    final employmentStatus = TextFormField(
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
                      'Employment Status',
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
                        itemCount: employmentStatusList.length,
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
                                          employmentStatusList[idx],
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
                                      // selectedId = employmentStatusList[idx];
                                      employmentStatusSelected = true;
                                    });
                                    _employmentStatusController.text =
                                        employmentStatusList[idx];
                                    // });

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != employmentStatusList.length - 1)
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
      controller: _employmentStatusController,

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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Select one',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateEmploymentStatus,
    );
    final position = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _positionController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Input your position',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validatePosition,
    );
    final netSalary = TextFormField(
      enableSuggestions: true,
      inputFormatters: [ThousandsFormatter()],
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _netSalaryController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.number,
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Input your net salary',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateNetSalary,
    );
    final nameOfBusiness = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _nameOfBusinessController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Input the name of your business',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateNameOfBusiness,
    );
    final cacNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _cacController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Input your CAC number',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateCacNumber,
    );
    final estimatedMonthlyTurnOver = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _estimatedMonthlyTurnOverController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Input estimated monthly turnover',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateEstimatedMonthlyTurnOver,
    );
    final estimatedNetMonthlyProfit = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _estimatedNetMonthlyNetProfitController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Input estimated net monthly profit',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateEstimatedNetMonthlyProfit,
    );
    final hasExistingLoans = TextFormField(
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
                      'Do you have existing loans?',
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
                        itemCount: existingLoansResponse.length,
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
                                          existingLoansResponse[idx],
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
                                      selectedId = existingLoansResponse[idx];
                                    });

                                    _existingLoansController.text =
                                        existingLoansResponse[idx];
                                    // });

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != existingLoansResponse.length - 1)
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
      controller: _existingLoansController,

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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Select one',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateExistingLoans,
    );
    final howMuch = TextFormField(
      enableSuggestions: true,
      inputFormatters: [ThousandsFormatter()],
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _howMuchController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Input amount',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateHowMuch,
    );
    final whereLoanWasCollected = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _whereLoanWasCollectedController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Where did you collect the loan?',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateWhere,
    );
    final loanDuration = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _howLongController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Duration of the loan',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateHowLong,
    );
    final guarantorName = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _guarantorNameController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Full name',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateGuarantorName,
    );
    final guarantorRelationship = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _guarantorRelationshipController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'What is your relationship with the guarantor?',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateGuarantorRelationship,
    );
    final guarantorNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _guarantorNumberController,
      onChanged: (text) {
        // Format the phone number whenever the user types
        String formattedNumber = formatPhoneNumber(text);
        _guarantorNumberController.value =
            _guarantorNumberController.value.copyWith(
          text: formattedNumber,
          selection: TextSelection.fromPosition(
            TextPosition(offset: formattedNumber.length),
          ),
        );
      },
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.number,
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Phone number of guarantor',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateGuarantorNumber,
    );
    final guarantorAddress = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _guarantorAddressController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.streetAddress,
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
          borderSide: const BorderSide(color: brandOne, width: 1),
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
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Address of guarantor',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateGuarantorAddress,
    );

    uploadBill(BuildContext context, File imageFile) async {
      String authToken =
          await GlobalService.sharedPreferencesManager.getAuthToken();

      var headers = {'Authorization': 'Bearer $authToken'};
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var request = http.MultipartRequest('POST',
          Uri.parse(AppConstants.BASE_URL + AppConstants.UPLOAD_UTILITY_BILL));
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Image uploaded successfully');
        }
        // context.pop();

        // refreshController.refreshCompleted();
        // if (mounted) {
        //   setState(() {
        //     isRefresh = true;
        //   });
        // }

        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.success(
        //     backgroundColor: Colors.green,
        //     message: 'Your profile picture has been updated successfully. !!',
        //     textStyle: GoogleFonts.poppins(
        //       fontSize: 14,
        //       color: Colors.white,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // );
        // await fetchUserData(refresh: true);
        // Get.to(FirstPage());
      } else {
        EasyLoading.dismiss();
        customErrorDialog(
            context, 'File too large', 'Please select image below 1.5mb');
        if (kDebugMode) {
          print(response.request);
        }
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
        if (kDebugMode) {
          print('Image upload failed with status ${response.statusCode}');
        }
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: 4.h,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  'Loan Application',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 24.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Wrap(
                        children: [
                          Text(
                            '${rentController.rentModel!.rents![widget.current].rentName}:',
                            style: GoogleFonts.lato(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            nairaFormaet.format(rentController
                                .rentModel!.rents![widget.current].paidAmount),
                            style: GoogleFonts.lato(
                              color: brandOne,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Form(
                      key: loanContFormKey,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Occupation',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Employment Status',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              employmentStatus,
                            ],
                          ),
                          Visibility(
                            visible: employmentStatusSelected,
                            child: (_employmentStatusController.text ==
                                    employmentStatusList[0])
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.h, horizontal: 3.w),
                                            child: Text(
                                              'Position',
                                              style: GoogleFonts.lato(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          position,
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.h, horizontal: 3.w),
                                            child: Text(
                                              'Net Salary',
                                              style: GoogleFonts.lato(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          netSalary,
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.h, horizontal: 3.w),
                                            child: Text(
                                              'Name of Business',
                                              style: GoogleFonts.lato(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          nameOfBusiness,
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.h, horizontal: 3.w),
                                            child: Text(
                                              'CAC Number. (Input Null if not registered)',
                                              style: GoogleFonts.lato(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          cacNumber,
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.h, horizontal: 3.w),
                                            child: Text(
                                              'Estimated Monthly Turnover',
                                              style: GoogleFonts.lato(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          estimatedMonthlyTurnOver,
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.h, horizontal: 3.w),
                                            child: Text(
                                              'Estimated Net Monthly Profit',
                                              style: GoogleFonts.lato(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          estimatedNetMonthlyProfit,
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(
                            height: 23.h,
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 3.h, horizontal: 3.w),
                          //       child: Text(
                          //         'Previous Loans',
                          //         style: GoogleFonts.lato(
                          //           color:
                          //               Theme.of(context).colorScheme.primary,
                          //           fontWeight: FontWeight.w500,
                          //           fontSize: 14,
                          //         ),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 3.h, horizontal: 3.w),
                          //       child: Text(
                          //         'Do you have existing loans?',
                          //         style: GoogleFonts.lato(
                          //           color:
                          //               Theme.of(context).colorScheme.primary,
                          //           fontWeight: FontWeight.w500,
                          //           fontSize: 12,
                          //         ),
                          //       ),
                          //     ),
                          //     hasExistingLoans,
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 20.h,
                          // ),
                          // Visibility(
                          //   visible: (_existingLoansController.text ==
                          //       existingLoansResponse[0]),
                          //   child: Column(
                          //     children: [
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Padding(
                          //             padding: EdgeInsets.symmetric(
                          //                 vertical: 3.h, horizontal: 3.w),
                          //             child: Text(
                          //               'How Much?',
                          //               style: GoogleFonts.lato(
                          //                 color: Theme.of(context)
                          //                     .colorScheme
                          //                     .primary,
                          //                 fontWeight: FontWeight.w500,
                          //                 fontSize: 12,
                          //               ),
                          //             ),
                          //           ),
                          //           howMuch,
                          //         ],
                          //       ),
                          //       SizedBox(
                          //         height: 20.h,
                          //       ),
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Padding(
                          //             padding: EdgeInsets.symmetric(
                          //                 vertical: 3.h, horizontal: 3.w),
                          //             child: Text(
                          //               'Where?',
                          //               style: GoogleFonts.lato(
                          //                 color: Theme.of(context)
                          //                     .colorScheme
                          //                     .primary,
                          //                 fontWeight: FontWeight.w500,
                          //                 fontSize: 12,
                          //               ),
                          //             ),
                          //           ),
                          //           whereLoanWasCollected,
                          //         ],
                          //       ),
                          //       SizedBox(
                          //         height: 20.h,
                          //       ),
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Padding(
                          //             padding: EdgeInsets.symmetric(
                          //                 vertical: 3.h, horizontal: 3.w),
                          //             child: Text(
                          //               'How Long?',
                          //               style: GoogleFonts.lato(
                          //                 color: Theme.of(context)
                          //                     .colorScheme
                          //                     .primary,
                          //                 fontWeight: FontWeight.w500,
                          //                 fontSize: 12,
                          //               ),
                          //             ),
                          //           ),
                          //           loanDuration,
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 23.h,
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Guarantor',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Name',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              guarantorName,
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Relationship',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              guarantorRelationship,
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Phone Number',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              guarantorNumber,
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Address',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              guarantorAddress,
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  child: Checkbox.adaptive(
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity,
                                    value: authorizeRentspace,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        authorizeRentspace = value!;
                                      });
                                    },
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                      (states) => brandTwo,
                                    ),
                                    fillColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return brandTwo;
                                      }
                                      return const Color(0xffF2F2F2);
                                    }),
                                    focusColor: MaterialStateColor.resolveWith(
                                      (states) => brandTwo,
                                    ),
                                    activeColor: MaterialStateColor.resolveWith(
                                      (states) => brandTwo,
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xffBDBDBD),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 9,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'I authorize Rentspace Technologies Limited to obtain personal and credit information about me from our credit bureau, or credit reporting agency, any person who has or may have any financial dealing with me, or from any references I have provided. ',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  child: Checkbox.adaptive(
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity,
                                    value: agreeToTerms,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        agreeToTerms = value!;
                                      });
                                    },
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                      (states) => brandTwo,
                                    ),
                                    fillColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return brandTwo;
                                      }
                                      return const Color(0xffF2F2F2);
                                    }),
                                    focusColor: MaterialStateColor.resolveWith(
                                      (states) => brandTwo,
                                    ),
                                    activeColor: MaterialStateColor.resolveWith(
                                      (states) => brandTwo,
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xffBDBDBD),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 9,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'I hereby agree that the information given is true, accurate and complete as of the date of this application submission. ',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Align(
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
                    if (loanContFormKey.currentState!.validate() &&
                        agreeToTerms == true &&
                        authorizeRentspace == true) {
                      loanController.applyForLoan(
                        rentController.rentModel!.rents![widget.current].id,
                        widget.reason,
                        widget.id,
                        widget.idNumber,
                        widget.bvn,
                        widget.phoneNumber,
                        widget.address,
                        widget.bill,
                        widget.landlordOrAgent,
                        widget.landlordOrAgentName,
                        widget.livesInSameProperty,
                        // (widget.livesInSameProperty == 'Yes')
                        //     ? widget.address
                        //     : widget.landlordOrAgentAddress,
                        widget.landlordOrAgentNumber,
                        widget.landlordAccountNumber,
                        widget.landlordBankName,
                        // widget.duration,
                        widget.propertyType,
                        _employmentStatusController.text,
                        _positionController.text,
                        _netSalaryController.text.trim().replaceAll(',', ''),
                        _nameOfBusinessController.text,
                        _cacController.text,
                        _estimatedMonthlyTurnOverController.text,
                        _estimatedNetMonthlyNetProfitController.text,
                        _guarantorNameController.text,
                        _guarantorRelationshipController.text,
                        _guarantorNumberController.text,
                        _guarantorAddressController.text,
                      );
                      // Get.to(const LoanApplicationSuccessfulPage());
                    } else if (!(agreeToTerms == true &&
                            authorizeRentspace == true) &&
                        loanContFormKey.currentState!.validate()) {
                      customErrorDialog(context, 'Invalid',
                          'Please click the checkboxes to continue');
                    } else {
                      customErrorDialog(context, 'Invalid',
                          'Please Fill all required fields');
                    }
                  },
                  child: Text(
                    'Proceed',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 12,
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
